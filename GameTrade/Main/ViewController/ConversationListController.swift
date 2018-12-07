//
//  ConversationListController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/12.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

import ChatCamp
import SDWebImage

//import ChatCampUIKit

class ConversationListController: JXTableViewController {
    
    fileprivate var loadingChannels = false
    open var channels: [CCPGroupChannel] = []
    fileprivate var db: SQLiteDatabase!
    var groupChannelsQuery: CCPGroupChannelListQuery!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "聊聊"
        
        self.tableView?.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kTabBarHeight - kNavStatusHeight)
        self.tableView?.estimatedRowHeight = 92
        self.tableView?.register(UINib(nibName: String(describing: ChatTableViewCell.self), bundle: Bundle(for: ChatTableViewCell.self)), forCellReuseIdentifier: ChatTableViewCell.string())
        
        do {
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("ChatDatabase.sqlite")
            db = try! SQLiteDatabase.open(path: fileURL.path)
            print("Successfully opened connection to database.")
            do {
                try db.createTable(table: Channel.self)
            } catch {
                print(db.errorMessage)
            }
        } catch SQLiteError.OpenDatabase(let message) {
            print("Unable to open database. Verify that you created the directory described in the Getting Started section.")
        }
        
        groupChannelsQuery = CCPGroupChannel.createGroupChannelListQuery()
        loadChannelsFromLocalStorage()

    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.navigationBar.isHidden = true
        
        CCPClient.addChannelDelegate(channelDelegate: self, identifier: GroupChannelsViewController.string())
        CCPClient.addConnectionDelegate(connectionDelegate: self, identifier: GroupChannelsViewController.string())
        refreshChannels()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //self.navigationController?.navigationBar.isHidden = false
        
        CCPClient.removeChannelDelegate(identifier: GroupChannelsViewController.string())
        CCPClient.removeConnectionDelegate(identifier: GroupChannelsViewController.string())
    }
    
    fileprivate func loadChannelsFromLocalStorage() {
        if let loadedChannels = self.db.getGroupChannels() {
            if loadedChannels.count > 0 {
                self.channels = loadedChannels
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
            }
        }
    }
    
    func refreshChannels() {
        
        guard let tabVC = UIApplication.shared.keyWindow?.rootViewController as? TabBarViewController else { return }
        tabVC.isUnreadMessagePoint(hidden: true)
        
        
        loadingChannels = true
        let groupChannelsListQuery = CCPGroupChannel.createGroupChannelListQuery()
        groupChannelsListQuery.load { (channels, error) in
            if error == nil {
                guard let channels = channels else { return }
                self.channels = channels
                
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                    self.loadingChannels = false
                }
                
                do {
                    try self.db.insertGroupChannels(channels: channels)
                } catch {
                    print(self.db.errorMessage)
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Can't Load Group Channels", message: "Unable to load Group Channels right now. Please try later.", actionText: "Ok")
                    self.loadingChannels = false
                }
            }
        }
        
        //获取未读消息
    
//        CCPClient.getTotalUnreadMessageCount { (num, param, error) in
//            if let e = error {
//                print(e.localizedDescription)
//            } else {
//                print(num,param)
//                guard let tabVC = UIApplication.shared.keyWindow?.rootViewController as? TabBarViewController else { return }
//                if let n = num, n > 0 {
//                    tabVC.isUnreadMessagePoint(hidden: false)
//                } else {
//                    tabVC.isUnreadMessagePoint(hidden: true)
//                }
//            }
//        }
    }
}

// MARK:- UITableViewDataSource
extension ConversationListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.string(), for: indexPath) as! ChatTableViewCell
//        cell.backgroundColor = UIColor.clear
//        cell.contentView.backgroundColor = UIColor.clear
//        cell.nameLabel.textColor = JXMainTextColor
//        cell.messageLabel.textColor = JXMainText50Color
        cell.unreadCountLabel.backgroundColor = JXMainColor
        
        let channel = channels[indexPath.row]
        
        if channel.getParticipantsCount() == 2 && channel.isDistinct() {
            let participants = channel.getParticipants()
            for participant in participants {
                
                if participant.getId() != CCPClient.getCurrentUser().getId() {
                    cell.nameLabel.text = participant.getDisplayName()
                    if let avatarUrl = participant.getAvatarUrl() {
                        cell.avatarImageView?.sd_setImage(with: URL(string: avatarUrl), completed: nil)
                    } else {
                        cell.avatarImageView.setImageForName(string: participant.getDisplayName() ?? "?", backgroundColor: nil, circular: true, textAttributes: nil)
                    }
                } else {
                    continue
                }
            }
        } else {
            cell.nameLabel.text = channel.getName()
            if let avatarUrl = channel.getAvatarUrl() {
                cell.avatarImageView?.sd_setImage(with: URL(string: avatarUrl), completed: nil)
            } else {
                cell.avatarImageView.setImageForName(string: channel.getName(), circular: true, textAttributes: nil)
            }
        }
        let unreadMessageCount = channel.getUnreadMessageCount()
        if unreadMessageCount > 0 {
            cell.unreadCountLabel.isHidden = false
            if unreadMessageCount < 10 {
                cell.unreadCountLabel.text = String(unreadMessageCount)
            } else {
                cell.unreadCountLabel.text = "9+"
            }
            //未读消息
            let tabVC = UIApplication.shared.keyWindow?.rootViewController as? TabBarViewController
            tabVC?.isUnreadMessagePoint(hidden: false)
        } else {
            cell.unreadCountLabel.isHidden = true
        }
        if let message = channel.getLastMessage(), let displayName = channel.getLastMessage()?.getUser().getDisplayName() {
            if message.getType() == "text" {
                cell.messageLabel.text =  displayName + ": " + message.getText()
            } else {
                cell.messageLabel.text =  displayName + ": " + message.getType()
            }
        }
        if let lastMessage = channel.getLastMessage() {
            let lastMessageTimeInterval = lastMessage.getInsertedAt()
            cell.lastMessageLabel.text = LastMessage.getDisplayableMessage(timeInterval: Double(lastMessageTimeInterval))
        }
        
        return cell
    }
}

// MARK:- UITableViewDelegate
extension ConversationListController {
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userID = CCPClient.getCurrentUser().getId()
        let username = CCPClient.getCurrentUser().getDisplayName()
        
        let sender = Sender(id: userID, displayName: username!)
        
        let chatViewController = ChatViewController(channel: channels[indexPath.row], sender: sender)
        chatViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK:- CCPChannelDelegate
extension ConversationListController: CCPChannelDelegate {
    public func channelDidReceiveMessage(channel: CCPBaseChannel, message: CCPMessage) {
        if let index = channels.index(where: { (groupChannel) -> Bool in
            groupChannel.getId() == channel.getId()
        }) {
            channels.remove(at: index)
            channels.insert(channel as! CCPGroupChannel, at: 0)
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    public func channelDidChangeTypingStatus(channel: CCPBaseChannel) {
        // Not applicable
    }
    
    public func channelDidUpdateReadStatus(channel: CCPBaseChannel) {
        // Not applicable
    }
    
    public func channelDidUpdated(channel: CCPBaseChannel) { }
    
    public func onTotalGroupChannelCount(count: Int, totalCountFilterParams: TotalCountFilterParams) { }
    
    public func onGroupChannelParticipantJoined(groupChannel: CCPGroupChannel, participant: CCPUser) { }
    
    public func onGroupChannelParticipantLeft(groupChannel: CCPGroupChannel, participant: CCPUser) { }
}

// MARK:- CCPConnectionDelegate
extension ConversationListController: CCPConnectionDelegate {
    public func connectionDidChange(isConnected: Bool) {
        if isConnected {
            refreshChannels()
        }
    }
}

// MARK:- ScrollView Delegate Methods
extension ConversationListController {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (self.tableView?.indexPathsForVisibleRows?.contains([0, channels.count - 1]) ?? false) && !loadingChannels && channels.count >= 20 {
            loadingChannels = true
            groupChannelsQuery.load { (channels, error) in
                if error == nil {
                    guard let channels = channels else { return }
                    self.channels.append(contentsOf: channels)
                    
                    DispatchQueue.main.async {
                        self.tableView?.reloadData()
                        self.loadingChannels = false
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert(title: "Can't Load Group Channels", message: "Unable to load Group Channels right now. Please try later.", actionText: "Ok")
                        self.loadingChannels = false
                    }
                }
            }
        }
    }
}
