//
//  JXNavigationController.swift
//  ShoppingGo-Swift
//
//  Created by 杜进新 on 2017/6/6.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit

class JXNavigationController: UINavigationController {
    
    lazy var backItem: UIBarButtonItem = {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 10, y: 7, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "icon-back"), for: .normal)
        //leftButton.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 24)
        //leftButton.setTitle("up", for: .normal)
        leftButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
        let item = UIBarButtonItem(customView: leftButton)
        return item
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar.isTranslucent = true
        self.navigationBar.barStyle = .blackTranslucent //状态栏 白色
        //self.navigationBar.barStyle = .default      //状态栏 黑色
        self.navigationBar.barTintColor = UIColor.white//导航条颜色
        self.navigationBar.tintColor = UIColor.darkText   //item图片文字颜色
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.darkText,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17)]//标题设置
        
        self.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension JXNavigationController {
    
    /// 重写push方法
    ///
    /// - Parameters:
    ///   - viewController: 将要push的viewController
    ///   - animated: 是否使用动画
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: true)
        
        guard viewControllers.count > 0 else { return }
        
        var titleName = ""//"返回"
        if viewControllers.count == 1 {
            titleName = viewControllers.first?.title ?? titleName
        }
        
        if let vc = viewController as? BaseViewController {
            vc.hidesBottomBarWhenPushed = true
            vc.customNavigationItem.leftBarButtonItem = self.backItem
            //vc.customNavigationItem.leftBarButtonItem = UIBarButtonItem.init(title: titleName, imageName: "imgBack", target: self, action: #selector(pop))
        } else if let vc = viewController as? JSTableViewController {
            vc.hidesBottomBarWhenPushed = true
            vc.customNavigationItem.leftBarButtonItem = self.backItem
        }
        
    }
    
    /// 自定义导航栏的返回按钮事件
    @objc func pop() {
        popViewController(animated: true)
    }
}
