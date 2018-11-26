//
//  JXUploadImageView.swift
//  JXUploadImageView
//
//  Created by 杜进新 on 2017/8/1.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit

enum Style {
    case normal
    case edit
}

class JXUploadImageView: UIView {

    var leadingTrailingMargin : CGFloat = 20
    var topMargin : CGFloat = 20
    var bottomMargin : CGFloat = 20
    var imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0) {
        didSet{
            self.leftImageView.imageEdgeInsets = imageEdgeInsets
            self.centerImageView.imageEdgeInsets = imageEdgeInsets
            self.rightImageView.imageEdgeInsets = imageEdgeInsets
        }
    }
    var buttonSize = CGSize(width: 30, height: 30) {
        didSet{
            self.leftImageView.buttonSize = buttonSize
            self.centerImageView.buttonSize = buttonSize
            self.rightImageView.buttonSize = buttonSize
        }
    }
    
    private var spaceWidth : CGFloat = 0
    private var addImage: UIImage?
    
    var imageTitle: String? = "img-upload" {
        didSet{
            self.addImage = UIImage(named: imageTitle ?? "")
            
            self.leftImageView.defaultImage = imageTitle
            self.centerImageView.defaultImage = imageTitle
            self.rightImageView.defaultImage = imageTitle
        }
    }
    var deleteImage: String? = "icon-delete" {
        didSet{
            self.leftImageView.deleteImage = deleteImage
            self.centerImageView.deleteImage = deleteImage
            self.rightImageView.deleteImage = deleteImage
        }
    }
    
    lazy var leftImageView: UploadImageView = {
        let view = UploadImageView(frame: CGRect())
        view.tag = 0
        
        view.deleteButton.tag = view.tag
        view.deleteButton.addTarget(self, action: #selector(deleteButtonClick(button:)), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick(tap:)))
        view.imageView.addGestureRecognizer(tap)
        return view
    }()
    lazy var centerImageView: UploadImageView = {
        let view = UploadImageView(frame: CGRect())
        view.tag = 1
        
        view.deleteButton.tag = view.tag
        view.deleteButton.addTarget(self, action: #selector(deleteButtonClick(button:)), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick(tap:)))
        view.imageView.addGestureRecognizer(tap)
        return view
    }()
    lazy var rightImageView: UploadImageView = {
        let view = UploadImageView(frame: CGRect())
        view.tag = 2
        
        view.deleteButton.tag = view.tag
        view.deleteButton.addTarget(self, action: #selector(deleteButtonClick(button:)), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick(tap:)))
        view.imageView.addGestureRecognizer(tap)
        return view
    }()
    
    var style: Style = .normal {
        didSet{
            if style == .normal {
                
            } else {
                self.leftImageView.isHidden = false
                self.leftImageView.imageView.image = addImage
                
                self.leftImageView.style = style
                self.centerImageView.style = style
                self.rightImageView.style = style
            }
        }
    }
    var imageArray: Array<Any>? = Array(){
        didSet{
            self.handleImageArray(array: imageArray)
        }
    }
    /// 选择图片闭包
    var selectImagesBlock : ((_ index:Int)->())?
    /// 删除图片闭包
    var deleteImagesBlock : ((_ index:Int)->())?
    /// 图片点击闭包
    var clickImageBlock: ((_ index:Int,_ imageArray:Array<Any>?)->())?
    
    
    convenience init() {
        self.init()
        addSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
        //fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        self.layoutSubViews()
        super.layoutSubviews()
    }
    override func updateConstraints() {
        self.layoutSubViews()
        super.updateConstraints()
    }
    func addSubviews() {
        
        self.addSubview(self.leftImageView)
        self.addSubview(self.centerImageView)
        self.addSubview(self.rightImageView)
        
        self.subviews.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    func layoutSubViews() {
        let sideLength = frame.height - (topMargin + bottomMargin)
        self.spaceWidth = (frame.width - leadingTrailingMargin * 2 - sideLength * 3) / 2
        
        //leftImageView
        addConstraint(NSLayoutConstraint(item: self.leftImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: leadingTrailingMargin))
        addConstraint(NSLayoutConstraint(item: self.leftImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: topMargin))
        addConstraint(NSLayoutConstraint(item: self.leftImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: sideLength))
        addConstraint(NSLayoutConstraint(item: self.leftImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: sideLength))
        
        
        //centerImageView
        addConstraint(NSLayoutConstraint(item: self.centerImageView, attribute: .leading, relatedBy: .equal, toItem: self.leftImageView, attribute: .trailing, multiplier: 1.0, constant: spaceWidth))
        addConstraint(NSLayoutConstraint(item: self.centerImageView, attribute: .top, relatedBy: .equal, toItem: self.leftImageView, attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: self.centerImageView, attribute: .height, relatedBy: .equal, toItem: self.leftImageView, attribute: .height, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: self.centerImageView, attribute: .width, relatedBy: .equal, toItem: self.leftImageView, attribute: .width, multiplier: 1.0, constant: 0))
        
        
        //rightImageView
        addConstraint(NSLayoutConstraint(item: self.rightImageView, attribute: .leading, relatedBy: .equal, toItem: self.centerImageView, attribute: .trailing, multiplier: 1.0, constant: spaceWidth))
        addConstraint(NSLayoutConstraint(item: self.rightImageView, attribute: .top, relatedBy: .equal, toItem: self.leftImageView, attribute: .top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: self.rightImageView, attribute: .height, relatedBy: .equal, toItem: self.leftImageView, attribute: .height, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: self.rightImageView, attribute: .width, relatedBy: .equal, toItem: self.leftImageView, attribute: .width, multiplier: 1.0, constant: 0))
    }
    func handleImageString(imageString:String?) {
        let array = imageString?.components(separatedBy: ",")
        self.imageArray = array
        //handleImageArray(array: array)
    }
    private func handleImageArray(array:Array<Any>?) {
        clearSubViews()
        guard
            let array = array
            else {
                
                return
        }
        
        if style == .normal {
            if array.isEmpty == true {
                return
            }
            leftImageView.setImageInfo(isHidden: false, image: array.first)
            switch array.count {
            case 1:
                ()
            case 2:
                centerImageView.setImageInfo(isHidden: false, image: array[1])
            default:
                centerImageView.setImageInfo(isHidden: false, image: array[1])
                rightImageView.setImageInfo(isHidden: false, image: array[2])
            }
        } else {
            switch array.count {
            case 0:
                leftImageView.setImageInfo(isHidden: false, image: nil)
            case 1:
                leftImageView.setImageInfo(isHidden: false, image: array.first)
                centerImageView.setImageInfo(isHidden: false, image: nil)
            case 2:
                leftImageView.setImageInfo(isHidden: false, image: array.first)
                centerImageView.setImageInfo(isHidden: false, image: array[1])
                rightImageView.setImageInfo(isHidden: false, image: nil)
                
            default:
                leftImageView.setImageInfo(isHidden: false,image: array.first)
                centerImageView.setImageInfo(isHidden: false, image: array[1])
                rightImageView.setImageInfo(isHidden: false, image: array[2])
                
            }
        }
    }
    private func clearSubViews(){
        self.subviews.forEach { (view) in
            if view is UploadImageView{
                let v = view as! UploadImageView
                v.clearSubViews()
            }
        }
    }
    @objc private func tapClick(tap: UITapGestureRecognizer) {
        if style == .normal {
            if
                let clickImageBlock = clickImageBlock,
                let index = tap.view?.tag
            {
                clickImageBlock(index,imageArray)
            }
        } else {
            if
                let selectImagesBlock = selectImagesBlock,
                let index = tap.view?.tag
            {
                selectImagesBlock(index)
            }
        }
        
    }
    @objc private func deleteButtonClick(button:UIButton) {
        self.imageArray?.remove(at: button.tag)
        if
            let deleteImagesBlock = deleteImagesBlock
        {
            deleteImagesBlock(button.tag)
        }
    }
}

class UploadImageView : UIView {
    
    var imageEdgeInsets = UIEdgeInsets.init(top: 15, left: 15, bottom: 15, right: 15)
    var buttonSize = CGSize(width: 30, height: 30)
    var defaultImage : String?
    var deleteImage : String? {
        didSet{
            self.deleteButton.setImage(UIImage(named:deleteImage ?? ""), for: .normal)
        }
    }
    
    var style: Style = .normal
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect())
        imageView.tag = 0
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"icon-delete"), for: .normal)
        button.isHidden = true
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        isUserInteractionEnabled = true
        contentMode = .scaleToFill
        isHidden = true
        
        addSubview(self.imageView)
        addSubview(self.deleteButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = CGRect(x: imageEdgeInsets.left, y: imageEdgeInsets.top, width: frame.size.width - imageEdgeInsets.left - imageEdgeInsets.right, height: frame.size.height - imageEdgeInsets.top - imageEdgeInsets.bottom)
        self.deleteButton.frame = CGRect(x: frame.size.width - buttonSize.width, y: 0, width: buttonSize.width, height: buttonSize.height)
    }
    func clearSubViews() {
        self.subviews.forEach { (view) in
            if view is UIImageView{
                let v = view as! UIImageView
                v.image = nil
            }
        }
    }
    func setImageInfo(isHidden: Bool, image: Any?) {
        self.isHidden = isHidden
        ///有图片，并且只有在编辑状态下才显示删除按钮
        if let image = image {
            self.imageView.jx_setImage(obj: image)
            self.deleteButton.isHidden = (self.style == .normal)
        } else {
            self.imageView.jx_setImage(obj: defaultImage)
            self.deleteButton.isHidden = true
        }
        
    }
}
