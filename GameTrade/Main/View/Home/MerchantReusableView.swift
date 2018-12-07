//
//  MerchantReusableView.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/17.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class MerchantReusableView: UICollectionReusableView {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainContentView: UIView!
    
    @IBOutlet weak var MerchantImageView: UIImageView!{
        didSet{
            MerchantImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(merchant)))
            MerchantImageView.isUserInteractionEnabled = true
            MerchantImageView.backgroundColor = UIColor.red
            MerchantImageView.layer.cornerRadius = 34
            MerchantImageView.layer.masksToBounds = true
            MerchantImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var merchantLabel: UILabel!{
        didSet{
            merchantLabel.textColor = JXMerchantIconTextColor
            merchantLabel.backgroundColor = JXMerchantIconBgColor
            merchantLabel.layer.cornerRadius = 34
            merchantLabel.layer.masksToBounds = true
            if app_style <= 1 {
                
            } else {
                merchantLabel.layer.borderColor = JXFfffffColor.cgColor
                merchantLabel.layer.borderWidth = 2
            }
        }
    }
    @IBOutlet weak var MerchantNameLabel: UILabel!{
        didSet{
            MerchantNameLabel.textColor = JXFfffffColor
        }
    }
    @IBOutlet weak var numberLabel: UILabel!{
        didSet{
            numberLabel.textColor = JXMainColor
            numberLabel.backgroundColor = app_style <= 1 ? UIColor.rgbColor(rgbValue: 0x2f2f3d) : JXFfffffColor
            numberLabel.layer.cornerRadius = 8.5
            numberLabel.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var percentLabel: UILabel!{
        didSet{
            percentLabel.textColor = JXMainColor
            percentLabel.backgroundColor = app_style <= 1 ? UIColor.rgbColor(rgbValue: 0x2f2f3d) : JXFfffffColor
            percentLabel.layer.cornerRadius = 8.5
            percentLabel.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var numberWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var percentWidthConstraint: NSLayoutConstraint!
    
    
    var merchantBlock : (()->())?
    
    var entity : MerchantEntity? {
        didSet {
//            if
//                let str = entity?.headImg,
//                let url = URL(string: str) {
//                self.MerchantImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "defaultImage"), options: [], completed: nil)
//            }
            self.merchantLabel.text = String(entity?.nickname?.prefix(1) ?? "")
            self.MerchantNameLabel.text = entity?.nickname
            let percent = String(format: "%.1f%%", Double(entity?.tradeSuccCounts ?? 0) / Double(entity?.tradeCounts ?? 1) * 100)
            
            self.numberLabel.text = "\(entity?.tradeCounts ?? 0)次"
            self.percentLabel.text = percent
            
            self.numberWidthConstraint.constant = self.calculate1(text: "\(entity?.tradeCounts ?? 0)次", width: 300, fontSize: 9).width
            self.percentWidthConstraint.constant = self.calculate1(text: percent, width: 300, fontSize: 9).width
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.topConstraint.constant = 13 + kNavStatusHeight
        
        if app_style <= 1 {
            let gradientLayer = CAGradientLayer.init()
            gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
            gradientLayer.locations = [0]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 231 + kNavStatusHeight)
            self.layer.insertSublayer(gradientLayer, at: 0)
        } else {
            self.mainContentView.backgroundColor = JXMainColor
        }
        
 
    }
    @objc func merchant(_ sender: Any) {
        if let block = merchantBlock {
            block()
        }
    }

    func calculate1(text: String, width: CGFloat, fontSize: CGFloat, lineSpace: CGFloat = -1) -> CGSize {
        
        if text.isEmpty {
            return CGSize()
        }
        
        let ocText = text as NSString
        var attributes : Dictionary<NSAttributedString.Key, Any>
        let paragraph = NSMutableParagraphStyle.init()
        paragraph.lineSpacing = lineSpace
        
        if lineSpace < 0 {
            attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize)]
        }else{
            attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize),NSAttributedString.Key.paragraphStyle:paragraph]
        }
        
        let rect = ocText.boundingRect(with: CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin,.usesFontLeading,.usesDeviceMetrics], attributes: attributes, context: nil)
        
        let height : CGFloat
        if rect.origin.x < 0 {
            height = abs(rect.origin.x) + rect.height
        }else{
            height = rect.height
        }
        
        return CGSize(width: rect.width + 20, height: height)
    }
}
