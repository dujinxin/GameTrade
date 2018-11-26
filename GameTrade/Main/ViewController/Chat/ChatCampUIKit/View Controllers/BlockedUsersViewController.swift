//
//  BlockedUsersViewController.swift
//  ChatCampUIKit
//
//  Created by Saurabh Gupta on 04/09/18.
//  Copyright © 2018 chatcamp. All rights reserved.
//

import UIKit
import ChatCamp
import SDWebImage
import MBProgressHUD

open class BlockedUsersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 44
            tableView?.register(UINib(nibName: String(describing: ChatTableViewCell.self), bundle: Bundle(for: ChatTableViewCell.self)), forCellReuseIdentifier: ChatTableViewCell.identifier)        }
    }
    
    var users: [CCPUser] = []
    fileprivate var usersToFetch: Int = 20
    fileprivate var loadingUsers = false
    var usersQuery: CCPUserListQuery!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Blocked Users"
        usersQuery = CCPClient.createBlockedUserListQuery()
        loadUsers(limit: usersToFetch)
    }
    
    fileprivate func loadUsers(limit: Int) {
        let progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHud.label.text = "Loading..."
        progressHud.contentColor = .black
        loadingUsers = true
        usersQuery.load(limit: limit) { [unowned self] (users, error) in
            progressHud.hide(animated: true)
            if error == nil {
                guard let users = users else { return }
                self.users.append(contentsOf: users.filter({ $0.getId() != CCPClient.getCurrentUser().getId() }))
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.loadingUsers = false
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Can't Load Users", message: "Unable to load Users right now. Please try later.", actionText: "Ok")
                    self.loadingUsers = false
                }
            }
        }
    }
}

// MARK:- UITableViewDataSource
extension BlockedUsersViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.string(), for: indexPath) as! ChatTableViewCell
        cell.nameLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        
        let user = users[indexPath.row]
        cell.nameLabel.text = user.getDisplayName()
        cell.messageLabel.text = ""
        cell.accessoryLabel.text = "Unblock"
        cell.unreadCountLabel.isHidden = true
        if let avatarUrl = user.getAvatarUrl() {
            cell.avatarImageView?.sd_setImage(with: URL(string: avatarUrl), completed: nil)
        } else {
            cell.avatarImageView.setImageForName(string: user.getDisplayName() ?? "?", circular: true, textAttributes: nil)
        }
        
        return cell
    }
}

// MARK:- UITableViewDelegate
extension BlockedUsersViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        CCPClient.unblockUser(userId: user.getId()) { (participant, error) in
            progressHud.hide(animated: true)
            if error == nil {
                self.users.remove(at: indexPath.row)
                tableView.reloadData()
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK:- ScrollView Delegate Methods
extension BlockedUsersViewController {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (tableView.indexPathsForVisibleRows?.contains([0, users.count - 1]) ?? false) && !loadingUsers && users.count >= (usersToFetch - 1) {
            loadUsers(limit: usersToFetch)
        }
    }
}

