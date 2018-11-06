//
//  WalletHeadCell.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/1.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class WalletHeadCell: UITableViewCell {
    
    @IBOutlet weak var backImageView: UIImageView!
    
    @IBOutlet weak var totalNumberLabel: UILabel!
    
    @IBOutlet weak var transferButton: UIButton!
    @IBOutlet weak var receiptButton: UIButton!
    
    var checkBlock : (()->())?
    var transferBlock : (()->())?
    var receiptBlock : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(tap:))))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func transfer(_ sender: Any) {
        if let block = transferBlock {
            block()
        }
    }
    @IBAction func receipt(_ sender: Any) {
        if let block = receiptBlock {
            block()
        }
    }
    @objc func tap(tap:UITapGestureRecognizer) {
        if let block = checkBlock {
            block()
        }
    }
    
}
