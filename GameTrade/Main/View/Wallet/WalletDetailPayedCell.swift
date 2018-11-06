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
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.mainContentView.backgroundColor = JXBackColor
        self.mainContentView.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.mainContentView.layer.shadowOpacity = 1
        self.mainContentView.layer.shadowRadius = 33
        self.mainContentView.layer.shadowColor = JX22222cShadowColor.cgColor
        self.mainContentView.layer.cornerRadius = 4
        
        
        self.nameLabel.textColor = JXTextColor
        self.statusLabel.textColor = JXText50Color
        self.valueLabel.textColor = JXRedColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
