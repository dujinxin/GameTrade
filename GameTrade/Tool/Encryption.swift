//
//  Encryption.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/11/20.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit

extension String {
    var MD5String: String {
        let cStrl = cString(using: String.Encoding.utf8)
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStrl, CC_LONG(strlen(cStrl!)), buffer)
        var md5String = ""
        for idx in 0...15 {
            let obcStrl = String.init(format: "%02x", buffer[idx])
            md5String.append(obcStrl)
        }
        free(buffer)
        return md5String
    }
}
//MAKE:MD5加密
class MD5 {
    static func encode(_ string: String) -> String {
        
        let str = string.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(string.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str, strLen, buffer)
        var hash : String = ""
        for i in 0 ..< digestLen {
            let s = String(format: "%02x", buffer[i])
            hash.append(s)
        }
        free(buffer)
        
        return hash
    }
//    static func encode(_ string:String) -> String {
//
//        let str = string.cString(using: String.Encoding.utf8)
//        let strLen = CUnsignedInt(string.lengthOfBytes(using: String.Encoding.utf8))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
//        CC_MD5(str!, strLen, result)
//        let hash = NSMutableString()
//        for i in 0 ..< digestLen {
//            hash.appendFormat("%02x", result[i])
//        }
//        result.deinitialize()
//
//        return String(format: hash as String)
//    }

}
//MAKR:base64加密、解密
class Base64 {
    static func stringEncode(_ string:String) -> String? {
        guard let data = string.data(using: .utf8) else{
            return nil
        }
        let base64Str = data.base64EncodedString(options: .lineLength64Characters)
        return base64Str
    }
    static func stringDecode(_ base64String:String) -> String? {
        guard
            let decodeData = Data.init(base64Encoded: base64String, options: .ignoreUnknownCharacters),
            let decodeString = String.init(data: decodeData, encoding: .utf8)
            else {
                return nil
        }
        return decodeString
    }
    static func dataEncode(_ data:Data) -> Data {
        return data.base64EncodedData(options: .lineLength64Characters)
    }
    static func dataDecode(_ base64Data:Data) -> Data? {
        guard
            let data = Data.init(base64Encoded: base64Data, options: .ignoreUnknownCharacters)
        else {
            return nil
        }
        return data
    }
    
    static func imageEncode(_ image: UIImage) -> Data? {
        //UIImageJPEGRepresentation(<#T##image: UIImage##UIImage#>, <#T##compressionQuality: CGFloat##CGFloat#>)
        guard let data = image.pngData() else {
            return nil
        }
        return self.dataEncode(data)
    }
    static func imageDecode(_ base64Data: Data) -> UIImage? {
        
        guard
            let data = self.dataDecode(base64Data),
            let image = UIImage(data: data)
        else {
            return nil
        }
        return image
    }
    static func fileEncode(path:String) -> Data? {
        let url = URL.init(fileURLWithPath: path)
        guard let data = try? Data.init(contentsOf: url) else {
            return nil
        }
        return self.dataEncode(data)
    }
    
}
