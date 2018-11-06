//
//  PaperListController.swift
//  Star
//
//  Created by 杜进新 on 2018/7/24.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class PaperListController: JXTableViewController {
    
    let vm = PaperVM()
    
    var clickBlock : ((_ id: String?)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "论文"
        
        self.tableView?.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight )
        self.tableView?.separatorStyle = .none
        self.tableView?.estimatedRowHeight = 107
        self.tableView?.register(UINib(nibName: "PaperListCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        self.tableView?.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.request(page: self.page)
        })
        self.tableView?.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.page += 1
            self.request(page: self.page)
        })
        self.tableView?.mj_header.beginRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    override func request(page: Int) {
        self.vm.paperList(pageNo: page, completion: { (_, msg, isSuc) in
            if page == 1 {
                self.tableView?.mj_header.endRefreshing()
            } else {
                self.tableView?.mj_footer.endRefreshing()
            }
            
            if isSuc {
                self.tableView?.reloadData()
            } else {
                ViewManager.showNotice(msg)
            }
        })
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.vm.paperListEntity.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! PaperListCell
        
        // Configure the cell...
        
        cell.entity = self.vm.paperListEntity.list[indexPath.row]
        cell.indexPath = indexPath
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

//        if let block = clickBlock {
//            let entity = self.vm.paperListEntity.list[indexPath.row]
//            block(entity.id)
//        }
        
        let entity = self.vm.paperListEntity.list[indexPath.row]
        let vc = PaperDetailController()
        vc.hidesBottomBarWhenPushed = true
        vc.id = entity.id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if let entity = sender as? ArticleEntity, identifier == "articleDetail" {
            let vc = segue.destination as! ArticleDetailsController
            vc.articleEntity = entity
        }
    }
    
}
