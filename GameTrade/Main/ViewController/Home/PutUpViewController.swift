//
//  PutUpViewController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/16.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class PutUpViewController: BaseViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topConstrants: NSLayoutConstraint!
    
    @IBOutlet weak var useLeftLabel: UILabel!
    @IBOutlet weak var sellLeftLabel: UILabel!
    @IBOutlet weak var priseLeftLabel: UILabel!
    @IBOutlet weak var totalLeftLabel: UILabel!
    @IBOutlet weak var serviceLeftLabel: UILabel!
    @IBOutlet weak var payTotalLeftLabel: UILabel!
    @IBOutlet weak var payNameLeftLabel: UILabel!
    
    @IBOutlet weak var useLabel: UILabel!
    @IBOutlet weak var sellTextField: UITextField!
    @IBOutlet weak var priseLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var payTotalLabel: UILabel!
    @IBOutlet weak var payNameLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    

    var defaultArray: Array = [["title":"可用币数量"],["title":"卖出币数量"],["title":"卖出单价"],["title":"卖出总价"],["title":"手续费"],["title":"实际总价"],["title":"支付方式"]]
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 30, y: 0, width: 200, height: 44)
        button.layer.cornerRadius = 4
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("添加", for: .normal)
        button.setTitleColor(JXFfffffColor, for: .normal)
        button.addTarget(self, action: #selector(addOrder), for: .touchUpInside)
        button.backgroundColor = JXOrangeColor
        return button
    }()
    
    var vm = SellVM()
    
    var useNum = "\(UserManager.manager.userEntity.property.balance)"
    
    var number = 0
    var sellTotal = "0 \(configuration_valueType)"
    var sellRealTotal = "0 \(configuration_valueType)"
    var serviceTotal = "0 \(configuration_valueType)"
    
    var payName = "支付宝"
    var payType = 1
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "添加挂单"
        
        self.customNavigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Close"), style: .plain, target: self, action: #selector(close))
        
        self.useLeftLabel.textColor = JXText50Color
        self.sellLeftLabel.textColor = JXText50Color
        self.priseLeftLabel.textColor = JXText50Color
        self.totalLeftLabel.textColor = JXText50Color
        self.payTotalLeftLabel.textColor = JXText50Color
        self.serviceLeftLabel.textColor = JXText50Color
        self.payNameLeftLabel.textColor = JXText50Color
        
        
        self.useLabel.text = self.useNum
        self.sellTextField.text = ""
        self.priseLabel.text = "\(configuration_coinPrice) \(configuration_valueType)"
        self.totalLabel.text = self.sellTotal
        self.serviceLabel.text = self.serviceTotal
        self.payTotalLabel.text = self.sellRealTotal
        self.payNameLabel.text = self.payName
        self.sellTextField.attributedPlaceholder = NSAttributedString(string: "请输入卖出数量", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:JXPlaceHolerColor])
            
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
        self.submitButton.layer.cornerRadius = 2
        self.submitButton.layer.shadowOpacity = 1
        self.submitButton.layer.shadowRadius = 10
        self.submitButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.submitButton.layer.shadowColor = JX10101aShadowColor.cgColor
        
        self.submitButton.addTarget(self, action: #selector(addOrder), for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging {
            self.view.endEditing(true)
        }
    }
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func addOrder() {
        print("T##items: Any...##Any")
        
        guard let num = self.sellTextField.text, num.isEmpty == false else {
            ViewManager.showNotice("请输入要挂出币数量")
            return
        }
        
        self.vm.sellCreate(payType: self.payType, amount: self.number, safePassword: "1111") { (_, msg, isSuc) in
            if isSuc {
                if let block = self.backBlock {
                    block()
                }
                //self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            } else {
                ViewManager.showNotice(msg)
            }
        }
    }
}

extension PutUpViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    @objc func textChange(notify: NSNotification) {
        
        if
            notify.object is UITextField,
            let textField = notify.object as? UITextField,
            let num = textField.text,
            let numDouble = Double(num) {
            
            self.useNum = "\(UserManager.manager.userEntity.property.balance - numDouble)"
            
            self.number = Int(num) ?? 0
            
            self.sellTotal = "\(configuration_coinPrice * numDouble) \(configuration_valueType)"
            self.serviceTotal = String(format:"%.2f",numDouble * configuration_service) + " \(configuration_valueType)"
            self.sellRealTotal = String(format:"%.2f",numDouble * configuration_realPrice) + " \(configuration_valueType)"
            //self.serviceTotal = "\(numDouble * configuration_service) \(configuration_valueType)"
            //self.sellRealTotal = "\(numDouble * configuration_realPrice) \(configuration_valueType)"
            
            //123.32
        } else {
            self.useNum = "\(UserManager.manager.userEntity.property.balance)"
            self.sellTotal = "\(0) \(configuration_valueType)"
            self.sellRealTotal = "\(0) \(configuration_valueType)"
            self.serviceTotal = "\(0) \(configuration_valueType)"
            
        }
        self.useLabel.text = self.useNum
        self.totalLabel.text = self.sellTotal
        self.serviceLabel.text = self.serviceTotal
        self.payTotalLabel.text = self.sellRealTotal
        //self.tableView?.reloadData()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //删除键
        if string == "" {
            return true
        }
        if
            let num = textField.text,
            let numDouble = Double(num + string), numDouble >= UserManager.manager.userEntity.property.balance{
            
            return false
            
        } else {
            return true
        }
    }
   
}
