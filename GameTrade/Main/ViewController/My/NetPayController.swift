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
    
    
    var psdTextView : PasswordTextView!
    lazy var statusBottomView: JXSelectView = {
        let selectView = JXSelectView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 200), style: JXSelectViewStyle.custom)
        selectView.isBackViewUserInteractionEnabled = false
        
        return selectView
    }()
    
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
        
        guard let _ = self.nameTextField.text else { return }
        guard let _ = self.accountTextField.text else { return }
        
        self.statusBottomView.customView = self.customViewInit()
        self.statusBottomView.show(inView: self.view)
        self.psdTextView.textField.becomeFirstResponder()
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
extension NetPayController {
    func customViewInit() -> UIView {
        
        let width : CGFloat = kScreenWidth - 48
        
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 442)
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 442 + kBottomMaginHeight)
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        
        
        let topBarView1 = { () -> UIView in
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 60))
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
            //label.center = view.center
            label.text = "输入资金密码"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18)
            label.textColor = JXFfffffColor
            view.addSubview(label)
            //label.sizeToFit()
            
            let button = UIButton()
            button.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
            //button.center = CGPoint(x: 30, y: view.jxCenterY)
            //button.setTitle("×", for: .normal)
            button.tintColor = JXFfffffColor
            button.setImage(UIImage(named: "Close")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button.setTitleColor(JX333333Color, for: .normal)
            button.contentVerticalAlignment = .center
            button.contentHorizontalAlignment = .center
            button.addTarget(self, action: #selector(closeStatus), for: .touchUpInside)
            view.addSubview(button)
            
            
            let button1 = UIButton()
            button1.frame = CGRect(x: kScreenWidth - 80 - 24, y: 10, width: 80, height: 40)
            //button.center = CGPoint(x: 30, y: view.jxCenterY)
            button1.setTitle("忘记密码？", for: .normal)
            
            button1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button1.setTitleColor(JXOrangeColor, for: .normal)
            button1.contentVerticalAlignment = .center
            button1.contentHorizontalAlignment = .right
            button1.addTarget(self, action: #selector(forgotPsd), for: .touchUpInside)
            view.addSubview(button1)
            
            return view
        }()
        contentView.addSubview(topBarView1)
        
        
        self.psdTextView = PasswordTextView(frame: CGRect(x: (kScreenWidth - 176) / 2, y: topBarView1.jxBottom, width: 176, height: 60))
        //psdTextView.textField.delegate = self
        psdTextView.backgroundColor = UIColor.white //要先设置颜色，再设置透明，不然不起作用，还有绘制的问题，待研究
        contentView.addSubview(psdTextView)
        
        psdTextView.backgroundColor = UIColor.clear
        psdTextView.limit = 4
        psdTextView.bottomLineColor = JXSeparatorColor
        psdTextView.textColor = JXFfffffColor
        psdTextView.font = UIFont.systemFont(ofSize: 42)
        psdTextView.completionBlock = { (text,isFinish) -> () in
            
            if isFinish {
                self.closeStatus()
                self.confirm(psd: text)
            }
        }
        
        return contentView
    }
    @objc func forgotPsd() {
        let storyboard = UIStoryboard(name: "My", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "modifyTradePsw") as! ModifyTradePswController
        vc.hidesBottomBarWhenPushed = true
        vc.type = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func closeStatus() {
        self.statusBottomView.dismiss()
    }
    
    func confirm(psd: String) {
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
        self.vm.editPay(id: id, type: type, account: account, name: userName, safePassword: psd) { (_, msg, isSuc) in
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
}
