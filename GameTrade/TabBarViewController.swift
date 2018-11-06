//
//  TabBarViewController.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/8.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let button = UIButton(type: .custom)
        //let image = UIImage.image(originalImage: UIImage(named: "diamond_selected"), to: 80)
        let image = UIImage(named: "diamond_selected")
        button.setImage(image, for: .normal)
        
        //button.frame = tabBar.frame.insetBy(dx: 2 * (tabBar.bounds.width / (CGFloat(childViewControllers.count) - 1)), dy: 0)
        
        button.frame = CGRect(x: tabBar.bounds.width / CGFloat(childViewControllers.count), y: -37, width: tabBar.bounds.width / CGFloat(childViewControllers.count), height: 86)
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        //tabBar.addSubview(button)
        
        //UITabBar.appearance()
        tabBar.barTintColor = UIColor.rgbColor(rgbValue: 0x31313f)
        tabBar.tintColor = JXOrangeColor
        let normalAttributed = [NSAttributedStringKey.foregroundColor:UIColor.rgbColor(rgbValue: 0x8585ae)]
        let selectedAttributed = [NSAttributedStringKey.foregroundColor:JXOrangeColor]
        tabBar.items?.forEach({ (item) in
            item.setTitleTextAttributes(normalAttributed, for: .normal)
            item.setTitleTextAttributes(selectedAttributed, for: .selected)
        })
        
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        tabBar.layer.shadowColor = UIColor.rgbColor(rgbValue: 0x5c6677, alpha: 0.2).cgColor
        tabBar.layer.shadowOpacity = 1
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginStatus(notify:)), name: NSNotification.Name(rawValue: NotificationLoginStatus), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tabBarStatus(notify:)), name: NSNotification.Name(rawValue: NotificationTabBarHiddenStatus), object: nil)
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
    @objc func loginStatus(notify:Notification) {
        print(notify)
        
        if let isSuccess = notify.object as? Bool,
            isSuccess == true{
            
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
        }
    }
    @objc func tabBarStatus(notify:Notification) {
        print(notify)
        
        if let isSuccess = notify.object as? Bool,
            isSuccess == true{
            self.tabBar.isHidden = true
        }else{
            self.tabBar.isHidden = false
        }
    }

}
extension TabBarViewController {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
}
