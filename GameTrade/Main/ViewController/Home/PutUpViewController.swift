//
//  PutUpViewController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/16.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class PutUpViewController: BaseViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topConstrants: NSLayoutConstraint!
    
    @IBOutlet weak var useLeftLabel: UILabel!
    @IBOutlet weak var sellLeftLabel: UILabel!
    @IBOutlet weak var priseLeftLabel: UILabel!
    @IBOutlet weak var totalLeftLabel: UILabel!
    @IBOutlet weak var serviceLeftLabel: UILabel!
    @IBOutlet weak var payTotalLeftLabel: UILabel!
    @IBOutlet weak var payNameLeftLabel: UILabel!
    
    @IBOutlet weak var useLabel: UILabel!
    @IBOutlet weak var sellTextField: UITextField!
    @IBOutlet weak var priseLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var payTotalLabel: UILabel!
    @IBOutlet weak var payNameLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!{
        didSet{
            arrowImageView.image = UIImage(named: "arrowRight")?.withRenderingMode(.alwaysTemplate)
            arrowImageView.tintColor = JXMainTextColor
        }
    }
    
    @IBOutlet weak var submitButton: UIButton!{
        didSet{
            submitButton.backgroundColor = JXMainColor
            
            submitButton.layer.cornerRadius = 2
            submitButton.layer.shadowOpacity = 1
            submitButton.layer.shadowRadius = 10
            submitButton.layer.shadowOffset = CGSize(width: 0, height: 10)
            submitButton.layer.shadowColor = JX10101aShadowColor.cgColor
            
            submitButton.addTarget(self, action: #selector(addOrder), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var paySelectView: UIView!
    
    
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    @IBOutlet weak var line4: UIView!
    @IBOutlet weak var line5: UIView!
    @IBOutlet weak var line6: UIView!
    @IBOutlet weak var line7: UIView!
   
    
    var defaultArray: Array = [["title":"可用币数量"],["title":"卖出币数量"],["title":"卖出单价"],["title":"卖出总价"],["title":"手续费"],["title":"实际总价"],["title":"支付方式"]]
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 30, y: 0, width: 200, height: 44)
        button.layer.cornerRadius = 4
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("添加", for: .normal)
        button.setTitleColor(JXFfffffColor, for: .normal)
        button.addTarget(self, action: #selector(addOrder), for: .touchUpInside)
        button.backgroundColor = JXMainColor
        return button
    }()
    
    var vm = SellVM()
    
    var sellTotal = "0 \(configuration_valueType)"
    var sellRealTotal = "0 \(configuration_valueType)"
    var serviceTotal = "0 \(configuration_coinName)"
    
    var sellInfoEntity : SellInfoEntity?
    var payName = "请选择"
    var payType = 0

    //select view
    lazy var statusBottomView: JXSelectView = {
        let selectView = JXSelectView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 200), style: JXSelectViewStyle.custom)
        selectView.backgroundColor = JXFfffffColor
        selectView.isBackViewUserInteractionEnabled = false
        return selectView
    }()
    var psdTextView : PasswordTextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.title = "添加挂单"
        
        self.customNavigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Close"), style: .plain, target: self, action: #selector(close))
        
        self.useLeftLabel.textColor = JXMainText50Color
        self.sellLeftLabel.textColor = JXMainTextColor
        self.priseLeftLabel.textColor = JXMainText50Color
        self.totalLeftLabel.textColor = JXMainText50Color
        self.payTotalLeftLabel.textColor = JXMainText50Color
        self.serviceLeftLabel.textColor = JXMainText50Color
        self.payNameLeftLabel.textColor = JXMainText50Color
        
        
        self.useLabel.textColor = JXMainTextColor
        self.sellTextField.textColor = JXMainTextColor
        self.priseLabel.textColor = JXMainTextColor
        self.totalLabel.textColor = JXMainTextColor
        self.payTotalLabel.textColor = JXRedColor
        self.serviceLabel.textColor = JXMainTextColor
        self.payNameLabel.textColor = JXMainTextColor
       
        
        self.useLabel.text = "\(self.sellInfoEntity?.balance ?? 0)"
        self.sellTextField.text = ""
        self.priseLabel.text = "\(configuration_coinPrice) \(configuration_valueType)"
        self.totalLabel.text = self.sellTotal
        self.serviceLabel.text = self.serviceTotal
        self.payTotalLabel.text = self.sellRealTotal
        self.payNameLabel.text = self.payName
        self.sellTextField.attributedPlaceholder = NSAttributedString(string: "请输入卖出数量", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),NSAttributedString.Key.foregroundColor:JXPlaceHolerColor])
        
        self.paySelectView.isUserInteractionEnabled = true
        self.paySelectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectPay)))
            
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: UITextField.textDidChangeNotification, object: nil)
        
        line1.backgroundColor = JXSeparatorColor
        line2.backgroundColor = JXSeparatorColor
        line3.backgroundColor = JXSeparatorColor
        line4.backgroundColor = JXSeparatorColor
        line5.backgroundColor = JXSeparatorColor
        line6.backgroundColor = JXSeparatorColor
        line7.backgroundColor = JXSeparatorColor
        
        
        
        let bar = JXKeyboardToolBar(frame: CGRect(), views: [sellTextField])
        bar.showBlock = { (view, value) in
            print(view,value)
        }
        
        bar.tintColor = JXMainTextColor
        bar.toolBar.barTintColor = JXViewBgColor
        bar.backgroundColor = JXViewBgColor
        self.view.addSubview(bar)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging {
            self.view.endEditing(true)
        }
    }
    @objc func close() {
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    @objc func addOrder() {
        print("T##items: Any...##Any")
        
        guard let numStr = self.sellTextField.text, numStr.isEmpty == false else {
            ViewManager.showNotice("请输入要挂出币数量")
            return
        }
        guard let num = Int(numStr), num >= 10 else {
            ViewManager.showNotice("最低挂卖数量为10")
            return
        }
        if self.payType == 0 {
            ViewManager.showNotice("请选择收款方式")
            return
        }
        self.view.endEditing(true)
        
        self.statusBottomView.customView = nil
        self.statusBottomView.customView = self.customViewInit(number: num, address: "address", remark: "无")
        self.statusBottomView.show(inView: self.view)
    }
}
//MARK: 挂单
extension PutUpViewController {
    func customViewInit(number: Int, address: String, remark: String) -> UIView {
        
        let width : CGFloat = kScreenWidth - 48
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth * 2, height: 442)
        
        if app_style <= 1 {
            let gradientLayer = CAGradientLayer.init()
            gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
            gradientLayer.locations = [0]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth * 2, height: 442 + kBottomMaginHeight)
            contentView.layer.insertSublayer(gradientLayer, at: 0)
        }
        
        
        let topBarView = { () -> UIView in
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 60))
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
            //label.center = view.center
            label.text = "确认挂单"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18)
            label.textColor = JXMainTextColor
            view.addSubview(label)
            //label.sizeToFit()
            
            let button = UIButton()
            button.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
            //button.center = CGPoint(x: 30, y: view.jxCenterY)
            //button.setTitle("×", for: .normal)
            button.tintColor = JXMainTextColor
            button.setImage(UIImage(named: "Close")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button.setTitleColor(JXMainTextColor, for: .normal)
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
            label.textColor = JXMainTextColor
            view.addSubview(label)
            //label.sizeToFit()
            
            let button = UIButton()
            button.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
            //button.center = CGPoint(x: 30, y: view.jxCenterY)
            //button.setTitle("×", for: .normal)
            button.tintColor = JXMainTextColor
            button.setImage(UIImage(named: "icon-back")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button.setTitleColor(JXMainTextColor, for: .normal)
            button.contentVerticalAlignment = .center
            button.contentHorizontalAlignment = .center
            button.addTarget(self, action: #selector(backTo), for: .touchUpInside)
            view.addSubview(button)
            
            
            let button1 = UIButton()
            button1.frame = CGRect(x: kScreenWidth - 80 - 24, y: 10, width: 80, height: 40)
            //button.center = CGPoint(x: 30, y: view.jxCenterY)
            button1.setTitle("忘记密码？", for: .normal)
            
            button1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button1.setTitleColor(JXMainColor, for: .normal)
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
        psdTextView.textColor = JXMainTextColor
        psdTextView.font = UIFont.systemFont(ofSize: 21)
        psdTextView.completionBlock = { (text,isFinish) -> () in
            
            if isFinish {
                self.closeStatus()
                guard let num = self.sellTextField.text,let number = Int(num) else { return }
                self.vm.sellCreate(payType: self.payType, amount: number, safePassword: text) { (_, msg, isSuc) in
                    if isSuc {
                        if let block = self.backBlock {
                            block()
                        }
                        //self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        ViewManager.showNotice(msg)
                    }
                }
            }
        }
        
        let nameLabel = UILabel()
        nameLabel.frame = CGRect(x: 24, y: topBarView.jxBottom + 20, width: width, height: 30)
        nameLabel.text = "\(number) \(configuration_coinName)"
        nameLabel.textColor = JXMainTextColor
        nameLabel.font = UIFont.systemFont(ofSize: 25)
        nameLabel.textAlignment = .center
        
        contentView.addSubview(nameLabel)
        
        //1
        let leftLabel1 = UILabel()
        leftLabel1.frame = CGRect(x: 24, y: nameLabel.jxBottom + 31, width: 65, height: 51)
        leftLabel1.text = "出售总额"
        leftLabel1.textColor = JXMainText50Color
        leftLabel1.font = UIFont.systemFont(ofSize: 13)
        leftLabel1.textAlignment = .left
        contentView.addSubview(leftLabel1)
        
        let rightLabel1 = UILabel()
        rightLabel1.frame = CGRect(x: leftLabel1.jxRight, y: leftLabel1.jxTop, width: kScreenWidth - 48 - leftLabel1.jxWidth, height: 51)
        rightLabel1.text = "\(Double(number) * configuration_coinPrice) \(configuration_valueType)"
        rightLabel1.textColor = JXRedColor
        rightLabel1.font = UIFont.systemFont(ofSize: 14)
        rightLabel1.textAlignment = .right
        contentView.addSubview(rightLabel1)
        
        let line1 = UIView()
        line1.frame = CGRect(x: nameLabel.jxLeft, y: leftLabel1.jxBottom, width: width, height: 1)
        line1.backgroundColor = JXSeparatorColor
        contentView.addSubview(line1)
        
        //2
        let leftLabel2 = UILabel()
        leftLabel2.frame = CGRect(x: 24, y: line1.jxBottom, width: 65, height: 51)
        leftLabel2.text = "手续费"
        leftLabel2.textColor = JXMainText50Color
        leftLabel2.font = UIFont.systemFont(ofSize: 13)
        leftLabel2.textAlignment = .left
        contentView.addSubview(leftLabel2)
        
        let rightLabel2 = UILabel()
        rightLabel2.frame = CGRect(x: leftLabel2.jxRight, y: leftLabel2.jxTop, width: kScreenWidth - 48 - leftLabel2.jxWidth, height: 51)
        rightLabel2.text = String(format:"%.2f",Double(number) * (self.sellInfoEntity?.saleRate ?? 0)) + " \(configuration_coinName)"
        rightLabel2.textColor = JXMainTextColor
        rightLabel2.font = UIFont.systemFont(ofSize: 14)
        rightLabel2.textAlignment = .right
        contentView.addSubview(rightLabel2)
        
        let line2 = UIView()
        line2.frame = CGRect(x: nameLabel.jxLeft, y: leftLabel2.jxBottom, width: width, height: 1)
        line2.backgroundColor = JXSeparatorColor
        contentView.addSubview(line2)
        
        
        //3
        let leftLabel3 = UILabel()
        leftLabel3.frame = CGRect(x: 24, y: line2.jxBottom , width: 65, height: 51)
        leftLabel3.text = "支付方式"
        leftLabel3.textColor = JXMainText50Color
        leftLabel3.font = UIFont.systemFont(ofSize: 13)
        leftLabel3.textAlignment = .left
        contentView.addSubview(leftLabel3)
        
        let rightButton = UIButton()
        rightButton.frame = CGRect(x: leftLabel3.jxRight, y: leftLabel3.jxTop, width: kScreenWidth - 48 - leftLabel3.jxWidth, height: 51)
        //rightButton.frame = CGRect(x: leftLabel3.jxRight, y: leftLabel3.jxTop, width: kScreenWidth - 48 - leftLabel3.jxWidth - 20, height: 51)
        rightButton.setTitle(self.payName, for: .normal)
        rightButton.setTitleColor(JXMainTextColor, for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightButton.contentHorizontalAlignment = .right
        contentView.addSubview(rightButton)
        
        //        let arrow = UIImageView(frame: CGRect(x: rightButton.jxRight, y: leftLabel3.jxTop + 15.5, width: 20, height: 20))
        //        arrow.backgroundColor = JXMainTextColor
        //        contentView.addSubview(arrow)
        
        
        let line3 = UIView()
        line3.frame = CGRect(x: nameLabel.jxLeft, y: leftLabel3.jxBottom, width: width, height: 1)
        line3.backgroundColor = JXSeparatorColor
        contentView.addSubview(line3)
        
        
        
        let button = UIButton()
        button.frame = CGRect(x: nameLabel.jxLeft, y: line2.jxBottom + 100, width: width, height: 44)
        button.setTitle("挂单", for: .normal)
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
        button.backgroundColor = JXMainColor
        
        
        //3
        let infoLabel = UILabel()
        infoLabel.frame = CGRect(x: 24, y: button.jxBottom + 14, width: width, height: 20)
        let percent = String(format: "%.1f%%", Double((self.sellInfoEntity?.saleRate ?? 0)) * 100)
        infoLabel.text = "挂单交易成功将收取\(percent)币手续费"
        infoLabel.textColor = JXMainText50Color
        infoLabel.font = UIFont.systemFont(ofSize: 13)
        infoLabel.textAlignment = .center
        contentView.addSubview(infoLabel)
        
        return contentView
    }
    @objc func closeStatus() {
        self.statusBottomView.dismiss()
    }
    @objc func confirmTransfer() {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionFlipFromRight, animations: {
            self.statusBottomView.frame.origin.x = -kScreenWidth
        }) { (isFinish) in
            if isFinish {
                self.psdTextView.textField.becomeFirstResponder()
            }
        }
    }
    @objc func backTo() {
        self.view.endEditing(true)
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
}
//MARK: select pay
extension PutUpViewController {
    
    @objc func selectPay() {
        
        self.view.endEditing(true)
        
        self.statusBottomView.customView = nil
        self.statusBottomView.customView = self.customViewInit1(list: self.sellInfoEntity?.list ?? [])
        self.statusBottomView.show(inView: self.view)
    }
    func customViewInit1(list: Array<PayEntity>) -> UIView {
        
        let width : CGFloat = kScreenWidth - 48
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 442)
        if app_style <= 1 {
            let gradientLayer = CAGradientLayer.init()
            gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
            gradientLayer.locations = [0]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth , height: 442 + kBottomMaginHeight)
            contentView.layer.insertSublayer(gradientLayer, at: 0)
        }
        
        
        let rightContentView = UIView()
        rightContentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 442 + kBottomMaginHeight)
        contentView.addSubview(rightContentView)
        
        let topBarView = { () -> UIView in
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 60))
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
            //label.center = view.center
            label.text = "选择收款方式"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18)
            label.textColor = JXMainTextColor
            view.addSubview(label)
            //label.sizeToFit()
            
            let button = UIButton()
            button.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
            //button.center = CGPoint(x: 30, y: view.jxCenterY)
            //button.setTitle("×", for: .normal)
            button.tintColor = JXMainTextColor
            button.setImage(UIImage(named: "Close")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button.setTitleColor(JXMainTextColor, for: .normal)
            button.contentVerticalAlignment = .center
            button.contentHorizontalAlignment = .center
            button.addTarget(self, action: #selector(closeStatus1), for: .touchUpInside)
            view.addSubview(button)
            
            
            let button1 = UIButton()
            button1.frame = CGRect(x: kScreenWidth - 80 - 24, y: 10, width: 80, height: 40)
            //button.center = CGPoint(x: 30, y: view.jxCenterY)
            //button1.setTitle("忘记密码？", for: .normal)
            
            button1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button1.setTitleColor(JXMainColor, for: .normal)
            button1.contentVerticalAlignment = .center
            button1.contentHorizontalAlignment = .right
            //button1.addTarget(self, action: #selector(forgotPsd), for: .touchUpInside)
            contentView.addSubview(button1)
            
            return view
        }()
        rightContentView.addSubview(topBarView)
        
        
        for i in 0..<list.count{
            let view = UIView(frame: CGRect(x: 24, y: topBarView.jxBottom + 20 + CGFloat(51 * i), width: width, height: 51))
            
            let entity = list[i]
            
            let icon1 = UIImageView(frame: CGRect(x: 0, y: 15.5, width: 20, height: 20))
            
            view.addSubview(icon1)
            
            let button1 = UIButton()
            button1.frame = CGRect(x: icon1.jxRight + 5, y: 0, width: width - icon1.jxWidth - 20 - 5, height: view.jxHeight)
            button1.setTitle(self.payName, for: .normal)
            button1.setTitleColor(JXMainTextColor, for: .normal)
            button1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button1.addTarget(self, action: #selector(payClick(button:)), for: .touchUpInside)
            
            button1.contentHorizontalAlignment = .left
            view.addSubview(button1)
            
            let arrow1 = UIImageView(frame: CGRect(x: button1.jxRight + 11.5, y: 18.5, width: 8.5, height: 14))
            arrow1.image = UIImage(named: "arrowRight")?.withRenderingMode(.alwaysTemplate)
            arrow1.tintColor = JXMainTextColor
            view.addSubview(arrow1)
            
            let rightLine1 = UIView()
            rightLine1.frame = CGRect(x: 0, y: button1.jxBottom - 1, width: width, height: 1)
            rightLine1.backgroundColor = JXSeparatorColor
            view.addSubview(rightLine1)
            
            button1.tag = entity.type
            button1.setTitle(entity.accountType ?? "", for: .normal)
            if entity.type == 1 {
                icon1.image = UIImage(named: "icon-mini-alipay")
            } else if entity.type == 2 {
                icon1.image = UIImage(named: "icon-mini-wechat")
            } else {
                icon1.image = UIImage(named: "icon-mini-card")
            }
            
            rightContentView.addSubview(view)
        }
        
        
        return contentView
    }
    
    @objc func closeStatus1() {
        self.statusBottomView.dismiss()
    }
    @objc func payClick(button: UIButton) {
        
        self.payNameLabel.text = button.currentTitle
        self.payName = button.currentTitle ?? ""
        self.payType = button.tag
        
        self.closeStatus1()
    }
}
extension PutUpViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    @objc func textChange(notify: NSNotification) {
        
        if
            notify.object is UITextField,
            let textField = notify.object as? UITextField,
            textField == self.sellTextField {
            
            
            if
                let num = textField.text,
                let numDouble = Double(num){
                
                //手续费的代扣由后台来扣
                self.useLabel.text = "\((self.sellInfoEntity?.balance ?? 0) - numDouble)"
                self.sellTotal = "\(configuration_coinPrice * numDouble) \(configuration_valueType)"
                self.serviceTotal = String(format:"%.2f",numDouble * (self.sellInfoEntity?.saleRate ?? 0)) + " \(configuration_coinName)"
                self.sellRealTotal = String(format:"%.2f",numDouble * (configuration_coinPrice - (self.sellInfoEntity?.saleRate ?? 0))) + " \(configuration_valueType)"
            } else {
                //self.useNum = "\(UserManager.manager.userEntity.property.balance)"
                self.useLabel.text = "\(self.sellInfoEntity?.balance ?? 0)"
                self.sellTotal = "\(0) \(configuration_valueType)"
                self.sellRealTotal = "\(0) \(configuration_valueType)"
                self.serviceTotal = "\(0) \(configuration_coinName)"
            }
            
            //self.useLabel.text = self.useNum
            self.totalLabel.text = self.sellTotal
            self.serviceLabel.text = self.serviceTotal
            self.payTotalLabel.text = self.sellRealTotal
        }
       
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //删除键
        if string == "" {
            return true
        }
        //手续费的代扣由后台来扣
        if
            textField == self.sellTextField,
            let num = textField.text,
            let numDouble = Double(num + string), numDouble > (self.sellInfoEntity?.balance ?? 0){
            
            return false
            
        } else {
            return true
        }
    }
   
}
