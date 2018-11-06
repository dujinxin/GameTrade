//
//  JXBarView.swift
//  FBSnapshotTestCase
//
//  Created by 杜进新 on 2018/7/25.
//

import UIKit

private let reuseIdentifier = "Cell"

@objc public protocol JXBarViewDelegate {
    func jxBarView(barView: JXBarView, didClick index: Int) -> Void
    @objc optional func jxBarView(_ : JXBarView, to indexPath: IndexPath) -> Void
    @objc optional func jxBarViewDidScroll(scrollView: UIScrollView) -> Void
}

public class JXBarView: UIView {
    
    public var titles = Array<String>()
    public var delegate : JXBarViewDelegate?
    public var selectedIndex = 0
    
    public var attribute : JXAttribute = JXAttribute() {
        didSet {
            let indexPath = IndexPath(item: self.selectedIndex, section: 0)
            self.containerView.reloadItems(at: [indexPath])
            self.scrollToItem(at: indexPath)
        }
    }
    
    public var bottomLineSize : CGSize = CGSize() {
        didSet {
            self.layoutSubviews()
        }
    }
    public var isBottomLineEnabled : Bool = false {
        didSet{
            self.bottomLineView.isHidden = !isBottomLineEnabled
        }
    }
    public lazy var bottomLineView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: self.frame.height - 1, width: 80, height: 1)
        view.backgroundColor = UIColor.darkGray
        view.isHidden = true
        return view
    }()
    public var itemSize: CGSize = CGSize(){
        didSet{
            let count = CGFloat(self.titles.count)
            if itemSize.width * count > self.bounds.width {
                self.containerView.bounces = true
                self.containerView.isScrollEnabled = true
            } else {
                self.containerView.bounces = false
                self.containerView.isScrollEnabled = false
            }
        }
    }
    public lazy var containerView: UICollectionView = {
        
        let flowlayout = UICollectionViewFlowLayout.init()
        flowlayout.scrollDirection = .horizontal
        flowlayout.minimumInteritemSpacing = 0
        flowlayout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: CGRect(origin: CGPoint(), size: CGSize(width: self.bounds.width, height: self.bounds.height)), collectionViewLayout: flowlayout)
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        return collectionView
    }()
    public init(frame: CGRect, titles: Array<String>) {
        super.init(frame: frame)

        self.titles = titles
        addSubview(self.containerView)
        addSubview(self.bottomLineView)
        
        let indexPath = IndexPath(item: self.selectedIndex, section: 0)
        self.containerView.reloadItems(at: [indexPath])
        self.scrollToItem(at: indexPath)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.frame = self.bounds
        
        var x : CGFloat
        let count = CGFloat(self.titles.count)
        if itemSize.width * count >= self.bounds.width {
            x = (itemSize.width  - self.bottomLineSize.width) / 2
        } else {
            x = (self.bounds.width / count  - self.bottomLineSize.width) / 2
        }
        self.bottomLineView.frame = CGRect(origin: CGPoint(x: x, y: self.bounds.height - self.bottomLineSize.height), size: self.bottomLineSize)
    }
    func clickItem(index: Int) {

        selectedIndex = index
        
        var x : CGFloat
        let count = CGFloat(self.titles.count)
        if itemSize.width * count >= self.bounds.width {
            x = (itemSize.width  - self.bottomLineSize.width) / 2 + itemSize.width * CGFloat(index)
        } else {
            x = (self.bounds.width / count  - self.bottomLineSize.width) / 2 + (self.bounds.width / count) * CGFloat(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomLineView.frame.origin.x = x
        }) { (finished) in
        
        }
        self.updateState(at: IndexPath(item: index, section: 0))
        if self.delegate != nil {
            self.delegate?.jxBarView(barView: self, didClick: index)
        }
    }
    public func updateState(at indexPath: IndexPath) {
        self.containerView.visibleCells.forEach { (cell) in
            if self.containerView.indexPath(for: cell) == indexPath {
                cell.isSelected = true
            } else {
                cell.isSelected = false
            }
            if let cell = cell as? ItemCell {
                cell.attribute = self.attribute
            }
        }
    }
    public func scrollToItem(at indexPath: IndexPath) {
        self.updateState(at: indexPath)
        self.containerView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
}
extension JXBarView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //DataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = containerView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ItemCell
        if titles.count > indexPath.item {
            cell.titleView.text = titles[indexPath.item]
            cell.attribute = self.attribute
        }
        return cell
    }
    //DelegateFlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.titles.count > 0 {
            let count = CGFloat(self.titles.count)
            if itemSize.width * count >= self.bounds.width {
                return itemSize
            } else {
                let size = CGSize(width: self.bounds.width / CGFloat(self.titles.count), height: self.bounds.height)
                return size
            }
        }
        return itemSize
    }
    //delegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ItemCell
        cell.attribute = attribute
        
        clickItem(index: indexPath.item)
        //delegate
        
        //block
    }
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ItemCell
        cell.attribute = attribute
    }
    //scrollView
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.delegate != nil {
            self.delegate?.jxBarViewDidScroll!(scrollView: self.containerView)
        }
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let page = offset / self.frame.size.width
        let indexPath = IndexPath.init(item: Int(page), section: 0)

        self.containerView.reloadItems(at: [indexPath as IndexPath])

        if self.delegate != nil{
            self.delegate?.jxBarView!(self, to: indexPath)
        }
    }
}
class ItemCell: UICollectionViewCell {
    lazy var titleView: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkText
        label.textAlignment = .center
        return label
    }()
    var title: String? = "" {
        didSet {
            self.titleView.text = title
        }
    }
    var attribute: JXAttribute? {
        didSet {
            if isSelected {
                self.titleView.textColor = attribute?.selectedColor
            } else {
                self.titleView.textColor = attribute?.normalColor
            }
            self.titleView.font = attribute?.font
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.addSubview(self.titleView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //self.titleView.center = self.contentView.center
        self.titleView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }
}
