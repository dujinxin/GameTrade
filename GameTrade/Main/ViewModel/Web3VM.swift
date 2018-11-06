//
//  Web3VM.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/25.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation
import web3swift

class Web3VM : BaseViewModel{
    //https://mainnet.infura.io/0a8aa5d2db674577bf61aa4be1e38472
    //https://mainnet.infura.io/v3/e91a846b69f14dc1a87fbd19a52955ed
    var web3 = Web3.InfuraMainnetWeb3()
    //var web3 = Web3.InfuraMainnetWeb3(accessToken: "0a8aa5d2db674577bf61aa4be1e38472")
    //var web3 = Web3.InfuraMainnetWeb3(accessToken: "e91a846b69f14dc1a87fbd19a52955ed")
    
    //var web3 = Web3.new(URL(string: "http://192.168.0.129:8545")!)
    var keystore: EthereumKeystoreV3?
    
    init(keystoreData:Data) {
        super.init()
        
        guard let keystoreV3 = EthereumKeystoreV3.init(keystoreData) else {return}
        let keystoreManager = KeystoreManager.init([keystoreV3])
        self.web3.addKeystoreManager(keystoreManager)
        self.keystore = keystoreV3
    }
    init(keystoreJsonStr:String) {
        super.init()
        let keystoreJsonStr1 = String.convertKeystore(keystoreJsonStr)
        
        guard let keystoreV3 = EthereumKeystoreV3.init(keystoreJsonStr1) else {return}
        let keystoreManager = KeystoreManager.init([keystoreV3])
        self.web3.addKeystoreManager(keystoreManager)
        self.keystore = keystoreV3
    }
    init(keystoreBase64Str:String) {
        super.init()
        guard
            keystoreBase64Str.isEmpty == false,
        
            let keystoreData = Data.init(base64Encoded: keystoreBase64Str, options: .ignoreUnknownCharacters),
            let keystoreStr = String.init(data: keystoreData, encoding: .utf8) else {
                return
        }
        let keystoreJsonStr = String.convertKeystore(keystoreStr)
        
        guard let keystoreV3 = EthereumKeystoreV3.init(keystoreJsonStr) else {return}        
        let keystoreManager = KeystoreManager.init([keystoreV3])
        self.web3.addKeystoreManager(keystoreManager)
        self.keystore = keystoreV3
    }
    
    
//    func convertKeystoreBy(_ keystoreData:String, removePrefix:String = "0x") -> String {
//        guard
//            let result = try? JSONSerialization.jsonObject(with: data, options: []),
//            var dict = result as? [String : Any],
//            let address = dict["address"] as? String
//            else {
//                fatalError("Not format keystoreData!")
//        }
//        if address.hasPrefix("0x"){
//            print("address：\(address)")
//            return data
//        } else {
//            let newAddress = "0x" + address
//            dict["address"] = newAddress
//            print("newAddress：\(newAddress)")
//            return try? JSONSerialization.data(withJSONObject: dict, options: [])
//        }
//    }
    
    func getKeystoreData() -> Data?{
        let pathUrl = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/keystore1.json")
        
        guard
            let data = try? Data(contentsOf: pathUrl) else {
                print("该地址不存在keystore文件：\(pathUrl)")
                return nil
        }
        
        guard
            let result = try? JSONSerialization.jsonObject(with: data, options: []),
            var dict = result as? [String : Any],
            let address = dict["address"] as? String
            else {
                print("该地址不存在用户信息：\(pathUrl)")
                return nil
        }
        print("keystore地址：\(pathUrl)")
        if address.hasPrefix("0x"){
            print("getKeystoreData func","address：\(address)")
            return data
        } else {
            let newAddress = "0x" + address
            dict["address"] = newAddress
            print("newAddress：\(newAddress)")
            return try? JSONSerialization.data(withJSONObject: dict, options: [])
        }
        //self.userDict = dict as! [String : Any]
        
        //        return data
    }

}
class Web3Request: JXRequest {
    
    let coinMarketCapUrl = "https://api.coinmarketcap.com/v2/ticker/1027/?convert=CNY"
    
    override func handleResponseResult(result: Any?) {
        var msg = "请求失败"
        var netCode : JXNetworkError = .kResponseUnknow
        var data : Any? = nil
        var isSuccess : Bool = false
        
        print("requestParam = \(String(describing: param))")
        print("requestUrl = \(String(describing: requestUrl))")
        
        if result is Dictionary<String, Any> {
            
            let jsonDict = result as! Dictionary<String, Any>
            print("responseData = \(jsonDict)")
            isSuccess = true
            data = result
        }else if result is Array<Any>{
            print("Array")
        }else if result is String{
            print("String")
        }else if result is Error{
            print("Error")
            guard let error = result as? NSError,
                let code = JXNetworkError(rawValue: error.code)
                else {
                    handleResponseResult(result: data, message: "Error", code: .kResponseUnknow, isSuccess: isSuccess)
                    return
            }
            netCode = code
            
            switch code {
            case .kRequestErrorCannotConnectToHost,
                 .kRequestErrorCannotFindHost,
                 .kRequestErrorNotConnectedToInternet,
                 .kRequestErrorNetworkConnectionLost,
                 .kRequestErrorUnknown:
                msg = kRequestNotConnectedDomain;
                break;
            case .kRequestErrorTimedOut:
                msg = kRequestTimeOutDomain;
                break;
            case .kRequestErrorResourceUnavailable:
                msg = kRequestResourceUnavailableDomain;
                break;
            case .kResponseDataError:
                msg = kRequestResourceDataErrorDomain;
                break;
            default:
                msg = error.localizedDescription;
                break;
            }
            
        }else{
            print("未知数据类型")
        }
        handleResponseResult(result: data, message: msg, code: netCode, isSuccess: isSuccess)
    }
    
    override func handleResponseResult(result:Any?,message:String,code:JXNetworkError,isSuccess:Bool) {
        
        guard
            let success = self.success,
            let failure = self.failure
            else {
                return
        }
        
        if isSuccess {
            success(result,message)
        }else{
            failure(message,code)
        }
    }
    
    
    /// 获取ETH当前人民币，美元价格
    /*
     向授权服务地址https://api.coinmarketcap.com/v2/ticker/1027/?convert=CNY发送请求
     "data": {
     "id": 1027,
     "name": "Ethereum",
     "symbol": "ETH",
     "website_slug": "ethereum",
     "rank": 2,
     "circulating_supply": 101045963.0,
     "total_supply": 101045963.0,
     "max_supply": null,
     "quotes": {
     "USD": {
     "price": 418.939268684,
     "volume_24h": 1897124199.14193,
     "market_cap": 42332121842.0,
     "percent_change_1h": 0.27,
     "percent_change_24h": -7.41,
     "percent_change_7d": -12.02
     },
     "CNY": {
     "price": 2856.3978967454,
     "volume_24h": 12934909609.490934,
     "market_cap": 288627476185.0,
     "percent_change_1h": 0.27,
     "percent_change_24h": -7.41,
     "percent_change_7d": -12.02
     }
     },
     "last_updated": 1533096513
     },
     "metadata": {
     "timestamp": 1533096107,
     "error": null
     }
     */
    ///
    /// - Parameter completion: 回调
    func getETHPrise(completion: @escaping ((_ data: Double, _ msg: String, _ isSuccess: Bool)->())){
        
        Web3Request.request(tag: 0, method: .get, url: coinMarketCapUrl, param: [:], success: { (data, message) in
            guard
                let mdict = data as? Dictionary<String, Any>,
                let dict = mdict["data"] as? Dictionary<String, Any>,
                let quotes = dict["quotes"] as? Dictionary<String, Any>,
                let cny = quotes["CNY"] as? Dictionary<String, Any>,
                let price = cny["price"] as? Double
                else{
                    completion(0,message,false)
                    return
            }
            completion(price,message,true)
            
        }, failure: { (message, code) in
            completion(0,message,false)
        })
//        Web3Request.request(url: coinMarketCapUrl, param: [:], success: { (data, message) in
//            guard
//                let dict = data as? Dictionary<String, Any>,
//                let quotes = dict["quotes"] as? Dictionary<String, Any>,
//                let cny = quotes["CNY"] as? Dictionary<String, Any>,
//                let price = cny["price"] as? Double
//                else{
//                    completion(0,message,false)
//                    return
//            }
//            print(dict)
//
//            completion(price,message,true)
//
//        }) { (message, code) in
//            completion(0,message,false)
//        }
    }
}
extension String {
    
    static func convertKeystore(_ keystoreStr:String, addPrefix:String = "0x") -> String {
        
        guard
            let data = keystoreStr.data(using: .utf8),
            let result = try? JSONSerialization.jsonObject(with: data, options: []),
            var dict = result as? [String : Any],
            let address = dict["address"] as? String
            else {
                fatalError("Not format keystoreData!")
        }
        if address.hasPrefix("0x"){
            print("convertKeystore func","address：\(address)")
            return keystoreStr
        } else {
            let newAddress = "0x" + address
            dict["address"] = newAddress
            print("newAddress：\(newAddress)")
            guard
                let newData = try? JSONSerialization.data(withJSONObject: dict, options: []),
                let newKeystoreStr = String.init(data: newData, encoding: .utf8) else {
                    fatalError("convertKeystore error")
            }
            return newKeystoreStr
        }
    }
    static func convertBase64Str(_ str:String) -> String {
        guard
            let keystoreData = Data.init(base64Encoded: str, options: .ignoreUnknownCharacters),
            let keystoreStr = String.init(data: keystoreData, encoding: .utf8) else {
                fatalError("convertString error")
        }
        return keystoreStr
    }
}
