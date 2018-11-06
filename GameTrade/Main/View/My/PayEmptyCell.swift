//
//  PayEmptyCell.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/18.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class PayEmptyCell: UITableViewCell {

    @IBOutlet weak var payImageView: UIImageView!
    @IBOutlet weak var payNameLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.payNameLabel.textColor = JXFfffffColor
        self.setLabel.textColor = JXOrangeColor
        
        self.lineView.backgroundColor = JXSeparatorColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
