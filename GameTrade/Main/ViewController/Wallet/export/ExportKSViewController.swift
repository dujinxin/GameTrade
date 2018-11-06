//
//  ExportKSViewController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/22.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import JXFoundation

class ExportKSViewController: UIViewController,JXTopBarViewDelegate,JXHorizontalViewDelegate {
    
    var topBar : JXTopBarView?
    var horizontalView : JXHorizontalView?
    
    lazy var ksTextVC: ExportKSTextController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ksTextVC") as! ExportKSTextController
        return vc
    }()
    lazy var ksCodeVC: ExportKSCodeController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ksCodeVC") as! ExportKSCodeController
        return vc
    }()
    
    var keystoreStr = ""
    
    var backBlock : (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ksTextVC.keystoreStr = self.keystoreStr
        self.ksTextVC.backBlock = { ()->() in
            if let block = self.backBlock {
                block()
            }
        }
        self.ksCodeVC.keystoreStr = self.keystoreStr
        self.ksCodeVC.backBlock = { ()->() in
            if let block = self.backBlock {
                block()
            }
        }
        
        topBar = JXTopBarView.init(frame: CGRect.init(x: 0, y: kNavStatusHeight, width: view.bounds.width, height: 44), titles: ["keystore文件","二维码"])
        topBar?.delegate = self
        topBar?.isBottomLineEnabled = true
        view.addSubview(topBar!)
        
        horizontalView = JXHorizontalView.init(frame: CGRect.init(x: 0, y: kNavStatusHeight + 44, width: view.bounds.width, height: UIScreen.main.bounds.height - kNavStatusHeight - 44), containers: [ksTextVC,ksCodeVC], parentViewController: self)
        view.addSubview(horizontalView!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ExportKSViewController {
    func jxTopBarView(topBarView: JXTopBarView, didSelectTabAt index: Int) {
        let indexPath = IndexPath.init(item: index, section: 0)
        self.horizontalView?.containerView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: true)
    }
    func horizontalViewDidScroll(scrollView:UIScrollView) {
        var frame = self.topBar?.bottomLineView.frame
        let offset = scrollView.contentOffset.x
        frame?.origin.x = (offset / view.bounds.width ) * (view.bounds.width / 2)
        self.topBar?.bottomLineView.frame = frame!
    }
    func horizontalView(_: JXHorizontalView, to indexPath: IndexPath) {
        //
        if self.topBar?.selectedIndex == indexPath.item {
            return
        }
        resetTopBarStatus(index: indexPath.item)
    }
    
    func resetTopBarStatus(index:Int) {
        
        self.topBar?.selectedIndex = index
        self.topBar?.subviews.forEach { (v : UIView) -> () in
            
            if (v is UIButton){
                let btn = v as! UIButton
                if (v.tag != self.topBar?.selectedIndex){
                    btn.isSelected = false
                }else{
                    btn.isSelected = !btn.isSelected
                }
            }
        }
    }
}
