//
//  MyWalletViewController.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/11.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import WebKit

//let kDiscoveryUrl = "https://find.guangjiego.com/Discovery/home.html"  //发现
let kWalletUrl = "http://192.168.0.171:8080/"  //钱包

class MyWebViewController: JXWkWebViewController {
    

    var urlStr: String?
    
    private var webUrl : URL?
    
    lazy var rightBarButtonItem: UIBarButtonItem = {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "scanIcon"), for: .normal)
        //leftButton.imageEdgeInsets = UIEdgeInsetsMake(7.5, 0, 12, 24)
        leftButton.addTarget(self, action: #selector(goScan), for: .touchUpInside)
        let item = UIBarButtonItem.init(customView: leftButton)
        return item
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let leftButton = UIButton()
//        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        leftButton.setImage(UIImage(named: "icon-back"), for: .normal)
//        leftButton.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 24)
//        leftButton.addTarget(self, action: #selector(goback), for: .touchUpInside)
//        self.customNavigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftButton)
        
        
        self.webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)

        self.webView.configuration.userContentController.add(self, name: "getParames")
        self.webView.configuration.userContentController.add(self, name: "titleFn")
        self.webView.configuration.userContentController.add(self, name: "copyFn")
        self.webView.configuration.userContentController.add(self, name: "scanFn")
        self.webView.configuration.userContentController.add(self, name: "taskFn")
        
        self.webView.evaluateJavaScript("navigator.userAgent") { (data, error) in
            
            if let error = error {
                print("Error = ",error.localizedDescription)
            } else {
                //注册ua
                //userAgent 可以简单的理解为 浏览器标识(简称UA,它是一个特殊字符串头，使得服务器能够识别客户使用的操作系统及版本、CPU类型、浏览器及版本、浏览器渲染引擎、浏览器语言、浏览器插件等)
                if
                    let userAgent = data as? String,
                    userAgent.contains("platformParams=") == false {
                    
                    let dict = ["platform":"ios"]
                    guard
                        let result = try? JSONSerialization.data(withJSONObject: dict, options: []),
                        let jsonStr = String.init(data: result, encoding: .utf8) else{
                            return
                    }
                    let newUserAgent = userAgent.appendingFormat("platformParams=%@", jsonStr)
                    if #available(iOS 9.0, *) {
                        self.webView.customUserAgent = newUserAgent
                    } else {
                        let mdict = ["UserAgent": newUserAgent]
                        print("mdict = ",mdict)
                        UserDefaults.standard.register(defaults: mdict)
                        UserDefaults.standard.synchronize()
                    }
                }
            }
        }

        if
            let str = self.urlStr,
            let url = URL.init(string: str) {
            webUrl = url
            self.webView.load(URLRequest(url: url))
        }

        NotificationCenter.default.addObserver(self, selector: #selector(loginStatus(notify:)), name: NSNotification.Name(rawValue: NotificationLoginStatus), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        
        if keyPath == "title" {
            //self.title = self.webView.title
            //            if  self.webView.title == "首页" {
            //                self.navigationItem.leftBarButtonItem = nil
            //            }else {
            //                self.title = self.webView.title;
            //                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "nav_back"), style: .plain, target: self, action: #selector(goback))
            //            }
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
        }else if keyPath == "URL"{
            guard
                let change = change,
                let value = change[NSKeyValueChangeKey.newKey],
                let url = value as? URL else{
                    return
            }
            print("webview.url = " + (webView.url?.absoluteString)!)
            print("url = " + url.absoluteString)
            
            if webView.url?.absoluteString == webUrl?.absoluteString {
                //            self.navigationItem.leftBarButtonItem = nil
                print("首页")
                
            }else {
                //            self.title = self.webView.title;
                //            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "nav_back"), style: .plain, target: self, action: #selector(goback))
                print("次级")
            }
        }
        
    }
    deinit {
        self.webView.removeObserver(self, forKeyPath: "title")
        self.webView.removeObserver(self, forKeyPath: "URL")
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "getParames")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationLocatedStatus), object: nil)
    }
    @objc func goback() {
        if self.webView.canGoBack {
            self.webView.goBack()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func goScan() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ScanVC") as! ScanViewController
        vc.hidesBottomBarWhenPushed = true
        vc.callBlock = { (address) in
            let url = URL.init(string: address!)
            self.webView.load(URLRequest(url: url!))
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func getParames() -> String{
        print("1234567890")
        ViewManager.showNotice("123456789")
        //callBack!("1234567890")
        return UserManager.manager.userEntity.planA_sid
    }
    @objc func loginStatus(notify:Notification) {
        print(notify)
        
        if let isSuccess = notify.object as? Bool,
            isSuccess == true,let url = webUrl{
            self.webView.load(URLRequest(url: url))
        }
    }
    override func requestData() {
        
        if let url = webUrl {
            self.webView.load(URLRequest(url: url))
        }
    }
}
extension MyWebViewController {
    
    override func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        super.webView(webView, didStartProvisionalNavigation: navigation)
    }
    override func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        super.webView(webView, didCommit: navigation)
    }
    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        super.webView(webView, didFinish: navigation)
    }
    override func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        super.webView(webView, didFail: navigation, withError: error)
    }
}
extension MyWebViewController {
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("message.name:",message.name)
        print("message.body:",message.body)
        guard let body = message.body as? String else {
            return
        }
        if message.name == "titleFn" {
            self.title = body
        } else if message.name == "copyFn" {
            if body == "true" {
                let pals = UIPasteboard.general
                pals.string = body
                ViewManager.showNotice("复制成功")
            }
            
        } else if message.name == "scanFn" {
            if body == "true" {
                self.customNavigationItem.rightBarButtonItem = self.rightBarButtonItem
            } else {
                self.customNavigationItem.rightBarButtonItem = nil
            }
        } else if message.name == "taskFn" {
            
        }
    }
}
