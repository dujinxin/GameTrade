//
//  ModifyImageController.swift
//  Star
//
//  Created by 杜进新 on 2018/6/4.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class ModifyImageController: BaseViewController {

    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var confirmButton: UIButton!
    
    var isSelected = false
    var imageVM = ModifyImageVM()
    var avatar : String?
    
    var imagePicker : UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设置头像"
        self.customNavigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "提交", style: UIBarButtonItem.Style.plain, target: self, action: #selector(confirm))
        
        
        self.userImageView.layer.shadowOffset = CGSize(width: 0, height: 13)
        self.userImageView.layer.shadowOpacity = 1
        self.userImageView.layer.shadowRadius = 52
        self.userImageView.layer.shadowColor = JX10101aShadowColor.cgColor
        self.userImageView.layer.cornerRadius = 4
        self.userImageView.backgroundColor = JXBackColor
        
        
        self.confirmButton.setTitleColor(JXTextColor, for: .normal)
        self.confirmButton.backgroundColor = JXOrangeColor
        
        self.confirmButton.layer.cornerRadius = 2
        self.confirmButton.layer.shadowOpacity = 1
        self.confirmButton.layer.shadowRadius = 10
        self.confirmButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.confirmButton.layer.shadowColor = JX10101aShadowColor.cgColor
        
        
        
        if let str = self.avatar,let url = URL(string: str){
            self.userImageView.sd_setImage(with: url, placeholderImage: nil, options: [], progress: nil, completed: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kNavStatusHeight
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }

    @IBAction func selectImage(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "拍照", style: .default, handler: { (action) in
            self.showImagePickerViewController(.camera)
        }))
        alert.addAction(UIAlertAction(title: "相册", style: .default, handler: { (action) in
            self.showImagePickerViewController(.photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    @objc func confirm() {
        if isSelected {
            self.showMBProgressHUD()
            let _ = UIImage.insert(image: self.userImageView.image!, name: "userImage.jpg")
            self.imageVM.modifyImage(param: [:]) { (_, msg, isSuc) in
                self.hideMBProgressHUD()
                if isSuc {
                    if let block = self.backBlock {
                        block()
                    }
                    let _ = UIImage.delete(name: "userImage.jpg")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            ViewManager.showNotice("请先选择图片")
        }
    }
    
    func showImagePickerViewController(_ sourceType:UIImagePickerController.SourceType) {
        self.imagePicker = UIImagePickerController()
        imagePicker?.title = "选择照片"
//        imagePicker.navigationBar.barTintColor = UIColor.blue
        imagePicker?.navigationBar.tintColor = UIColor.black
        //print(self.imagePicker?.navigationItem.rightBarButtonItem!)
        
        imagePicker?.delegate = self
        imagePicker?.allowsEditing = true
        imagePicker?.sourceType = sourceType
        self.present(imagePicker!, animated: true, completion: nil)
    }
    @objc func hideImagePickerViewContorller(){
        self.imagePicker?.dismiss(animated: true, completion: nil)
    }
}
extension ModifyImageController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        let button = UIButton()
//        button.frame = CGRect(x: 0, y: 0, width: 44, height: 30)
//        button.setTitle("取消", for: .normal)
//        button.setTitleColor(UIColor.darkGray, for: .normal)
//        let item = UIBarButtonItem.init(customView: button)
//
//        viewController.navigationItem.rightBarButtonItem = item//UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(hideImagePickerViewContorller))
//    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        let mediaType = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as! String
        if mediaType == "public.image"{
            let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
            //UIImage.image(originalImage: image, to: view.bounds.width)
            self.userImageView.image = image
            isSelected = true
            
        }
        picker.dismiss(animated: true, completion: nil)
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
