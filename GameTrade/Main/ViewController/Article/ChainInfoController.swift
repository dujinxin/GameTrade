//
//  ChainInfoController.swift
//  Star
//
//  Created by 杜进新 on 2018/7/13.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class ChainInfoController: BaseViewController {

    let articleVM = ArticleVM()
    var articleEntity : ArticleEntity?
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "链上信息"

        guard let id = self.articleEntity?.id ,let artHashIndex = self.articleEntity?.artHashIndex else {
            return
        }
        self.articleVM.articleChain(id, artHashIndex: artHashIndex) { (_, msg, isSuc) in
            //
            
            self.label1.text = "ipfs公网访问地址:\(self.articleVM.articleChainEntity.ipfsUrl ?? "")"
            self.label2.text = "ipfs私有节点访问地址:\(self.articleVM.articleChainEntity.ipfsNodeUrl ?? "")"
            self.label3.text = "区块hash:\(self.articleVM.articleChainEntity.blockHash ?? "")"
            self.label4.text = "区块高度:\(self.articleVM.articleChainEntity.blockHeight ?? "")"
            self.label5.text = "上一区块hash:\(self.articleVM.articleChainEntity.blockHashPre ?? "")"
            self.label6.text = "交易hash:\(self.articleVM.articleChainEntity.tradeHash ?? "")"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kNavStatusHeight + 30
    }
}
