//
//  MainViewController.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/4.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"
private let reuseIndentifierHeader = "reuseIndentifierHeader"

class MainViewController: JXCollectionViewController {

    var homeVM = HomeVM()
    var isIpe : Bool = true
    var additionArray : Array = ["发币","收币","钱包记录"]
    var defaultArray: Array = [["image":"icon-big-shop","title":"我要买"],["image":"icon-big-sale","title":"我要卖"],["image":"icon-big-help","title":"帮助信息"]]
    
    var noticeView : JXSelectView?
    
    lazy var statusBottomView: JXSelectView = {
        let selectView = JXSelectView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 200), style: JXSelectViewStyle.custom)
        selectView.backgroundColor = JXMainColor
        selectView.isBackViewUserInteractionEnabled = false
        
        return selectView
    }()
    
    var vm = BuyVM()
    var payName = "支付宝"
    var payType = 1
    var amount: Int = 0
    var buttonArray = Array<UIButton>()
    var textField : UITextField?
    
    lazy var keyboard: JXKeyboardToolBar = {
        let bar = JXKeyboardToolBar(frame: CGRect())
        bar.showBlock = { (view, value) in
            print(view,value)
        }
        bar.closeBlock = {
            //self.textField?.text = ""
        }
        bar.tintColor = JXMainTextColor
        bar.toolBar.barTintColor = JXBackColor
        bar.backgroundColor = JXBackColor
        return bar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar.removeFromSuperview()
        //self.customNavigationBar.alpha = 0
        self.view.addSubview(self.keyboard)
 
        self.collectionView?.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kTabBarHeight)
        // Register cell classes
        self.collectionView?.register(UINib.init(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.register(UINib.init(nibName: "HomeReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIndentifierHeader)
        
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = CGSize(width: kScreenWidth / 3, height: kScreenWidth / 3)
        
        layout.sectionInset = UIEdgeInsets.init(top: 0.5, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        //layout.headerReferenceSize = CGSize(width: kScreenWidth, height: (400 - 80 + (122 + 160 - 50 * kPercent)))
        layout.headerReferenceSize = CGSize(width: kScreenWidth, height: (400 - 80 + (122 + 160 + 50 * kPercent)))
        self.collectionView?.collectionViewLayout = layout
      
        
        self.collectionView?.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.requestData()
        })
        //self.collectionView?.mj_header.beginRefreshing()
        //每次进入都刷新，则不用监听登录状态
        //NotificationCenter.default.addObserver(self, selector: #selector(loginStatus(notify:)), name: NSNotification.Name(rawValue: NotificationLoginStatus), object: nil)
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserManager.manager.isLogin {
            self.requestData()
        } else {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let login = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            let loginVC = UINavigationController.init(rootViewController: login)
            
            self.navigationController?.present(loginVC, animated: false, completion: nil)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        
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
    @objc func loginStatus(notify:Notification) {
        print(notify)
        
        if let isSuccess = notify.object as? Bool,
            isSuccess == true{
            self.requestData()
        }
    }
    func showAuth() {
        
        //未实名认证
        if UserManager.manager.userEntity.authStatus == 1 {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let login = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            let loginVC = UINavigationController.init(rootViewController: login)
            
            self.navigationController?.present(loginVC, animated: false, completion: nil)
        }else{
            print("已认证")
            self.requestData()
        }
    }
    override func requestData() {
        self.homeVM = HomeVM()
        self.homeVM.home { (_, msg, isSuc) in
            self.collectionView?.mj_header.endRefreshing()
            if isSuc {
                
            } else {
                ViewManager.showNotice(msg)
            }
            self.collectionView?.reloadData()
        }
    }
}
//MARK: Trade password notice
extension MainViewController {
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
            label.textColor = JXMainTextColor
            backgroundView.addSubview(label)
            
            
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: 24, y: label.jxBottom + 20, width: width - 24 * 2, height: 30)
            nameLabel.text = "您还未设置资金密码"
            nameLabel.textColor = JXMainTextColor
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
            button1.setTitleColor(JXMainColor, for: .normal)
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
            button.backgroundColor = JXMainColor
            
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
    
}
//MARK: SelectView - quick buy
extension MainViewController {
    
    func customViewInit(number: String) -> UIView {
        
        let width : CGFloat = kScreenWidth - 48
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth * 2, height: 362)
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth * 2, height: 362 + kBottomMaginHeight)
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        let leftContentView = UIView()
        leftContentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 362 + kBottomMaginHeight)
        contentView.addSubview(leftContentView)
        
        //左侧视图
        
        let topBarView = { () -> UIView in
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 60))
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
            //label.center = view.center
            label.text = "确认购买"
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
        
        if let num = Double(number) {
            nameLabel.text = "\(num * configuration_coinPrice) \(configuration_valueType)"
        }
        nameLabel.textColor = JXMainTextColor
        nameLabel.font = UIFont.systemFont(ofSize: 25)
        nameLabel.textAlignment = .center
        
        leftContentView.addSubview(nameLabel)
        
        //3
        let leftLabel3 = UILabel()
        leftLabel3.frame = CGRect(x: 24, y: nameLabel.jxBottom + 31, width: 65, height: 51)
        leftLabel3.text = "交易数量"
        leftLabel3.textColor = JXMainText50Color
        leftLabel3.font = UIFont.systemFont(ofSize: 13)
        leftLabel3.textAlignment = .left
        leftContentView.addSubview(leftLabel3)
        
        let rightLabel3 = UILabel()
        rightLabel3.frame = CGRect(x: leftLabel3.jxRight, y: leftLabel3.jxTop, width: kScreenWidth - 48 - leftLabel3.jxWidth, height: 51)
        rightLabel3.text = number + " \(configuration_coinName)"
        rightLabel3.textColor = JXRedColor
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
        leftLabel4.textColor = JXMainText50Color
        leftLabel4.font = UIFont.systemFont(ofSize: 13)
        leftLabel4.textAlignment = .left
        leftContentView.addSubview(leftLabel4)
        
     
        let view = UIView(frame: CGRect(x: 24, y: leftLabel4.jxBottom , width: width, height: 32))
        leftContentView.addSubview(view)
        
        self.buttonArray.removeAll()
        
        let buttonSpace: CGFloat = 24
        let buttonWidth = (width - buttonSpace * 2) / 3
        let buttonHeight: CGFloat = 32
        
        for i in 0..<self.vm.buyPayTypeEntity.listArray.count{
            let type = self.vm.buyPayTypeEntity.listArray[i]
            
            let button = UIButton()
            button.frame = CGRect(x: (buttonWidth + buttonSpace) * CGFloat(i), y: 0, width: buttonWidth, height: buttonHeight)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            button.addTarget(self, action: #selector(payClick(button:)), for: .touchUpInside)
            button.contentHorizontalAlignment = .center
            button.layer.cornerRadius = 2
            button.layer.borderWidth = 1
            
            view.addSubview(button)
            
            button.tag = type
            
            if type == 1 {
                button.setTitle("支付宝", for: .normal)
            } else if type == 2 {
                button.setTitle("微信", for: .normal)
            } else {
                button.setTitle("银行卡", for: .normal)
            }
            button.setTitleColor(JXPlaceHolerColor, for: .normal)
            button.setTitleColor(JXMainColor, for: .selected)
            if i == 0 {
                button.isSelected = true
                button.layer.borderColor = JXMainColor.cgColor
                
                self.payName = button.currentTitle ?? ""
                self.payType = type
            } else {
                button.layer.borderColor = JXPlaceHolerColor.cgColor
            }
            buttonArray.append(button)
        }
        
        
        
        let button = UIButton()
        button.frame = CGRect(x: nameLabel.jxLeft, y: view.jxBottom + 30, width: width, height: 44)
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
        button.backgroundColor = JXMainColor
        
        
        
        return contentView
    }
    @objc func confirm() {
        print("confirm")
//        guard let text = self.textField.text, text.isEmpty == false else{
//            return
//        }
        self.closeStatus()
        self.showMBProgressHUD()
        self.vm.buyQuick(payType: self.payType, amount: self.amount, completion: { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            if isSuc {
                let vc = OrderDetailController()
                vc.id = self.vm.id
                vc.hidesBottomBarWhenPushed = true
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
        
        self.buttonArray.forEach { (btn) in
            if button.tag == btn.tag {
                btn.isSelected = true
                btn.layer.borderColor = JXMainColor.cgColor
                self.payName = btn.currentTitle ?? ""
                self.payType = btn.tag
            } else {
                btn.isSelected = false
                btn.layer.borderColor = JXPlaceHolerColor.cgColor
            }
        }
    }
}
//MARK: UICollectionViewDataSource & UICollectionViewDelegate
extension MainViewController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
        //return self.defaultArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeCell

        let dict = self.defaultArray[indexPath.item]
        cell.iconImageView.image = UIImage(named: dict["image"]!)
        cell.titleLabel.text = dict["title"]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIndentifierHeader, for: indexPath) as! HomeReusableView
        if kind == UICollectionView.elementKindSectionHeader {
            
            reusableView.propertyEntity = self.homeVM.homeEntity.property
            reusableView.noticeEntity = self.homeVM.homeEntity.notice
            
            reusableView.totalWidthConstraint.constant = self.homeVM.totalWidth
            reusableView.useWidthConstraint.constant = self.homeVM.useWidth
            reusableView.limitWidthConstraint.constant = self.homeVM.limitWidth
            
            if self.keyboard.views.isEmpty == true {
                self.keyboard.views = [reusableView.textField]
                self.textField = reusableView.textField
            }
            self.textField?.text = ""
            reusableView.quickBuyBlock = {
    
                guard let text = reusableView.textField.text, text.isEmpty == false else{
                    ViewManager.showNotice("请先输入购买数量")
                    return
                }
                guard let num = Int(text), num > 10 else{
                    ViewManager.showNotice("暂无该挂单金额，请重新输入")
                    return
                }
                reusableView.textField.resignFirstResponder()
                
                self.showMBProgressHUD()
                self.vm.getQuickPayType(amount: num, completion: { (_, msg, isSuc) in
                    self.hideMBProgressHUD()
                    if isSuc{
                        self.amount = num
                        reusableView.textField.text = ""
                        self.statusBottomView.customView = self.customViewInit(number: text)
                        self.statusBottomView.show()
                    } else {
                        reusableView.textField.text = ""
                        ViewManager.showNotice("暂无该挂单金额，请重新输入")
                    }
                })
            }
            reusableView.scanBlock = {
                if UserManager.manager.userEntity.user.safePwdInit != 0 {
                    //self.performSegue(withIdentifier: "scan", sender: nil)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let login = storyboard.instantiateViewController(withIdentifier: "ScanVC") as! ScanViewController
                    let loginVC = JXNavigationController(rootViewController: login)
                    login.type = 1
                    self.navigationController?.present(loginVC, animated: true, completion: nil)
                    
                } else {
                    self.showNoticeView()
                }
            }
            reusableView.noticeBlock = {
                let vc = MyWebViewController()
                vc.title = "资讯"//self.homeVM.homeEntity.notice.title
                vc.urlStr = self.homeVM.homeEntity.notice.url
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            reusableView.additionBlock = {
                
                let vc = WalletRecordListController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)

//                let sel = JXDropListView(frame: CGRect(x: kScreenWidth - 100 - 10, y: kNavStatusHeight, width: 100, height: 120), style: .list)
//                sel.delegate = self
//                sel.dataSource = self
//                sel.backgroundColor = UIColor.rgbColor(rgbValue: 0x323245)
//
//                sel.layer.cornerRadius = 2
//                sel.layer.shadowColor = UIColor.rgbColor(rgbValue: 0x10101a, alpha: 0.5).cgColor
//                sel.layer.shadowOffset = CGSize(width: 0, height: 10)
//                sel.layer.shadowRadius = 10
//                sel.layer.shadowOpacity = 1
//
//                sel.show()
            }
            reusableView.buyBlock = {
                let vc = NewBuyController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            reusableView.sellBlock = {
                self.performSegue(withIdentifier: "sell", sender: nil)
            }
            reusableView.helpBlock = {
                let vc = MyWebViewController()
                vc.title = "帮助信息"//self.homeVM.homeEntity.notice.title
                vc.urlStr = kHelpUrl
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        
        return reusableView
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            //let vc = BuyCollectionController()
            let vc = NewBuyController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.item == 1 {
            self.performSegue(withIdentifier: "sell", sender: nil)
        } else if indexPath.item == 2 {
            ViewManager.showImageNotice("设置成功")
            if !UserManager.manager.isLogin {
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let login = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
                let loginVC = UINavigationController.init(rootViewController: login)
                
                self.navigationController?.present(loginVC, animated: false, completion: nil)
            }
        } else if indexPath.item == 3 {
            
            self.performSegue(withIdentifier: "transfer", sender: nil)
            
        } else if indexPath.item == 4 {
    
            self.performSegue(withIdentifier: "receipt", sender: nil)
        } else {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "tradeDetail") as! TradeDetailController
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
// MARK: JXDropListViewDelegate & JXDropListViewDataSource
extension MainViewController : JXDropListViewDelegate,JXDropListViewDataSource {
    func dropListView(listView: JXDropListView, didSelectRowAt row: Int, inSection section: Int) {
        print(row)
        switch row {
        case 0:
            let storyboard = UIStoryboard(name: "Wallet", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "transfer") as! TransferViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let storyboard = UIStoryboard(name: "Wallet", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "receipt") as! ReceiptViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = WalletRecordListController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            print(row)
        }
    }
    func dropListView(listView: JXDropListView, numberOfRowsInSection section: Int) -> Int {
        return additionArray.count
    }
    
    func dropListView(listView: JXDropListView, heightForRowAt row: Int) -> CGFloat {
        return 40
    }
    
    func dropListView(listView: JXDropListView, contentForRow row: Int, InSection section: Int) -> String {
        return additionArray[row]
    }
    
    
}

