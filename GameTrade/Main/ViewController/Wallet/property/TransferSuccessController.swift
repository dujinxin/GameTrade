//
//  TransferSuccessController.swift
//  Star
//
//  Created by 杜进新 on 2018/8/5.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class TransferSuccessController: BaseViewController {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var addressContentView: UIView!
    @IBOutlet weak var addressName: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var successLabel: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var address : String?
    var number : String?
    var name : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.numberLabel.textColor = JXTextColor
        self.successLabel.textColor = JXTextColor
        self.addressName.textColor = JXText50Color
        self.addressLabel.textColor = JXTextColor
        self.addressLabel.backgroundColor = UIColor.clear
        
        
        self.addressLabel.text = self.address
        self.numberLabel.text = "\((self.number ?? "0")) \(configuration_coinName)"
        self.successLabel.text = "发币成功"
        
        self.customNavigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: UIView())
        
        addressContentView.backgroundColor = JXSeparatorColor
//        addressContentView.layer.shadowColor =  UIColor.rgbColor(rgbValue: 0xe2e2e2).cgColor
//        addressContentView.layer.shadowOpacity = 0.5
//        addressContentView.layer.shadowRadius = 3
//        addressContentView.layer.shadowOffset = CGSize.init(width: 3, height: 3)

        
        confirmButton.setTitleColor(JXFfffffColor, for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        confirmButton.layer.cornerRadius = 2
        confirmButton.layer.shadowOpacity = 1
        confirmButton.layer.shadowRadius = 10
        confirmButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        confirmButton.layer.shadowColor = JX10101aShadowColor.cgColor
        confirmButton.setTitleColor(JXFfffffColor, for: .normal)
        confirmButton.backgroundColor = JXOrangeColor
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kNavStatusHeight + 55
        self.bottomConstraint.constant = kBottomMaginHeight + 20
        
    }
    @IBAction func complete(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
//        if
//            let controllers = self.navigationController?.viewControllers,
//            controllers.count > 2, let vc = self.navigationController?.viewControllers[1] as? WalletViewController{
//            print(controllers)
//            vc.requestData()
//            self.navigationController?.popToViewController(vc, animated: true)
//        } else {
//            self.navigationController?.popToRootViewController(animated: true)
//        }
        
    }
    
}
