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
    var psdText : String = ""
    
    var vm = WeChatOrAliVM()
    
    @IBOutlet weak var nameLabel: UILabel!{
        didSet{
            nameLabel.textColor = JXMainTextColor
        }
    }
    @IBOutlet weak var accountTextField: UITextField!{
        didSet{
            accountTextField.textColor = JXMainTextColor
        }
    }
    @IBOutlet weak var userContentView: UIView!{
        didSet{
            userContentView.backgroundColor = JXTextViewBgColor
        }
    }
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var codeImageView: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    lazy var keyboard: JXKeyboardToolBar = {
        let k = JXKeyboardToolBar(frame: CGRect(), views: [accountTextField])
        k.showBlock = { (height, rect) in
            print(height,rect)
        }
        k.tintColor = JXMainTextColor
        k.toolBar.barTintColor = JXViewBgColor
        k.backgroundColor = JXViewBgColor
        //k.textFieldDelegate = self
        return k
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.keyboard)
        
        self.infoLabel.textColor = JXFfffffColor
        self.submitButton.backgroundColor = JXUnableColor
        self.submitButton.setTitleColor(JXFfffffColor, for: .normal)

        self.codeImageView.isUserInteractionEnabled = true
        self.codeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(select(tap:))))
        
        
        if type == 1 {
            self.title = "设置支付宝"
            self.accountTextField.attributedPlaceholder = NSAttributedString(string: "请输入支付宝账号", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:JXPlaceHolerColor])
        } else {
            self.title = "设置微信"
            self.accountTextField.attributedPlaceholder = NSAttributedString(string: "请输入微信账号", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:JXPlaceHolerColor])
        }
        
        self.nameLabel.text = UserManager.manager.userEntity.realName
        
        
        if isEdit {
            self.accountTextField.text = self.entity?.account
            if let str = self.entity?.qrcodeImg, str.hasPrefix("http") {
                let url = URL(string: str)
                self.codeImageView.sd_setImage(with: url, completed: nil)
                self.deleteButton.isHidden = false
            } else {
                self.deleteButton.isHidden = true
            }
        } else {
            self.deleteButton.isHidden = true
        }
        
        self.updateButtonStatus()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: UITextField.textDidChangeNotification, object: nil)
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
    @IBAction func deleteImage(_ sender: Any) {
        self.codeImageView.image = UIImage(named: "img-upload")
        self.deleteButton.isHidden = true
    }
    @IBAction func submit() {
        
        guard let account = self.accountTextField.text else { return }
        var id = ""
        if isEdit {
            id = entity?.id ?? ""
        }
        
        guard let image = self.codeImageView.image, isSelected == true else {
            ViewManager.showNotice("请添加收款二维码")
            return
        }
        let ss = UIImage.insert(image: image, name: "userImage.jpg")
        print("sssssssssssssssssssssssssss",ss)
        
        self.showMBProgressHUD()
        self.vm.editPay(id: id, type: type, account: account, name: UserManager.manager.userEntity.realName, safePassword: self.psdText) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            
            let _ = UIImage.delete(name: "userImage.jpg")
            if isSuc {
                if let block = self.backBlock {
                    block()
                }
                ViewManager.showImageNotice("设置成功")
                self.navigationController?.popViewController(animated: true)
            } else {
                ViewManager.showNotice(msg)
            }
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        let mediaType = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as! String
        if mediaType == "public.image"{
            let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
            //UIImage.image(originalImage: image, to: view.bounds.width)
            self.codeImageView.image = image
            isSelected = true
            self.deleteButton.isHidden = false
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
            let card = self.accountTextField.text, card.isEmpty == false{
            
            self.submitButton.isEnabled = true
            self.submitButton.backgroundColor = JXAbleColor
            self.submitButton.setTitleColor(JXFfffffColor, for: .normal)
        } else {
            
            self.submitButton.isEnabled = false
            self.submitButton.backgroundColor = JXUnableColor
            self.submitButton.setTitleColor(UIColor.rgbColor(rgbValue: 0xb5b5b5), for: .normal)
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
