//
//  BaseViewController.swift
//  ShoppingGo-Swift
//
//  Created by 杜进新 on 2017/6/6.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit
import MBProgressHUD

class BaseViewController: UIViewController {
    
    var backBlock : (()->())?
    
    var isUseGradientColor : Bool = true
    
    //MARK: - custom NavigationBar
    //自定义导航栏
    lazy var customNavigationBar : JXNavigationBar = {
        let navigationBar = JXNavigationBar(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kNavStatusHeight))
        navigationBar.barTintColor = UIColor.clear//导航条颜色,透明色不起作用
        navigationBar.isTranslucent = true
        navigationBar.barStyle = .blackTranslucent
        navigationBar.tintColor = UIColor.white //item图片文字颜色
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17)]//标题设置
        navigationBar.setBackgroundImage(navigationBar.imageWithColor(UIColor.clear), for: UIBarMetrics.default)
        return navigationBar
    }()
    lazy var customNavigationItem: UINavigationItem = {
        let item = UINavigationItem()
        return item
    }()
    
    //重写title的setter方法
    override var title: String?{
        didSet {
            customNavigationItem.title = title
        }
    }
    
    //MARK: - default view info
    
    /// default view
    lazy var defaultView: JXDefaultView = {
        let v = JXDefaultView()
        v.backgroundColor = UIColor.randomColor
        return v
    }()
    
    var defaultInfo : [String:String]?
    
    //log state
    var isLogin = false
    //var isCustomNavigationBarUsed = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = JXFfffffColor
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        self.setUpMainView()
        //isLogin ? setUpMainView() : setUpDefaultView()
        
        self.isCustomNavigationBarUsed() ? setCustomNavigationBar() : navigationBarConfig()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func isCustomNavigationBarUsed() -> Bool{
        return true
    }
    /// request data
    @objc func requestData() {}
    //MARK: - base view set
    func setUpMainView() {}
    /// add default view eg:no data,no network,no login
    func setUpDefaultView() {
        defaultView.frame = view.bounds
        view.addSubview(defaultView)
        defaultView.info = defaultInfo
        defaultView.tapBlock = {()->() in
            self.requestData()
        }
    }
}

extension BaseViewController {
    func setCustomNavigationBar() {
        //隐藏navigationBar
        self.navigationController?.navigationBar.isHidden = true
        //1.自定义view代替NavigationBar,需要自己实现手势返回;
        //2.自定义navigatioBar代替系统的，手势返回不用自己实现
        view.addSubview(self.customNavigationBar)
        customNavigationBar.items = [customNavigationItem]
    }
    func navigationBarConfig() {
        let image = UIImage(named: "icon-back")
        self.navigationController?.navigationBar.backIndicatorImage = image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftItemsSupplementBackButton = false;
        let backBarButtonItem = UIBarButtonItem.init(title:"", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        self.navigationController?.navigationBar.tintColor = JX333333Color //item图片文字颜色
//        self.navigationController?.navigationBar.barTintColor = UIColor.rgbColor(rgbValue: 0x046ac9)//导航条颜色
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 19)]//标题设置
    }
}

extension BaseViewController {
    
    
}

extension BaseViewController {
    func showMBProgressHUD() {
        let _ = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.backgroundView.color = UIColor.black
//        hud.contentColor = UIColor.black
//        hud.bezelView.backgroundColor = UIColor.black
//        hud.label.text = "加载中..."
        
    }
    func hideMBProgressHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}
