//
//  ProfileViewController.swift
//  ChatCamp Demo
//
//  Created by Saurabh Gupta on 20/04/18.
//  Copyright © 2018 iFlyLabs Inc. All rights reserved.
//

import UIKit
import ChatCamp
import MBProgressHUD

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.layer.cornerRadius = profileImageView.bounds.width/2
            profileImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var blockUserButton: UIButton! {
        didSet {
            if participant?.isParticipantBlockedByMe() ?? false {
                blockUserButton.setTitle("Unblock User", for: .normal)
            } else {
                blockUserButton.setTitle("Block User", for: .normal)
            }
        }
    }
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var onlineStatusImageView: UIImageView!
    
    var participant: CCPParticipant?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Contact Info"
        if let avatarUrl = participant?.getAvatarUrl() {
            profileImageView.sd_setImage(with: URL(string: avatarUrl), completed: nil)
        } else {
            profileImageView.setImageForName(string: participant?.getDisplayName() ?? "?", circular: true, textAttributes: nil)
        }
        
        if participant?.getIsOnline() ?? false {
            onlineStatusImageView.image = UIImage(named: "online", in: Bundle(for: ProfileViewController.self), compatibleWith: nil)
        } else {
            onlineStatusImageView.image = UIImage(named: "offline", in: Bundle(for: ProfileViewController.self), compatibleWith: nil)
        }

        displayNameLabel.text = participant?.getDisplayName()
    }
    
    @IBAction func blockUserButtonTapped(_ sender: Any) {
        let progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        if participant?.isParticipantBlockedByMe() ?? false {
            CCPClient.unblockUser(userId: participant?.getId() ?? "") { (participant, error) in
                progressHud.hide(animated: true)
                if error == nil {
                    self.blockUserButton.setTitle("Block User", for: .normal)
                    self.participant = participant
                }
            }
        } else {
            CCPClient.blockUser(userId: participant?.getId() ?? "") { (participant, error) in
                progressHud.hide(animated: true)
                if error == nil {
                    self.blockUserButton.setTitle("Unblock User", for: .normal)
                    self.participant = participant
                }
            }
        }
    }
}
