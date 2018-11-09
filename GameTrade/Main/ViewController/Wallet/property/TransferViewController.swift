//
//  TransferViewController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/2.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class TransferViewController: BaseViewController {
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryView: UIView!
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var remarkTextField: UITextField!
    
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var useLabel: UILabel!
    @IBOutlet weak var limitLabel: UILabel!
    
    @IBOutlet weak var tradeButton: UIButton!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    
    var noticeView : JXSelectView?
    
    var psdTextView : PasswordTextView!
    
    var vm = SellVM()
    
    lazy var sendVC: UINavigationController = {
        let v = UINavigationController(rootViewController: UIViewController())
        
        v.modalPresentationStyle = .overCurrentContext
        //v.modalTransitionStyle = .crossDissolve
        v.navigationBar.isHidden = true
        v.view.backgroundColor = UIColor.clear
        return v
    }()
    var isUseSel = true //启用selectView 还是modelViewController
    
    var vcView : UIView!
    
    lazy var rightBarButtonItem: UIBarButtonItem = {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "scanIcon"), for: .normal)
        //leftButton.imageEdgeInsets = UIEdgeInsetsMake(7.5, 0, 12, 24)
        leftButton.addTarget(self, action: #selector(goScan), for: .touchUpInside)
        let item = UIBarButtonItem.init(customView: leftButton)
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "发币"
  
        self.addressTextField.attributedPlaceholder = NSAttributedString(string: "收款人钱包地址，一般为0x开头的42位字", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:JXPlaceHolerColor])
        self.numberTextField.attributedPlaceholder = NSAttributedString(string: "发币数量", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:JXPlaceHolerColor])
        self.remarkTextField.attributedPlaceholder = NSAttributedString(string: "备注（选填）", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:JXPlaceHolerColor])
        
        self.useLabel.text = "可用：\(UserManager.manager.userEntity.property.balance)"
        self.limitLabel.text = "0/16"
        
        self.tradeButton.layer.cornerRadius = 2
        self.tradeButton.layer.shadowOpacity = 1
        self.tradeButton.layer.shadowRadius = 10
        self.tradeButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.tradeButton.layer.shadowColor = JX10101aShadowColor.cgColor
        
        self.updateButtonStatus()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
        self.requestData()
        
        self.addressTextField.text = "0xf3bbce303e2532f8b072ca15e0fe6cd7823228c1"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kNavStatusHeight
        self.bottomConstraint.constant = kBottomMaginHeight + 20
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TransferSuccessController {
            vc.address = self.addressTextField.text
            //vc.name = self.currentEntity?.shortName
            vc.number = self.numberTextField.text
        }
    }

    @IBAction func goScan() {
        self.view.endEditing(true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ScanVC") as! ScanViewController
        vc.hidesBottomBarWhenPushed = true
        vc.callBlock = { (address) in
            self.addressTextField.text = address
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func showNoticeView() {
        let width : CGFloat = kScreenWidth - 40 * 2
        let height : CGFloat = 300
        
        self.noticeView = JXSelectView(frame: CGRect(x: 0, y: 0, width: width, height: height), style: .custom)
        self.noticeView?.position = .middle
        self.noticeView?.customView = {
            
            let contentView = UIView()
            contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: height)
            
            let backgroundView = UIView()
            backgroundView.frame = CGRect(x: 40, y: 0, width: width, height: height)
            contentView.addSubview(backgroundView)
            
            let gradientLayer = CAGradientLayer.init()
            gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
            gradientLayer.locations = [0]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
            gradientLayer.cornerRadius = 5
            backgroundView.layer.insertSublayer(gradientLayer, at: 0)
            
            
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: width, height: 100)
            //label.center = view.center
            label.text = "提示"
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = JXTextColor
            backgroundView.addSubview(label)
            
            
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: 24, y: label.jxBottom + 20, width: width - 24 * 2, height: 30)
            nameLabel.text = "您还未设置资金密码"
            nameLabel.textColor = JXTextColor
            nameLabel.font = UIFont.systemFont(ofSize: 16)
            nameLabel.textAlignment = .center
            
            backgroundView.addSubview(nameLabel)
            nameLabel.center.y = backgroundView.center.y
            
            
            let margin : CGFloat = 16
            let space : CGFloat = 24
            let buttonWidth : CGFloat = (width - 24 - 16 * 2) / 2
            let buttonHeight : CGFloat = 44
            
            let button1 = UIButton()
            button1.frame = CGRect(x: margin, y: height - space - buttonHeight, width: buttonWidth, height: buttonHeight)
            button1.setTitle("稍后再说", for: .normal)
            button1.setTitleColor(JXOrangeColor, for: .normal)
            button1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button1.addTarget(self, action: #selector(hideNoticeView), for: .touchUpInside)
            backgroundView.addSubview(button1)
            
            
            let button = UIButton()
            button.frame = CGRect(x: button1.jxRight + space, y: button1.jxTop, width: buttonWidth, height: buttonHeight)
            button.setTitle("立即设置", for: .normal)
            button.setTitleColor(JXFfffffColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.addTarget(self, action: #selector(setPsd), for: .touchUpInside)
            backgroundView.addSubview(button)
            
            
            button.layer.cornerRadius = 2
            button.layer.shadowOpacity = 1
            button.layer.shadowRadius = 10
            button.layer.shadowOffset = CGSize(width: 0, height: 10)
            button.layer.shadowColor = JX10101aShadowColor.cgColor
            button.setTitleColor(JXFfffffColor, for: .normal)
            button.backgroundColor = JXOrangeColor
            
            return contentView
        }()
        
        self.noticeView?.show()
    }
    @objc func hideNoticeView() {
        self.noticeView?.dismiss()
    }
    @objc func setPsd() {
        self.hideNoticeView()
        
        let storyboard = UIStoryboard(name: "My", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "modifyTradePsw") as! ModifyTradePswController
        vc.hidesBottomBarWhenPushed = true
        vc.type = 2
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func showBottomView() {
 
        guard let number = self.numberTextField.text, number.isEmpty == false  else {
            ViewManager.showNotice("请填写转账数量")
            return
        }
        guard let address = self.addressTextField.text, address.isEmpty == false else {
            ViewManager.showNotice("请填写收款人地址")
            return
        }

        print(address,number)
        
        if UserManager.manager.userEntity.user.safePwdInit != 0 {
            if isUseSel {
                self.statusBottomView.customView = self.customViewInit(number: number, address: address, remark: self.remarkTextField.text ?? "无")
                self.statusBottomView.show(inView: self.view)
            } else {
                self.vcView = self.customViewInit(number: number, address: address, gas: "gas", remark: self.remarkTextField.text ?? "无")
                //self.vcView = self.customViewInit(number: number, address: address, gas: "gas", remark: self.remarkTextField.text ?? "无备注")
                self.vcView.frame = CGRect(x: 0, y: kScreenHeight - 442 - kBottomMaginHeight, width: kScreenWidth * 2, height: 442 + kBottomMaginHeight)
                self.sendVC.view.addSubview(self.vcView)
                self.present(self.sendVC, animated: true, completion: nil)
            }
        } else {
            self.showNoticeView()
        }
        
        
//        self.statusBottomView.customView = self.customViewInit(number: number, address: address, gas: "gas", remark: self.remarkTextField.text ?? "无备注")
//        self.statusBottomView.show()
        
        
//        self.statusBottomView.addSubview(self.statusBottomView.customView!)
//        self.statusBottomView.frame = CGRect(x: 0, y: kScreenHeight - 442 - kBottomMaginHeight, width: kScreenWidth * 2, height: 442 + kBottomMaginHeight)
//        self.statusBottomView.customView?.frame = CGRect(x: 0, y: kScreenHeight - 442 - kBottomMaginHeight, width: kScreenWidth * 2, height: 442 + kBottomMaginHeight)
//        self.sendVC.view.addSubview(self.statusBottomView)
//        self.present(self.sendVC, animated: true, completion: nil)
        
    }
    
    lazy var statusBottomView: JXSelectView = {
        let selectView = JXSelectView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 200), style: JXSelectViewStyle.custom)
        selectView.backgroundColor = JXOrangeColor
        selectView.isBackViewUserInteractionEnabled = false
//        selectView.topBarView = {
//            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 260))
//
//            let label = UILabel()
//            label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 59.5)
//            //label.center = view.center
//            label.text = "确认转账"
//            label.textAlignment = .center
//            label.font = UIFont.systemFont(ofSize: 18)
//            label.textColor = JXFfffffColor
//            view.addSubview(label)
//            //label.sizeToFit()
//
//            let button = UIButton()
//            button.frame = CGRect(x: 10, y: 8.5, width: 40, height: 40)
//            //button.center = CGPoint(x: 30, y: view.jxCenterY)
//            //button.setTitle("×", for: .normal)
//            button.tintColor = JXFfffffColor
//            button.setImage(UIImage(named: "Close")?.withRenderingMode(.alwaysTemplate), for: .normal)
//            button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
//            button.setTitleColor(JX333333Color, for: .normal)
//            button.contentVerticalAlignment = .center
//            button.contentHorizontalAlignment = .center
//            button.addTarget(self, action: #selector(closeStatus), for: .touchUpInside)
//            view.addSubview(button)
//
//            return view
//        }()
//        selectView.isUseCustomTopBar = true
        
        return selectView
    }()
    func customViewInit(number: String, address: String, gas: String, remark: String) -> UIView {
//        guard let entity = self.currentEntity else {
//            return UIView()
//        }
        //
        let width : CGFloat = kScreenWidth - 48
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth * 2, height: 442 + kBottomMaginHeight)
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth * 2, height: 442 + kBottomMaginHeight)
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        
//        let backView = UIView()
//        backView.frame = CGRect(x: 24, y: 0, width: width, height: contentView.jxHeight)
//        backView.backgroundColor = UIColor.white
//        contentView.addSubview(backView)
        
        let topBarView = { () -> UIView in
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 60))
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
            //label.center = view.center
            label.text = "确认发送"
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
        contentView.addSubview(topBarView)
        
        
        let topBarView1 = { () -> UIView in
            let view = UIView.init(frame: CGRect.init(x: kScreenWidth, y: 0, width: kScreenWidth, height: 60))
            
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
            button.setImage(UIImage(named: "Close")?.withRenderingMode(.alwaysTemplate), for: .normal)
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
        contentView.addSubview(topBarView1)
        
        
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
                
                self.vm.transfer(address: self.addressTextField.text!, amount: Int(self.numberTextField.text!) ?? 0, safePassword: text, remarks: self.remarkTextField.text!, completion: { (_, msg, isSuc) in
                    if isSuc {
                        let storyboard = UIStoryboard(name: "Wallet", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "transferSuccess") as! TransferSuccessController
                        vc.address = self.addressTextField.text
                        vc.number = self.numberTextField.text
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        ViewManager.showNotice(msg)
                    }
                })
            }
        }
        
        let nameLabel = UILabel()
        nameLabel.frame = CGRect(x: 24, y: topBarView.jxBottom + 20, width: width, height: 30)
        nameLabel.text = "\(number) \(configuration_coinName)"
        nameLabel.textColor = JXTextColor
        nameLabel.font = UIFont.systemFont(ofSize: 25)
        nameLabel.textAlignment = .center
        
        contentView.addSubview(nameLabel)
        
        
        let topLabel = UILabel()
        topLabel.frame = CGRect(x: nameLabel.jxLeft, y: nameLabel.jxBottom + 31 , width: width, height: 18)
        topLabel.text = "对方账户地址"
        topLabel.textColor = JXText50Color
        topLabel.font = UIFont.systemFont(ofSize: 13)
        topLabel.textAlignment = .left
        
        contentView.addSubview(topLabel)
        
        let addressLabel = UILabel()
        addressLabel.frame = CGRect(x: nameLabel.jxLeft, y: topLabel.jxBottom + 8, width: width, height: 40)
        addressLabel.text = "\(address)"
        addressLabel.textColor = JXTextColor
        addressLabel.font = UIFont.systemFont(ofSize: 16)
        addressLabel.textAlignment = .left
        addressLabel.numberOfLines = 0
        
//        addressLabel.layer.shadowColor =  UIColor.rgbColor(rgbValue: 0xe2e2e2).cgColor
//        addressLabel.layer.shadowOpacity = 0.5
//        addressLabel.layer.shadowRadius = 4
//        addressLabel.layer.shadowOffset = CGSize.init(width: 4, height: 4)
        
        contentView.addSubview(addressLabel)
        
        
        let line1 = UIView()
        line1.frame = CGRect(x: nameLabel.jxLeft, y: addressLabel.jxBottom + 16, width: width, height: 1)
        line1.backgroundColor = JXSeparatorColor
        contentView.addSubview(line1)
        
        let leftLabel = UILabel()
        leftLabel.frame = CGRect(x: 24, y: line1.jxBottom, width: 32, height: 51)
        leftLabel.text = "备注"
        leftLabel.textColor = JXText50Color
        leftLabel.font = UIFont.systemFont(ofSize: 13)
        leftLabel.textAlignment = .left
        contentView.addSubview(leftLabel)
        
        let remarkLabel = UILabel()
        remarkLabel.frame = CGRect(x: leftLabel.jxRight, y: line1.jxBottom, width: kScreenWidth - 48 - leftLabel.jxWidth, height: 51)
        remarkLabel.text = remark
        remarkLabel.textColor = JXTextColor
        remarkLabel.font = UIFont.systemFont(ofSize: 14)
        remarkLabel.textAlignment = .right
        contentView.addSubview(remarkLabel)
        
        let line2 = UIView()
        line2.frame = CGRect(x: nameLabel.jxLeft, y: leftLabel.jxBottom, width: width, height: 1)
        line2.backgroundColor = JXSeparatorColor
        contentView.addSubview(line2)
        
        
        
        let button = UIButton()
        button.frame = CGRect(x: nameLabel.jxLeft, y: line2.jxBottom + 100, width: width, height: 44)
        button.setTitle("发送", for: .normal)
        button.setTitleColor(JXFfffffColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(confirmTransfer), for: .touchUpInside)
        contentView.addSubview(button)
        
        
        button.layer.cornerRadius = 2
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.shadowColor = JX10101aShadowColor.cgColor
        button.setTitleColor(JXFfffffColor, for: .normal)
        button.backgroundColor = JXOrangeColor
        
        return contentView
    }
    func customViewInit(number: String, address: String, remark: String) -> UIView {
        
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
        
        //        let backView = UIView()
        //        backView.frame = CGRect(x: 24, y: 0, width: width, height: contentView.jxHeight)
        //        backView.backgroundColor = UIColor.white
        //        contentView.addSubview(backView)
        
        let topBarView = { () -> UIView in
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 60))
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
            //label.center = view.center
            label.text = "确认发送"
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
        contentView.addSubview(topBarView)
        
        
        let topBarView1 = { () -> UIView in
            let view = UIView.init(frame: CGRect.init(x: kScreenWidth, y: 0, width: kScreenWidth, height: 60))
            
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
        contentView.addSubview(topBarView1)
        
        
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
                
                self.vm.transfer(address: self.addressTextField.text!, amount: Int(self.numberTextField.text!) ?? 0, safePassword: text, remarks: self.remarkTextField.text!, completion: { (_, msg, isSuc) in
                    if isSuc {
                        let storyboard = UIStoryboard(name: "Wallet", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "transferSuccess") as! TransferSuccessController
                        vc.address = self.addressTextField.text
                        vc.number = self.numberTextField.text
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        ViewManager.showNotice(msg)
                    }
                })
            }
        }
        
        let nameLabel = UILabel()
        nameLabel.frame = CGRect(x: 24, y: topBarView.jxBottom + 20, width: width, height: 30)
        nameLabel.text = "\(number) \(configuration_coinName)"
        nameLabel.textColor = JXTextColor
        nameLabel.font = UIFont.systemFont(ofSize: 25)
        nameLabel.textAlignment = .center
        
        contentView.addSubview(nameLabel)
        
        
        let topLabel = UILabel()
        topLabel.frame = CGRect(x: nameLabel.jxLeft, y: nameLabel.jxBottom + 31 , width: width, height: 18)
        topLabel.text = "对方账户地址"
        topLabel.textColor = JXText50Color
        topLabel.font = UIFont.systemFont(ofSize: 13)
        topLabel.textAlignment = .left
        
        contentView.addSubview(topLabel)
        
        let addressLabel = UILabel()
        addressLabel.frame = CGRect(x: nameLabel.jxLeft, y: topLabel.jxBottom + 8, width: width, height: 40)
        addressLabel.text = "\(address)"
        addressLabel.textColor = JXTextColor
        addressLabel.font = UIFont.systemFont(ofSize: 16)
        addressLabel.textAlignment = .left
        addressLabel.numberOfLines = 0
        
        //        addressLabel.layer.shadowColor =  UIColor.rgbColor(rgbValue: 0xe2e2e2).cgColor
        //        addressLabel.layer.shadowOpacity = 0.5
        //        addressLabel.layer.shadowRadius = 4
        //        addressLabel.layer.shadowOffset = CGSize.init(width: 4, height: 4)
        
        contentView.addSubview(addressLabel)
        
        
        let line1 = UIView()
        line1.frame = CGRect(x: nameLabel.jxLeft, y: addressLabel.jxBottom + 16, width: width, height: 1)
        line1.backgroundColor = JXSeparatorColor
        contentView.addSubview(line1)
        
        let leftLabel = UILabel()
        leftLabel.frame = CGRect(x: 24, y: line1.jxBottom, width: 32, height: 51)
        leftLabel.text = "备注"
        leftLabel.textColor = JXText50Color
        leftLabel.font = UIFont.systemFont(ofSize: 13)
        leftLabel.textAlignment = .left
        contentView.addSubview(leftLabel)
        
        let remarkLabel = UILabel()
        remarkLabel.frame = CGRect(x: leftLabel.jxRight, y: line1.jxBottom, width: kScreenWidth - 48 - leftLabel.jxWidth, height: 51)
        remarkLabel.text = remark
        remarkLabel.textColor = JXTextColor
        remarkLabel.font = UIFont.systemFont(ofSize: 14)
        remarkLabel.textAlignment = .right
        contentView.addSubview(remarkLabel)
        
        let line2 = UIView()
        line2.frame = CGRect(x: nameLabel.jxLeft, y: leftLabel.jxBottom, width: width, height: 1)
        line2.backgroundColor = JXSeparatorColor
        contentView.addSubview(line2)
        
        
        
        let button = UIButton()
        button.frame = CGRect(x: nameLabel.jxLeft, y: line2.jxBottom + 100, width: width, height: 44)
        button.setTitle("发送", for: .normal)
        button.setTitleColor(JXFfffffColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(confirmTransfer), for: .touchUpInside)
        contentView.addSubview(button)
        
        
        button.layer.cornerRadius = 2
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.shadowColor = JX10101aShadowColor.cgColor
        button.setTitleColor(JXFfffffColor, for: .normal)
        button.backgroundColor = JXOrangeColor
        
        return contentView
    }
    @objc func confirmTransfer() {
    
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionFlipFromRight, animations: {
            if self.isUseSel {
                self.statusBottomView.frame.origin.x = -kScreenWidth
            } else {
                self.vcView.frame.origin.x = -kScreenWidth
            }
        }) { (isFinish) in
            if isFinish {
                self.psdTextView.textField.becomeFirstResponder()
            }
        }
    }

    
    @objc func backTo() {
        
        if self.isUseSel {
            self.view.endEditing(true)
        } else {
            self.sendVC.view.endEditing(true)
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionFlipFromLeft, animations: {
            if self.isUseSel {
                self.statusBottomView.frame.origin.x = 0
            } else {
                self.vcView.frame.origin.x = 0
            }
        }, completion: nil)
    }
    @objc func forgotPsd() {
        print("forgot")
        if self.isUseSel {
            let storyboard = UIStoryboard(name: "My", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "modifyTradePsw") as! ModifyTradePswController
            vc.hidesBottomBarWhenPushed = true
            vc.type = 0
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            self.sendVC.dismiss(animated: false) {
                let storyboard = UIStoryboard(name: "My", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "modifyTradePsw") as! ModifyTradePswController
                vc.hidesBottomBarWhenPushed = true
                vc.type = 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    @objc func closeStatus() {
    
        if isUseSel {
            self.statusBottomView.dismiss()
        } else {
            self.sendVC.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension TransferViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == remarkTextField {
            self.showBottomView()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //删除键
        if string == "" {
            return true
        }
        if
            textField == numberTextField,
            let num = textField.text,
            let numDouble = Double(num + string), numDouble >= UserManager.manager.userEntity.property.balance{
            
            return false
            
        } else if textField == remarkTextField {
            if range.location > 15 {
                return false
            }
        } else {
            return true
        }
        
        return true
    }
    @objc func textChange(notify: NSNotification) {
        
        if notify.object is UITextField {
            self.updateButtonStatus()
        }
    }
    func updateButtonStatus() {
        if
            let name = self.addressTextField.text, name.isEmpty == false,
            let card = self.numberTextField.text, card.isEmpty == false{
            
            self.tradeButton.isEnabled = true
            self.tradeButton.backgroundColor = JXOrangeColor
            self.tradeButton.setTitleColor(JXTextColor, for: .normal)

        } else {
            
            self.tradeButton.isEnabled = false
            self.tradeButton.backgroundColor = UIColor.rgbColor(rgbValue: 0x9b9b9b)
            self.tradeButton.setTitleColor(UIColor.rgbColor(rgbValue: 0xb5b5b5), for: .normal)
            
        }
        if let remark = self.remarkTextField.text {
            self.limitLabel.text = "\(remark.count)/16"
        }
    }
}
