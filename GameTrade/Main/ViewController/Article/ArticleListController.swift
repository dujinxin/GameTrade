//
//  ArticleListController.swift
//  Star
//
//  Created by 杜进新 on 2018/5/30.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

enum FromType {
    case tab
    case task
}

class ArticleListController: JXTableViewController {

    let vm = ArticleVM()
    var type : FromType = .tab
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "文章"
  
        self.tableView?.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight)
        self.tableView?.separatorStyle = .none
        self.tableView?.estimatedRowHeight = 256
        self.tableView?.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
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
        self.vm.articleList(pageNo: page, completion: { (_, msg, isSuc) in
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
        return self.vm.articleListEntity.list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ArticleCell

        let entity = self.vm.articleListEntity.list[indexPath.row]
        cell.entity = entity
        // Configure the cell...

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let entity = self.vm.articleListEntity.list[indexPath.row]
        self.performSegue(withIdentifier: "articleDetail", sender: entity)
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
