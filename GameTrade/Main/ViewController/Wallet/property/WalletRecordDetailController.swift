//
//  WalletRecordDetailController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/29.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

enum Type: Int {
    case paying
    case payed
    case transfer
}

private let reuseIdentifieringDetailPayed = "reuseIdentifieringDetailPayed"
private let reuseIdentifierAddress = "reuseIdentifierAddress"

class WalletRecordDetailController: JXTableViewController {
    
    var defaultArray: Array = [["title":"对方账户"],["title":"分类"],["title":"订单号"],["title":"交易单价"],["title":"交易数量"],["title":"创建时间"]]
    
    var pageType : Type = .payed
    //var tradeEntity = TradeEntity()
    
    var type : Int = 0
    var bizId : String = ""
    
    var vm = WalletVM()
    var noticeView : JXSelectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "交易详情"
        
        self.tableView?.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight)
        
        //self.tableView?.separatorStyle = .none
        self.tableView?.estimatedRowHeight = 44
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.register(UINib(nibName: "WalletListPayingCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierNormal)
        self.tableView?.register(UINib(nibName: "WalletDetailPayedCell", bundle: nil), forCellReuseIdentifier: reuseIdentifieringDetailPayed)
        self.tableView?.register(UINib(nibName: "WalletAddressCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierAddress)
        self.tableView?.register(UINib(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: labelCellIdentifier)
        self.tableView?.separatorStyle = .none
        
        
        self.requestData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func requestData() {
        self.vm.tradeDetail(type: self.type, bizId: self.bizId) { (_, msg, isSuc) in
            if isSuc {
                self.tableView?.reloadData()
            } else {
                ViewManager.showNotice(msg)
            }
        }
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.pageType == .transfer {
            return 6
        } else {
            return 5
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifieringDetailPayed, for: indexPath) as! WalletDetailPayedCell
            //cell.entity = self.vm.tradeDetailEntity
            cell.setEntity(self.vm.tradeDetailEntity, type: self.type)
            return cell
        } else if indexPath.row == 1{
            
            if self.pageType == .transfer {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierAddress, for: indexPath) as! WalletAddressCell
                cell.addressLabel.text = self.vm.tradeDetailEntity.account
                //cell.nameLabel.text = dict["title"]
                cell.showCodeImage = {
                    self.showNoticeView2()
                }
                return cell
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: labelCellIdentifier, for: indexPath) as! LabelCell
                
                cell.nameLabel.text = "分类"
                cell.infoLabel.text = "支付"
                return cell
            }
            
        } else {
            let dict = self.defaultArray[indexPath.row - 1]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: labelCellIdentifier, for: indexPath) as! LabelCell
            //cell.selectionStyle = .none
            cell.nameLabel.text = dict["title"]
            
            if indexPath.row == 2 {
                if self.pageType == .transfer {
                    cell.nameLabel.text = "分类"
                    cell.infoLabel.text = "转账"
                } else {
                    cell.nameLabel.text = "订单号"
                    cell.infoLabel.text = self.vm.tradeDetailEntity.orderNumber
                }
                
            } else if indexPath.row == 3 {
                if self.pageType == .transfer {
                    cell.nameLabel.text = "交易单价"
                    cell.infoLabel.text = "\(self.vm.tradeDetailEntity.price) \(configuration_valueType)"
                } else {
                    cell.nameLabel.text = "交易数量"
                    cell.infoLabel.text = "\(self.vm.tradeDetailEntity.amount) \(configuration_coinName)"
                }
              
            } else if indexPath.row == 4 {
                if self.pageType == .transfer {
                    cell.nameLabel.text = "交易数量"
                    cell.infoLabel.text = "\(self.vm.tradeDetailEntity.amount) \(configuration_coinName)"
                } else {
                    cell.nameLabel.text = "创建时间"
                    cell.infoLabel.text = self.vm.tradeDetailEntity.createTime
                }
        
            } else if indexPath.row == 5 {
                if self.pageType == .transfer {
                    cell.nameLabel.text = "创建时间"
                    cell.infoLabel.text = self.vm.tradeDetailEntity.createTime
                } else {
                    
                }
            }
            
            return cell
        }
   
    }
    
    //MARK: selectView2
    @objc func showNoticeView2() {
        let width : CGFloat = kScreenWidth - 24 * 2
        let height : CGFloat = width + 12
        
        self.noticeView = JXSelectView(frame: CGRect(x: 0, y: 0, width: width, height: height), style: .custom)
        self.noticeView?.position = .middle
        self.noticeView?.customView = {
            
            let contentView = UIView()
            contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: height)
            
            let backgroundView = UIView()
            backgroundView.frame = CGRect(x: 24, y: 0, width: width, height: height)
            contentView.addSubview(backgroundView)
            
            let gradientLayer = CAGradientLayer.init()
            gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
            gradientLayer.locations = [0]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
            gradientLayer.cornerRadius = 5
            backgroundView.layer.insertSublayer(gradientLayer, at: 0)
            
            
            let margin : CGFloat = 16
            let space : CGFloat = 24
            let buttonWidth : CGFloat = (width - 16 * 2)
            let buttonHeight : CGFloat = 44
            
            
            let button = UIButton()
            button.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
            //button.center = CGPoint(x: 30, y: view.jxCenterY)
            //button.setTitle("×", for: .normal)
            button.tintColor = JXFfffffColor
            button.setImage(UIImage(named: "Close")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button.setTitleColor(JX333333Color, for: .normal)
            button.contentVerticalAlignment = .center
            button.contentHorizontalAlignment = .center
            button.addTarget(self, action: #selector(hideNoticeView2), for: .touchUpInside)
            backgroundView.addSubview(button)
            
            
            let imageView = UIImageView(frame: CGRect(x: 48, y: button.jxBottom + 10, width: width - 48 * 2, height: width - 48 * 2))
            if let str = self.vm.tradeDetailEntity.qrCode {
                imageView.sd_setImage(with: URL(string: str), completed: nil)
            }
            backgroundView.addSubview(imageView)
            
            return contentView
        }()
        
        self.noticeView?.show()
    }
    @objc func hideNoticeView2() {
        self.noticeView?.dismiss()
    }
   
}
