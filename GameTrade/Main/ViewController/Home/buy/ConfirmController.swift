//
//  ConfirmController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/2.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class ConfirmController: UIViewController {
    
    var number : String = "0"
    var value = 0
    
    var payName = "支付宝"
    var payType = 1
    
    var rightButton : UIButton!
    
    
    
    var closeBlock : (()->())?
    var confirmBlock : ((_ type: Int)->())?
    
    var vcView : UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear

        //[["title":"交易金额"],["title":"交易单价"],["title":"交易数量"],["title":"支付方式"]]
        
        self.vcView = self.customViewInit(number: self.number, address: "address", gas: "gas", remark: "无备注")
        //self.vcView = self.customViewInit(number: number, address: value, gas: "gas", remark: self.remarkTextField.text ?? "无备注")
        vcView.frame = CGRect(x: 0, y: kScreenHeight - 442 - kBottomMaginHeight, width: kScreenWidth * 2, height: 442 + kBottomMaginHeight)
        self.view.addSubview(vcView)
    }
    func customViewInit(number: String, address: String, gas: String, remark: String) -> UIView {
    
        let width : CGFloat = kScreenWidth - 48
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth * 2, height: 442 + kBottomMaginHeight)
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth * 2, height: 442 + kBottomMaginHeight)
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        let leftContentView = UIView()
        leftContentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 442 + kBottomMaginHeight)
        contentView.addSubview(leftContentView)
        
        //左侧视图
        
        let topBarView = { () -> UIView in
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 60))
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
            //label.center = view.center
            label.text = "确认转账"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18)
            label.textColor = JXFfffffColor
            view.addSubview(label)
            //label.sizeToFit()
            
            let button = UIButton()
            button.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
            //button.center = CGPoint(x: 30, y: view.jxCenterY)
            //button.setTitle("×", for: .normal)
            button.tintColor = JXFfffffColor
            button.setImage(UIImage(named: "Close")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button.setTitleColor(JX333333Color, for: .normal)
            button.contentVerticalAlignment = .center
            button.contentHorizontalAlignment = .center
            button.addTarget(self, action: #selector(closeStatus), for: .touchUpInside)
            view.addSubview(button)
            
            return view
        }()
        leftContentView.addSubview(topBarView)
        
        
        let nameLabel = UILabel()
        nameLabel.frame = CGRect(x: 24, y: topBarView.jxBottom + 20, width: width, height: 30)
        nameLabel.text = "\(number) \(configuration_valueType)"
        nameLabel.textColor = JXFfffffColor
        nameLabel.font = UIFont.systemFont(ofSize: 25)
        nameLabel.textAlignment = .center
        
        leftContentView.addSubview(nameLabel)
        
        //1
        let leftLabel1 = UILabel()
        leftLabel1.frame = CGRect(x: 24, y: nameLabel.jxBottom + 31, width: 65, height: 51)
        leftLabel1.text = "交易金额"
        leftLabel1.textColor = JXMainText50Color
        leftLabel1.font = UIFont.systemFont(ofSize: 13)
        leftLabel1.textAlignment = .left
        leftContentView.addSubview(leftLabel1)
        
        let rightLabel1 = UILabel()
        rightLabel1.frame = CGRect(x: leftLabel1.jxRight, y: leftLabel1.jxTop, width: kScreenWidth - 48 - leftLabel1.jxWidth, height: 51)
        if let num = Double(self.number) {
            rightLabel1.text = "\(num * configuration_coinPrice) \(configuration_valueType)"
        } else {
            rightLabel1.text = "\(0) \(configuration_valueType)"
        }
        
        rightLabel1.textColor = JXRedColor
        rightLabel1.font = UIFont.systemFont(ofSize: 14)
        rightLabel1.textAlignment = .right
        leftContentView.addSubview(rightLabel1)
        
        let line1 = UIView()
        line1.frame = CGRect(x: nameLabel.jxLeft, y: leftLabel1.jxBottom, width: width, height: 1)
        line1.backgroundColor = JXSeparatorColor
        leftContentView.addSubview(line1)
        
        //2
        let leftLabel2 = UILabel()
        leftLabel2.frame = CGRect(x: 24, y: line1.jxBottom, width: 65, height: 51)
        leftLabel2.text = "交易单价"
        leftLabel2.textColor = JXMainText50Color
        leftLabel2.font = UIFont.systemFont(ofSize: 13)
        leftLabel2.textAlignment = .left
        leftContentView.addSubview(leftLabel2)
        
        let rightLabel2 = UILabel()
        rightLabel2.frame = CGRect(x: leftLabel2.jxRight, y: leftLabel2.jxTop, width: kScreenWidth - 48 - leftLabel2.jxWidth, height: 51)
        rightLabel2.text = "\(configuration_coinPrice) \(configuration_valueType)"
        rightLabel2.textColor = JXMainTextColor
        rightLabel2.font = UIFont.systemFont(ofSize: 14)
        rightLabel2.textAlignment = .right
        leftContentView.addSubview(rightLabel2)
        
        let line2 = UIView()
        line2.frame = CGRect(x: nameLabel.jxLeft, y: leftLabel2.jxBottom, width: width, height: 1)
        line2.backgroundColor = JXSeparatorColor
        leftContentView.addSubview(line2)
        
        
        //3
        let leftLabel3 = UILabel()
        leftLabel3.frame = CGRect(x: 24, y: line2.jxBottom , width: 65, height: 51)
        leftLabel3.text = "交易数量"
        leftLabel3.textColor = JXMainText50Color
        leftLabel3.font = UIFont.systemFont(ofSize: 13)
        leftLabel3.textAlignment = .left
        leftContentView.addSubview(leftLabel3)
        
        let rightLabel3 = UILabel()
        rightLabel3.frame = CGRect(x: leftLabel3.jxRight, y: leftLabel3.jxTop, width: kScreenWidth - 48 - leftLabel3.jxWidth, height: 51)
        rightLabel3.text = number
        rightLabel3.textColor = JXMainTextColor
        rightLabel3.font = UIFont.systemFont(ofSize: 14)
        rightLabel3.textAlignment = .right
        leftContentView.addSubview(rightLabel3)
        
        let line3 = UIView()
        line3.frame = CGRect(x: nameLabel.jxLeft, y: leftLabel3.jxBottom, width: width, height: 1)
        line3.backgroundColor = JXSeparatorColor
        leftContentView.addSubview(line3)
        
        
        //4
        let leftLabel4 = UILabel()
        leftLabel4.frame = CGRect(x: 24, y: line3.jxBottom, width: 65, height: 51)
        leftLabel4.text = "支付方式"
        leftLabel4.textColor = JXMainText50Color
        leftLabel4.font = UIFont.systemFont(ofSize: 13)
        leftLabel4.textAlignment = .left
        leftContentView.addSubview(leftLabel4)
        
//        let rightLabel4 = UILabel()
//        rightLabel4.frame = CGRect(x: leftLabel4.jxRight, y: leftLabel4.jxTop, width: kScreenWidth - 48 - leftLabel4.jxWidth, height: 51)
//        rightLabel4.text = remark
//        rightLabel4.textColor = JXMainTextColor
//        rightLabel4.font = UIFont.systemFont(ofSize: 14)
//        rightLabel4.textAlignment = .right
//        leftContentView.addSubview(rightLabel4)
        
        
        
        self.rightButton = UIButton()
        rightButton.frame = CGRect(x: leftLabel4.jxRight, y: leftLabel4.jxTop, width: kScreenWidth - 48 - leftLabel4.jxWidth - 20, height: 51)
        rightButton.setTitle(self.payName, for: .normal)
        rightButton.setTitleColor(JXMainTextColor, for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightButton.addTarget(self, action: #selector(selectPay), for: .touchUpInside)
        rightButton.contentHorizontalAlignment = .right
        leftContentView.addSubview(rightButton)
        
        let arrow = UIImageView(frame: CGRect(x: rightButton.jxRight, y: leftLabel4.jxTop + 15.5, width: 20, height: 20))
        arrow.backgroundColor = JXMainTextColor
        leftContentView.addSubview(arrow)
        
        
        let line4 = UIView()
        line4.frame = CGRect(x: nameLabel.jxLeft, y: leftLabel4.jxBottom, width: width, height: 1)
        line4.backgroundColor = JXSeparatorColor
        leftContentView.addSubview(line4)
        
     
        
        
        let button = UIButton()
        button.frame = CGRect(x: nameLabel.jxLeft, y: line4.jxBottom + 30, width: width, height: 44)
        button.setTitle("下单", for: .normal)
        button.setTitleColor(JXFfffffColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        leftContentView.addSubview(button)
        
        
        button.layer.cornerRadius = 2
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.shadowColor = JX10101aShadowColor.cgColor
        button.setTitleColor(JXFfffffColor, for: .normal)
        button.backgroundColor = JXMainColor
        
        
        
        //右侧视图
        
        let rightContentView = UIView()
        rightContentView.frame = CGRect(x: kScreenWidth, y: 0, width: kScreenWidth, height: 442 + kBottomMaginHeight)
        contentView.addSubview(rightContentView)
        
        let topBarView1 = { () -> UIView in
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 60))
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
            //label.center = view.center
            label.text = "选择支付方式"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18)
            label.textColor = JXFfffffColor
            view.addSubview(label)
            //label.sizeToFit()
            
            let button = UIButton()
            button.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
            //button.center = CGPoint(x: 30, y: view.jxCenterY)
            //button.setTitle("×", for: .normal)
            button.tintColor = JXFfffffColor
            button.setImage(UIImage(named: "icon-back")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button.setTitleColor(JX333333Color, for: .normal)
            button.contentVerticalAlignment = .center
            button.contentHorizontalAlignment = .center
            button.addTarget(self, action: #selector(backTo), for: .touchUpInside)
            view.addSubview(button)
            
            
            let button1 = UIButton()
            button1.frame = CGRect(x: kScreenWidth - 80 - 24, y: 10, width: 80, height: 40)
            //button.center = CGPoint(x: 30, y: view.jxCenterY)
            button1.setTitle("忘记密码？", for: .normal)
            
            button1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button1.setTitleColor(JXMainColor, for: .normal)
            button1.contentVerticalAlignment = .center
            button1.contentHorizontalAlignment = .right
            //button1.addTarget(self, action: #selector(forgotPsd), for: .touchUpInside)
            contentView.addSubview(button1)
            
            return view
        }()
        rightContentView.addSubview(topBarView1)
        
        //1
        let icon1 = UIImageView(frame: CGRect(x: 24, y: topBarView.jxBottom + 20 + 15.5, width: 20, height: 20))
        icon1.image = UIImage(named: "icon-mini-alipay")
        rightContentView.addSubview(icon1)
        
        let button1 = UIButton()
        button1.frame = CGRect(x: icon1.jxRight, y: topBarView.jxBottom + 20, width: kScreenWidth - 48 - icon1.jxWidth - 20, height: 51)
        button1.setTitle(self.payName, for: .normal)
        button1.setTitleColor(JXMainTextColor, for: .normal)
        button1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button1.addTarget(self, action: #selector(payClick(button:)), for: .touchUpInside)
        button1.tag = 1
        button1.contentHorizontalAlignment = .left
        rightContentView.addSubview(button1)
        
        let arrow1 = UIImageView(frame: CGRect(x: button1.jxRight, y: button1.jxTop + 15.5, width: 20, height: 20))
        arrow1.backgroundColor = JXMainTextColor
        rightContentView.addSubview(arrow1)
        
        let rightLine1 = UIView()
        rightLine1.frame = CGRect(x: icon1.jxLeft, y: button1.jxBottom, width: width, height: 1)
        rightLine1.backgroundColor = JXSeparatorColor
        rightContentView.addSubview(rightLine1)
        
        //2
        let icon2 = UIImageView(frame: CGRect(x: 24, y: rightLine1.jxBottom + 15.5, width: 20, height: 20))
        icon2.image = UIImage(named: "icon-mini-wechat")
        rightContentView.addSubview(icon2)
        
        let button2 = UIButton()
        button2.frame = CGRect(x: icon1.jxRight, y: rightLine1.jxBottom, width: kScreenWidth - 48 - icon1.jxWidth - 20, height: 51)
        button2.setTitle("微信", for: .normal)
        button2.setTitleColor(JXMainTextColor, for: .normal)
        button2.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button2.addTarget(self, action: #selector(payClick(button:)), for: .touchUpInside)
        button2.tag = 2
        button2.contentHorizontalAlignment = .left
        rightContentView.addSubview(button2)
        
        let arrow2 = UIImageView(frame: CGRect(x: button1.jxRight, y: button2.jxTop + 15.5, width: 20, height: 20))
        arrow2.backgroundColor = JXMainTextColor
        rightContentView.addSubview(arrow2)
        
        let rightLine2 = UIView()
        rightLine2.frame = CGRect(x: icon1.jxLeft, y: button2.jxBottom, width: width, height: 1)
        rightLine2.backgroundColor = JXSeparatorColor
        rightContentView.addSubview(rightLine2)
        
        //3
        let icon3 = UIImageView(frame: CGRect(x: 24, y: rightLine2.jxBottom + 15.5, width: 20, height: 20))
        icon3.image = UIImage(named: "icon-mini-card")
        rightContentView.addSubview(icon3)
        
        let button3 = UIButton()
        button3.frame = CGRect(x: icon1.jxRight, y: rightLine2.jxBottom, width: kScreenWidth - 48 - icon1.jxWidth - 20, height: 51)
        button3.setTitle("银行卡", for: .normal)
        button3.setTitleColor(JXMainTextColor, for: .normal)
        button3.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button3.addTarget(self, action: #selector(payClick(button:)), for: .touchUpInside)
        button3.tag = 3
        button3.contentHorizontalAlignment = .left
        rightContentView.addSubview(button3)
        
        let arrow3 = UIImageView(frame: CGRect(x: button1.jxRight, y: button3.jxTop + 15.5, width: 20, height: 20))
        arrow3.backgroundColor = JXMainTextColor
        rightContentView.addSubview(arrow3)
        
        let rightLine3 = UIView()
        rightLine3.frame = CGRect(x: icon1.jxLeft, y: button3.jxBottom, width: width, height: 1)
        rightLine3.backgroundColor = JXSeparatorColor
        rightContentView.addSubview(rightLine3)
        
        
        return contentView
    }
    @objc func selectPay() {
        //self.closeStatus()
        
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionFlipFromRight, animations: {
            self.vcView.frame.origin.x = -kScreenWidth
        }) { (isFinish) in
            if isFinish {
                //self.psdTextView.textField.becomeFirstResponder()
            }
        }
        
    }
    @objc func backTo() {
        
        //self.sendVC.view.endEditing(true)
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionFlipFromLeft, animations: {
            self.vcView.frame.origin.x = 0
        }, completion: nil)
    }
    @objc func confirm() {
        print("confirm")
        if let block = confirmBlock {
            block(self.payType)
        }
        self.closeStatus()
    }
    @objc func closeStatus() {
        
        if let block = closeBlock {
            block()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    @objc func payClick(button: UIButton) {
        if button.tag == 1 {
            self.payName = "支付宝"
            self.payType = 1
        } else if button.tag == 2 {
            self.payName = "微信"
            self.payType = 2
        } else {
            self.payName = "银行卡"
            self.payType = 3
        }
        self.rightButton.setTitle(self.payName, for: .normal)
        
        self.backTo()
    }
}
