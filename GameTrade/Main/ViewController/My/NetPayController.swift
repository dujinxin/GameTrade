//
//  NetPayController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/19.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class NetPayController: BaseViewController {

    var imagePicker : UIImagePickerController?
    var isSelected = false
    var avatar : String?
    
    var type : Int = 1
    var entity : PayEntity?
    var isEdit : Bool = false
    
    var vm = WeChatOrAliVM()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var codeImageView: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.infoLabel.textColor = JXFfffffColor
        self.submitButton.backgroundColor = UIColor.rgbColor(rgbValue: 0x9b9b9b)
        self.submitButton.setTitleColor(JXFfffffColor, for: .normal)

        self.codeImageView.isUserInteractionEnabled = true
        self.codeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(select(tap:))))
        
        if type == 1 {
            self.title = "设置支付宝"
            self.accountTextField.attributedPlaceholder = NSAttributedString(string: "请输入支付宝账号", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:JXPlaceHolerColor])
        } else {
            self.title = "设置微信"
            self.accountTextField.attributedPlaceholder = NSAttributedString(string: "请输入微信账号", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:JXPlaceHolerColor])
        }
        
        self.nameTextField.attributedPlaceholder = NSAttributedString(string: "请输入真实姓名", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:JXPlaceHolerColor])
        
        
        if isEdit {
            self.nameTextField.text = self.entity?.name
            self.accountTextField.text = self.entity?.account
        } else {
            
        }
        
        self.updateButtonStatus()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kNavStatusHeight + 20
        self.bottomConstraint.constant = kBottomMaginHeight + 20
    }
    
    @objc func select(tap: UITapGestureRecognizer) {
        self.view.endEditing(true)
        
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

    @IBAction func submit() {
        
        guard let userName = self.nameTextField.text else { return }
        guard let account = self.accountTextField.text else { return }
        
        var id = ""
        if isEdit {
            id = entity?.id ?? ""
        }
        
        if isSelected, let image = self.codeImageView.image{
            let ss = UIImage.insert(image: image, name: "userImage.jpg")
            print("sssssssssssssssssssssssssss",ss)
        }
        self.showMBProgressHUD()
        self.vm.editPay(id: id, type: type, account: account, name: userName) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            ViewManager.showNotice(msg)
            let _ = UIImage.delete(name: "userImage.jpg")
            if isSuc {
                if let block = self.backBlock {
                    block()
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func showImagePickerViewController(_ sourceType:UIImagePickerControllerSourceType) {
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
extension NetPayController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        if mediaType == "public.image"{
            let image = info[UIImagePickerControllerEditedImage] as? UIImage
            //UIImage.image(originalImage: image, to: view.bounds.width)
            self.codeImageView.image = image
            isSelected = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
extension NetPayController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    @objc func textChange(notify:NSNotification) {
        
        if notify.object is UITextField {
            self.updateButtonStatus()
        }
    }
    func updateButtonStatus() {
        if
            let name = self.nameTextField.text, name.isEmpty == false,
            let card = self.accountTextField.text, card.isEmpty == false{
            
            self.submitButton.isEnabled = true
            self.submitButton.backgroundColor = JXOrangeColor
            self.submitButton.setTitleColor(JXTextColor, for: .normal)
        } else {
            
            self.submitButton.isEnabled = false
            self.submitButton.backgroundColor = UIColor.rgbColor(rgbValue: 0x9b9b9b)
            self.submitButton.setTitleColor(UIColor.rgbColor(rgbValue: 0xb5b5b5), for: .normal)
        }
    }
}