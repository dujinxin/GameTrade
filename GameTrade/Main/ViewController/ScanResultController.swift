//
//  ScanResultController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/12/7.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class ScanResultController: BaseViewController {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            topConstraint.constant = kNavStatusHeight + 100
        }
    }
    @IBOutlet weak var errorImageView: UIImageView!{
        didSet{
            
        }
    }
    @IBOutlet weak var errorTitleLabel: UILabel!{
        didSet{
            errorTitleLabel.textColor = JXMainColor
        }
    }
    @IBOutlet weak var errorInfoLabel: UILabel!{
        didSet{
            errorInfoLabel.textColor = JXMainColor
        }
    }
    @IBOutlet weak var errorButton: UIButton!{
        didSet{
            errorButton.setTitle("重新扫描", for: .normal)
            errorButton.setTitleColor(JXFfffffColor, for: .normal)
            errorButton.backgroundColor = JXMainColor
            errorButton.layer.cornerRadius = 2
            errorButton.layer.shadowOpacity = 1
            errorButton.layer.shadowRadius = 10
            errorButton.layer.shadowOffset = CGSize(width: 0, height: 10)
            errorButton.layer.shadowColor = JX10101aShadowColor.cgColor
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "扫描结果"
    }
   
    @IBAction func backScan(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
