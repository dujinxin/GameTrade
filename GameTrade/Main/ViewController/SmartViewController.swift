//
//  SmartViewController.swift
//  Star
//
//  Created by 杜进新 on 2018/7/26.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class SmartViewController: JXTableViewController {
    
    var type : FromType = .tab
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "智慧"
       
        self.tableView?.backgroundColor = UIColor.white
        if type == .tab {
            self.tableView?.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight - kTabBarHeight)
        } else {
            self.tableView?.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight)
        }
        self.tableView?.separatorStyle = .none
        self.tableView?.estimatedRowHeight = 107
        self.tableView?.register(UINib(nibName: "SmartCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! SmartCell
        cell.selectionStyle = .none
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
  
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "Smart", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ArticleVC") as! ArticleListController
            vc.hidesBottomBarWhenPushed = true
            vc.type = .tab
            self.navigationController?.pushViewController(vc, animated: true)

        } else {
            let vc = PaperListController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
