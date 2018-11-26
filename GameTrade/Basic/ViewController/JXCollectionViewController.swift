//
//  JXCollectionViewController.swift
//  Star
//
//  Created by 杜进新 on 2018/7/11.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"
private let reuseIndentifierHeader = "reuseIndentifierHeader"

class JXCollectionViewController: BaseViewController {

    //tableview
    var collectionView : UICollectionView?
    //refreshControl
    var refreshControl : UIRefreshControl?
    //data array
    var dataArray = NSMutableArray()
    var page : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.collectionView?.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc override func setUpMainView() {
        setUpTableView()
    }
    
    func setUpTableView(){
        let y = self.isCustomNavigationBarUsed() ? kNavStatusHeight : 0
        let height = self.isCustomNavigationBarUsed() ? (view.bounds.height - kNavStatusHeight) : view.bounds.height
        
        
        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsetsMake(0.5, 0, 0, 0)
        layout.minimumLineSpacing = 0.5
        layout.minimumInteritemSpacing = 0.5
        
        layout.itemSize = UICollectionViewFlowLayoutAutomaticSize
        layout.estimatedItemSize = CGSize(width: kScreenWidth / 3, height: kScreenWidth / 3)
        
//        layout.headerReferenceSize = CGSize(width: 0, height: 0)
//        layout.headerReferenceSize = UICollectionViewFlowLayoutAutomaticSize
//        layout.footerReferenceSize = UICollectionViewFlowLayoutAutomaticSize
    
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: y, width: view.bounds.width, height: height), collectionViewLayout: layout)
        self.collectionView?.backgroundColor = UIColor.clear
        
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.view.addSubview(self.collectionView!)

    }
    /// request data
    ///
    /// - Parameter page: load data for page,
    func request(page:Int) {}
}
extension JXCollectionViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
