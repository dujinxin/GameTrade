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
        self.tableView?.estimatedRowHeight = kScreenHeight - kNavStatusHeight
        self.tableView?.estimatedSectionHeaderHeight = 0
        self.tableView?.estimatedSectionFooterHeight = 0
        // Register cell classes
        self.tableView?.register(UINib(nibName: "OrderBuyingDetailCell", bundle: nil), forCellReuseIdentifier: reuseIndentifierHeaderBuying)
        self.tableView?.register(UINib(nibName: "OrderBuyedDetailCell", bundle: nil), forCellReuseIdentifier: reuseIndentifierHeaderBuyed)
        self.tableView?.register(UINib(nibName: "OrderSellingDetailCell", bundle: nil), forCellReuseIdentifier: reuseIndentifierHeaderSelling)
        self.tableView?.register(UINib(nibName: "OrderSelledDetailCell", bundle: nil), forCellReuseIdentifier: reuseIndentifierHeaderSelled)

        self.requestData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let timer = self.timer {
            print("cancel...")
            timer.suspend()
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
            self.tableView?.contentOffset = CGPoint(x: 0, y: 0)
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
                cell.copyBlock = {
                    let pals = UIPasteboard.general
                    pals.string = self.vm.orderDetailEntity.account
                    ViewManager.showImageNotice("已复制")
                }
                cell.cancelBlock = {
                    self.showNoticeView1()
                }
                cell.timeOutBlock = {
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
                cell.copyBlock = {
                    let pals = UIPasteboard.general
                    pals.string = self.vm.orderDetailEntity.account
                    ViewManager.showImageNotice("已复制")
                }
                return cell
            }
        } else {
            if self.vm.orderDetailEntity.orderStatus == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIndentifierHeaderSelling, for: indexPath) as! OrderSellingDetailCell
                cell.entity = self.vm.orderDetailEntity
                cell.codeButton.addTarget(self, action: #selector(showNoticeView2), for: .touchUpInside)
                self.timer = cell.timer
                cell.timeOutBlock = {
                    self.requestData()
                }
                cell.payBlock = {
                    //确认
                    self.vm.sellConfirm(id: self.vm.orderDetailEntity.id, completion: { (_, msg, isSuc) in
                        if isSuc {
                            self.requestData()
                        } else {
                            ViewManager.showNotice(msg)
                        }
                    })
                }
                cell.chatBlock = {
                    self.connectService()
                }
                cell.copyBlock = {
                    let pals = UIPasteboard.general
                    pals.string = self.vm.orderDetailEntity.account
                    ViewManager.showImageNotice("已复制")
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIndentifierHeaderSelled, for: indexPath) as! OrderSelledDetailCell
                cell.entity = self.vm.orderDetailEntity
                cell.codeButton.addTarget(self, action: #selector(showNoticeView2), for: .touchUpInside)
                cell.chatBlock = {
                    self.connectService()
                }
                cell.copyBlock = {
                    let pals = UIPasteboard.general
                    pals.string = self.vm.orderDetailEntity.account
                    ViewManager.showImageNotice("已复制")
                }
                return cell
            }
        }
    }
}
//MARK: chat
extension OrderDetailController {
    @objc func connectFinance() {
//        if let chatID = self.vm.financeId {
//            self.createChat(id: chatID)
//        } else {
//            self.vm.getChatID(agentId: "suibian", type: 2, completion: { (_, msg, isSuc) in
//
//                if isSuc {
//                    self.createChat(id: self.vm.financeId)
//                } else {
//                    ViewManager.showNotice(msg)
//                }
//            })
//        }
        self.connectService()
    }
    func connectService() {
      
        var chatID = ""
        if self.vm.orderDetailEntity.orderType == "购买" {
            chatID = self.vm.orderDetailEntity.salerId ?? ""
        } else {
            chatID = self.vm.orderDetailEntity.buyerId ?? ""
        }
        self.createChat(id: chatID)
        
        
        
//        if let chatID = self.vm.serviceId {
//            self.createChat(id: chatID)
//        } else {
//            var agentId = ""
//            if self.vm.orderDetailEntity.orderType == "购买" {
//                agentId = self.vm.orderDetailEntity.salerId ?? ""
//            } else {
//                agentId = self.vm.orderDetailEntity.buyerId ?? ""
//            }
//            self.vm.getChatID(agentId: agentId, type: 1, completion: { (_, msg, isSuc) in
//
//                if isSuc {
//                    self.createChat(id: self.vm.serviceId)
//                } else {
//                    ViewManager.showNotice(msg)
//                }
//            })
//        }
    }
    func createChat(id: String?) {
        
        guard let chatID = id else { return }
        
        let userID = CCPClient.getCurrentUser().getId()
        let username = CCPClient.getCurrentUser().getDisplayName()
        
        let sender = Sender(id: userID, displayName: username!)
        
        CCPGroupChannel.create(name: self.vm.orderDetailEntity.agentName ?? "", userIds: [userID, chatID], isDistinct: true) { groupChannel, error in
            if error == nil {
                //
                let chatViewController = ChatViewController(channel: groupChannel!, sender: sender)
                
                if let meta = groupChannel?.getMetadata(), let orderId = meta["id"], orderId == self.vm.orderDetailEntity.id {
                    //同一个,不做操作
                    self.navigationController?.pushViewController(chatViewController, animated: true)
                } else {
                    groupChannel?.updateMetadata(metadata: ["id": self.vm.orderDetailEntity.id,"fromId": userID,"first": "1"], completionHandler: { (baseChannel, error) in
                        if let e = error {
                            print(e.localizedDescription)
                        } else {
                            print("-----------",baseChannel?.getMetadata())
                            chatViewController.sendMessage("你好，我的订单号是\(self.vm.orderDetailEntity.orderNum ?? "")。", orderId: self.vm.orderDetailEntity.id)
                            self.navigationController?.pushViewController(chatViewController, animated: true)
                        }
                    })
                }
                
                
                
            } else {
                self.showAlert(title: "Error!", message: "Some error occured, please try again.", actionText: "OK")
            }
        }
    }
}
//MARK: show codeImage
extension OrderDetailController {
    
    @objc func showNoticeView2() {
        let width : CGFloat = kScreenWidth - 24 * 2
        let imageWidth = width - 28 * 2
        if self.vm.codeImageSize.width <= 0 {
            return
        }
        let imageHeight = imageWidth * (self.vm.codeImageSize.height / self.vm.codeImageSize.width)
   
        let height : CGFloat = imageHeight + 24 + 90
        
        self.noticeView = JXSelectView(frame: CGRect(x: 0, y: 0, width: width, height: height), style: .custom)
        self.noticeView?.position = .middle
        //self.noticeView?.presentModelStyle = .none
        self.noticeView?.isBackViewUserInteractionEnabled = false
        self.noticeView?.customView = {
            
            let contentView = UIView()
            contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: height)
            
            
            
            let backgroundView = UIView()
            backgroundView.frame = CGRect(x: 24, y: 0, width: width, height: height)
            contentView.addSubview(backgroundView)
            
            if app_style <= 1 {
                let gradientLayer = CAGradientLayer.init()
                gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
                gradientLayer.locations = [0]
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0, y: 1)
                gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height - 30)
                gradientLayer.cornerRadius = 5
                backgroundView.layer.insertSublayer(gradientLayer, at: 0)
            } else {
                let gradientLayer = CALayer()
                gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height - 30)
                gradientLayer.cornerRadius = 5
                gradientLayer.backgroundColor = JXFfffffColor.cgColor
                backgroundView.layer.insertSublayer(gradientLayer, at: 0)
            }
            
            
            let imageView = UIImageView(frame: CGRect(x: 28, y: 24, width: imageWidth, height: imageHeight))
            if let str = self.vm.orderDetailEntity.qrcodeImg {
                imageView.sd_setImage(with: URL(string: str), completed: nil)
            }
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPress)))
            backgroundView.addSubview(imageView)
            
            let button = UIButton()
            button.frame = CGRect(x: 0, y: imageView.jxBottom + 30, width: 60, height: 60)
            button.backgroundColor = app_style <= 1 ? UIColor.rgbColor(rgbValue: 0x22222c) : JXFfffffColor
            //button.setTitle("×", for: .normal)
            button.tintColor = JXMainTextColor
            button.setImage(UIImage(named: "Close")?.withRenderingMode(.alwaysTemplate), for: .normal)
            //button.setBackgroundImage(UIImage(named: "close-big"), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button.setTitleColor(JX333333Color, for: .normal)
            button.contentVerticalAlignment = .center
            button.contentHorizontalAlignment = .center
            button.addTarget(self, action: #selector(hideNoticeView), for: .touchUpInside)
            backgroundView.addSubview(button)
            button.center.x = imageView.center.x
            button.layer.cornerRadius = 30
            button.layer.borderColor = app_style <= 1 ? UIColor.rgbColor(rgbValue: 0x0A0A0E).cgColor : JXSeparatorColor.cgColor
            button.layer.borderWidth = 2.5
            
            
            return contentView
        }()
        self.noticeView?.show()
    }
    
    @objc func longPress(long: UILongPressGestureRecognizer) {
   
        if let v = long.view as? UIImageView, let image = v.image {
            self.hideNoticeView()
            
            let alert = UIAlertController(title: nil, message: "保存到相册", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "是", style: .default, handler: { (action) in
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.imageSavedToPhotosAlbum(image:didFinishSavingWithError:contextInfo:)), nil)
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    @objc func imageSavedToPhotosAlbum(image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer?) {
        
//didFinishSavingWithError error:Error?,contextInfo:AnyObject?
        if let error = error {
            ViewManager.showNotice(error.localizedDescription)
        } else {
            ViewManager.showImageNotice("添加成功")
        }
    }
}
//MARK: confirm order notice
extension OrderDetailController {
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
            backgroundView.backgroundColor = JXFfffffColor
            backgroundView.layer.cornerRadius = 5
            contentView.addSubview(backgroundView)
            
            if app_style <= 1 {
                let gradientLayer = CAGradientLayer.init()
                gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
                gradientLayer.locations = [0]
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0, y: 1)
                gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
                gradientLayer.cornerRadius = 5
                backgroundView.layer.insertSublayer(gradientLayer, at: 0)
            }
            
            
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: width, height: 100)
            //label.center = view.center
            label.text = "注意"
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = JXMainTextColor
            backgroundView.addSubview(label)
            
            
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: 24, y: label.jxBottom + 20, width: width - 24 * 2, height: 45)
            nameLabel.text = "请确认您已向卖家付款\n「恶意点击将直接冻结账户」"
            nameLabel.textColor = JXMainTextColor
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
            button1.setTitleColor(JXMainColor, for: .normal)
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
            button.backgroundColor = JXMainColor
            
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
            } else {
                ViewManager.showNotice(msg)
            }
        })
    }
}
//MARK: cancel order notice
extension OrderDetailController {
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
            backgroundView.backgroundColor = JXFfffffColor
            backgroundView.layer.cornerRadius = 5
            contentView.addSubview(backgroundView)
            
            if app_style <= 1 {
                let gradientLayer = CAGradientLayer.init()
                gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
                gradientLayer.locations = [0]
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0, y: 1)
                gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
                gradientLayer.cornerRadius = 5
                backgroundView.layer.insertSublayer(gradientLayer, at: 0)
            }
            
            
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: width, height: 100)
            //label.center = view.center
            label.text = "注意"
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = JXMainTextColor
            backgroundView.addSubview(label)
            
            
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: 24, y: label.jxBottom + 20, width: width - 24 * 2, height: 45)
            nameLabel.text = "如果您已向卖家付款\n请千万不要取消交易"
            nameLabel.textColor = JXMainTextColor
            nameLabel.font = UIFont.systemFont(ofSize: 16)
            nameLabel.textAlignment = .center
            nameLabel.numberOfLines = 0
            
            backgroundView.addSubview(nameLabel)
            nameLabel.center.y = backgroundView.center.y - 20
            
            
            let infoLabel = UILabel()
            infoLabel.frame = CGRect(x: 24, y: nameLabel.jxBottom, width: width - 24 * 2, height: 40)
            infoLabel.text = "取消规则：买家当日只能取消3次交易"
            infoLabel.textColor = JXRedColor
            infoLabel.font = UIFont.systemFont(ofSize: 12)
            infoLabel.textAlignment = .center
            infoLabel.numberOfLines = 0
            backgroundView.addSubview(infoLabel)
        
            
            let margin : CGFloat = 16
            let space : CGFloat = 24
            let buttonWidth : CGFloat = (width - 24 - 16 * 2) / 2
            let buttonHeight : CGFloat = 44
            
            let button1 = UIButton()
            button1.frame = CGRect(x: margin, y: height - space - buttonHeight, width: buttonWidth, height: buttonHeight)
            button1.setTitle("点错了", for: .normal)
            button1.setTitleColor(JXMainColor, for: .normal)
            button1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button1.addTarget(self, action: #selector(hideNoticeView), for: .touchUpInside)
            backgroundView.addSubview(button1)
            
            
            let button = UIButton()
            button.frame = CGRect(x: button1.jxRight + space, y: button1.jxTop, width: buttonWidth, height: buttonHeight)
            button.setTitle("取消交易", for: .normal)
            button.setTitleColor(JXFfffffColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.addTarget(self, action: #selector(cancelTrade), for: .touchUpInside)
            backgroundView.addSubview(button)
            
            
            button.layer.cornerRadius = 2
            button.layer.shadowOpacity = 1
            button.layer.shadowRadius = 10
            button.layer.shadowOffset = CGSize(width: 0, height: 10)
            button.layer.shadowColor = JX10101aShadowColor.cgColor
            button.setTitleColor(JXFfffffColor, for: .normal)
            button.backgroundColor = JXMainColor
            
            return contentView
        }()
        
        self.noticeView?.show()
    }
    @objc func cancelTrade() {
        self.hideNoticeView()
        
        self.showMBProgressHUD()
        self.vm.buyCancel(id: self.vm.orderDetailEntity.id, completion: { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            if isSuc {
                self.requestData()
            } else {
                ViewManager.showNotice(msg)
            }
        })
    }
    //暂时不用
    func showNoticeView3() {
        let width : CGFloat = kScreenWidth - 40 * 2
        let height : CGFloat = 300
        
        self.noticeView = JXSelectView(frame: CGRect(x: 0, y: 0, width: width, height: height), style: .custom)
        self.noticeView?.position = .middle
        self.noticeView?.customView = {
            
            let contentView = UIView()
            contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: height)
            
            let backgroundView = UIView()
            backgroundView.frame = CGRect(x: 40, y: 0, width: width, height: height)
            backgroundView.backgroundColor = JXFfffffColor
            backgroundView.layer.cornerRadius = 5
            contentView.addSubview(backgroundView)
            
            if app_style <= 1 {
                let gradientLayer = CAGradientLayer.init()
                gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
                gradientLayer.locations = [0]
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0, y: 1)
                gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
                gradientLayer.cornerRadius = 5
                backgroundView.layer.insertSublayer(gradientLayer, at: 0)
            }
            
            
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: width, height: 100)
            //label.center = view.center
            label.text = "注意"
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = JXMainTextColor
            backgroundView.addSubview(label)
            
            
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: 24, y: label.jxBottom + 20, width: width - 24 * 2, height: 45)
            nameLabel.text = "购买的资产已到账\n您可以到首页查询"
            nameLabel.textColor = JXMainTextColor
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
            button.addTarget(self, action: #selector(confirm), for: .touchUpInside)
            backgroundView.addSubview(button)
            
            
            button.layer.cornerRadius = 2
            button.layer.shadowOpacity = 1
            button.layer.shadowRadius = 10
            button.layer.shadowOffset = CGSize(width: 0, height: 10)
            button.layer.shadowColor = JX10101aShadowColor.cgColor
            button.setTitleColor(JXFfffffColor, for: .normal)
            button.backgroundColor = JXMainColor
            
            return contentView
        }()
        
        self.noticeView?.show()
    }
}
