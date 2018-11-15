//
//  HelpViewController.swift
//  Star
//
//  Created by 杜进新 on 2018/7/12.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class HelpViewController: BaseViewController {
    
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "帮助中心"
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

