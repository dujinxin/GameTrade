//
//  ExportKSTextController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/22.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import JXFoundation

class ExportKSTextController: UIViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentSize_heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textView: JXPlaceHolderTextView!
    @IBOutlet weak var copyButton: UIButton!
    
    var backBlock : (()->())?
    var keystoreStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.textView.text = self.keystoreStr
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func copyKs(_ sender: Any) {

        let pals = UIPasteboard.general
        pals.string = self.textView.text
        
        print("复制成功 = ",pals.string)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
