//
//  NameSetController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/15.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class NameSetController: BaseViewController {
    
    var name : String = ""
    
    var vm = PayVM()
    var noticeView : JXSelectView?
    
    @IBOutlet weak var nameTextField: UITextField!{
        didSet{
            nameTextField.tintColor = JXMainColor
            nameTextField.textColor = JXMainTextColor
            nameTextField.attributedPlaceholder = NSAttributedString(string: "请输入真实姓名", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:JXPlaceHolerColor])
        }
    }
    @IBOutlet weak var userContentView: UIView!{
        didSet{
            userContentView.backgroundColor = JXTextViewBgColor
        }
    }
    @IBOutlet weak var infoLabel: UILabel!
  
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.infoLabel.textColor = JXRedColor
        self.submitButton.backgroundColor = JXUnableColor
        self.submitButton.setTitleColor(JXFfffffColor, for: .normal)
        
        self.title = "添加实名"
        
        self.updateButtonStatus()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kNavStatusHeight + 20
        self.bottomConstraint.constant = kBottomMaginHeight + 20
    }
   
    @IBAction func submit() {
        self.showNoticeView()
    }
}

extension NameSetController: UITextFieldDelegate {
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
            let name = self.nameTextField.text, name.isEmpty == false {
            self.submitButton.isEnabled = true
            self.submitButton.backgroundColor = JXAbleColor
            self.submitButton.setTitleColor(JXFfffffColor, for: .normal)
        } else {
            self.submitButton.isEnabled = false
            self.submitButton.backgroundColor = JXUnableColor
            self.submitButton.setTitleColor(UIColor.rgbColor(rgbValue: 0xb5b5b5), for: .normal)
        }
    }
}
//MARK: confirm name notice
extension NameSetController {
    func showNoticeView() {
        let width : CGFloat = kScreenWidth - 40 * 2
        let height : CGFloat = 300
        
        self.noticeView = JXSelectView(frame: CGRect(x: 0, y: 0, width: width, height: height), style: .custom)
        self.noticeView?.position = .middle
        self.noticeView?.customView = {
            
            let contentView = UIView()
            contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: height)
            
            let backgroundView = UIView()
            backgroundView.frame = CGRect(x: 40, y: 0, width: width, height: height)
            backgroundView.backgroundColor = JXFfffffColor
            backgroundView.layer.cornerRadius = 5
            contentView.addSubview(backgroundView)
            
            if app_style <= 1 {
                let gradientLayer = CAGradientLayer.init()
                gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
                gradientLayer.locations = [0]
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0, y: 1)
                gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
                gradientLayer.cornerRadius = 5
                backgroundView.layer.insertSublayer(gradientLayer, at: 0)
            }
            
            
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: width, height: 100)
            //label.center = view.center
            label.text = "注意"
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = JXMainTextColor
            backgroundView.addSubview(label)
            
            
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: 24, y: label.jxBottom + 20, width: width - 24 * 2, height: 45)
            nameLabel.text = "请确认您输入的是\n「正确的真实姓名」"
            nameLabel.textColor = JXMainTextColor
            nameLabel.font = UIFont.systemFont(ofSize: 16)
            nameLabel.textAlignment = .center
            nameLabel.numberOfLines = 0
            
            backgroundView.addSubview(nameLabel)
            nameLabel.center.y = backgroundView.center.y
            
            
            let margin : CGFloat = 16
            let space : CGFloat = 24
            let buttonWidth : CGFloat = (width - 24 - 16 * 2) / 2
            let buttonHeight : CGFloat = 44
            
            let button1 = UIButton()
            button1.frame = CGRect(x: margin, y: height - space - buttonHeight, width: buttonWidth, height: buttonHeight)
            button1.setTitle("点错了", for: .normal)
            button1.setTitleColor(JXMainColor, for: .normal)
            button1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button1.addTarget(self, action: #selector(hideNoticeView), for: .touchUpInside)
            backgroundView.addSubview(button1)
            
            
            let button = UIButton()
            button.frame = CGRect(x: button1.jxRight + space, y: button1.jxTop, width: buttonWidth, height: buttonHeight)
            button.setTitle("确认", for: .normal)
            button.setTitleColor(JXFfffffColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.addTarget(self, action: #selector(confirm), for: .touchUpInside)
            backgroundView.addSubview(button)
            
            
            button.layer.cornerRadius = 2
            button.layer.shadowOpacity = 1
            button.layer.shadowRadius = 10
            button.layer.shadowOffset = CGSize(width: 0, height: 10)
            button.layer.shadowColor = JX10101aShadowColor.cgColor
            button.setTitleColor(JXFfffffColor, for: .normal)
            button.backgroundColor = JXMainColor
            
            return contentView
        }()
        
        self.noticeView?.show()
    }
    @objc func hideNoticeView() {
        self.noticeView?.dismiss()
    }
    @objc func confirm() {
        self.hideNoticeView()
        
        guard let userName = self.nameTextField.text else { return }

        self.showMBProgressHUD()
        self.vm.addName(userName) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            if isSuc {
                let payList = PayListController()
                payList.isFirstEnter = true
                self.navigationController?.pushViewController(payList, animated: true)
            } else {
                ViewManager.showNotice(msg)
            }
        }
    }
}
