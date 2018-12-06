//
//  MyCell.swift
//  Star
//
//  Created by 杜进新 on 2018/7/10.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.backgroundColor = UIColor.clear
            
            backView.layer.cornerRadius = 2
            backView.layer.shadowOpacity = 1
            backView.layer.shadowRadius = 10
            backView.layer.shadowColor = JX10101aShadowColor.cgColor
            //backView.layer.shadowOffset = CGSize(width: 0, height: 40)
            let path = CGPath(rect: CGRect(x: -24, y: -40, width: kScreenWidth, height: 184), transform: nil)
            backView.layer.shadowPath = path
        }
    }
    @IBOutlet weak var userImageView: UIImageView!{
        didSet{
            userImageView.backgroundColor = JXMainColor
            userImageView.layer.cornerRadius = 34
            userImageView.layer.masksToBounds = true
            userImageView.clipsToBounds = true
            userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(modifyImage)))
        }
    }
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var rankLabel: UILabel!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var modifyBlock : (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.topConstraint.constant = 30 + kStatusBarHeight//kNavStatusHeight
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func modifyImage() {
        if let block = modifyBlock {
            block()
        }
    }
}
