//
//  MerchantReusableView.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/17.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class MerchantReusableView: UICollectionReusableView {

    @IBOutlet weak var mainContentView: UIView!
    
    @IBOutlet weak var MerchantImageView: UIImageView!
    @IBOutlet weak var MerchantNameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var extraLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    
    var merchantBlock : (()->())?
    
    var entity : MerchantEntity? {
        didSet {
            if
                let str = entity?.headImg,
                let url = URL(string: str) {
                self.MerchantImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "defaultImage"), options: [], completed: nil)
            }
            self.MerchantNameLabel.text = entity?.nickname
            let percent = String(format: "%.1f%%", Double(entity?.tradeSuccCounts ?? 0) / Double(entity?.tradeCounts ?? 1) * 100)
            //String(format: ".1f%", Double(entity?.agentEntity.tradeSuccCounts ?? 0) / Double(entity?.agentEntity.tradeCounts ?? 1))
            self.numberLabel.text = "\(entity?.tradeCounts ?? 0)次"
            self.percentLabel.text = percent
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.percentLabel.textColor = JXOrangeColor
        self.numberLabel.textColor = JXOrangeColor
        //self.extraLabel.textColor = JXText50Color
        self.MerchantNameLabel.textColor = JXTextColor
        //self.valueLabel.textColor = JXTextColor
        
        self.percentLabel.backgroundColor = UIColor.rgbColor(rgbValue: 0x2f2f3d)
        self.percentLabel.layer.cornerRadius = 11.5
        
        self.numberLabel.backgroundColor = UIColor.rgbColor(rgbValue: 0x2f2f3d)
        self.numberLabel.layer.cornerRadius = 11.5
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
    
}
