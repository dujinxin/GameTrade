//
//  CreateSuccessController.swift
//  Star
//
//  Created by 杜进新 on 2018/7/31.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class CreateSuccessController: BaseViewController {
    @IBOutlet weak var defaultBackView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "创建成功"
        
        if let controllers = self.navigationController?.viewControllers {
            print(controllers)
            let count = controllers.count
            if count > 2 {
               
               self.navigationController?.viewControllers.remove(at: count - 2)
            }
        }
        
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 100, height: self.copyButton.jxHeight)
        gradientLayer.cornerRadius = 22
        self.copyButton.layer.insertSublayer(gradientLayer, at: 0)
        self.copyButton.backgroundColor = UIColor.clear
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kNavStatusHeight + 41
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    @IBAction func copyPrivacyStr(_ sender: Any) {
    }
    @IBAction func checkWallet(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
