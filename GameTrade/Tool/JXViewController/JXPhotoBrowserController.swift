//
//  JXPhotoBrowserController.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/7/7.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "Cell"

class JXPhotoBrowserController: UICollectionViewController {
    
    ///图片数组
    var images = Array<String>()
    ///当前页码
    var currentPage = 0
    
    lazy var pageLabel: UILabel = {
        let lab = UILabel()
        lab.frame = CGRect(origin: CGPoint(), size: CGSize(width: 100, height: 30))
        lab.textColor = UIColor.white
        lab.textAlignment = .center
        return lab
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
//        images = [
//            "http://img.izheng.org/d879ec5f-43dc-4860-ba35-ca63c974a83b",
//            "http://img.izheng.org/e0cc9b48-aaad-47a4-bc0b-1133189b148d",
//            "http://img.izheng.org/be2c15bb-d877-4580-802e-57e2252c4600",
//            "http://img.izheng.org/2017-07-08_uwbkzimk.png",
//            "http://img.izheng.org/2017-07-08_uzhmpsrc.png"
//        ]
        
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = view.bounds.size
        layout.scrollDirection = .horizontal

        self.collectionView?.collectionViewLayout = layout
        self.collectionView?.isPagingEnabled = true
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView!.register(PhotoImageView.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
        
        view.addSubview(self.pageLabel)
        
        pageLabel.center = CGPoint(x: view.center.x, y: view.bounds.height - 80)
        pageLabel.text = "\(self.currentPage + 1)/\(self.images.count)"
        

        //显示默认设置的页码
        self.collectionView?.scrollToItem(at: IndexPath.init(item: currentPage, section: 0), at: .left, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoImageView
    
        // Configure the cell
        cell.imageView.backgroundColor = UIColor.randomColor
        
        let urlStr = images[indexPath.item]
        if let url = URL.init(string: urlStr),urlStr.hasPrefix("http"){
            cell.imageView.sd_setImage(with: url, placeholderImage: nil)
        }else{
            cell.imageView.image = UIImage(named: urlStr)
        }
        cell.closeBlock = {
            self.dismiss(animated: true, completion: nil)
        }
        cell.showAddtionBlock = {
            let actionVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionVC.addAction(UIAlertAction(title: "保存图片", style: .destructive, handler: { (action) in
                //UIImage.save(image: cell.imageView.image!, completion: nil)
                UIImageWriteToSavedPhotosAlbum(cell.imageView.image!, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
                
//                UIImage.saveImage(image: cell.imageView.image!, isAlbum: false, completion: { (isSuccess, msg) in
//                    print("msg:\(msg)")
//                })
                
            }))
            actionVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                
            }))
            self.present(actionVC, animated: true, completion: nil)
        }
    
        return cell
    }
    @objc func image(image:UIImage,didFinishSavingWithError error:Error?,contextInfo:AnyObject?) {
        if error == nil {
            //
            print("保存成功")
        }else{
            print("保存失败:\(String(describing: error?.localizedDescription))")
        }
    }
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? PhotoImageView {
            cell.scrollView.zoomScale = 1.0
        }
    }

}
extension JXPhotoBrowserController {
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x / view.bounds.width
        currentPage = Int(offset)
        pageLabel.text = "\(self.currentPage + 1)/\(self.images.count)"
    }
    
}

/// cell 图片视图，用于缩放和处理其他特殊事件
class PhotoImageView: UICollectionViewCell,UIScrollViewDelegate {

    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.minimumZoomScale = 1.0
        scroll.maximumZoomScale = 3.0 //不设置范围，缩放不起作用
        scroll.delegate = self
        return scroll
    }()
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFit
        
        //单击事件：用于显示或隐藏导航栏，或者退出图片浏览
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(tapZoomScale(tap:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        iv.addGestureRecognizer(doubleTap)
        //双击事件：用于图片放大显示
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDismiss(tap:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        singleTap.require(toFail: doubleTap)//单击事件需要双击事件失败才响应，不然优先响应双击
        iv.addGestureRecognizer(singleTap)
        //缩放：图片的放大或者缩小
        let pan = UIPinchGestureRecognizer(target: self, action: #selector(pinchZoonScale(pinch:)))
        iv.addGestureRecognizer(pan)
        //长按事件：弹出视图。类似保存到相册，分享等
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(pressAction(press:)))
        iv.addGestureRecognizer(longPress)
        return iv
    }()
    
    /// 关闭closure
    var closeBlock : (()->())?
    /// addtion closure
    var showAddtionBlock : (()->())?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        
        self.scrollView.frame = self.contentView.bounds
        self.imageView.frame = self.scrollView.bounds
        
        self.scrollView.addSubview(self.imageView)
        self.contentView.addSubview(self.scrollView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - imageView gesture method
    /// 收起
    ///
    /// - Parameter tap: 单击
    @objc func tapDismiss(tap:UITapGestureRecognizer) {
        
        if let block = closeBlock {
            block()
        }
    }
    /// 缩放
    ///
    /// - Parameter tap: 双击
    @objc func tapZoomScale(tap:UITapGestureRecognizer) {
        //
        UIView.animate(withDuration: 0.3, animations: { 
            if self.scrollView.zoomScale == 1.0 {
                self.scrollView.zoomScale = 3.0
            }else {
                self.scrollView.zoomScale = 1.0
            }
        }) { (finished) in
            //
        }
    }
    /// 缩放
    ///
    /// - Parameter pinch: pinch gesture
    @objc func pinchZoonScale(pinch:UIPinchGestureRecognizer) {
        var size = pinch.view?.frame.size
        size?.width *= pinch.scale
        size?.height *= pinch.scale
        self.scrollView.bounds.size = size!
    }
    /// 长按
    ///
    /// - Parameter press: press gesture
    @objc func pressAction(press:UILongPressGestureRecognizer) {
        //print("long press")
        switch press.state {
        case .began:
            print("long press begin")
        case .ended:
            print("long press ended")
            if let block = showAddtionBlock {
                block()
            }
        case .cancelled:
            print("long press cancelled")
        case .failed:
            print("long press failed")
        case .possible:
            print("long press possible")
        default://.changed 会调用多次
            break
        }
    }
    //MARK:- iamgeView zooming Scale
    /// 获取要缩放的视图
    ///
    /// - Parameter scrollView: scrollview
    /// - Returns: 要缩放的视图
    @objc func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
        var centerX = scrollView.center.x
        var centerY = scrollView.center.y
        centerX = scrollView.contentSize.width > scrollView.frame.size.width ?
            scrollView.contentSize.width/2:centerX
        centerY = scrollView.contentSize.height > scrollView.frame.size.height ?
            scrollView.contentSize.height/2:centerY
        print(centerX,centerY)
        self.imageView.center = CGPoint(x: centerX, y: centerY)
    }
}
