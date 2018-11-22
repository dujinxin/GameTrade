//
//  NewSellController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/9.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"

class NewSellController: JXTableViewController {
    
    var vm = SellVM()
    var payVM = PayVM()
    var noticeView : JXSelectView?
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel(frame: CGRect())
        label.textColor = UIColor.rgbColor(rgbValue: 0x8E8E97)
        label.text = "您当前没有挂卖单信息"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.isHidden = true
        label.sizeToFit()
        label.center = self.view.center
        return label
    }()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.emptyLabel)
        
        self.title = "我要卖"
        self.customNavigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(sell))
        
        
        self.tableView?.register(UINib(nibName: "SellTableCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        self.tableView?.estimatedRowHeight = 101
        self.tableView?.rowHeight = 101//UITableViewAutomaticDimension
        self.tableView?.separatorStyle = .none
        
        self.tableView?.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.request(page: self.page)
        })
//        self.tableView?.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
//            self.page += 1
//            self.request(page: self.page)
//        })
        
        self.tableView?.mj_header.beginRefreshing()
        
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
    deinit {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "putUp":
            if let vc = segue.destination as? PutUpViewController, let entity = sender as? SellInfoEntity {
                vc.sellInfoEntity = entity
                vc.backBlock = {
                    ViewManager.showImageNotice("挂单成功")
                    self.tableView?.mj_header.beginRefreshing()
                }
            }
        default:
            print("123456")
        }
    }
    @objc func loginStatus(notify:Notification) {
        print(notify)
        
        if let isSuccess = notify.object as? Bool,
            isSuccess == true{
            self.tableView?.mj_header.beginRefreshing()
        }
    }
    @objc func sell() {
        
        if UserManager.manager.userEntity.user.safePwdInit != 0 {
            if UserManager.manager.userEntity.realName.isEmpty == false {
                self.vm.sellInfo { (_, msg, isSuc) in
                    if isSuc {
                        if self.vm.sellInfoEntity.list.count > 0 {
                            //self.performSegue(withIdentifier: "putUp", sender: self.vm.sellInfoEntity)
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "putUpVC") as! PutUpViewController
                            let nvc = JXNavigationController.init(rootViewController: vc)
                            
                            vc.sellInfoEntity = self.vm.sellInfoEntity
                            vc.backBlock = {
                                ViewManager.showImageNotice("挂单成功")
                                self.tableView?.mj_header.beginRefreshing()
                            }
                            //vc.hidesBottomBarWhenPushed = true
                            self.present(nvc, animated: true, completion: nil)
                        } else {
                            self.showNoticeView()
                        }
                    } else {
                        ViewManager.showNotice(msg)
                    }
                }
            } else {
                let storyboard = UIStoryboard(name: "My", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "nameSet") as! NameSetController
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        } else {
            self.showNoticeView1()
        }
    }
    override func request(page: Int) {
    
        self.vm.sellList{ (_, msg, isSuc) in
            self.hideMBProgressHUD()
            if self.vm.sellListEntity.listArray.count == 0 {
                self.emptyLabel.isHidden = false
                self.tableView?.isHidden = true
            } else {
                self.emptyLabel.isHidden = true
                self.tableView?.isHidden = false
            }
            self.tableView?.mj_header.endRefreshing()
            //self.collectionView?.mj_footer.endRefreshing()
            self.tableView?.reloadData()
            
            
        }
    }
}
//MARK: receipt type notice
extension NewSellController {
    func showNoticeView() {
        let width : CGFloat = kScreenWidth - 40 * 2
        let height : CGFloat = 300
        
        self.noticeView = JXSelectView(frame: CGRect(x: 0, y: 0, width: width, height: height), style: .custom)
        self.noticeView?.position = .middle
        self.noticeView?.customView = {
            
            let contentView = UIView()
            contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: height)
            
            let backgroundView = UIView()
            backgroundView.frame = CGRect(x: 40, y: 0, width: width, height: height)
            contentView.addSubview(backgroundView)
            
            let gradientLayer = CAGradientLayer.init()
            gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
            gradientLayer.locations = [0]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
            gradientLayer.cornerRadius = 5
            backgroundView.layer.insertSublayer(gradientLayer, at: 0)
            
            
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: width, height: 100)
            //label.center = view.center
            label.text = "提示"
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = JXTextColor
            backgroundView.addSubview(label)
            
            
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: 24, y: label.jxBottom + 20, width: width - 24 * 2, height: 30)
            nameLabel.text = "您还未添加收款方式"
            nameLabel.textColor = JXTextColor
            nameLabel.font = UIFont.systemFont(ofSize: 16)
            nameLabel.textAlignment = .center
            
            backgroundView.addSubview(nameLabel)
            nameLabel.center.y = backgroundView.center.y
            
            
            let margin : CGFloat = 16
            let space : CGFloat = 24
            let buttonWidth : CGFloat = (width - 24 - 16 * 2) / 2
            let buttonHeight : CGFloat = 44
            
            let button1 = UIButton()
            button1.frame = CGRect(x: margin, y: height - space - buttonHeight, width: buttonWidth, height: buttonHeight)
            button1.setTitle("稍后再说", for: .normal)
            button1.setTitleColor(JXOrangeColor, for: .normal)
            button1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button1.addTarget(self, action: #selector(hideNoticeView), for: .touchUpInside)
            backgroundView.addSubview(button1)
            
            
            let button = UIButton()
            button.frame = CGRect(x: button1.jxRight + space, y: button1.jxTop, width: buttonWidth, height: buttonHeight)
            button.setTitle("立即设置", for: .normal)
            button.setTitleColor(JXFfffffColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.addTarget(self, action: #selector(setPsd), for: .touchUpInside)
            backgroundView.addSubview(button)
            
            
            button.layer.cornerRadius = 2
            button.layer.shadowOpacity = 1
            button.layer.shadowRadius = 10
            button.layer.shadowOffset = CGSize(width: 0, height: 10)
            button.layer.shadowColor = JX10101aShadowColor.cgColor
            button.setTitleColor(JXFfffffColor, for: .normal)
            button.backgroundColor = JXOrangeColor
            
            return contentView
        }()
        
        self.noticeView?.show()
    }
    @objc func hideNoticeView() {
        self.noticeView?.dismiss()
    }
    @objc func setPsd() {
        self.hideNoticeView()
        
        let vc = PayListController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: trade psd notice
extension NewSellController {
    
    func showNoticeView1() {
        let width : CGFloat = kScreenWidth - 40 * 2
        let height : CGFloat = 300
        
        self.noticeView = JXSelectView(frame: CGRect(x: 0, y: 0, width: width, height: height), style: .custom)
        self.noticeView?.position = .middle
        self.noticeView?.customView = {
            
            let contentView = UIView()
            contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: height)
            
            let backgroundView = UIView()
            backgroundView.frame = CGRect(x: 40, y: 0, width: width, height: height)
            contentView.addSubview(backgroundView)
            
            let gradientLayer = CAGradientLayer.init()
            gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
            gradientLayer.locations = [0]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
            gradientLayer.cornerRadius = 5
            backgroundView.layer.insertSublayer(gradientLayer, at: 0)
            
            
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: width, height: 100)
            //label.center = view.center
            label.text = "提示"
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = JXTextColor
            backgroundView.addSubview(label)
            
            
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: 24, y: label.jxBottom + 20, width: width - 24 * 2, height: 30)
            nameLabel.text = "您还未设置资金密码"
            nameLabel.textColor = JXTextColor
            nameLabel.font = UIFont.systemFont(ofSize: 16)
            nameLabel.textAlignment = .center
            
            backgroundView.addSubview(nameLabel)
            nameLabel.center.y = backgroundView.center.y
            
            
            let margin : CGFloat = 16
            let space : CGFloat = 24
            let buttonWidth : CGFloat = (width - 24 - 16 * 2) / 2
            let buttonHeight : CGFloat = 44
            
            let button1 = UIButton()
            button1.frame = CGRect(x: margin, y: height - space - buttonHeight, width: buttonWidth, height: buttonHeight)
            button1.setTitle("稍后再说", for: .normal)
            button1.setTitleColor(JXOrangeColor, for: .normal)
            button1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button1.addTarget(self, action: #selector(hideNoticeView), for: .touchUpInside)
            backgroundView.addSubview(button1)
            
            
            let button = UIButton()
            button.frame = CGRect(x: button1.jxRight + space, y: button1.jxTop, width: buttonWidth, height: buttonHeight)
            button.setTitle("立即设置", for: .normal)
            button.setTitleColor(JXFfffffColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.addTarget(self, action: #selector(setPsd1), for: .touchUpInside)
            backgroundView.addSubview(button)
            
            
            button.layer.cornerRadius = 2
            button.layer.shadowOpacity = 1
            button.layer.shadowRadius = 10
            button.layer.shadowOffset = CGSize(width: 0, height: 10)
            button.layer.shadowColor = JX10101aShadowColor.cgColor
            button.setTitleColor(JXFfffffColor, for: .normal)
            button.backgroundColor = JXOrangeColor
            
            return contentView
        }()
        
        self.noticeView?.show()
    }
    @objc func setPsd1() {
        self.hideNoticeView()
        
        let storyboard = UIStoryboard(name: "My", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "modifyTradePsw") as! ModifyTradePswController
        vc.hidesBottomBarWhenPushed = true
        vc.type = 2
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension NewSellController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.vm.sellListEntity.listArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SellTableCell
        
        let entity = self.vm.sellListEntity.listArray[indexPath.row]
        cell.entity = entity
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let entity = self.vm.orderListEntity.listArray[indexPath.row]
//        let vc = OrderDetailController()
//        vc.id = entity.id
//        vc.hidesBottomBarWhenPushed = true
//        vc.backBlock = {
//            self.tableView?.mj_header.beginRefreshing()
//        }
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除！"
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        let style : UITableViewCellEditingStyle = .delete
        return style
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //default,destructive默认红色，normal默认灰色，可以通过backgroundColor 修改背景颜色，backgroundEffect 添加模糊效果
        let deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { (action, indexPath) in
            print("删除")
            
            let entity = self.vm.sellListEntity.listArray[indexPath.row]
            
            self.vm.sellDelete(id: entity.id ?? "", completion: { (_, msg, isSuc) in
                if isSuc {
                    ViewManager.showImageNotice("删除成功")
                    self.vm.sellListEntity.listArray.remove(at: indexPath.row)
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                    self.request(page: self.page)
                } else {
                    ViewManager.showNotice(msg)
                }
            })

        }
        
        deleteAction.backgroundColor = JXRedColor
       
        return [deleteAction]
    }
}
