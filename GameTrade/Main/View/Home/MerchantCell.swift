//
//  MerchantCell.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/16.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class MerchantCell: UICollectionViewCell {

    @IBOutlet weak var mainContentView: UIView!
    
    @IBOutlet weak var MerchantImageView: UIImageView!
    @IBOutlet weak var MerchantNameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var payImageView: UIImageView!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var extraLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    
    var buyBlock : (()->())?
    var merchantBlock : (()->())?
    
    var entity: BuyEntity? {
        didSet {
            if
                let str = entity?.agentEntity.headImg,
                let url = URL(string: str) {
                self.MerchantImageView.sd_setImage(with: url, completed: nil)
            }
            self.MerchantNameLabel.text = entity?.agentEntity.nickname
            let percent = NSString(format: "%.1f%%", Double(entity?.agentEntity.tradeSuccCounts ?? 0) / Double(entity?.agentEntity.tradeCounts ?? 1) * 100)
            //String(format: ".1f%", Double(entity?.agentEntity.tradeSuccCounts ?? 0) / Double(entity?.agentEntity.tradeCounts ?? 1))
            self.limitLabel.text = "\(entity?.agentEntity.tradeCounts ?? 0)|\(percent)"
            self.extraLabel.text = "最高"
            self.numberLabel.text = "数量：\(entity?.limitMin ?? 0)-\(entity?.limitMax ?? 0)\(configuration_coinName)"
            self.valueLabel.text = "\(Double(entity?.limitMax ?? 0) * configuration_coinPrice)\(configuration_valueType)"
            
            if entity?.payType == 1 {
                self.payImageView.image = UIImage(named: "icon-mini-alipay")
            }else if entity?.payType == 2 {
                self.payImageView.image = UIImage(named: "icon-mini-wechat")
            } else {
                self.payImageView.image = UIImage(named: "icon-mini-card")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.mainContentView.backgroundColor = JXBackColor
        self.mainContentView.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.mainContentView.layer.shadowOpacity = 1
        self.mainContentView.layer.shadowRadius = 33
        self.mainContentView.layer.shadowColor = JX22222cShadowColor.cgColor
        self.mainContentView.layer.cornerRadius = 4
        
        self.MerchantImageView.layer.cornerRadius = 15.0
        self.MerchantImageView.layer.masksToBounds = true
        
        self.limitLabel.textColor = JXText50Color
        self.numberLabel.textColor = JXText50Color
        self.extraLabel.textColor = JXText50Color
        self.MerchantNameLabel.textColor = JXTextColor
        self.valueLabel.textColor = JXTextColor
        
        buyButton.backgroundColor = JXOrangeColor
        buyButton.layer.cornerRadius = 2
        buyButton.layer.shadowOpacity = 1
        buyButton.layer.shadowRadius = 10
        buyButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        buyButton.layer.shadowColor = JX10101aShadowColor.cgColor
        buyButton.setTitleColor(JXFfffffColor, for: .normal)
        buyButton.backgroundColor = JXOrangeColor
        
        self.MerchantImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(merchant)))
        self.MerchantImageView.isUserInteractionEnabled = true
        self.MerchantImageView.backgroundColor = UIColor.red
    }
    @IBAction func buy(_ sender: Any) {
        if let block = buyBlock {
            block()
        }
    }
    @objc func merchant(_ sender: Any) {
        if let block = merchantBlock {
            block()
        }
    }
}
