//
//  PayNormalCell.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/18.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class PayNormalCell: UITableViewCell {

    @IBOutlet weak var payImageView: UIImageView!
    @IBOutlet weak var payNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!{
        didSet{
            editButton.setTitleColor(JXMainColor, for: .normal)
        }
    }
    @IBOutlet weak var lineView: UIView!{
        didSet{
            lineView.backgroundColor = JXSeparatorColor
        }
    }
    
    var editBlock : (()->())?
    
    var entity: PayEntity? {
        didSet{
            self.userNameLabel.text = entity?.name
            self.accountLabel.text = entity?.account
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.payNameLabel.textColor = JXMainTextColor
        self.userNameLabel.textColor = JXMainTextColor
        self.accountLabel.textColor = JXMainTextColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func payEdit(_ sender: Any) {
        if let block = editBlock {
            block()
        }
    }
    
}
