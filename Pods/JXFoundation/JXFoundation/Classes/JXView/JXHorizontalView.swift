//
//  JXHorizontalView.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/6/21.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let reuseIndentifierHeader = "reuseIndentifierHeader"
private let reuseIndentifierFooter = "reuseIndentifierFooter"

public class JXHorizontalView: UIView {

    let parentViewController : UIViewController
    let rect : CGRect
    var containers = Array<Any>()
    
    var delegate : JXHorizontalViewDelegate?
    
    public init(frame: CGRect, containers:Array<UIViewController>,parentViewController:UIViewController) {
        
        self.rect = frame
        self.parentViewController = parentViewController
        self.delegate = parentViewController as? JXHorizontalViewDelegate
        self.containers = containers
        
        for vc in containers {
            if vc .isKind(of: UINavigationController.self) {
                assert(false, "can not append UINavigationController")
            }
            self.parentViewController.addChild(vc)
        }
        
        super.init(frame: frame)
        
        self.addSubview(self.containerView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    public func reloadData() {
        let indexPath = IndexPath.init(item: 0, section: 0)
        self.containerView.reloadItems(at: [indexPath])
    }
    
    
    
    public lazy var containerView: UICollectionView = {
        
        let flowlayout = UICollectionViewFlowLayout.init()
        flowlayout.itemSize = self.rect.size
        flowlayout.scrollDirection = .horizontal
        flowlayout.minimumLineSpacing  = 0.0
        flowlayout.minimumInteritemSpacing = 0.0
        flowlayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //flowlayout.headerReferenceSize = CGSize.init(width: self.rect.size.width, height: 44)
        
        let collectionView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: self.rect.width, height: self.rect.height), collectionViewLayout: flowlayout)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.brown
  
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        return collectionView
    }()
}

public protocol JXHorizontalViewDelegate {
    func horizontalView(_ :JXHorizontalView,to indexPath:IndexPath) -> Void
    func horizontalViewDidScroll(scrollView:UIScrollView) -> Void
}

extension JXHorizontalView:UICollectionViewDelegate,UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if containers.count > 0 {
            return containers.count
        }
        return 0
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = containerView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if containers.count > indexPath.item {
            let v = containers[indexPath.item]
            if v is UIViewController {
                let vc = v as! UIViewController
                vc.view.frame = CGRect.init(x: 0, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
                cell.contentView.addSubview(vc.view)
                vc.didMove(toParent: parentViewController)
            }else if(v is UIView){
                let iv = v as! UIView
                iv.frame = cell.contentView.bounds
                iv.tag = 1000
                cell.contentView.addSubview(iv)
            }

        }
        
        return cell
    }
}

extension JXHorizontalView {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.delegate != nil {
            self.delegate?.horizontalViewDidScroll(scrollView: self.containerView)
        }
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let page = offset / self.frame.size.width
        let indexPath = IndexPath.init(item: Int(page), section: 0)
        
        self.containerView.reloadItems(at: [indexPath as IndexPath])
        
        if self.delegate != nil{
            self.delegate?.horizontalView(self, to: indexPath)
        }
        
    }
}
