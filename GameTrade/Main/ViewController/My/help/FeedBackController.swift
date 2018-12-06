//
//  FeedBackController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/20.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import TZImagePickerController

class FeedBackController: BaseViewController, TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.backgroundColor = JXTextViewBgColor
            backView.layer.cornerRadius = 4
        }
    }
    
    @IBOutlet weak var textField: JXPlaceHolderTextView!{
        didSet{
            textField.placeHolderText = "填写您的问题"
            textField.textColor = JXMainTextColor
            textField.delegate = self
        }
    }
    @IBOutlet weak var uploadImageView: JXUploadImageView!{
        didSet{
            uploadImageView.leadingTrailingMargin = 0
            uploadImageView.topMargin = 0
            uploadImageView.bottomMargin = 15
            uploadImageView.imageEdgeInsets = UIEdgeInsets.init(top: 15, left: 0, bottom: 0, right: 15)
            
            uploadImageView.updateConstraintsIfNeeded()
            
            //self.uploadImageView.leftImageView.backgroundColor = UIColor.red
            //self.uploadImageView.leftImageView.image = UIImage(named: "img-upload")
            uploadImageView.imageTitle = "img-upload"
            uploadImageView.deleteImage = "icon-delete"
            uploadImageView.style = .edit
            uploadImageView.backgroundColor = UIColor.clear
            
            uploadImageView.selectImagesBlock = { index in
                
                let alert = UIAlertController(title: "图片选择", message: nil, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "从相册中选择（最多三张）", style: .destructive, handler: { (alertAction) in
                    self.selectAlbumImage()
                }))
                alert.addAction(UIAlertAction(title: "拍照", style: .destructive, handler: { (alertAction) in
                    self.takePhotoImage()
                }))
                alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (alertAction) in
                    //
                }))
                self.present(alert, animated: true, completion: {
                    //
                })
            }
            uploadImageView.deleteImagesBlock = { index in
                //
                self.imageDataArray.remove(at: index)
            }
        }
    }
    @IBOutlet weak var submitButton: UIButton!{
        didSet{
            submitButton.isEnabled = false
            submitButton.setTitleColor(UIColor.rgbColor(rgbValue: 0xb5b5b5), for: .normal)
            submitButton.backgroundColor = UIColor.rgbColor(rgbValue: 0x9b9b9b)
            
            submitButton.layer.cornerRadius = 2
            submitButton.layer.shadowOpacity = 1
            submitButton.layer.shadowRadius = 10
            submitButton.layer.shadowOffset = CGSize(width: 0, height: 10)
            submitButton.layer.shadowColor = JX10101aShadowColor.cgColor
        }
    }
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    var completion : ((Dictionary<String,Any>)->())?
    
    var imageDataArray = Array<Data>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "提交反馈"
       
        
        NotificationCenter.default.addObserver(self, selector: #selector(placeHolderTextChange(nofiy:)), name: UITextView.textDidChangeNotification, object: nil)
    }
    override func updateViewConstraints() {
        
        self.topConstraint.constant = kNavStatusHeight + 24
        self.bottomConstraint.constant = kBottomMaginHeight + 20
        
        super.updateViewConstraints()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
        self.removeObserver(self, forKeyPath: "text")
    }
    @IBAction func submit() {
        print("send")
        self.showMBProgressHUD()
        for i in 0..<self.imageDataArray.count {
            let _ = FileManager.insert(data: self.imageDataArray[i], toFile: "photo\(i + 1).jpg")
        }
        let vm = FeedBackVM()
        vm.feedBack(param: ["content":self.textField.text!]) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            ViewManager.showNotice(msg)
            for i in 0..<self.imageDataArray.count {
                let _ = FileManager.delete(fromFile: "photo\(i + 1).jpg")
            }
            if isSuc {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    func selectAlbumImage() {
        
        var imageArray = self.uploadImageView.imageArray ?? Array<Any>()
        
        
        let imagePickerVC = TZImagePickerController.init(maxImagesCount: 3 - (self.uploadImageView.imageArray?.count)!, delegate: self)
        imagePickerVC?.allowTakePicture = false
        imagePickerVC?.allowPickingImage = true
        imagePickerVC?.allowPickingOriginalPhoto = true
        imagePickerVC?.sortAscendingByModificationDate = true
        
        imagePickerVC?.didFinishPickingPhotosHandle = { (images, assets, isSelectOriginalPhoto) -> () in
            
            if let images = images {
                images.forEach({ (image) in
                    imageArray.append(image)
                })
                self.uploadImageView.imageArray = imageArray
            }
            
            for asset in assets! {
                
                PHImageManager.default().requestImageData(for: asset as! PHAsset, options: nil, resultHandler: { (data, uti, orientation, dict) in
                    
                    guard let data = data else{
                        return
                    }
                    //成功后才加入。。。待完善    请求失败时与外部的image数组不同步
                    self.imageDataArray.append(data)
                    
                    if data.count > 5 * 1024 * 1024 {
                        print("图片大于5M")
                    }
                })
            }
        }
        self.present(imagePickerVC!, animated: true, completion: nil)
    }
    func takePhotoImage() {
        let vc = UIImagePickerController.init()
        vc.delegate = self
        vc.sourceType = .camera
        self.present(vc, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        let newImage = UIImage.image(originalImage: image, to: UIScreen.main.bounds.width)
        
        if let im = newImage {
            self.uploadImageView.imageArray?.append(im)
            
            if let data = im.jpegData(compressionQuality: 0.01){
                self.imageDataArray.append(data)
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension FeedBackController : UITextViewDelegate,UITextFieldDelegate{
    
    //MARK:UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //限制字数不可以限制回车，删除键，所以要优先响应，然后再限制
        //删除键
        if text == "" {
            return true
        }
        //return键 收键盘
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        //限制输入字符数
        if let string = textView.text, string.count >= 200 {
            textView.text = String(string.prefix(upTo: string.index(string.startIndex, offsetBy: 200)))
            //textView.text = string.substring(to: string.index(string.startIndex, offsetBy: 500))
            ViewManager.showNotice("字符个数不能大于\(200)")
            return false
        }
        return true
    }
    
    /// 添加通知，是为了确保用户修改值时placeHolder正常显示
    @objc func placeHolderTextChange(nofiy:Notification) {
        
        if self.textField.text.isEmpty == true {
            self.submitButton.isEnabled = false
            self.submitButton.setTitleColor(UIColor.rgbColor(rgbValue: 0xb5b5b5), for: .normal)
            self.submitButton.backgroundColor = UIColor.rgbColor(rgbValue: 0x9b9b9b)
        }else{
            self.submitButton.isEnabled = true
            self.submitButton.setTitleColor(JXFfffffColor, for: .normal)
            self.submitButton.backgroundColor = JXMainColor
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
