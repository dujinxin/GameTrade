//
//  CardPayController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/19.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class CardPayController: BaseViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var cardTextField: UITextField!
    @IBOutlet weak var dropButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var isEdit : Bool = false
    var bankName : String?
    var entity : PayEntity?
    var vm = PayVM()
    
    var selectBlock : ((_ entity: BankEntity)->())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置银行卡"
        
        self.bankNameLabel.font = UIFont.systemFont(ofSize: 14)
        
        self.nameTextField.attributedPlaceholder = NSAttributedString(string: "请输入真实姓名", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:JXPlaceHolerColor])
        self.cardTextField.attributedPlaceholder = NSAttributedString(string: "请输入银行卡号", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:JXPlaceHolerColor])

        if isEdit {
            self.bankNameLabel.textColor = JXTextColor
            self.bankNameLabel.text = self.entity?.bank
            self.bankName = self.entity?.bank
            
            self.nameTextField.text = self.entity?.name
            self.cardTextField.text = self.entity?.account
        
        } else {
            self.bankNameLabel.textColor = JXPlaceHolerColor
            self.bankNameLabel.text = "开户银行"
            
        }
        
        self.updateButtonStatus()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kNavStatusHeight + 20
        self.bottomConstraint.constant = kBottomMaginHeight + 20
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UITextFieldTextDidChange, object: nil)
    }
    @IBAction func submit() {
        print("45689")
        
        guard let bankName = self.bankNameLabel.text else { return }
        guard let userName = self.nameTextField.text else { return }
        guard let number = self.cardTextField.text else { return }
        
        var id = ""
        if isEdit {
            id = entity?.id ?? ""
        }
        
        self.showMBProgressHUD()
        self.vm.editPay(id: id, type: 3, bank: bankName, account: number, name: userName) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            ViewManager.showNotice(msg)
            if isSuc {
                if let block = self.backBlock {
                    block()
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBAction func selectBank(_ sender: UIButton) {
        let vc = BankListController()
        //vc.hidesBottomBarWhenPushed =
        vc.selectBlock = { (_ entity: BankEntity)->() in
            self.bankName = entity.name
            self.bankNameLabel.text = entity.name
            self.bankNameLabel.textColor = JXTextColor
            
            self.updateButtonStatus()
        }
        self.present(vc, animated: true, completion: nil)
    }
}
extension CardPayController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    @objc func textChange(notify:NSNotification) {
        
        if notify.object is UITextField {
            self.updateButtonStatus()
        }
    }
    func updateButtonStatus() {
        if
            let name = self.nameTextField.text, name.isEmpty == false,
            let card = self.cardTextField.text, card.isEmpty == false,
            let bank = self.bankName, bank.isEmpty == false{
           
            self.submitButton.isEnabled = true
            self.submitButton.backgroundColor = JXOrangeColor
            self.submitButton.setTitleColor(JXTextColor, for: .normal)
        } else {
            
            self.submitButton.isEnabled = false
            self.submitButton.backgroundColor = UIColor.rgbColor(rgbValue: 0x9b9b9b)
            self.submitButton.setTitleColor(UIColor.rgbColor(rgbValue: 0xb5b5b5), for: .normal)
        }
    }
}
