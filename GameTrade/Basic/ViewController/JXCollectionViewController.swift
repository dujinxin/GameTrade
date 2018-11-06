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
            self.collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(kNavStatusHeight, 0, 0, 0)
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
        //layout.itemSize = CGSize.init(width: width, height: height)
        //layout.headerReferenceSize = CGSize(width: kScreenWidth, height: 272 + kNavStatusHeight)
        
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: y, width: view.bounds.width, height: height), collectionViewLayout: layout)
        self.collectionView?.backgroundColor = UIColor.clear
        
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.view.addSubview(self.collectionView!)
        // Register cell classes
//        self.collectionView?.register(UINib.init(nibName: "TaskCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
//        self.collectionView?.register(UINib.init(nibName: "TaskReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseIndentifierHeader)
        
//        refreshControl = UIRefreshControl()
//        refreshControl?.addTarget(self, action: #selector(requestData), for: UIControlEvents.valueChanged)
//        
//        self.collectionView?.addSubview(refreshControl!)
    }
    /// request data
    ///
    /// - Parameter page: load data for page,
    func request(page:Int) {
        
    }
}
extension JXCollectionViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}
