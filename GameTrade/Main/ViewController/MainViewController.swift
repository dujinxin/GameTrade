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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar.removeFromSuperview()
        //self.customNavigationBar.alpha = 0
 
        self.collectionView?.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kTabBarHeight)
        // Register cell classes
        self.collectionView?.register(UINib.init(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.register(UINib.init(nibName: "HomeReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseIndentifierHeader)
        
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize.init(width: kScreenWidth / 3, height: kScreenWidth / 3)
        
        layout.sectionInset = UIEdgeInsetsMake(0.5, 0, 0, 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.headerReferenceSize = CGSize(width: kScreenWidth, height: 400)
        
        self.collectionView?.collectionViewLayout = layout
        //self.collectionView?.bounces = false
        
        self.collectionView?.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.requestData()
        })
        self.collectionView?.mj_header.beginRefreshing()
        //每次进入都刷新，则不用监听登录状态
        //NotificationCenter.default.addObserver(self, selector: #selector(loginStatus(notify:)), name: NSNotification.Name(rawValue: NotificationLoginStatus), object: nil)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !UserManager.manager.isLogin {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let login = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            let loginVC = UINavigationController.init(rootViewController: login)

            self.navigationController?.present(loginVC, animated: false, completion: nil)
        }else{
            self.showAuth()
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
}
extension MainViewController {
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.defaultArray.count
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
        if kind == UICollectionElementKindSectionHeader {
           
            reusableView.entity = self.homeVM.homeEntity.property
            reusableView.noticeLabel.text = self.homeVM.homeEntity.notice.title
            reusableView.scanBlock = {
                if UserManager.manager.userEntity.user.safePwdInit != 0 {
                    //self.performSegue(withIdentifier: "scan", sender: nil)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let login = storyboard.instantiateViewController(withIdentifier: "ScanVC") as! ScanViewController
                    let loginVC = JXNavigationController(rootViewController: login)
                    login.type = 1
                    self.navigationController?.present(loginVC, animated: false, completion: nil)
                    
                } else {
                    self.showNoticeView()
                }
            }
            reusableView.noticeBlock = {
                let vc = MyWebViewController()
                vc.title = self.homeVM.homeEntity.notice.title
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

