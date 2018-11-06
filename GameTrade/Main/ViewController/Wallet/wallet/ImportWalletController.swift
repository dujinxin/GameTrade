//
//  ImportWalletController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/20.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import JXFoundation

class ImportWalletController: UIViewController,JXTopBarViewDelegate,JXHorizontalViewDelegate {

    var topBar : JXTopBarView?
    var horizontalView : JXHorizontalView?
    
    lazy var keystoreVC: KeyStoreController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "keystoreVC") as! KeyStoreController
        return vc
    }()
    lazy var privateVC: PrivateKeyController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "privateVC") as! PrivateKeyController
        return vc
    }()
    
    var backBlock : (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.keystoreVC.backBlock = { ()->() in
            if let block = self.backBlock {
                block()
            }
        }
        self.privateVC.backBlock = { ()->() in
            if let block = self.backBlock {
                block()
            }
        }

        topBar = JXTopBarView.init(frame: CGRect.init(x: 0, y: kNavStatusHeight, width: view.bounds.width, height: 44), titles: ["keystore导入","明文私钥导入"])
        topBar?.delegate = self
        topBar?.isBottomLineEnabled = true
        view.addSubview(topBar!)
        
        horizontalView = JXHorizontalView.init(frame: CGRect.init(x: 0, y: kNavStatusHeight + 44, width: view.bounds.width, height: UIScreen.main.bounds.height - kNavStatusHeight - 44), containers: [keystoreVC,privateVC], parentViewController: self)
        view.addSubview(horizontalView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ImportWalletController {
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
