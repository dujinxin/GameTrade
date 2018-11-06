//
//  SellCollectionController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/16.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"
private let reuseIndentifierHeader = "reuseIndentifierHeader"

class SellCollectionController: JXCollectionViewController {
    
    var vm = SellVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我要卖"
        self.customNavigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(sell))
        
        self.collectionView?.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight)
        // Register cell classes
        self.collectionView?.register(UINib.init(nibName: "SellCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize.init(width: kScreenWidth - 48, height: 85)
        
        layout.sectionInset = UIEdgeInsetsMake(8, 24, 8, 24)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
     
        self.collectionView?.collectionViewLayout = layout
        
        self.collectionView?.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.request(page: 1)
        })
//        self.collectionView?.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
//            self.page += 1
//            self.request(page: self.page)
//        })
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
    @objc func sell() {
        self.performSegue(withIdentifier: "putUp", sender: nil)
    }
    @objc func loginStatus(notify:Notification) {
        print(notify)
        
        if let isSuccess = notify.object as? Bool,
            isSuccess == true{
            self.collectionView?.mj_header.beginRefreshing()
        }
    }
    override func request(page: Int) {
        self.vm.sellList{ (_, msg, isSuc) in
            self.hideMBProgressHUD()
            self.collectionView?.mj_header.endRefreshing()
            //self.collectionView?.mj_footer.endRefreshing()
            self.collectionView?.reloadData()
        }
    }
}
extension SellCollectionController {
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.vm.sellListEntity.listArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SellCell
        let entity = self.vm.sellListEntity.listArray[indexPath.item]
        cell.entity = entity
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
