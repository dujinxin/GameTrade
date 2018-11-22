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
    
    @IBOutlet weak var MerchantImageView: UIImageView!
    @IBOutlet weak var merchantLabel: UILabel!
    @IBOutlet weak var MerchantNameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
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
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 231 + kNavStatusHeight)
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        self.merchantLabel.layer.cornerRadius = 34
        self.merchantLabel.layer.masksToBounds = true
        
        
        self.percentLabel.textColor = JXOrangeColor
        self.numberLabel.textColor = JXOrangeColor
        self.MerchantNameLabel.textColor = JXTextColor
     
        
        self.percentLabel.backgroundColor = UIColor.rgbColor(rgbValue: 0x2f2f3d)
        self.percentLabel.layer.cornerRadius = 8.5
        self.percentLabel.layer.masksToBounds = true
        
        self.numberLabel.backgroundColor = UIColor.rgbColor(rgbValue: 0x2f2f3d)
        self.numberLabel.layer.cornerRadius = 8.5
        self.numberLabel.layer.masksToBounds = true
        
        self.MerchantImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(merchant)))
        self.MerchantImageView.isUserInteractionEnabled = true
        self.MerchantImageView.backgroundColor = UIColor.red
        self.MerchantImageView.layer.cornerRadius = 34
        self.MerchantImageView.layer.masksToBounds = true
        self.MerchantImageView.clipsToBounds = true
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
