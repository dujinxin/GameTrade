//
//  HomeReusableView.swift
//  Star
//
//  Created by 杜进新 on 2018/7/11.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import AVFoundation

class HomeReusableView: UICollectionReusableView {

    @IBOutlet weak var backgroundImageView: UIImageView!{
        didSet{
            backgroundImageView.backgroundColor = app_style <= 1 ? UIColor.clear : JXMainColor
        }
    }
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var totalNumLabel: UILabel!{
        didSet{
            totalNumLabel.textColor = JXFfffffColor
        }
    }
    @IBOutlet weak var totalInfoLabel: UILabel!{
        didSet{
            totalInfoLabel.textColor = JXFfffffColor
            totalInfoLabel.text = "总\(configuration_coinName)资产"
        }
    }
    @IBOutlet weak var totalPriceLabel: UILabel!{
        didSet{
            totalPriceLabel.textColor = app_style <= 1 ? JXMainColor : JXFfffffColor
            totalPriceLabel.backgroundColor = app_style <= 1 ? UIColor.rgbColor(rgbValue: 0x272732, alpha: 1) : UIColor.rgbColor(rgbValue: 0x272732, alpha: 0.5)
            totalPriceLabel.layer.cornerRadius = 11.5
            totalPriceLabel.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var totalWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var useNumLabel: UILabel!{
        didSet{
            useNumLabel.textColor = JXFfffffColor
        }
    }
    @IBOutlet weak var useInfoLabel: UILabel!{
        didSet{
            useInfoLabel.textColor = JXFfffffColor
            useInfoLabel.text = "可用\(configuration_coinName)资产"
        }
    }
    @IBOutlet weak var usePriceLabel: UILabel!{
        didSet{
            usePriceLabel.textColor = app_style <= 1 ? JXMainColor : JXFfffffColor
            usePriceLabel.backgroundColor = app_style <= 1 ? UIColor.rgbColor(rgbValue: 0x272732, alpha: 1) : UIColor.rgbColor(rgbValue: 0x272732, alpha: 0.5)
            usePriceLabel.layer.cornerRadius = 8.5
            usePriceLabel.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var useWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var limitNumLabel: UILabel!{
        didSet{
            limitNumLabel.textColor = JXFfffffColor
        }
    }
    @IBOutlet weak var limitInfoLabel: UILabel!{
        didSet{
            limitInfoLabel.textColor = JXFfffffColor
            limitInfoLabel.text = "冻结\(configuration_coinName)资产"
        }
    }
    @IBOutlet weak var limitPriceLabel: UILabel!{
        didSet{
            limitPriceLabel.textColor = app_style <= 1 ? JXMainColor : JXFfffffColor
            limitPriceLabel.backgroundColor = app_style <= 1 ? UIColor.rgbColor(rgbValue: 0x272732, alpha: 1) : UIColor.rgbColor(rgbValue: 0x272732, alpha: 0.5)
            limitPriceLabel.layer.cornerRadius = 8.5
            limitPriceLabel.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var limitWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var noticeLabel: UILabel!{
        didSet{
            noticeLabel.textColor = JXMainTextColor
        }
    }
    
    
    @IBOutlet weak var quickImageView: UIImageView!{
        didSet{

            if app_style <= 1 {
                quickImageView.image = UIImage(named: "quickBG")
            } else {
                quickImageView.tintColor = JXFfffffColor
                quickImageView.image = UIImage(named: "quickBG")?.withRenderingMode(.alwaysTemplate)
            }
            
            quickImageView.layer.cornerRadius = 2
            quickImageView.layer.shadowOpacity = 1
            quickImageView.layer.shadowRadius = 10
            quickImageView.layer.shadowColor = JX10101aShadowColor.cgColor
//            quickImageView.layer.shadowOffset = CGSize(width: 0, height: 40)
            let path = CGPath(rect: CGRect(x: -24, y: -25, width: kScreenWidth, height: 125), transform: nil)
            quickImageView.layer.shadowPath = path
        }
    }
    @IBOutlet weak var textField: UITextField!{
        didSet{
            textField.backgroundColor = JXTextViewBg2Color
            //textField.delegate = self
            textField.layer.cornerRadius = 2
            
            textField.placeholder = "输入购买金额"
            textField.keyboardType = .numberPad
            textField.font = UIFont.systemFont(ofSize: 18)
            textField.textColor = JXMainTextColor
            let placeholderColor = app_style <= 1 ? UIColor.rgbColor(rgbValue: 0xb3b3cb) : UIColor.rgbColor(rgbValue: 0x2d2e44)
            textField.attributedPlaceholder = NSAttributedString(string: "输入购买金额", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),NSAttributedString.Key.foregroundColor:placeholderColor])
            textField.leftViewMode = .always
            textField.leftView = {
                let v = UIView(frame: CGRect(0, 0, 10, 10))
                v.backgroundColor = UIColor.clear
                return v
            }()
        }
    }
    @IBOutlet weak var buyButton: UIButton! {
        didSet{
            
            buyButton.setTitle("快捷购买", for: .normal)
            buyButton.setTitleColor(JXFfffffColor, for: .normal)
            buyButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            buyButton.backgroundColor = JXMainColor
            buyButton.layer.cornerRadius = 2
            buyButton.layer.shadowOpacity = 1
            buyButton.layer.shadowRadius = 10
            buyButton.layer.shadowOffset = CGSize(width: 0, height: 10)
            buyButton.layer.shadowColor = JX10101aShadowColor.cgColor
            buyButton.addTarget(self, action: #selector(quickBuy), for: .touchUpInside)
        }
    }
    
    
    
    @IBOutlet weak var itemContentView: UIView!

    @IBOutlet weak var scanIconBackView: UIView!
    @IBOutlet weak var scanIconButton: UIButton!
    @IBOutlet weak var scanArrow: UIButton!
    
    
    @IBOutlet weak var switchContentView: UIView!{
        didSet{
            switchContentView.backgroundColor = app_style <= 1 ? UIColor.rgbColor(rgbValue: 0x21202c) : UIColor.rgbColor(rgbValue: 0xd4d4d4)
        }
    }

    @IBOutlet weak var infoContentView: UIView!
    
    
    @IBOutlet weak var scanImageView: UIImageView!{
        didSet{
            
        }
    }
    
    @IBOutlet weak var buyView: UIView!
    @IBOutlet weak var sellView: UIView!
    @IBOutlet weak var helpView: UIView!
    
    @IBOutlet weak var buyLabel: UILabel!{
        didSet{
            buyLabel.textColor = JXMainTextColor
        }
    }
    @IBOutlet weak var sellLabel: UILabel!{
        didSet{
            sellLabel.textColor = JXMainTextColor
        }
    }
    @IBOutlet weak var helpLabel: UILabel!{
        didSet{
            helpLabel.textColor = JXMainTextColor
        }
    }

    @IBOutlet weak var leftLine: UIView!{
        didSet{
            leftLine.backgroundColor = app_style <= 1 ? UIColor.rgbColor(rgbValue: 0x32333E) : JXSeparatorColor
            
        }
    }
    @IBOutlet weak var rightLine: UIView!{
        didSet{
            rightLine.backgroundColor =  app_style <= 1 ? UIColor.rgbColor(rgbValue: 0x32333E) : JXSeparatorColor
        }
    }
    @IBOutlet weak var bottomLine: UIView!{
        didSet{
            bottomLine.backgroundColor =  app_style <= 1 ? UIColor.rgbColor(rgbValue: 0x32333E) : JXSeparatorColor
        }
    }
    
    
    
    var additionBlock : (()->())?
    var noticeBlock : (()->())?
    var quickBuyBlock : (()->())?
    var scanBlock : (()->())?
    
    var buyBlock : (()->())?
    var sellBlock : (()->())?
    var helpBlock : (()->())?
    
    var propertyEntity : PropertyEntity? {
        didSet{
            self.totalNumLabel.text = "\(propertyEntity?.totalCounts ?? 0)"
            self.useNumLabel.text = "\(propertyEntity?.balance ?? 0)"
            self.limitNumLabel.text = "\(propertyEntity?.blockedBalance ?? 0)"
            
            self.totalPriceLabel.text = "=\((propertyEntity?.totalCounts ?? 0) * configuration_coinPrice) \(configuration_valueType)"
            self.usePriceLabel.text = "=\((propertyEntity?.balance ?? 0) * configuration_coinPrice) \(configuration_valueType)"
            self.limitPriceLabel.text = "=\((propertyEntity?.blockedBalance ?? 0) * configuration_coinPrice) \(configuration_valueType)"
            
        }
    }
    var noticeEntity : NoticeEntity? {
        didSet{
            self.noticeLabel.text = noticeEntity?.title
            if let title = noticeEntity?.title, title.isEmpty == false {
                self.switchContentView.isHidden = false
            } else {
                self.switchContentView.isHidden = true
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.topConstraint.constant = kStatusBarHeight + 12
   
        self.rightButton.backgroundColor = UIColor.clear
        
        
        self.infoContentView.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.infoContentView.layer.shadowOpacity = 1
        self.infoContentView.layer.shadowRadius = 40
        self.infoContentView.layer.shadowColor = JX10101aShadowColor.cgColor
        self.infoContentView.layer.cornerRadius = 4
        
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0xff4465).cgColor,UIColor.rgbColor(rgbValue: 0xF6CA1D).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        gradientLayer.cornerRadius = 5
        
        self.scanIconBackView.layer.insertSublayer(gradientLayer, at: 0)
        
        self.scanIconButton.tintColor = UIColor.black
        self.scanIconButton.setImage(UIImage(named: "scanIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        
//        self.switchContentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(noticeTap(tap:))))
//        self.infoContentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(scanTap(tap:))))
        
        
        self.switchContentView.tag = 1
        self.scanImageView.tag = 2
        self.buyView.tag = 3
        self.sellView.tag = 4
        self.helpView.tag = 5
        self.switchContentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapClick(tap:))))
        self.scanImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapClick(tap:))))
        self.buyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapClick(tap:))))
        self.sellView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapClick(tap:))))
        self.helpView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapClick(tap:))))
        
    }

    @IBAction func addition(_ sender: Any) {
        if let block = self.additionBlock {
            block()
        }
    }
//    @objc func noticeTap(tap: UITapGestureRecognizer) {
//        if let block = self.noticeBlock {
//            block()
//        }
//    }
//    @objc func scanTap(tap: UITapGestureRecognizer) {
//        if let block = self.scanBlock {
//            block()
//        }
//    }
    @objc func quickBuy(button: UIButton) {
        if let block = self.quickBuyBlock {
            block()
        }
    }
    @objc func tapClick(tap: UITapGestureRecognizer) {
        guard let v = tap.view else { return }
        switch v.tag {
        case 1:
            if let block = self.noticeBlock {
                block()
            }
        case 2:
            if let block = self.scanBlock {
                block()
            }
        case 3:
            if let block = self.buyBlock {
                block()
            }
        case 4:
            if let block = self.sellBlock {
                block()
            }
        case 5:
            if let block = self.helpBlock {
                block()
            }
        default:
            print("")
        }
    }
}
