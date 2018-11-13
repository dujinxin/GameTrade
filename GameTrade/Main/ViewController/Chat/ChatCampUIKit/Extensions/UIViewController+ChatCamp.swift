//
//  UIViewController+ChatCamp.swift
//  ChatCamp Demo
//
//  Created by Tanmay Khandelwal on 13/02/18.
//  Copyright © 2018 iFlyLabs Inc. All rights reserved.
//

import UIKit
import ChatCamp

extension UIViewController {
//    static func loginViewController() -> LoginViewController {
//        return UIStoryboard.login().instantiateViewController(withIdentifier: LoginViewController.string()) as! LoginViewController
//    }
    
    public static func homeTabBarNavigationController() -> UINavigationController {
        return UIStoryboard.home().instantiateViewController(withIdentifier: UINavigationController.string()) as! UINavigationController
    }
    
    static func chatViewController(channel: CCPGroupChannel, sender: Sender) -> ChatViewController {
        return ChatViewController(channel:channel, sender: sender)
    }
    
    static func createChannelViewController() -> UINavigationController {
        return UIStoryboard.createChannel().instantiateViewController(withIdentifier: UINavigationController.string()) as! UINavigationController
    }
    
    static func profileViewController() -> ProfileViewController {
        return UIStoryboard.channel().instantiateViewController(withIdentifier: ProfileViewController.string()) as! ProfileViewController
    }
    
    static func channelProfileViewController() -> ChannelProfileViewController {
        return UIStoryboard.channel().instantiateViewController(withIdentifier: ChannelProfileViewController.string()) as! ChannelProfileViewController
    }
    
//    static func cameraViewController() -> CameraViewController {
//        return UIStoryboard.channel().instantiateViewController(withIdentifier: CameraViewController.string()) as! CameraViewController
//    }
    
    static func imagePreviewViewController() -> ImagePreviewViewController {
        return UIStoryboard.channel().instantiateViewController(withIdentifier: ImagePreviewViewController.string()) as! ImagePreviewViewController
    }
    
    public static func blockedUsersViewController() -> BlockedUsersViewController {
        return UIStoryboard.channel().instantiateViewController(withIdentifier: BlockedUsersViewController.string()) as! BlockedUsersViewController
    }
}

// MARK:- Alerts
extension UIViewController {
    public func showAlert(title: String, message: String, actionText: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionText, style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
}
