//
//  NewBuyController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/4.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import JXFoundation

private let reuseIdentifier = "reuseIdentifier"
private let reuseIndentifierHeader = "reuseIndentifierHeader"

class NewBuyController: JXCollectionViewController {
    
    
    var vm = BuyVM()
    var type = 0
    
    var textField : UITextField!
    
    var headViewHeight : CGFloat = 126
    
    lazy var headView: UIView = {
        let headView = UIView(frame: CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: headViewHeight))
        return headView
    }()
    
    var topBar : JXBarView!
    var horizontalView : JXHorizontalView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "我要买"
        
        //self.view.insertSubview(self.headView, belowSubview: self.customNavigationBar)
        self.view.addSubview(self.headView)
        
        let topView = UIView(frame: CGRect(x: 24, y: 8, width: kScreenWidth - 48, height: 67))
        topView.backgroundColor = JXSeparatorColor
        topView.layer.cornerRadius = 4
        topView.layer.shadowOpacity = 1
        topView.layer.shadowRadius = 33
        topView.layer.shadowOffset = CGSize(width: 0, height: 10)
        topView.layer.shadowColor = JX22222cShadowColor.cgColor
        headView.addSubview(topView)
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x393948).cgColor,UIColor.rgbColor(rgbValue: 0x3c3c4b).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 48, height: 67)
        
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        
        self.textField = UITextField(frame: CGRect(x: 16, y: 18, width: topView.jxWidth - 16 * 2 - 12 - 88, height: 32))
        textField.backgroundColor = UIColor.rgbColor(rgbValue: 0x2f2f3c)
        textField.delegate = self
        textField.placeholder = "输入购买金额"
        textField.keyboardType = .numberPad
        textField.font = UIFont.systemFont(ofSize: 12)
        textField.textColor = JXFfffffColor
        textField.attributedPlaceholder = NSAttributedString(string: "输入购买金额", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:JXPlaceHolerColor])
        topView.addSubview(textField)
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: topView.jxWidth - 16 - 88, y: 18, width: 88, height: 32)
        button.setTitle("快捷购买", for: .normal)
        button.setTitleColor(JXFfffffColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.backgroundColor = JXOrangeColor
        button.layer.cornerRadius = 2
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.shadowColor = JX10101aShadowColor.cgColor
        button.addTarget(self, action: #selector(buy), for: .touchUpInside)
        
        topView.addSubview(button)
        
        topBar = JXBarView.init(frame: CGRect.init(x: 0, y: 83, width: view.bounds.width , height: 44), titles: ["全部","支付宝","微信","银行卡"])
        topBar.delegate = self
        
        let att = JXAttribute()
        att.normalColor = JX999999Color
        att.selectedColor = JXOrangeColor
        att.normalColor = JX999999Color
        att.font = UIFont.systemFont(ofSize: 14)
        topBar.attribute = att
        
        //topBar.backgroundColor = JXOrangeColor
        topBar.bottomLineSize = CGSize(width: 45, height: 3)
        topBar.bottomLineView.backgroundColor = JXOrangeColor
        topBar.isBottomLineEnabled = true
        
        headView.addSubview(topBar!)
        
        self.collectionView?.frame = CGRect.init(x: 0, y: kNavStatusHeight + headViewHeight, width: view.bounds.width, height: UIScreen.main.bounds.height - kNavStatusHeight - headViewHeight)
        self.collectionView?.register(UINib.init(nibName: "MerchantCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.register(UINib.init(nibName: "HomeReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseIndentifierHeader)
        
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize.init(width: kScreenWidth, height: 168)
        
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        //layout.headerReferenceSize = CGSize(width: kScreenWidth, height: 400)
        
        self.collectionView?.collectionViewLayout = layout
        
        //每次进入都刷新，则不用监听登录状态
        //NotificationCenter.default.addObserver(self, selector: #selector(loginStatus(notify:)), name: NSNotification.Name(rawValue: NotificationLoginStatus), object: nil)
        
        self.collectionView?.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.request(page: 1)
        })
        self.collectionView?.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.page += 1
            self.request(page: self.page)
        })
        self.collectionView?.mj_header.beginRefreshing()
        
        
        //每次进入都刷新，则不用监听登录状态
        //NotificationCenter.default.addObserver(self, selector: #selector(loginStatus(notify:)), name: NSNotification.Name(rawValue: NotificationLoginStatus), object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        switch segue.identifier {
        //        case "invite":
        //            if let vc = segue.destination as? InviteViewController, let inviteEntity = sender as? InviteEntity {
        //                vc.inviteEntity = inviteEntity
        //            }
        //        default:
        //            print("123456")
        //        }
    }
    override func request(page: Int) {
        self.vm.buyList(payType: self.type, pageSize: 10, pageNo: page) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            self.collectionView?.mj_header.endRefreshing()
            self.collectionView?.mj_footer.endRefreshing()
            self.collectionView?.reloadData()
        }
    }
    @objc func buy() {
        
        guard let text = self.textField.text, text.isEmpty == false else{
            ViewManager.showNotice("请先输入数量")
            return
        }
        self.textField.resignFirstResponder()
        
        self.statusBottomView.customView = self.customViewInit(number: text, address: "address", gas: "gas", remark: "无")
        self.statusBottomView.show()
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    //MARK: SelectView - quick
    
    var payName = "支付宝"
    var payType = 1
    
    var rightButton : UIButton!
    
    
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
            label.text = "选择支付方式"
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
            button.setTitle("忘记密码？", for: .normal)
            
            button1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button1.setTitleColor(JXOrangeColor, for: .normal)
            button1.contentVerticalAlignment = .center
            button1.contentHorizontalAlignment = .right
            //button1.addTarget(self, action: #selector(forgotPsd), for: .touchUpInside)
            contentView.addSubview(button1)
            
            return view
        }()
        rightContentView.addSubview(topBarView1)
        
        //1
        let icon1 = UIImageView(frame: CGRect(x: 24, y: topBarView.jxBottom + 20 + 15.5, width: 20, height: 20))
        icon1.image = UIImage(named: "icon-mini-alipay")
        rightContentView.addSubview(icon1)
        
        let button1 = UIButton()
        button1.frame = CGRect(x: icon1.jxRight + 5, y: topBarView.jxBottom + 20, width: kScreenWidth - 48 - icon1.jxWidth - 20 - 5, height: 51)
        button1.setTitle(self.payName, for: .normal)
        button1.setTitleColor(JXTextColor, for: .normal)
        button1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button1.addTarget(self, action: #selector(payClick(button:)), for: .touchUpInside)
        button1.tag = 1
        button1.contentHorizontalAlignment = .left
        rightContentView.addSubview(button1)
        
        let arrow1 = UIImageView(frame: CGRect(x: button1.jxRight, y: button1.jxTop + 15.5, width: 20, height: 20))
        arrow1.backgroundColor = JXTextColor
        rightContentView.addSubview(arrow1)
        
        let rightLine1 = UIView()
        rightLine1.frame = CGRect(x: icon1.jxLeft, y: button1.jxBottom, width: width, height: 1)
        rightLine1.backgroundColor = JXSeparatorColor
        rightContentView.addSubview(rightLine1)
        
        //2
        let icon2 = UIImageView(frame: CGRect(x: 24, y: rightLine1.jxBottom + 15.5, width: 20, height: 20))
        icon2.image = UIImage(named: "icon-mini-wechat")
        rightContentView.addSubview(icon2)
        
        let button2 = UIButton()
        button2.frame = CGRect(x: button1.jxLeft, y: rightLine1.jxBottom, width: button1.jxWidth, height: 51)
        button2.setTitle("微信", for: .normal)
        button2.setTitleColor(JXTextColor, for: .normal)
        button2.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button2.addTarget(self, action: #selector(payClick(button:)), for: .touchUpInside)
        button2.tag = 2
        button2.contentHorizontalAlignment = .left
        rightContentView.addSubview(button2)
        
        let arrow2 = UIImageView(frame: CGRect(x: button1.jxRight, y: button2.jxTop + 15.5, width: 20, height: 20))
        arrow2.backgroundColor = JXTextColor
        rightContentView.addSubview(arrow2)
        
        let rightLine2 = UIView()
        rightLine2.frame = CGRect(x: icon1.jxLeft, y: button2.jxBottom, width: width, height: 1)
        rightLine2.backgroundColor = JXSeparatorColor
        rightContentView.addSubview(rightLine2)
        
        //3
        let icon3 = UIImageView(frame: CGRect(x: 24, y: rightLine2.jxBottom + 15.5, width: 20, height: 20))
        icon3.image = UIImage(named: "icon-mini-card")
        rightContentView.addSubview(icon3)
        
        let button3 = UIButton()
        button3.frame = CGRect(x: button1.jxLeft, y: rightLine2.jxBottom, width: button1.jxWidth, height: 51)
        button3.setTitle("银行卡", for: .normal)
        button3.setTitleColor(JXTextColor, for: .normal)
        button3.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button3.addTarget(self, action: #selector(payClick(button:)), for: .touchUpInside)
        button3.tag = 3
        button3.contentHorizontalAlignment = .left
        rightContentView.addSubview(button3)
        
        let arrow3 = UIImageView(frame: CGRect(x: button1.jxRight, y: button3.jxTop + 15.5, width: 20, height: 20))
        arrow3.backgroundColor = JXTextColor
        rightContentView.addSubview(arrow3)
        
        let rightLine3 = UIView()
        rightLine3.frame = CGRect(x: icon1.jxLeft, y: button3.jxBottom, width: width, height: 1)
        rightLine3.backgroundColor = JXSeparatorColor
        rightContentView.addSubview(rightLine3)
        
        
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
    @objc func confirm() {
        print("confirm")
        guard let text = self.textField.text, text.isEmpty == false else{
            return
        }
        self.closeStatus()
        self.showMBProgressHUD()
        self.vm.buyQuick(payType: self.payType, amount: Int(text) ?? 0, completion: { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            if isSuc {
                let vc = OrderDetailController()
                vc.id = self.vm.id
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                ViewManager.showNotice(msg)
            }
        })
    }
    @objc func closeStatus() {
        self.statusBottomView.dismiss()
    }
    @objc func payClick(button: UIButton) {
        if button.tag == 1 {
            self.payName = "支付宝"
            self.payType = 1
        } else if button.tag == 2 {
            self.payName = "微信"
            self.payType = 2
        } else {
            self.payName = "银行卡"
            self.payType = 3
        }
        self.rightButton.setTitle(self.payName, for: .normal)
        
        self.backTo()
    }
    
    
    //MARK: SelectView - normal
    
    var buyEntity : BuyEntity?
    
    var textField1 : UITextField!
    
    lazy var statusBottomView1: JXSelectView = {
        let selectView = JXSelectView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 200), style: JXSelectViewStyle.custom)
        selectView.backgroundColor = JXOrangeColor
        selectView.isBackViewUserInteractionEnabled = false
        //selectView.customView = self.customViewInit(number: self.number, address: "address", gas: "gas", remark: "无备注")
        
        self.setKeyBoardObserver()
        return selectView
    }()
    private func setKeyBoardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func customViewInit1(number: String, address: String, gas: String, remark: String) -> UIView {
        
        let width : CGFloat = kScreenWidth - 48
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth * 2, height: 398)
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth * 2, height: 398 + kBottomMaginHeight)
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        let leftContentView = UIView()
        leftContentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 398 + kBottomMaginHeight)
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
            button.addTarget(self, action: #selector(closeStatus1), for: .touchUpInside)
            view.addSubview(button)
            
            return view
        }()
        leftContentView.addSubview(topBarView)
        
        let textField = UITextField(frame: CGRect(x: 24, y: topBarView.jxBottom + 20, width: width , height: 48))
        textField.backgroundColor = UIColor.rgbColor(rgbValue: 0x2f2f3c)
        textField.delegate = self
        textField.placeholder = "输入购买金额"
        textField.text = number
        textField.keyboardType = .numberPad
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = JXFfffffColor
        textField.attributedPlaceholder = NSAttributedString(string: "输入购买金额", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:JXPlaceHolerColor])
        leftContentView.addSubview(textField)
        
        textField.rightViewMode = .always
        textField.rightView = {
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: 24, y: topBarView.jxBottom + 20, width: 60, height: 30)
            nameLabel.text = "\(configuration_coinName)"
            nameLabel.textColor = JXFfffffColor
            nameLabel.font = UIFont.systemFont(ofSize: 13)
            nameLabel.textAlignment = .center
            
            return nameLabel
        }()
        self.textField1 = textField
        
//        let nameLabel = UILabel()
//        nameLabel.frame = CGRect(x: 24, y: topBarView.jxBottom + 20, width: width, height: 30)
//        nameLabel.text = "\(number) \(configuration_coinName)"
//        nameLabel.textColor = JXFfffffColor
//        nameLabel.font = UIFont.systemFont(ofSize: 25)
//        nameLabel.textAlignment = .center
//
//        leftContentView.addSubview(nameLabel)
        
        //1
        let leftLabel1 = UILabel()
        leftLabel1.frame = CGRect(x: 24, y: textField.jxBottom + 16, width: 65, height: 51)
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
        line1.frame = CGRect(x: textField.jxLeft, y: leftLabel1.jxBottom, width: width, height: 1)
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
        line2.frame = CGRect(x: textField.jxLeft, y: leftLabel2.jxBottom, width: width, height: 1)
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
        line3.frame = CGRect(x: textField.jxLeft, y: leftLabel3.jxBottom, width: width, height: 1)
        line3.backgroundColor = JXSeparatorColor
        leftContentView.addSubview(line3)
        
        
        let button = UIButton()
        button.frame = CGRect(x: textField.jxLeft, y: line3.jxBottom + 30, width: width, height: 44)
        button.setTitle("下单", for: .normal)
        button.setTitleColor(JXFfffffColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(confirm1), for: .touchUpInside)
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
        rightContentView.frame = CGRect(x: kScreenWidth, y: 0, width: kScreenWidth, height: 398 + kBottomMaginHeight)
        contentView.addSubview(rightContentView)
        
        let topBarView1 = { () -> UIView in
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 60))
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
            //label.center = view.center
            label.text = "选择支付方式"
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
            button.setTitle("忘记密码？", for: .normal)
            
            button1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button1.setTitleColor(JXOrangeColor, for: .normal)
            button1.contentVerticalAlignment = .center
            button1.contentHorizontalAlignment = .right
            //button1.addTarget(self, action: #selector(forgotPsd), for: .touchUpInside)
            contentView.addSubview(button1)
            
            return view
        }()
        rightContentView.addSubview(topBarView1)
        
        //1
        let icon1 = UIImageView(frame: CGRect(x: 24, y: topBarView.jxBottom + 20 + 15.5, width: 20, height: 20))
        icon1.image = UIImage(named: "icon-mini-alipay")
        rightContentView.addSubview(icon1)
        
        let button1 = UIButton()
        button1.frame = CGRect(x: icon1.jxRight + 5, y: topBarView.jxBottom + 20, width: kScreenWidth - 48 - icon1.jxWidth - 20 - 5, height: 51)
        button1.setTitle(self.payName, for: .normal)
        button1.setTitleColor(JXTextColor, for: .normal)
        button1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button1.addTarget(self, action: #selector(payClick(button:)), for: .touchUpInside)
        button1.tag = 1
        button1.contentHorizontalAlignment = .left
        rightContentView.addSubview(button1)
        
        let arrow1 = UIImageView(frame: CGRect(x: button1.jxRight, y: button1.jxTop + 15.5, width: 20, height: 20))
        arrow1.backgroundColor = JXTextColor
        rightContentView.addSubview(arrow1)
        
        let rightLine1 = UIView()
        rightLine1.frame = CGRect(x: icon1.jxLeft, y: button1.jxBottom, width: width, height: 1)
        rightLine1.backgroundColor = JXSeparatorColor
        rightContentView.addSubview(rightLine1)
        
        //2
        let icon2 = UIImageView(frame: CGRect(x: 24, y: rightLine1.jxBottom + 15.5, width: 20, height: 20))
        icon2.image = UIImage(named: "icon-mini-wechat")
        rightContentView.addSubview(icon2)
        
        let button2 = UIButton()
        button2.frame = CGRect(x: button1.jxLeft, y: rightLine1.jxBottom, width: button1.jxWidth, height: 51)
        button2.setTitle("微信", for: .normal)
        button2.setTitleColor(JXTextColor, for: .normal)
        button2.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button2.addTarget(self, action: #selector(payClick(button:)), for: .touchUpInside)
        button2.tag = 2
        button2.contentHorizontalAlignment = .left
        rightContentView.addSubview(button2)
        
        let arrow2 = UIImageView(frame: CGRect(x: button1.jxRight, y: button2.jxTop + 15.5, width: 20, height: 20))
        arrow2.backgroundColor = JXTextColor
        rightContentView.addSubview(arrow2)
        
        let rightLine2 = UIView()
        rightLine2.frame = CGRect(x: icon1.jxLeft, y: button2.jxBottom, width: width, height: 1)
        rightLine2.backgroundColor = JXSeparatorColor
        rightContentView.addSubview(rightLine2)
        
        //3
        let icon3 = UIImageView(frame: CGRect(x: 24, y: rightLine2.jxBottom + 15.5, width: 20, height: 20))
        icon3.image = UIImage(named: "icon-mini-card")
        rightContentView.addSubview(icon3)
        
        let button3 = UIButton()
        button3.frame = CGRect(x: button1.jxLeft, y: rightLine2.jxBottom, width: button1.jxWidth, height: 51)
        button3.setTitle("银行卡", for: .normal)
        button3.setTitleColor(JXTextColor, for: .normal)
        button3.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button3.addTarget(self, action: #selector(payClick(button:)), for: .touchUpInside)
        button3.tag = 3
        button3.contentHorizontalAlignment = .left
        rightContentView.addSubview(button3)
        
        let arrow3 = UIImageView(frame: CGRect(x: button1.jxRight, y: button3.jxTop + 15.5, width: 20, height: 20))
        arrow3.backgroundColor = JXTextColor
        rightContentView.addSubview(arrow3)
        
        let rightLine3 = UIView()
        rightLine3.frame = CGRect(x: icon1.jxLeft, y: button3.jxBottom, width: width, height: 1)
        rightLine3.backgroundColor = JXSeparatorColor
        rightContentView.addSubview(rightLine3)
        
        
        return contentView
    }
    @objc func confirm1() {
        print("confirm")
        guard let text = self.textField1.text, text.isEmpty == false else{
            return
        }
        self.closeStatus1()
        self.showMBProgressHUD()
        self.vm.buyNormal(tradeSaleId: self.buyEntity?.id ?? "", amount: Int(text) ?? 0, completion: { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            if isSuc {
                let vc = OrderDetailController()
                vc.id = self.vm.id
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                ViewManager.showNotice(msg)
            }
        })
    }
    @objc func closeStatus1() {
        self.statusBottomView1.dismiss()
    }
}

extension NewBuyController : JXBarViewDelegate {
    
    func jxBarView(barView: JXBarView, didClick index: Int) {
        self.type = index
        self.collectionView?.mj_header.beginRefreshing()
    }
}

extension NewBuyController : UITextFieldDelegate {
    @objc func keyboardWillShow(notify:Notification) {
        
        guard
            let userInfo = notify.userInfo,
            let rect = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        UIView.animate(withDuration: animationDuration, animations: {
            self.statusBottomView1.frame.origin.y = kScreenHeight - self.statusBottomView1.frame.size.height - rect.height
        }) { (finish) in
            //
        }
    }
    @objc func keyboardWillHide(notify:Notification) {
        print("notify = ","notify")
        guard
            let userInfo = notify.userInfo,
            let _ = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        UIView.animate(withDuration: animationDuration, animations: {
            
        }) { (finish) in
            
        }
    }
}
extension NewBuyController {
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vm.buyListEntity.listArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MerchantCell
        let entity = self.vm.buyListEntity.listArray[indexPath.item]
        cell.entity = entity
        cell.merchantBlock = {
            let vc = MerchantViewController()
            vc.id = entity.agentId
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.buyBlock = {
            self.buyEntity = entity
            self.statusBottomView1.customView = self.customViewInit1(number: "\(entity.limitMax)", address: "address", gas: "gas", remark: "无")
            self.statusBottomView1.show()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            
        }
    }
}
