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
    
    func setClearNavigationBar(title:String,leftItem:UIView? = nil,rightItem:UIView? = nil) -> UIView {
        
        let navigiationBar = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavStatusHeight))
        let backgroudView = UIView(frame: navigiationBar.bounds)
        
        let titleView = UILabel(frame: CGRect(x: 80, y: kStatusBarHeight, width: kScreenWidth - 160, height: 44))
        titleView.text = title
        titleView.textColor = UIColor.white
        titleView.textAlignment = .center
        titleView.font = UIFont.systemFont(ofSize: 20)
        
        
        navigiationBar.addSubview(backgroudView)
        navigiationBar.addSubview(titleView)
        
        
        if let left = leftItem {
            navigiationBar.addSubview(left)
            left.frame = CGRect(x: 10, y: kStatusBarHeight + 7, width: 30, height: 30)
        }
        if let right = rightItem {
            right.frame = CGRect(x: kScreenWidth - 10 - 30, y: kStatusBarHeight + 7, width: 30, height: 30)
            navigiationBar.addSubview(right)
        }
        return navigiationBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.customNavigationBar.removeFromSuperview()
        self.customNavigationBar.alpha = 0
 
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
        self.collectionView?.bounces = false
        
        //每次进入都刷新，则不用监听登录状态
        //NotificationCenter.default.addObserver(self, selector: #selector(loginStatus(notify:)), name: NSNotification.Name(rawValue: NotificationLoginStatus), object: nil)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        
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
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
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
            if isSuc {
                
            } else {
                ViewManager.showNotice(msg)
            }
            self.collectionView?.reloadData()
        }
        
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
                if UserManager.manager.isLogin {
                    self.performSegue(withIdentifier: "scan", sender: nil)
//                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
//                    let login = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
//                    let loginVC = UINavigationController.init(rootViewController: login)
//
//                    self.navigationController?.present(loginVC, animated: false, completion: nil)
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

                let sel = JXDropListView(frame: CGRect(x: kScreenWidth - 100 - 10, y: kNavStatusHeight, width: 100, height: 120), style: .list)
                sel.delegate = self
                sel.dataSource = self
                sel.backgroundColor = UIColor.rgbColor(rgbValue: 0x323245)
                
                sel.layer.cornerRadius = 2
                sel.layer.shadowColor = UIColor.rgbColor(rgbValue: 0x10101a, alpha: 0.5).cgColor
                sel.layer.shadowOffset = CGSize(width: 0, height: 10)
                sel.layer.shadowRadius = 10
                sel.layer.shadowOpacity = 1
                
                sel.show()
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

