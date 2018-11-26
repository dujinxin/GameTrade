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
    @IBOutlet weak var photoButton: UIButton!
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
    
    var type = 0 //0 地址  1 付款
    
    
    var id : String?
    var webNanme : String?
    var orderId : String?
    var amount : String?
    var expireTime : String?
    var sign : String?
    
    var vm = HomeVM()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidLoad() {
        //super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true

        self.backButton.tintColor = UIColor.white
        self.scanImageView.tintColor = UIColor.blue
        self.topView.alpha = 0.5
        self.leftView.alpha = 0.5
        self.rightView.alpha = 0.5
        self.bottomView.alpha = 0.5
        
        self.controlButton.setImage(#imageLiteral(resourceName: "off"), for: .normal)
        self.controlButton.setImage(#imageLiteral(resourceName: "on"), for: .selected)
        
//        self.statusBottomView.customView = self.customViewInit(number: "text", address: "address", gas: "gas", remark: "无")
//        self.statusBottomView.show(inView: self.view)
//        self.psdTextView.textField.becomeFirstResponder()
        
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
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kStatusBarHeight + 7
    }
    private func setKeyBoardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    @IBAction func selectPhoto(_ sender: Any) {
        self.session.stopRunning()
        
        let imagePicker = UIImagePickerController()
        imagePicker.title = "选择照片"
        //        imagePicker.navigationBar.barTintColor = UIColor.blue
        imagePicker.navigationBar.tintColor = UIColor.black
        //print(self.imagePicker?.navigationItem.rightBarButtonItem!)
        
        imagePicker.delegate = self
//        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
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
        contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth * 2, height: 562)
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth * 2, height: 562 + kBottomMaginHeight)
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        let leftContentView = UIView()
        leftContentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 562 + kBottomMaginHeight)
        contentView.addSubview(leftContentView)
        
        //左侧视图
        
        let topBarView = { () -> UIView in
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 60))
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
            //label.center = view.center
            label.text = "请输入资金密码"
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
        nameLabel.text = "\(self.amount ?? "0") \(configuration_coinName)"
        nameLabel.textColor = JXFfffffColor
        nameLabel.font = UIFont.systemFont(ofSize: 25)
        nameLabel.textAlignment = .center
        
        leftContentView.addSubview(nameLabel)
        
        //1
        let leftLabel1 = UILabel()
        leftLabel1.frame = CGRect(x: 24, y: nameLabel.jxBottom + 30, width: 65, height: 50)
        leftLabel1.text = "收款商户"
        leftLabel1.textColor = JXText50Color
        leftLabel1.font = UIFont.systemFont(ofSize: 13)
        leftLabel1.textAlignment = .left
        leftContentView.addSubview(leftLabel1)
        
        let rightLabel1 = UILabel()
        rightLabel1.frame = CGRect(x: leftLabel1.jxRight, y: leftLabel1.jxTop, width: kScreenWidth - 48 - leftLabel1.jxWidth, height: 50)
        rightLabel1.text = self.vm.webName
        rightLabel1.textColor = JXTextColor
        rightLabel1.font = UIFont.systemFont(ofSize: 14)
        rightLabel1.textAlignment = .right
        leftContentView.addSubview(rightLabel1)
        
        let line1 = UIView()
        line1.frame = CGRect(x: nameLabel.jxLeft, y: leftLabel1.jxBottom, width: width, height: 1)
        line1.backgroundColor = JXSeparatorColor
        leftContentView.addSubview(line1)
        

        self.psdTextView = PasswordTextView(frame: CGRect(x: (kScreenWidth - 176) / 2, y: line1.jxBottom + 30, width: 176, height: 60))
        //psdTextView.textField.delegate = self
        psdTextView.backgroundColor = UIColor.white //要先设置颜色，再设置透明，不然不起作用，还有绘制的问题，待研究
        leftContentView.addSubview(psdTextView)
        
        psdTextView.backgroundColor = UIColor.clear
        psdTextView.limit = 4
        psdTextView.bottomLineColor = JXSeparatorColor
        psdTextView.textColor = JXFfffffColor
        psdTextView.font = UIFont.systemFont(ofSize: 21)
        psdTextView.completionBlock = { (text,isFinish) -> () in
            
            if isFinish {
                self.closeStatus()
                self.showMBProgressHUD()
                
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.5, execute: {
                    print("12345678")
                    guard let numStr = self.amount, let num = Int(numStr) else { return }
                    self.vm.scanPay(id: self.id ?? "", orderId: self.orderId ?? "", amount: num, expireTime: self.expireTime ?? "", sign: self.sign ?? "", safePassword: text, completion: { (_, msg, isSuc) in
                        self.hideMBProgressHUD()
                        if isSuc {
                            let vc = WalletRecordDetailController()
                            vc.hidesBottomBarWhenPushed = true
                            //vc.tradeEntity = entity
                            vc.type = 3
                            vc.bizId = self.vm.bizId
                            //1:买币，2:卖币，3:支付，4:收款，5:转账，6:手续费，当type为6时不可查看详情
                            vc.pageType = .payed
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            ViewManager.showNotice(msg)
                        }
                    })
                })
                
                
            }
        }
       
        return contentView
    }

    @objc func forgotPsd() {
        print("forgot")
        let storyboard = UIStoryboard(name: "My", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "modifyTradePsw") as! ModifyTradePswController
        vc.hidesBottomBarWhenPushed = true
        vc.type = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func closeStatus() {
        self.statusBottomView.dismiss()
        self.session.startRunning()
    }
}
//MARK:UIKeyboardNotification
extension ScanViewController {
    @objc func keyboardWillShow(notify:Notification) {
        
        guard
            let userInfo = notify.userInfo,
            let rect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        UIView.animate(withDuration: animationDuration, animations: {
            self.statusBottomView.frame.origin.y = 300 + rect.height
        }) { (finish) in
            //
        }
    }
    @objc func keyboardWillHide(notify:Notification) {
        print("notify = ","notify")
        guard
            let userInfo = notify.userInfo,
            let _ = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        UIView.animate(withDuration: animationDuration, animations: {
            
        }) { (finish) in
            
        }
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
            print(codeStr)
            self.handleCode(codeStr)
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
    
    func handleCode(_ str: String) {
        
        if self.type == 0 {
            if self.validate(code: str) == false {
                ViewManager.showNotice("无效地址")
            } else {
                if let block = callBlock {
                    block(str)
                }
            }
            self.navigationController?.popViewController(animated: true)
        } else {
            
            if str.hasPrefix(configuration_coinName) == true {
                let result = str.components(separatedBy: "scan_pay?")
                if result.count > 1 {
                    let paramStr = result[1]
                    let data = paramStr.components(separatedBy: "&")
                    data.forEach { (value) in
                        let keyValues = value.components(separatedBy: "=")
                        if value.hasPrefix("webName"), keyValues.count > 1 {
                            self.webNanme = keyValues[1]
                        }
                        if value.hasPrefix("id"), keyValues.count > 1 {
                            self.id = keyValues[1]
                        }
                        if value.hasPrefix("orderId"), keyValues.count > 1 {
                            self.orderId = keyValues[1]
                        }
                        if value.hasPrefix("expireTime"), keyValues.count > 1 {
                            self.expireTime = keyValues[1]
                        }
                        if value.hasPrefix("amount"), keyValues.count > 1 {
                            self.amount = keyValues[1]
                        }
                        if value.hasPrefix("sign"), keyValues.count > 1 {
                            self.sign = keyValues[1]
                        }
                    }
                }
            }
            guard let numStr = self.amount, let num = Int(numStr) else { return }
            self.vm.scanPayGetName(id: self.id ?? "", orderId: self.orderId ?? "", amount: num, expireTime: self.expireTime ?? "", sign: self.sign ?? "") { (_, msg, isSuc) in
                if isSuc {
                    self.statusBottomView.customView = self.customViewInit(number: "text", address: "address", gas: "gas", remark: "无")
                    self.statusBottomView.show(inView: self.view)
                    self.psdTextView.textField.becomeFirstResponder()
                } else {
                    ViewManager.showNotice(msg)
                    self.session.startRunning()
                }
            }
            
        }
    }
}
extension ScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    //        let button = UIButton()
    //        button.frame = CGRect(x: 0, y: 0, width: 44, height: 30)
    //        button.setTitle("取消", for: .normal)
    //        button.setTitleColor(UIColor.darkGray, for: .normal)
    //        let item = UIBarButtonItem.init(customView: button)
    //
    //        viewController.navigationItem.rightBarButtonItem = item//UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(hideImagePickerViewContorller))
    //    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        self.session.startRunning()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        self.session.stopRunning()
        
        let mediaType = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as! String
        if mediaType == "public.image" {
            guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage, let ciImage = CIImage(image: image) else {
                return
            }
            //UIImage.image(originalImage: image, to: view.bounds.width)
//            self.userImageView.image = image
//            isSelected = true
            
            // 2.从选中的图片中读取二维码数据
            // 2.1创建一个探测器
            // CIDetectorTypeFace -- 探测器还可以搞人脸识别
            guard let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow]) else { return }
            // 2.2利用探测器探测数据
            let results = detector.features(in: ciImage)
            // 2.3取出探测到的数据
            for result in results {
                guard
                    let feature = result as? CIQRCodeFeature,
                    let codeStr = feature.messageString
                    else {
                        return
                }
                print(codeStr)
                self.handleCode(codeStr)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
