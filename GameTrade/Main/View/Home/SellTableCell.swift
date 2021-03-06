//
//  SellTableCell.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/9.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class SellTableCell: UITableViewCell {

    @IBOutlet weak var mainContentView: UIView!{
        didSet{
            mainContentView.backgroundColor = JXViewBgColor
            mainContentView.layer.shadowOffset = CGSize(width: 0, height: 10)
            mainContentView.layer.shadowOpacity = 1
            mainContentView.layer.shadowRadius = 33
            mainContentView.layer.shadowColor = JX22222cShadowColor.cgColor
            mainContentView.layer.cornerRadius = 4
        }
    }
    
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
        
        self.backgroundColor = UIColor.clear
 
        self.numberLabel.textColor = JXMainText50Color
        self.timeLabel.textColor = JXMainText50Color
        self.valueLabel.textColor = JXMainColor
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
