//
//  WalletDetailPayedCell.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/29.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class WalletDetailPayedCell: UITableViewCell {

    @IBOutlet weak var mainContentView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
 
    var entity : TradeDetailEntity? {
        didSet {
            //1:买币，2:卖币，3:支付，4:收款，5:转账，6:手续费，当type为6时不可查看详情
            if entity?.type == 3 {
                self.nameLabel.text = entity?.webName
            } else {
                self.nameLabel.text = entity?.typeName
            }
            if entity?.type == 2 {
                self.statusLabel.textColor = JXGreenColor
                self.statusLabel.text = "已发币"
                self.valueLabel.textColor = JXRedColor
            } else if entity?.type == 4 {
                self.statusLabel.textColor = JXGreenColor
                self.statusLabel.text = "已收币"
                self.valueLabel.textColor = JXGreenColor
            } else {
                self.statusLabel.textColor = JXMainText50Color
                self.statusLabel.text = "已完成"
                self.valueLabel.textColor = JXRedColor
            }
            if entity?.type == 2 || entity?.type == 4 {
                //self.valueLabel.text = "+\(entity.amount) \(configuration_coinName)"
                self.valueLabel.text = "\(Double(entity?.amount ?? 0) * configuration_coinPrice) \(configuration_valueType)"
            } else {
                //self.valueLabel.text = "\(entity.amount) \(configuration_coinName)"
                self.valueLabel.text = "\(Double(entity?.amount ?? 0) * configuration_coinPrice) \(configuration_valueType)"
            }
        }
    }
    func setEntity(_ entity: TradeDetailEntity, type: Int) {
        //1:买币，2:卖币，3:支付，4:收款，5:转账，6:手续费，当type为6时不可查看详情
        if type == 3 {
            self.nameLabel.text = entity.account
        } else {
            self.nameLabel.text = "转账" //entity.typeName
        }
        if type == 2 {
            self.statusLabel.textColor = JXGreenColor
            self.statusLabel.text = "已发币"
            self.valueLabel.textColor = JXRedColor
        } else if type == 4 {
            self.statusLabel.textColor = JXGreenColor
            self.statusLabel.text = "已收币"
            self.valueLabel.textColor = JXGreenColor
        } else {
            self.statusLabel.textColor = JXMainText50Color
            self.statusLabel.text = "已完成"
            self.valueLabel.textColor = JXRedColor
        }
        if type == 2 || type == 4 {
            //self.valueLabel.text = "+\(entity.amount) \(configuration_coinName)"
            self.valueLabel.text = "+\(Double(entity.amount) * configuration_coinPrice) \(configuration_valueType)"
        } else {
            //self.valueLabel.text = "\(entity.amount) \(configuration_coinName)"
            self.valueLabel.text = "\(Double(entity.amount) * configuration_coinPrice) \(configuration_valueType)"
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
        
        
        self.nameLabel.textColor = JXMainTextColor
        self.statusLabel.textColor = JXMainText50Color
        self.valueLabel.textColor = JXRedColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
