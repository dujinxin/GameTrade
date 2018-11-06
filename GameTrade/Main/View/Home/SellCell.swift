//
//  SellCell.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/16.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class SellCell: UICollectionViewCell {

    @IBOutlet weak var mainContentView: UIView!
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var payImageView: UIImageView!
  
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    
    var buyBlock : (()->())?
    
    var entity : SellEntity? {
        didSet{
            self.numberLabel.text = "数量：\(entity?.total ?? 0) \(configuration_coinName)"
            self.timeLabel.text = entity?.createTime
            self.valueLabel.text = "\(entity?.realTotal ?? 0 * configuration_coinPrice) \(configuration_valueType)"
            
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
        
        self.numberLabel.alpha = 0.5
        self.timeLabel.alpha = 0.5
    }

}
