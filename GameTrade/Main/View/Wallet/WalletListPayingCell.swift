//
//  WalletListPayingCell.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/29.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class WalletListPayingCell: UITableViewCell {

    @IBOutlet weak var mainContentView: UIView!
    
    @IBOutlet weak var MerchantNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var methodLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.mainContentView.backgroundColor = JXBackColor
        self.mainContentView.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.mainContentView.layer.shadowOpacity = 1
        self.mainContentView.layer.shadowRadius = 33
        self.mainContentView.layer.shadowColor = JX22222cShadowColor.cgColor
        self.mainContentView.layer.cornerRadius = 4
        
        self.valueLabel.alpha = 0.5
        self.timeLabel.alpha = 0.5
        
        payButton.backgroundColor = JXOrangeColor
        payButton.layer.cornerRadius = 2
        payButton.layer.shadowOpacity = 1
        payButton.layer.shadowRadius = 10
        payButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        payButton.layer.shadowColor = JX10101aShadowColor.cgColor
        payButton.setTitleColor(JXFfffffColor, for: .normal)
        payButton.backgroundColor = JXOrangeColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func pay(_ sender: Any) {
    }
    @IBAction func cancel(_ sender: Any) {
    }
    
}
