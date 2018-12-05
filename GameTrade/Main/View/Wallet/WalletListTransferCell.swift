//
//  WalletListTransferCell.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/29.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class WalletListTransferCell: UITableViewCell {

    @IBOutlet weak var mainContentView: UIView!
    
    @IBOutlet weak var methodLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    var entity : TradeEntity? {
        didSet {
           
            if entity?.type == 6 {
                self.methodLabel.text = "手续费"
            } else {
                self.methodLabel.text = "转账"
            }
            self.timeLabel.text = entity?.createTime
            //1:买币，2:卖币，3:支付，4:收款，5:转账，6:手续费，当type为6时不可查看详情
            if entity?.type == 1 || entity?.type == 4 {
                self.numberLabel.text = "+\(entity?.amount ?? 0) \(configuration_coinName)"
            } else {
                self.numberLabel.text = "\(entity?.amount ?? 0) \(configuration_coinName)"
            }
            self.valueLabel.text = "=\(fabs(Double(entity?.amount ?? 0)) * configuration_coinPrice) \(configuration_valueType)"
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
        
        self.valueLabel.textColor = JXMainText50Color
        self.timeLabel.textColor = JXMainText50Color
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
