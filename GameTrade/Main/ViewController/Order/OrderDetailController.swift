//
//  NewOrderDetailController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/5.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

import ChatCamp


private let reuseIndentifierHeaderBuying = "reuseIndentifierHeaderBuying"
private let reuseIndentifierHeaderBuyed = "reuseIndentifierHeaderBuyed"
private let reuseIndentifierHeaderSelling = "reuseIndentifierHeaderSelling"
private let reuseIndentifierHeaderSelled = "reuseIndentifierHeaderSelled"

class OrderDetailController: JXTableViewController {

    var vm = OrderVM()
    var id : String?
    var comeFrom = 0 //默认为订单列表待确认付款状态直接进来
    
    var timer : DispatchSourceTimer?
    var noticeView : JXSelectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "订单详情"
        
        self.customNavigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon-back"), style: .plain, target: self, action: #selector(backToRoot))
        
        self.tableView?.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight)
        // Register cell classes
        self.tableView?.register(UINib(nibName: "OrderBuyingDetailCell", bundle: nil), forCellReuseIdentifier: reuseIndentifierHeaderBuying)
        self.tableView?.register(UINib(nibName: "OrderBuyedDetailCell", bundle: nil), forCellReuseIdentifier: reuseIndentifierHeaderBuyed)
        self.tableView?.register(UINib(nibName: "OrderSellingDetailCell", bundle: nil), forCellReuseIdentifier: reuseIndentifierHeaderSelling)
        self.tableView?.register(UINib(nibName: "OrderSelledDetailCell", bundle: nil), forCellReuseIdentifier: reuseIndentifierHeaderSelled)

        self.requestData()
        
        self.vm.orderDetail(id: self.id ?? "") { (_, msg, isSuc) in
            self.tableView?.reloadData()
            
            self.resetNaviagationItem()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let timer = self.timer {
            print("cancel...")
            timer.cancel()
        }
    }
    deinit {
    
    }
    @objc func loginStatus(notify:Notification) {
        print(notify)
        
        if let isSuccess = notify.object as? Bool,
            isSuccess == true{
            self.requestData()
        }
    }
    
    override func requestData() {
        
        self.vm.orderDetail(id: self.id ?? "") { (_, msg, isSuc) in
            self.tableView?.reloadData()
            
            self.resetNaviagationItem()
        }
    }
    func resetNaviagationItem() {
        //订单状态 1：待付款，2：待确认付款，3：已完成，4：未付款取消，5：财务判断取消,6：超时系统自动取消
        if self.vm.orderDetailEntity.orderType == "购买" {
            if self.vm.orderDetailEntity.orderStatus != 1 {
                self.customNavigationItem.rightBarButtonItem = UIBarButtonItem(title: "申诉", fontSize: 14, imageName: "", target: self, action: #selector(connectFinance))
            }
        } else {
            if self.vm.orderDetailEntity.orderStatus != 2 {
                self.customNavigationItem.rightBarButtonItem = UIBarButtonItem(title: "申诉", fontSize: 14, imageName: "", target: self, action: #selector(connectFinance))
            }
        }
        
    }
    @objc func backToRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @objc func appeal() {
        print("shengshu")
    }
    //MARK: selectView
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
            label.text = "注意"
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = JXTextColor
            backgroundView.addSubview(label)
            
            
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: 24, y: label.jxBottom + 20, width: width - 24 * 2, height: 45)
            nameLabel.text = "请确认您已向卖家付款\n「恶意点击将直接冻结账户」"
            nameLabel.textColor = JXTextColor
            nameLabel.font = UIFont.systemFont(ofSize: 16)
            nameLabel.textAlignment = .center
            nameLabel.numberOfLines = 0
            
            backgroundView.addSubview(nameLabel)
            nameLabel.center.y = backgroundView.center.y
            
            
            let margin : CGFloat = 16
            let space : CGFloat = 24
            let buttonWidth : CGFloat = (width - 24 - 16 * 2) / 2
            let buttonHeight : CGFloat = 44
            
            let button1 = UIButton()
            button1.frame = CGRect(x: margin, y: height - space - buttonHeight, width: buttonWidth, height: buttonHeight)
            button1.setTitle("点错了", for: .normal)
            button1.setTitleColor(JXOrangeColor, for: .normal)
            button1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button1.addTarget(self, action: #selector(hideNoticeView), for: .touchUpInside)
            backgroundView.addSubview(button1)
            
            
            let button = UIButton()
            button.frame = CGRect(x: button1.jxRight + space, y: button1.jxTop, width: buttonWidth, height: buttonHeight)
            button.setTitle("确认付款", for: .normal)
            button.setTitleColor(JXFfffffColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.addTarget(self, action: #selector(confirm), for: .touchUpInside)
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
    @objc func confirm() {
        self.hideNoticeView()
        
        //确认
        self.vm.buyConfirm(id: self.vm.orderDetailEntity.id, completion: { (_, msg, isSuc) in
            if isSuc {
                
                self.requestData()
                
                //self.showNoticeView1()
            } else {
                ViewManager.showNotice(msg)
            }
        })
    }
    //MARK: selectView1
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
            label.text = "注意"
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = JXTextColor
            backgroundView.addSubview(label)
            
            
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: 24, y: label.jxBottom + 20, width: width - 24 * 2, height: 45)
            nameLabel.text = "购买的资产已到账\n您可以到首页查询"
            nameLabel.textColor = JXTextColor
            nameLabel.font = UIFont.systemFont(ofSize: 16)
            nameLabel.textAlignment = .center
            nameLabel.numberOfLines = 0
            
            backgroundView.addSubview(nameLabel)
            nameLabel.center.y = backgroundView.center.y
            
            
            let margin : CGFloat = 16
            let space : CGFloat = 24
            let buttonWidth : CGFloat = (width - 16 * 2)
            let buttonHeight : CGFloat = 44
            
            
            let button = UIButton()
            button.frame = CGRect(x: margin, y: height - space - buttonHeight, width: buttonWidth, height: buttonHeight)
            button.setTitle("确认", for: .normal)
            button.setTitleColor(JXFfffffColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.addTarget(self, action: #selector(confirm1), for: .touchUpInside)
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
    @objc func hideNoticeView1() {
        self.noticeView?.dismiss()
    }
    @objc func confirm1() {
        self.hideNoticeView1()
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
            if let str = self.vm.orderDetailEntity.qrcodeImg {
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
extension OrderDetailController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //付款状态，1：待付款，2：待确认付款，3：已完成，4：未付款取消，5：财务判断取消,6：超时系统自动取消
        if self.vm.orderDetailEntity.orderType == "购买" {
            if self.vm.orderDetailEntity.orderStatus == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIndentifierHeaderBuying, for: indexPath) as! OrderBuyingDetailCell
                cell.entity = self.vm.orderDetailEntity
                self.timer = cell.timer
                cell.codeButton.addTarget(self, action: #selector(showNoticeView2), for: .touchUpInside)
                cell.chatBlock = {
                    self.connectService()
                }
                cell.cancelBlock = {
                    
                    self.vm.buyCancel(id: self.vm.orderDetailEntity.id, completion: { (_, msg, isSuc) in
                        if isSuc {
                            self.requestData()
                        } else {
                            ViewManager.showNotice(msg)
                        }
                    })
                }
                cell.timeOutBlock = {
                    
                    print("timeOutBlock")
                    self.requestData()
                }
                cell.payBlock = {
                    self.showNoticeView()
                    
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIndentifierHeaderBuyed, for: indexPath) as! OrderBuyedDetailCell
                cell.entity = self.vm.orderDetailEntity
                cell.codeButton.addTarget(self, action: #selector(showNoticeView2), for: .touchUpInside)
                cell.chatBlock = {
                    self.connectService()
                }
                return cell
            }
        } else {
            if self.vm.orderDetailEntity.orderStatus == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIndentifierHeaderSelling, for: indexPath) as! OrderSellingDetailCell
                cell.entity = self.vm.orderDetailEntity
                cell.codeButton.addTarget(self, action: #selector(showNoticeView2), for: .touchUpInside)
                self.timer = cell.timer
                cell.cancelBlock = {
                    
                }
                cell.timeOutBlock = {
                    
                    print("timeOutBlock")
                    self.requestData()
                }
                cell.payBlock = {
                    //确认
                    self.vm.sellConfirm(id: self.vm.orderDetailEntity.id, completion: { (_, msg, isSuc) in
                        if isSuc {
//                            if let block = self.backBlock {
//                                block()
//                            }
//                            self.navigationController?.popToRootViewController(animated: true)
                            self.requestData()
                        } else {
                            ViewManager.showNotice(msg)
                        }
                    })
                }
                cell.chatBlock = {
                    if let chatID = self.vm.serviceId {
                        self.createChat(id: chatID)
                    } else {
                        self.vm.getChatID(agentId: self.vm.orderDetailEntity.salerId ?? "", type: 1, completion: { (_, msg, isSuc) in
                            
                            if isSuc {
                                self.createChat(id: self.vm.serviceId)
                            } else {
                                ViewManager.showNotice(msg)
                            }
                        })
                    }
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIndentifierHeaderSelled, for: indexPath) as! OrderSelledDetailCell
                cell.entity = self.vm.orderDetailEntity
                cell.codeButton.addTarget(self, action: #selector(showNoticeView2), for: .touchUpInside)
                cell.chatBlock = {
                    self.connectService()
                }
                return cell
            }
        }
    }
}
extension OrderDetailController {
    @objc func connectFinance() {
        if let chatID = self.vm.financeId {
            self.createChat(id: chatID)
        } else {
            self.vm.getChatID(agentId: "suibian", type: 2, completion: { (_, msg, isSuc) in
                
                if isSuc {
                    self.createChat(id: self.vm.financeId)
                } else {
                    ViewManager.showNotice(msg)
                }
            })
        }
    }
    func connectService() {
        if let chatID = self.vm.serviceId {
            self.createChat(id: chatID)
        } else {
            var agentId = ""
            if self.vm.orderDetailEntity.orderType == "购买" {
                agentId = self.vm.orderDetailEntity.salerId ?? ""
            } else {
                agentId = self.vm.orderDetailEntity.buyerId ?? ""
            }
            self.vm.getChatID(agentId: agentId, type: 1, completion: { (_, msg, isSuc) in
                
                if isSuc {
                    self.createChat(id: self.vm.serviceId)
                } else {
                    ViewManager.showNotice(msg)
                }
            })
        }
    }
    func createChat(id: String?) {
        
        guard let chatID = id else { return }
        
        let userID = CCPClient.getCurrentUser().getId()
        let username = CCPClient.getCurrentUser().getDisplayName()
        
        let sender = Sender(id: userID, displayName: username!)
        
        CCPGroupChannel.create(name: self.vm.orderDetailEntity.agentName ?? "", userIds: [userID, chatID], isDistinct: true) { groupChannel, error in
            print("jxnotice =============  ",groupChannel,"\n",error)
            if error == nil {
                let chatViewController = ChatViewController(channel: groupChannel!, sender: sender)
                self.navigationController?.pushViewController(chatViewController, animated: true)
            } else {
                self.showAlert(title: "Error!", message: "Some error occured, please try again.", actionText: "OK")
            }
        }
    }
}
