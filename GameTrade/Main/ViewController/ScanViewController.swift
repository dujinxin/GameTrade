//
//  ScanViewController.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/4.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: BaseViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var controlButton: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var scanImageView: UIImageView!
    
    @IBOutlet weak var leftViewWidthConstraint: NSLayoutConstraint!
    
    var session = AVCaptureSession()
    
    var callBlock : ((_ address: String?)->())?
    
    var type = 0 //地址  1 付款
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.backButton.tintColor = UIColor.white
        self.scanImageView.tintColor = UIColor.blue
        self.topView.alpha = 0.5
        self.leftView.alpha = 0.5
        self.rightView.alpha = 0.5
        self.bottomView.alpha = 0.5
        
//        self.controlButton.setImage(#imageLiteral(resourceName: "off"), for: .normal)
//        self.controlButton.setImage(#imageLiteral(resourceName: "on"), for: .selected)
        
        if self.type == 1 {
            self.statusBottomView.customView = self.customViewInit(number: "text", address: "address", gas: "gas", remark: "无")
            self.statusBottomView.show(inView: self.view)
            
            return
        }
        
        
        guard
            let device = AVCaptureDevice.default(for: .video),   //创建摄像设备
            let input = try? AVCaptureDeviceInput(device: device)//创建输入流
            else{
            return
        }
        
        let output = AVCaptureMetadataOutput()                   //创建输出流
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        
        let x = self.leftViewWidthConstraint.constant
        let width = view.bounds.width - 2 * self.leftViewWidthConstraint.constant
        let height = width
        let y = (view.bounds.height - height) / 2

        output.rectOfInterest = self.getScanCrop(rect: CGRect(x: x, y: y, width: width, height: height), readerViewBounds: view.bounds)
        
        session.sessionPreset = .high                           //高质量采集率
        session.addInput(input)
        session.addOutput(output)
        
        //先添加输出流 才可以设置格式，不然报错
        output.metadataObjectTypes = [.qr,.ean13,.ean8,.code128]//设置扫码支持的编码格式(设置条形码和二维码兼容)
        
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        layer.frame = view.layer.bounds
        view.layer.insertSublayer(layer, at: 0)

        session.startRunning()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kStatusBarHeight + 7
    }
    func getScanCrop(rect: CGRect,readerViewBounds bounds:CGRect) -> CGRect {
        
        let x,y,width,height : CGFloat
        x = rect.origin.y / bounds.height
        y = rect.origin.x / bounds.width
        width = rect.size.height / bounds.height
        height = rect.size.width / bounds.width
        return CGRect(x: x, y: y, width: width, height: height)
    }
    @IBAction func backEvent(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func switchButton(_ sender: UIButton) {
        guard
            let device = AVCaptureDevice.default(for: .video),
            device.hasTorch == true else {
                ViewManager.showNotice("闪光灯故障")
            return
        }
        sender.isSelected = !sender.isSelected
        if  device.torchMode == .on{
            try? device.lockForConfiguration()
            device.torchMode = .off
            try? device.unlockForConfiguration()
        } else {
            try? device.lockForConfiguration()
            device.torchMode = .on
            try? device.unlockForConfiguration()
        }
    }
    
    //MARK: SelectView --------
    
    var number : String = "0"
    var value = 0
    
    var payName = "支付宝"
    var payType = 1
    
    var rightButton : UIButton!
    
    
    
    var closeBlock : (()->())?
    var confirmBlock : ((_ type: Int)->())?
    var psdTextView : PasswordTextView!
    lazy var statusBottomView: JXSelectView = {
        let selectView = JXSelectView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 200), style: JXSelectViewStyle.custom)
        selectView.backgroundColor = JXOrangeColor
        selectView.isBackViewUserInteractionEnabled = false
        //selectView.customView = self.customViewInit(number: self.number, address: "address", gas: "gas", remark: "无备注")
        return selectView
    }()
    
    func customViewInit(number: String, address: String, gas: String, remark: String) -> UIView {
        
        let width : CGFloat = kScreenWidth - 48
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth * 2, height: 442)
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth * 2, height: 442 + kBottomMaginHeight)
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        let leftContentView = UIView()
        leftContentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 442 + kBottomMaginHeight)
        contentView.addSubview(leftContentView)
        
        //左侧视图
        
        let topBarView = { () -> UIView in
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 60))
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
            //label.center = view.center
            label.text = "确认转账"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18)
            label.textColor = JXFfffffColor
            view.addSubview(label)
            //label.sizeToFit()
            
            let button = UIButton()
            button.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
            //button.center = CGPoint(x: 30, y: view.jxCenterY)
            //button.setTitle("×", for: .normal)
            button.tintColor = JXFfffffColor
            button.setImage(UIImage(named: "Close")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button.setTitleColor(JX333333Color, for: .normal)
            button.contentVerticalAlignment = .center
            button.contentHorizontalAlignment = .center
            button.addTarget(self, action: #selector(closeStatus), for: .touchUpInside)
            view.addSubview(button)
            
            return view
        }()
        leftContentView.addSubview(topBarView)
        
        
        let nameLabel = UILabel()
        nameLabel.frame = CGRect(x: 24, y: topBarView.jxBottom + 20, width: width, height: 30)
        nameLabel.text = "\(number) \(configuration_coinName)"
        nameLabel.textColor = JXFfffffColor
        nameLabel.font = UIFont.systemFont(ofSize: 25)
        nameLabel.textAlignment = .center
        
        leftContentView.addSubview(nameLabel)
        
        //1
        let leftLabel1 = UILabel()
        leftLabel1.frame = CGRect(x: 24, y: nameLabel.jxBottom + 31, width: 65, height: 51)
        leftLabel1.text = "交易金额"
        leftLabel1.textColor = JXText50Color
        leftLabel1.font = UIFont.systemFont(ofSize: 13)
        leftLabel1.textAlignment = .left
        leftContentView.addSubview(leftLabel1)
        
        let rightLabel1 = UILabel()
        rightLabel1.frame = CGRect(x: leftLabel1.jxRight, y: leftLabel1.jxTop, width: kScreenWidth - 48 - leftLabel1.jxWidth, height: 51)
        if let num = Double(number) {
            rightLabel1.text = "\(num * configuration_coinPrice) \(configuration_valueType)"
        } else {
            rightLabel1.text = "\(0) \(configuration_valueType)"
        }
        
        rightLabel1.textColor = JXRedColor
        rightLabel1.font = UIFont.systemFont(ofSize: 14)
        rightLabel1.textAlignment = .right
        leftContentView.addSubview(rightLabel1)
        
        let line1 = UIView()
        line1.frame = CGRect(x: nameLabel.jxLeft, y: leftLabel1.jxBottom, width: width, height: 1)
        line1.backgroundColor = JXSeparatorColor
        leftContentView.addSubview(line1)
        
        //2
        let leftLabel2 = UILabel()
        leftLabel2.frame = CGRect(x: 24, y: line1.jxBottom, width: 65, height: 51)
        leftLabel2.text = "交易单价"
        leftLabel2.textColor = JXText50Color
        leftLabel2.font = UIFont.systemFont(ofSize: 13)
        leftLabel2.textAlignment = .left
        leftContentView.addSubview(leftLabel2)
        
        let rightLabel2 = UILabel()
        rightLabel2.frame = CGRect(x: leftLabel2.jxRight, y: leftLabel2.jxTop, width: kScreenWidth - 48 - leftLabel2.jxWidth, height: 51)
        rightLabel2.text = "\(configuration_coinPrice) \(configuration_valueType)"
        rightLabel2.textColor = JXTextColor
        rightLabel2.font = UIFont.systemFont(ofSize: 14)
        rightLabel2.textAlignment = .right
        leftContentView.addSubview(rightLabel2)
        
        let line2 = UIView()
        line2.frame = CGRect(x: nameLabel.jxLeft, y: leftLabel2.jxBottom, width: width, height: 1)
        line2.backgroundColor = JXSeparatorColor
        leftContentView.addSubview(line2)
        
        
        //3
        let leftLabel3 = UILabel()
        leftLabel3.frame = CGRect(x: 24, y: line2.jxBottom , width: 65, height: 51)
        leftLabel3.text = "交易数量"
        leftLabel3.textColor = JXText50Color
        leftLabel3.font = UIFont.systemFont(ofSize: 13)
        leftLabel3.textAlignment = .left
        leftContentView.addSubview(leftLabel3)
        
        let rightLabel3 = UILabel()
        rightLabel3.frame = CGRect(x: leftLabel3.jxRight, y: leftLabel3.jxTop, width: kScreenWidth - 48 - leftLabel3.jxWidth, height: 51)
        rightLabel3.text = number
        rightLabel3.textColor = JXTextColor
        rightLabel3.font = UIFont.systemFont(ofSize: 14)
        rightLabel3.textAlignment = .right
        leftContentView.addSubview(rightLabel3)
        
        let line3 = UIView()
        line3.frame = CGRect(x: nameLabel.jxLeft, y: leftLabel3.jxBottom, width: width, height: 1)
        line3.backgroundColor = JXSeparatorColor
        leftContentView.addSubview(line3)
        
        
        //4
        let leftLabel4 = UILabel()
        leftLabel4.frame = CGRect(x: 24, y: line3.jxBottom, width: 65, height: 51)
        leftLabel4.text = "支付方式"
        leftLabel4.textColor = JXText50Color
        leftLabel4.font = UIFont.systemFont(ofSize: 13)
        leftLabel4.textAlignment = .left
        leftContentView.addSubview(leftLabel4)
        
        //        let rightLabel4 = UILabel()
        //        rightLabel4.frame = CGRect(x: leftLabel4.jxRight, y: leftLabel4.jxTop, width: kScreenWidth - 48 - leftLabel4.jxWidth, height: 51)
        //        rightLabel4.text = remark
        //        rightLabel4.textColor = JXTextColor
        //        rightLabel4.font = UIFont.systemFont(ofSize: 14)
        //        rightLabel4.textAlignment = .right
        //        leftContentView.addSubview(rightLabel4)
        
        
        
        self.rightButton = UIButton()
        rightButton.frame = CGRect(x: leftLabel4.jxRight, y: leftLabel4.jxTop, width: kScreenWidth - 48 - leftLabel4.jxWidth - 20, height: 51)
        rightButton.setTitle(self.payName, for: .normal)
        rightButton.setTitleColor(JXTextColor, for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightButton.addTarget(self, action: #selector(selectPay), for: .touchUpInside)
        rightButton.contentHorizontalAlignment = .right
        leftContentView.addSubview(rightButton)
        
        let arrow = UIImageView(frame: CGRect(x: rightButton.jxRight, y: leftLabel4.jxTop + 15.5, width: 20, height: 20))
        arrow.backgroundColor = JXTextColor
        leftContentView.addSubview(arrow)
        
        
        let line4 = UIView()
        line4.frame = CGRect(x: nameLabel.jxLeft, y: leftLabel4.jxBottom, width: width, height: 1)
        line4.backgroundColor = JXSeparatorColor
        leftContentView.addSubview(line4)
        
        
        
        
        let button = UIButton()
        button.frame = CGRect(x: nameLabel.jxLeft, y: line4.jxBottom + 30, width: width, height: 44)
        button.setTitle("下单", for: .normal)
        button.setTitleColor(JXFfffffColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        leftContentView.addSubview(button)
        
        
        button.layer.cornerRadius = 2
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.shadowColor = JX10101aShadowColor.cgColor
        button.setTitleColor(JXFfffffColor, for: .normal)
        button.backgroundColor = JXOrangeColor
        
        
        
        //右侧视图
        
        let rightContentView = UIView()
        rightContentView.frame = CGRect(x: kScreenWidth, y: 0, width: kScreenWidth, height: 442 + kBottomMaginHeight)
        contentView.addSubview(rightContentView)
        
        let topBarView1 = { () -> UIView in
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 60))
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
            //label.center = view.center
            label.text = "输入资金密码"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18)
            label.textColor = JXFfffffColor
            view.addSubview(label)
            //label.sizeToFit()
            
            let button = UIButton()
            button.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
            //button.center = CGPoint(x: 30, y: view.jxCenterY)
            //button.setTitle("×", for: .normal)
            button.tintColor = JXFfffffColor
            button.setImage(UIImage(named: "icon-back")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button.setTitleColor(JX333333Color, for: .normal)
            button.contentVerticalAlignment = .center
            button.contentHorizontalAlignment = .center
            button.addTarget(self, action: #selector(backTo), for: .touchUpInside)
            view.addSubview(button)
            
            
            let button1 = UIButton()
            button1.frame = CGRect(x: kScreenWidth - 80 - 24, y: 10, width: 80, height: 40)
            //button.center = CGPoint(x: 30, y: view.jxCenterY)
            button1.setTitle("忘记密码？", for: .normal)
            
            button1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button1.setTitleColor(JXOrangeColor, for: .normal)
            button1.contentVerticalAlignment = .center
            button1.contentHorizontalAlignment = .right
            button1.addTarget(self, action: #selector(forgotPsd), for: .touchUpInside)
            view.addSubview(button1)
            
            return view
        }()
        rightContentView.addSubview(topBarView1)
        
        
        self.psdTextView = PasswordTextView(frame: CGRect(x: kScreenWidth + (kScreenWidth - 176) / 2, y: topBarView1.jxBottom, width: 176, height: 60))
        //psdTextView.textField.delegate = self
        psdTextView.backgroundColor = UIColor.white //要先设置颜色，再设置透明，不然不起作用，还有绘制的问题，待研究
        contentView.addSubview(psdTextView)
        
        psdTextView.backgroundColor = UIColor.clear
        psdTextView.limit = 4
        psdTextView.bottomLineColor = JXSeparatorColor
        psdTextView.textColor = JXFfffffColor
        psdTextView.font = UIFont.systemFont(ofSize: 42)
        psdTextView.completionBlock = { (text,isFinish) -> () in
            
            if isFinish {
                self.closeStatus()
                print("12345678")
//                self.vm.transfer(address: self.addressTextField.text!, amount: Int(self.numberTextField.text!) ?? 0, safePassword: text, remarks: self.remarkTextField.text!, completion: { (_, msg, isSuc) in
//                    if isSuc {
//                        let storyboard = UIStoryboard(name: "Wallet", bundle: nil)
//                        let vc = storyboard.instantiateViewController(withIdentifier: "transferSuccess") as! TransferSuccessController
//                        vc.address = self.addressTextField.text
//                        vc.number = self.numberTextField.text
//                        vc.hidesBottomBarWhenPushed = true
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    } else {
//                        ViewManager.showNotice(msg)
//                    }
//                })
            }
        }
        rightContentView.addSubview(topBarView1)
        
        
        
        
        return contentView
    }
    @objc func selectPay() {
        //self.closeStatus()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionFlipFromRight, animations: {
            self.statusBottomView.frame.origin.x = -kScreenWidth
        }) { (isFinish) in
            if isFinish {
                //self.psdTextView.textField.becomeFirstResponder()
            }
        }
        
    }
    @objc func backTo() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionFlipFromLeft, animations: {
            self.statusBottomView.frame.origin.x = 0
        }, completion: nil)
    }
    @objc func forgotPsd() {
        print("forgot")
        let storyboard = UIStoryboard(name: "My", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "modifyTradePsw") as! ModifyTradePswController
        vc.hidesBottomBarWhenPushed = true
        vc.type = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func confirm() {
        print("confirm")
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionFlipFromRight, animations: {
            self.statusBottomView.frame.origin.x = -kScreenWidth
        }) { (isFinish) in
            if isFinish {
                self.psdTextView.textField.becomeFirstResponder()
            }
        }
//        self.showMBProgressHUD()
//        self.vm.buyQuick(payType: self.payType, amount: Int(text) ?? 0, completion: { (_, msg, isSuc) in
//            self.hideMBProgressHUD()
//            if isSuc {
//                let vc = OrderDetailController()
//                vc.id = self.vm.id
//                self.navigationController?.pushViewController(vc, animated: true)
//            } else {
//                ViewManager.showNotice(msg)
//            }
//        })
    }
    @objc func closeStatus() {
        self.statusBottomView.dismiss()
    }
}
extension ScanViewController : AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            guard
                let metadataObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject,
                let codeStr = metadataObject.stringValue
            else {
                return
            }
            session.stopRunning()
            
            if self.validate(code: codeStr) == false {
                ViewManager.showNotice("无效地址")
            } else {
                if let block = callBlock {
                    block(codeStr)
                }
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    func validate(code: String) -> Bool {
        if code.count != 42 {
            return false
        }
        if code.hasPrefix("0x") == false{
            return false
        }
        return true
    }
}
