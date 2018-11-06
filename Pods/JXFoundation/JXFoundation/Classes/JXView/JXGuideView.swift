//
//  JJXGuideView.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/7/12.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CellId"

public enum GuidePageStyle {
    case number
    case point
}

public class JXGuideView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    
    ///图片数组
    var images = Array<String>()
    ///当前页码
    public var currentPage = 0
    public var style : GuidePageStyle = .point
    public typealias DismissBlock =  ((_ guide:JXGuideView)->())?
    public var dismissBlock : DismissBlock
    
    /// 首次安装和升级安装要显示引导页
    static var isShowGuideView: Bool {
        let version = Bundle.main.version
        
        if  ///非首次安装且不是升级那么不显示
            let oldVersion = UserDefaults.standard.string(forKey: "version"),
            oldVersion == version {
            
            return false
        }else{
            UserDefaults.standard.set(version, forKey: "version")
            UserDefaults.standard.synchronize()
            
            return true
        }
    }
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = self.bounds.size
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.clear
        collection.dataSource = self
        collection.delegate = self
        
        collection.isPagingEnabled = true
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.register(GuideImageView.self, forCellWithReuseIdentifier: reuseIdentifier)
        return collection
    }()
    
    public lazy var pageLabel: UILabel = {
        let lab = UILabel()
        lab.frame = CGRect(origin: CGPoint(), size: CGSize(width: 100, height: 30))
        lab.textColor = UIColor.white
        lab.textAlignment = .center
        return lab
    }()
    public lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = UIColor.darkGray
        pc.currentPageIndicatorTintColor = UIColor.white
        pc.currentPage = 0
        pc.frame = CGRect(origin: CGPoint(), size: CGSize(width: 100, height: 20))
        return pc
    }()
    public lazy var enterButton: UIButton = {
        let button = UIButton()
        button.setTitle("进入", for: .normal)
        button.frame = CGRect(origin: CGPoint(), size: CGSize(width: 120, height: 40))
        //button.sizeToFit()
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(touchDismiss(button:)), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.isHidden = true
        return button
    }()
    
    
    public init(frame: CGRect,images: Array<String>, style: GuidePageStyle, block:DismissBlock) {
        super.init(frame: frame)
        
        self.images = images
        self.dismissBlock = block
        self.style = style

        addSubview(self.collectionView)
        addSubview(self.enterButton)
        
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } 
        self.pageControl.numberOfPages = self.images.count
        
        if style == .point {
            addSubview(self.pageControl)
        }else{
            addSubview(self.pageLabel)
        }

        self.collectionView.reloadData()
        resetPage(page: currentPage)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        enterButton.center = CGPoint(x: center.x, y: bounds.height - kTabBarHeight - 30 )
        if style == .point {
            pageControl.center = CGPoint(x: center.x, y: enterButton.jxBottom + pageControl.jxHeight / 2)
        }else{
            pageLabel.center = CGPoint(x: self.center.x, y: enterButton.jxBottom + pageLabel.jxHeight / 2)
        }
    }
    // MARK: UICollectionViewDataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GuideImageView
        
        // Configure the cell
    
        let urlStr = images[indexPath.item]
        if
            let _ = URL.init(string: urlStr),
            urlStr.hasPrefix("http"){
            cell.imageView.jx_setImage(with: urlStr, placeholderImage: nil)
        }else{
            if let path = Bundle.main.path(forResource: urlStr, ofType: nil) {//这种方式不能获取到images.xcassets中的图片
                cell.imageView.image = UIImage(contentsOfFile: path)
            }else{
                cell.imageView.image = UIImage(named: urlStr)
            }
            
        }
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
    
}
//MARK: - imageView gesture method
extension JXGuideView {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x / self.bounds.width
        currentPage = Int(offset)
        resetPage(page: currentPage)
    }
    
    func resetPage(page:Int) {
        if page == self.images.count - 1 {
            self.enterButton.isHidden = false
        }else{
            self.enterButton.isHidden = true
        }
        if style == .point {
            pageControl.currentPage = currentPage
        }else{
            pageLabel.text = "\(self.currentPage + 1)/\(self.images.count)"
        }
    }
    
    @objc func touchDismiss(button:UIButton) {
        if let block = dismissBlock {
            self.removeFromSuperview()
            block(self)
        }
    }
}

/// cell 图片视图，用于缩放和处理其他特殊事件
class GuideImageView: UICollectionViewCell{

    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        //iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView.frame = self.contentView.bounds
        self.contentView.addSubview(self.imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
