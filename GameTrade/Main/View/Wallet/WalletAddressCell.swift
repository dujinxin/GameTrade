//
//  WalletAddressCell.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/29.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class WalletAddressCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var codeImageView: UIImageView!
    @IBOutlet weak var separatorView: UIView!{
        didSet{
            separatorView.backgroundColor = JXSeparatorColor
        }
    }
    
    var showCodeImage : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
        self.nameLabel.textColor = JXMainText50Color
        self.addressLabel.textColor = JXMainTextColor
        
        self.codeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCode)))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func showCode(tap: UITapGestureRecognizer) {
        if let block = showCodeImage {
            block()
        }
    }
    
}
