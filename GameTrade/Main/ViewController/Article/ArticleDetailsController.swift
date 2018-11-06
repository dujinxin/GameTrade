//
//  ArticleDetailsController.swift
//  Star
//
//  Created by 杜进新 on 2018/5/30.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import WebKit

private let additionalBottomHeight : CGFloat = (deviceModel == .iPhoneX) ? 34 : 0
private let bottomInputViewHeight : CGFloat = 60 + additionalBottomHeight

class ArticleDetailsController: BaseViewController,UITableViewDelegate,UITableViewDataSource,JXInputTextViewDelegate,UIScrollViewDelegate {

    let articleVM = ArticleVM()
    var articleEntity : ArticleEntity?
    
    var page : Int = 1

    let commentVM = CommentVM()
    
    var articleLiked : Bool = false
    var articleLikes : Int = 0
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomInputView: BottomInputView!
    @IBOutlet weak var bottomConstraintsHeight: NSLayoutConstraint!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var priseLabel: UILabel!
    @IBOutlet weak var priseButton: UIButton!
    @IBOutlet weak var checkChain: UIButton!
    
    @IBOutlet weak var actionButton: UIButton!
    
    var navigationBar : UIView?
    var backgroundView : UIView?
    var titleView : UILabel?
    var leftItem : UIButton?
    
    lazy var processView: UIProgressView = {
        let process = UIProgressView()
        process.progressTintColor = UIColor.blue
        process.progress = 0.0
        return process
    }()
    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        //初始化偏好设置属性：preferences
        let preferences = WKPreferences()
        config.preferences = preferences
        //The minimum font size in points default is 0
        config.preferences.minimumFontSize = 10
        //是否支持JavaScript
        config.preferences.javaScriptEnabled = true
        //不通过用户交互，是否可以打开窗口
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        //通过JS与webView内容交互
        let userContentController = WKUserContentController()
        config.userContentController = userContentController
        // 注入JS对象名称senderModel，当JS通过senderModel来调用时，我们可以在WKScriptMessageHandler代理中接收到
        let web = WKWebView(frame: CGRect(), configuration: config)
        
        //web.uiDelegate = self
        web.navigationDelegate = self
        
        return web
    }()
    lazy var headerView: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight + 40)
        v.addSubview(self.webView)
        v.addSubview(self.infoLabel)
        v.addSubview(self.readLabel)
        for v in v.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        v.addConstraints([NSLayoutConstraint.init(item: self.infoLabel,
                                                attribute: .left,
                                                relatedBy: .equal,
                                                toItem: v,
                                                attribute: .left,
                                                multiplier: 1.0,
                                                constant: 20),
                        NSLayoutConstraint.init(item: self.infoLabel,
                                                attribute: .bottom,
                                                relatedBy: .equal,
                                                toItem: v,
                                                attribute: .bottom,
                                                multiplier: 1.0,
                                                constant: -10),
                        NSLayoutConstraint.init(item: self.infoLabel,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: nil,//没有参照物
                            attribute: .notAnAttribute,//没有参照物
                            multiplier: 1.0,
                            constant: 20),
                        NSLayoutConstraint.init(item: self.infoLabel,
                                                attribute: .width,
                                                relatedBy: .equal,
                                                toItem: nil,//没有参照物
                            attribute: .notAnAttribute,//没有参照物
                            multiplier: 1.0,
                            constant: 240)])
        v.addConstraints([NSLayoutConstraint.init(item: self.readLabel,
                                                  attribute: .left,
                                                  relatedBy: .equal,
                                                  toItem: self.infoLabel,
                                                  attribute: .right,
                                                  multiplier: 1.0,
                                                  constant: 10),
                          NSLayoutConstraint.init(item: self.readLabel,
                                                  attribute: .right,
                                                  relatedBy: .equal,
                                                  toItem: v,
                                                  attribute: .right,
                                                  multiplier: 1.0,
                                                  constant: -20),
                          NSLayoutConstraint.init(item: self.readLabel,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,//没有参照物
                            attribute: .notAnAttribute,//没有参照物
                            multiplier: 1.0,
                            constant: 20),
                          NSLayoutConstraint.init(item: self.readLabel,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: v,
                                                  attribute: .bottom,
                                                  multiplier: 1.0,
                                                  constant: -10),])
        return v
    }()
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 20, y: self.webView.jxBottom + 10, width: 220, height: 20)
        label.textColor = UIColor.rgbColor(from: 160, 160, 160)
        label.text = "声明：本文数据已被IPXE区块链记录！"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        return label
    }()
    lazy var readLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: self.webView.jxBottom + 10, width: kScreenWidth - self.infoLabel.jxRight - 20, height: 20)
        label.textColor = UIColor.rgbColor(from: 160, 160, 160)
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "详情"
        
        self.customNavigationBar.removeFromSuperview()
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "imgBack"), for: .normal)
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(5, 9, 5, 9)
        //leftButton.setTitle("up", for: .normal)
        leftButton.addTarget(self, action: #selector(backTo), for: .touchUpInside)
        
        self.navigationBar = self.setClearNavigationBar(title: "文章详情", leftItem: leftButton)
        self.view.addSubview(navigationBar!)
        
        //self.tableView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - bottomInputViewHeight)
        self.tableView.contentInset = UIEdgeInsetsMake(kNavStatusHeight, 0, 0, 0)
        //self.tableView.addSubview(self.navigationBar!)
        
        if #available(iOS 11.0, *) {
            self.tableView?.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
 
        self.priseButton.setImage(UIImage(named: "iconHeartNormal"), for: .normal)
        self.priseButton.setImage(UIImage(named: "iconHeartSelected"), for: .selected)
        
        
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.checkChain.jxWidth, height: self.checkChain.jxHeight)
        gradientLayer.cornerRadius = 15
        self.checkChain.layer.addSublayer(gradientLayer)
        
        guard let articleId = self.articleEntity?.id else { return }
        guard let articleHashIndex = self.articleEntity?.artHashIndex else { return }
        
        self.tableView?.estimatedRowHeight = 126
        self.tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.page += 1
            self.request(page: self.page)
        })
        
        self.bottomConstraintsHeight.constant = bottomInputViewHeight
        
        self.webView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: self.tableView.bounds.height )
        //self.webView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 3 * bottomInputViewHeight)
        self.webView.scrollView.isScrollEnabled = false
        self.webView.scrollView.bounces = false
        self.webView.scrollView.delegate = self
        
        
        self.processView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 2)
        view.addSubview(self.processView)
        
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webView.scrollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        
        self.showMBProgressHUD()
        //self.webView.load(URLRequest(url: URL(string: "https://www.jianshu.com/p/0b781b423170")!))
        if let str = self.articleEntity?.cdnUrl,let url = URL(string: str) {
            self.webView.load(URLRequest(url: url))
        }
        self.tableView.tableHeaderView = self.headerView
   
        self.articleVM.articleDetails(articleId, articleHash: articleHashIndex) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            if isSuc {
                self.articleLiked = self.articleVM.articleDetailsEntity.like
                self.priseButton.isSelected = self.articleVM.articleDetailsEntity.like
                self.articleLikes = self.articleVM.articleDetailsEntity.article.likes
                self.priseLabel.text = "\(self.articleVM.articleDetailsEntity.article.likes)"
                self.readLabel.text = "阅读\(self.articleVM.articleDetailsEntity.article.views)"
                if self.articleVM.articleDetailsEntity.like == true {
                    self.priseLabel.textColor = UIColor.rgbColor(from: 251, 74, 88)
                } else {
                    self.priseLabel.textColor = UIColor.rgbColor(from: 160, 160, 160)
                }
            }
        }
        self.request(page: self.page)
        
//        CommonManager.countDown(timeOut: 1, timeInterval: 30, process: { (n) in
//            print("开始计时")
//        }) {
//            print("计时结束")
////            self.articleVM.articleRead("", completion: { (_, msg, isSuc) in
////                //
////            })
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .default
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.articleVM.articleDetailsEntity.like != self.articleLiked {
            guard let id = self.articleEntity?.id ,let artHashIndex = self.articleEntity?.artHashIndex else {
                return
            }
            self.articleVM.articleLike(id, artHashIndex: artHashIndex, status: self.articleLiked == true ? 2 : 1, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kStatusBarHeight
    }
    deinit {
        self.webView.scrollView.removeObserver(self, forKeyPath: "contentSize")
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "getParames")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationLocatedStatus), object: nil)
    }
    func setClearNavigationBar(title:String,leftItem:UIView,rightItem:UIView? = nil) -> UIView {
        
        let navigiationBar = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavStatusHeight))
        navigationBar?.backgroundColor = UIColor.clear
        
        self.backgroundView = UIView(frame: navigiationBar.bounds)
        self.backgroundView?.backgroundColor = UIColor.white
        
        self.titleView = UILabel(frame: CGRect(x: 80, y: kStatusBarHeight, width: kScreenWidth - 160, height: 44))
        titleView?.text = title
        titleView?.textColor = UIColor.black
        titleView?.textAlignment = .center
        titleView?.font = UIFont.systemFont(ofSize: 17)
        
        self.leftItem = leftItem as? UIButton
        self.leftItem?.frame = CGRect(x: 10, y: kStatusBarHeight + 7, width: 30, height: 30)
        self.leftItem?.setTitleColor(UIColor.black, for: .normal)
        self.leftItem?.setImage(UIImage(named: "imgBack")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.leftItem?.tintColor = UIColor.black
        
        navigiationBar.addSubview(self.backgroundView!)
        navigiationBar.addSubview(self.titleView!)
        
        navigiationBar.addSubview(self.leftItem!)
        if let right = rightItem {
            right.frame = CGRect(x: kScreenWidth - 10 - 30, y: kStatusBarHeight + 7, width: 30, height: 30)
            navigiationBar.addSubview(right)
        }
        return navigiationBar
        
    }
    @objc func backTo() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func showInputView() {
        let inputTextView = JXInputTextView(frame: CGRect(x: 0, y: self.tableView.frame.height, width: view.bounds.width, height: 60), style: .hidden, completion:nil)
        inputTextView.sendBlock = { (_,object) in
            self.commentVM.comment(object as! String, articleHash: (self.articleEntity?.artHashIndex)!, articleId: (self.articleEntity?.id)!, completion: { (_, msg, isSuc) in
                ViewManager.showNotice(msg)
                if isSuc {
                    self.page = 1
                    self.request(page: self.page)
                }
            })
        }
        inputTextView.cancelBlock = { (_,_) in
            
        }
        inputTextView.limitWords = 255
        inputTextView.placeHolder = "请输入您的回复内容"
        inputTextView.useTopBar = true
        inputTextView.show()
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentSize" {
            if
                let change = change,
                let sizeValue = change[NSKeyValueChangeKey.newKey],
                let size = sizeValue as? CGSize{
                //print(size)
                
                if size.height != (self.tableView.tableHeaderView?.frame.size.height)! - 40 {
                    //print("更新header")
                    self.tableView.beginUpdates()
                    self.webView.frame = CGRect(origin: CGPoint(), size: CGSize(width: kScreenWidth, height: size.height))
                    self.tableView.tableHeaderView?.frame = CGRect(origin: CGPoint(), size: CGSize(width: kScreenWidth, height: size.height + 40))
                    self.tableView.endUpdates()
                }
            }
            
        }else if keyPath == "estimatedProgress"{
            if
                let change = change,
                let processValue = change[NSKeyValueChangeKey.newKey],
                let process = processValue as? Float{
                
                self.processView.setProgress(process, animated: true)//动画有延时，所以要等动画结束再隐藏
                if process == 1.0 {
                    //perform(<#T##aSelector: Selector##Selector#>, with: <#T##Any?#>, afterDelay: <#T##TimeInterval#>)
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.25, execute: {
                        self.processView.alpha = 0.0
                    })
                }
            }
        }
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging {
            self.view.endEditing(true)
        }
        let yOffset = scrollView.contentOffset.y
        //print(yOffset)
        if yOffset <= 0 {
            //self.customNavigationBar.barTintColor = UIColor.orange
            //self.customNavigationBar.alpha = 0
            self.backgroundView?.alpha = 1
            self.titleView?.text = "文章详情"
            self.leftItem?.setImage(UIImage(named: "imgBack")?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.leftItem?.tintColor = UIColor.black
            self.leftItem?.imageEdgeInsets = UIEdgeInsetsMake(5, 9, 5, 9)
        }else if yOffset >= kNavStatusHeight{
            //self.customNavigationBar.alpha = 1
            self.backgroundView?.alpha = 0
            self.titleView?.text = ""
            self.leftItem?.setImage(UIImage(named: "iconBackBlackbg"), for: .normal)
            self.leftItem?.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        }else{
            //self.customNavigationBar.alpha = fabs(fabs(yOffset) - kNavStatusHeight) / kNavStatusHeight
            self.backgroundView?.alpha = fabs(fabs(yOffset) - kNavStatusHeight) / kNavStatusHeight
        }
    }
    @IBAction func priseClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.articleLiked == true {
            self.articleLiked = false
            self.articleLikes -= 1
            self.priseLabel.textColor = UIColor.rgbColor(from: 160, 160, 160)
        } else {
            self.articleLiked = true
            self.articleLikes += 1
            self.priseLabel.textColor = UIColor.rgbColor(from: 251, 74, 88)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.priseButton.alpha = 0.0
                self.priseButton.transform = CGAffineTransform(scaleX: 2, y: 2)
//                var frame = self.priseButton.frame
//                frame.origin.y += 25
//                self.priseButton.frame = frame
                
            }) { (finished) in
                self.priseButton.alpha = 1.0
                self.priseButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                
//                var frame = self.priseButton.frame
//                frame.origin.y -= 25
//                self.priseButton.frame = frame
            }
        }
        self.priseLabel.text = "\(self.articleLikes)"
        
    }
    @IBAction func checkChainArticle(_ sender: Any) {
        self.performSegue(withIdentifier: "chain", sender: self.articleEntity)
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    func request(page: Int) {
        guard let articleId = self.articleEntity?.id else { return }
        guard let articleHashIndex = self.articleEntity?.artHashIndex else { return }
        self.commentVM.commentList(artId: articleId, artHashIndex: articleHashIndex, pageNo: page) { (_, msg, isSuc) in
            self.tableView.mj_footer.endRefreshing()
            self.tableView.reloadData()
        }
    }
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.commentVM.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! CommentCell
        
        let entity = self.commentVM.dataArray[indexPath.row] as? CommentListEntity
        cell.entity = entity
        cell.deleteBlock = {
            
            guard let commentId = entity?.id else { return }
            guard let articleHashIndex = self.articleEntity?.artHashIndex else { return }
            guard let articleId = self.articleEntity?.id else { return }
            self.commentVM.delete(commentId, artHashIndex: articleHashIndex, artId: articleId, completion: { (_, msg, isSuc) in
                if isSuc {
                    self.commentVM.dataArray.remove(at: indexPath.row)
                    self.tableView.reloadData()
                } else {
                    ViewManager.showNotice(msg)
                }
            })
        }
        // Configure the cell...

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chain" {
            if let vc = segue.destination as? ChainInfoController,let articleEntity = sender as? ArticleEntity {
                vc.articleEntity = articleEntity
            }
        }
    }
}
extension ArticleDetailsController:UITextFieldDelegate {
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        print("我可以做别的吗？")
//        textField.resignFirstResponder()
//        self.showInputView()
//        return true
//    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        return true
//    }
}
extension ArticleDetailsController:WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("start")
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("commit")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish",webView.scrollView.contentSize)
        self.hideMBProgressHUD()
//        self.webView.frame = CGRect(origin: CGPoint(), size: size)
//        self.tableView.tableHeaderView?.frame = CGRect(origin: CGPoint(), size: size)
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("fail:\(error.localizedDescription)")
        self.hideMBProgressHUD()
    }
    
    //当webView的web内容进程被终止时调用。(iOS 9.0之后)
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        
    }
    //监听页面跳转的代理方法，分为：收到跳转与决定是否跳转两种
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    //收到服务器重定向时调用
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    //当webView需要响应身份验证时调用(如需验证服务器证书)
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.performDefaultHandling, nil)
    }
    ////加载错误时调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
}
extension ArticleDetailsController :WKScriptMessageHandler{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("message:",message)
    }
}




