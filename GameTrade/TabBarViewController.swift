//
//  TabBarViewController.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/8.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

import ChatCamp

class TabBarViewController: UITabBarController {

    lazy var pointView: UIView = {
        let point = UIView()
        point.backgroundColor = JXRedColor
        let x = tabBar.bounds.width / CGFloat(children.count) * 5 / 2 + 5
        point.frame = CGRect(x: x, y: 5, width: 10, height: 10)
        point.layer.cornerRadius = 5
        point.isHidden = true
        return point
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        //UITabBar.appearance()
        tabBar.barTintColor = UIColor.rgbColor(rgbValue: 0x31313f)
        tabBar.isTranslucent = false
        tabBar.tintColor = JXMainColor
        
        let normalImageList = ["tab1_normal","tab2_normal","tab3_normal","tab4_normal"]
        let selectedImageList = ["tab1_selected","tab2_selected","tab3_selected","tab4_selected"]
        
        let normalAttributed = [NSAttributedString.Key.foregroundColor:UIColor.rgbColor(rgbValue: 0x8585ae)]
        let selectedAttributed = [NSAttributedString.Key.foregroundColor:JXMainColor]
//        tabBar.items?.forEach({ (item) in
//            item.setTitleTextAttributes(normalAttributed, for: .normal)
//            item.setTitleTextAttributes(selectedAttributed, for: .selected)
//            item.image?.renderingMode = .alwaysOriginal
//        })
        if let items = tabBar.items {
            for i in 0..<items.count {
                let item = items[i]
                item.setTitleTextAttributes(normalAttributed, for: .normal)
                item.setTitleTextAttributes(selectedAttributed, for: .selected)
                item.image = UIImage(named: normalImageList[i])?.withRenderingMode(.alwaysOriginal)
                item.selectedImage = UIImage(named: selectedImageList[i])?.withRenderingMode(.alwaysOriginal)
            }
        }
        
        
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        tabBar.layer.shadowColor = UIColor.rgbColor(rgbValue: 0x5c6677, alpha: 0.2).cgColor
        tabBar.layer.shadowOpacity = 1
        tabBar.addObserver(self, forKeyPath: "frame", options: [.old, .new], context: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginStatus(notify:)), name: NSNotification.Name(rawValue: NotificationLoginStatus), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tabBarStatus(notify:)), name: NSNotification.Name(rawValue: NotificationTabBarHiddenStatus), object: nil)
        
        tabBar.addSubview(self.pointView)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let tabBar = object as? UITabBar, keyPath == "frame" {
            if let oldFrame = change?[.oldKey] as? CGRect, let newFrame = change?[.newKey] as? CGRect {
                if oldFrame.size != newFrame.size {
                    if oldFrame.height > newFrame.height {
                        tabBar.frame = oldFrame
                    } else {
                        tabBar.frame = newFrame
                    }
                }
            }
        }
    }
    func imageWithColor(_ color:UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        tabBar.removeObserver(self, forKeyPath: "frame")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationLocatedStatus), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationTabBarHiddenStatus), object: nil)
    }

    @objc func buttonClick() {

        //self.tabBarController?.selectedIndex = 1
        
        self.selectedIndex = 1
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let scan = storyboard.instantiateViewController(withIdentifier: "ScanVC") as! ScanViewController
//        let scanVC = UINavigationController.init(rootViewController: scan)
//
//        self.present(scanVC, animated: false, completion: nil)
    }
    
    @objc func tabBarStatus(notify: Notification) {
        print(notify)
        
        if let isSuccess = notify.object as? Bool,
            isSuccess == true{
            self.tabBar.isHidden = true
        }else{
            self.tabBar.isHidden = false
        }
    }
    func isUnreadMessagePoint(hidden: Bool) {
        print("-------------------\(hidden)--------------------")
        self.pointView.isHidden = hidden
    }

}

extension TabBarViewController {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
}
//MARK: loginStatus
extension TabBarViewController {
    @objc func loginStatus(notify:Notification) {
        print(notify)
        
        if let isSuccess = notify.object as? Bool,
            isSuccess == true{
            
            guard let userID = UserManager.manager.userEntity.id else { return }
            //登录聊天
            CCPClient.connect(uid: userID) { [unowned self] (user, error) in
                DispatchQueue.main.async {
                    //self.activityIndicator.stopAnimating()
                    
                    if error != nil {
                        let alertController = UIAlertController(title: "Error In Login", message: "An error occurred while logging you in.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                            alertController.dismiss(animated: true, completion: nil)
                        })
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                        return
                    } else {
                        UserDefaults.standard.setUserID(userID: userID)
                        if let deviceToken = UserDefaults.standard.deviceToken() {
                            CCPClient.updateUserPushToken(token: deviceToken) { (_,_) in
                                print("update device token on the server.")
                            }
                        }
                        CCPClient.updateDisplayNameOnServer(displayName: UserManager.manager.userEntity.nickname ?? "昵称") { (user, error) in
                            if error == nil {
                                UserDefaults.standard.setUsername(username: UserManager.manager.userEntity.nickname ?? "昵称")
                            }
                        }
                        CCPClient.updateAvatarUrlOnServer(avatarUrl: UserManager.manager.userEntity.headImg ?? "") { user, error in
                            if error == nil {
                                //Avatar Url has been updated.
                            }
                        }
                        //WindowManager.shared.showHomeWithAnimation()
                    }
                }
            }
            
        }else{
            UserManager.manager.removeAccound()
            
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let login = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            let loginVC = UINavigationController.init(rootViewController: login)
            if self.selectedViewController is UINavigationController {
                let selectVC = self.selectedViewController as! UINavigationController
                let topVC = selectVC.topViewController
                if let modelVC = topVC?.navigationController?.visibleViewController {
                    modelVC.dismiss(animated: false, completion: nil)
                }
                topVC?.navigationController?.popToRootViewController(animated: false)
                topVC!.navigationController?.present(loginVC, animated: true, completion: nil)
            }else{
                self.selectedViewController?.navigationController?.present(login, animated: true, completion: nil)
            }
            
            //self.navigationController?.pushViewController(vc, animated: true)
            
            //退出聊天
            if let token = UserDefaults.standard.deviceToken() {
                CCPClient.deleteUserPushToken(token, completionHandler: { (error) in
                    if error == nil {
                        UserDefaults.standard.setUserID(userID: nil)
                        UserDefaults.standard.setUsername(username: nil)
                        CCPClient.disconnect() { (error) in
                            //WindowManager.shared.showLoginWithAnimation()
                        }
                    } else {
                        //self.showAlert(title: "Error", message: "Error while deleting push token on server. Please try again.", actionText: "OK")
                    }
                })
            } else {
                CCPClient.disconnect() { (error) in
                    //WindowManager.shared.showLoginWithAnimation()
                }
            }
        }
    }
}
