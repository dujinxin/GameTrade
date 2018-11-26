//
//  PropertyViewController.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/10.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class PropertyViewController: UIViewController {
    
    //MARK: - custom NavigationBar
    //自定义导航栏
    lazy var customNavigationBar : PropertyNavigationBar = {
        let navigationBar = PropertyNavigationBar(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kNavStatusHeight))
        navigationBar.barTintColor = UIColor.groupTableViewBackground
        navigationBar.tintColor = UIColor.black
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17)]
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

    var vm = MyVM()
    
    @IBOutlet weak var propertyLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var FetchButton: UIButton!
    
    @IBAction func recordAction(_ sender: Any) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.groupTableViewBackground
        self.navigationController?.navigationBar.barStyle = .default
        setCustomNavigationBar()
        self.title = "我的水晶IPE"
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 7, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "imgBack")?.withRenderingMode(.alwaysTemplate), for: .normal)
        leftButton.imageEdgeInsets = UIEdgeInsets.init(top: 12, left: 0, bottom: 12, right: 24)
        leftButton.tintColor = UIColor.black
        leftButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
        self.customNavigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftButton)
        
        
        self.FetchButton.backgroundColor = UIColor.rgbColor(from: 221, 221, 221)
        self.FetchButton.setTitleColor(UIColor.rgbColor(from: 174, 174, 174), for: .normal)
        self.FetchButton.isEnabled = false
        self.FetchButton.layer.cornerRadius = 22
        self.FetchButton.layer.masksToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setCustomNavigationBar() {
        //隐藏navigationBar
        self.navigationController?.navigationBar.isHidden = true
        //1.自定义view代替NavigationBar,需要自己实现手势返回;
        //2.自定义navigatioBar代替系统的，手势返回不用自己实现
        view.addSubview(self.customNavigationBar)
        customNavigationBar.items = [customNavigationItem]
    }
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }
}
class PropertyNavigationBar: UINavigationBar {

    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavStatusHeight)
        
        self.subviews.forEach { (v) in
            if NSStringFromClass(type(of: v)).contains("UIBarBackground") {
                v.frame = rect

                v.subviews.forEach({ (subV) in
                    if subV is UIImageView {
                        subV.backgroundColor = UIColor.groupTableViewBackground
                    }
                })
            } else if NSStringFromClass(type(of: v)).contains("UINavigationBarContentView") {
                rect.origin.y += kStatusBarHeight
                rect.size.height -= kStatusBarHeight
                v.frame = rect
            }
        }
    }
}
