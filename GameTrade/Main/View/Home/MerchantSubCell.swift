//
//  MerchantSubCell.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/30.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class MerchantSubCell: UICollectionViewCell {

    @IBOutlet weak var mainContentView: UIView!
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var payImageView: UIImageView!
    @IBOutlet weak var extraLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    
    var buyBlock : (()->())?
    
    var entity : MerchantOrderEntity? {
        didSet {
            self.numberLabel.text = "数量：\(entity?.limitMin ?? 0)-\(entity?.limitMax ?? 0) \(configuration_coinName)"
            //self.timeLabel.text = entity?.createTime
            self.valueLabel.text = "\(Double(entity?.limitMax ?? 0) * configuration_coinPrice) \(configuration_valueType)"
            self.extraLabel.text = "最高"
            
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
   
        self.numberLabel.textColor = JXText50Color
        self.extraLabel.textColor = JXText50Color
        self.valueLabel.textColor = JXTextColor
        
        buyButton.backgroundColor = JXOrangeColor
        buyButton.layer.cornerRadius = 2
        buyButton.layer.shadowOpacity = 1
        buyButton.layer.shadowRadius = 10
        buyButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        buyButton.layer.shadowColor = JX10101aShadowColor.cgColor
        buyButton.setTitleColor(JXFfffffColor, for: .normal)
        buyButton.backgroundColor = JXOrangeColor
        
    }
    @IBAction func buy(_ sender: Any) {
        if let block = buyBlock {
            block()
        }
    }

}
