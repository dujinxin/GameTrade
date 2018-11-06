//
//  OrderCell.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/17.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class OrderCell: UICollectionViewCell {

    @IBOutlet weak var mainContentView: UIView!
    
    @IBOutlet weak var MerchantNameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    
    var buyBlock : (()->())?
    
    @IBAction func buy(_ sender: Any) {
        if let block = buyBlock {
            block()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

}
