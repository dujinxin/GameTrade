//
//  BuySubController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/30.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import JXFoundation

private let reuseIdentifier = "reuseIdentifier"
private let reuseIndentifierHeader = "reuseIndentifierHeader"

class BuySubController: JXCollectionViewController {
    
    var vm = BuyVM()
    var type : Int = 0 //
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
        var subLayers = self.view.layer.sublayers
        let subLayer = subLayers?[0]
        subLayer?.removeFromSuperlayer()
        
        //self.collectionView?.frame = CGRect(x: 0, y: kNavStatusHeight + headViewHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight - headViewHeight)
        // Register cell classes
        self.collectionView?.register(UINib.init(nibName: "MerchantCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.register(UINib.init(nibName: "HomeReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIndentifierHeader)
        
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize.init(width: kScreenWidth, height: 168)
        
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
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
    override func isCustomNavigationBarUsed() -> Bool {
        return false
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
            self.collectionView?.mj_header.beginRefreshing()
        }
    }
    override func request(page: Int) {
        self.vm.buyList(payType: self.type, pageSize: 10, pageNo: page) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            self.collectionView?.mj_header.endRefreshing()
            self.collectionView?.mj_footer.endRefreshing()
            self.collectionView?.reloadData()
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //        print(scrollView.contentOffset.y)
        //        let yOffset = scrollView.contentOffset.y
        //
        //        if yOffset > 83 {
        //            let y = self.headView.frame.origin.y
        //            self.headView.frame.origin.y = y - 83
        //            scrollView.frame = CGRect(x: 0, y: kNavStatusHeight + (headViewHeight - 83), width: kScreenWidth, height: kScreenHeight - kNavStatusHeight - (headViewHeight - 83))
        //        } else if yOffset > 0 && yOffset <= 83{
        //            let y = self.headView.frame.origin.y
        //            self.headView.frame.origin.y = kNavStatusHeight - CGFloat(fabs(yOffset))
        //            scrollView.frame = CGRect(x: 0, y: kNavStatusHeight + (headViewHeight - CGFloat(fabs(yOffset))), width: kScreenWidth, height: kScreenHeight - kNavStatusHeight - (headViewHeight - CGFloat(fabs(yOffset))))
        //        } else {
        //
        //            self.headView.frame.origin.y = headViewHeight
        //            scrollView.frame = CGRect(x: 0, y: kNavStatusHeight + headViewHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight - headViewHeight)
        //        }
    }
}
extension BuySubController {
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
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.buyBlock = {
            
        }
        return cell
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            
        }
    }
}
