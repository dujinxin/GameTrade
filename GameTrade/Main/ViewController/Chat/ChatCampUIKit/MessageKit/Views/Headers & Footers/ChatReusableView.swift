//
//  ChatReusableView.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/20.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class ChatReusableView: MessageHeaderView {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var merchatImageView: UIImageView!
    @IBOutlet weak var merchatNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var worthLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    var entity : OrderDetailEntity? {
        didSet{
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
}
