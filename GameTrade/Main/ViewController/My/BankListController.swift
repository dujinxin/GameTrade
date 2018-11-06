//
//  BankListController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/1.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class BankListController: JXTableViewController {
    
    var vm = PayVM()
    
    var selectBlock : ((_ entity: BankEntity)->())?
    
    
    lazy var searchVC : UISearchController = {
        let vc = UISearchController(searchResultsController: nil)
        vc.searchResultsUpdater = self
//        vc.hidesNavigationBarDuringPresentation = true
        vc.dimsBackgroundDuringPresentation = false
        
        vc.searchBar.backgroundColor = UIColor.rgbColor(rgbValue: 0x393948)
        vc.searchBar.backgroundImage = UIImage.imageWithColor(UIColor.rgbColor(rgbValue: 0x393948))
        vc.searchBar.setSearchFieldBackgroundImage(UIImage.imageWithColor(UIColor.rgbColor(rgbValue: 0x393948), size: CGSize(width: kScreenWidth, height: 44)), for: .normal)
        
        vc.searchBar.tintColor = JXOrangeColor
        vc.searchBar.placeholder = "开户银行"
        vc.searchBar.showsCancelButton = false
        if #available(iOS 11.0, *) {
//            let searchFieldBackgroudView = vc.searchBar.subviews.first
//            searchFieldBackgroudView?.backgroundColor = UIColor.rgbColor(rgbValue: 0x393948)
//            print(vc.searchBar.subviews)
//            for view in vc.searchBar.subviews {
//                view.backgroundColor = UIColor.rgbColor(rgbValue: 0x393948)
//                for v in view.subviews {
//                    v.backgroundColor = UIColor.rgbColor(rgbValue: 0x393948)
//                }
//            }
        } else {
            
        }
        vc.searchBar.isTranslucent = true
        
        let searchField = vc.searchBar.value(forKey: "searchField") as? UITextField
        searchField?.textColor = JXTextColor
        searchField?.font = UIFont.systemFont(ofSize: 14)
        
        
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择开户行"
        
        self.customNavigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Close"), style: .plain, target: self, action: #selector(close))
        
        self.tableView?.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight)
        
        self.tableView?.estimatedRowHeight = 44
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.separatorStyle = .singleLine
        self.tableView?.separatorColor = JXSeparatorColor
        self.tableView?.separatorInset = UIEdgeInsetsMake(0, 24, 0, 0)
     
        self.tableView?.register(UINib(nibName: "BankCell", bundle: nil), forCellReuseIdentifier: labelCellIdentifier)
        
//        self.button.frame = CGRect(x: 30, y: 0, width: kScreenWidth - 30 * 2, height: 44)
//        let footer = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 44))
//        footer.addSubview(self.button)
//        self.tableView?.tableFooterView = footer
        
        self.tableView?.tableHeaderView = self.searchVC.searchBar
        
        self.vm.bankList { (_, msg, isSuc) in
            self.tableView?.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.vm.bankIndexList.count
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return self.vm.bankIndexList[section]
//    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 40))
        contentView.backgroundColor = UIColor.rgbColor(rgbValue: 0x24242f)
        
        let label = UILabel(frame: CGRect(x: 24, y: 0, width: 100, height: 40))
        label.textColor = JXTextColor
        label.text = self.vm.bankIndexList[section]
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        contentView.addSubview(label)
        
        return contentView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let key = self.vm.bankIndexList[section]
        let arr = self.vm.bankFormatDictionary[key]
        return arr?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: labelCellIdentifier, for: indexPath) as! BankCell
        let key = self.vm.bankIndexList[indexPath.section]
        let arr = self.vm.bankFormatDictionary[key]
        let entity = arr?[indexPath.row]
        cell.nameLabel.text = entity?.name
        cell.infoLabel.text = entity?.pinyin
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let key = self.vm.bankIndexList[indexPath.section]
        
        if
            let arr = self.vm.bankFormatDictionary[key],
            let block = selectBlock {
            let entity = arr[indexPath.row]
            block(entity)
        }
        self.dismiss(animated: true) {}
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
extension BankListController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
