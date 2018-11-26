//
//  HelpFeedBackController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/20.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class HelpFeedBackController: JXTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "帮助与反馈"
        
        self.tableView?.frame = CGRect(x: 0, y: kNavStatusHeight  + 48, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight - 48)
        self.tableView?.separatorStyle = .none
        self.tableView?.estimatedRowHeight = 64
        //self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        self.tableView?.register(UINib(nibName: "PersonCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! PersonCell
        cell.backgroundColor = UIColor.clear
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.leftLabel.textColor = JXTextColor
        cell.leftLabel.font = UIFont.systemFont(ofSize: 14)
        if indexPath.row == 0 {
            cell.leftLabel.text = "帮助中心"
        } else {
            cell.leftLabel.text = "提交反馈"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
//            let storyboard = UIStoryboard(name: "My", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "help") as! HelpViewController
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
            
            let vc = MyWebViewController()
            vc.title = "帮助信息"//self.homeVM.homeEntity.notice.title
            vc.urlStr = "https://cooodingcdn.s3-ap-northeast-1.amazonaws.com/html/static/help.html"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }  else {
            let storyboard = UIStoryboard(name: "My", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "feedBack") as! FeedBackController
            vc.hidesBottomBarWhenPushed = true
            //vc.type = .tab
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
