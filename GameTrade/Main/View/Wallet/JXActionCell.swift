//
//  JXActionCell.swift
//  Star
//
//  Created by 杜进新 on 2018/8/4.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class JXActionCell: UITableViewCell {

    @IBOutlet weak internal var coinNameLabel: UILabel!
    
    @IBOutlet weak internal var coinNumberLabel: UILabel!
    
    @IBOutlet weak internal var worthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
