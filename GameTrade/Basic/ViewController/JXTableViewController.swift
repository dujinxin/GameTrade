//
//  JXTableViewController.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/6/7.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit

let reuseIdentifierNormal = "reuseIdentifierNormal"

class JXTableViewController: BaseViewController{

    //tableview
    var tableView : UITableView?
    //refreshControl
    var refreshControl : UIRefreshControl?
    //data array
    var dataArray : Array<Any>!
    var page : Int = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.tableView?.contentInsetAdjustmentBehavior = .never
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
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: y, width: view.bounds.width, height: height), style: .plain)
        self.tableView?.backgroundColor = UIColor.clear
        self.tableView?.separatorStyle = .none
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.estimatedSectionHeaderHeight = 0
        self.tableView?.estimatedSectionFooterHeight = 0
        self.tableView?.estimatedRowHeight = 44
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tableView?.sectionFooterHeight = UITableViewAutomaticDimension
        self.view.addSubview(self.tableView!)
        
//        refreshControl = UIRefreshControl()
//        refreshControl?.addTarget(self, action: #selector(requestData), for: UIControlEvents.valueChanged)
//        self.tableView?.addSubview(refreshControl!)
    }
    /// request data
    ///
    /// - Parameter page: load data for page,
    func request(page:Int) {}
}


extension JXTableViewController : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

