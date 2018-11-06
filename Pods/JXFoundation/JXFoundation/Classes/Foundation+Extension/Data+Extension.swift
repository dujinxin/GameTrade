//
//  Data+Extension.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/12/5.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import Foundation

public extension Data{
    /// 保存图片到文件中
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - name: 图片名称
    public static func save(data:Data,name:String) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0]
        let imagePath = path + "/\(name)"
        let imagePathUrl = URL.init(fileURLWithPath: imagePath)
        
        try? data.write(to: imagePathUrl)
        
        if FileManager.default.fileExists(atPath: imagePath) {
            print("保存成功",imagePath)
        }
    }
    /// 获取文件中的图片
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - name: 图片名称
    public static func get(name:String) -> Data? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0]
        let imagePath = path + "/\(name)"
        let imagePathUrl = URL.init(fileURLWithPath: imagePath)
        
        let data = try? Data.init(contentsOf: imagePathUrl)
        
        return data
    }
    /// 移除文件中图片
    ///
    /// - Parameter name: 图片名称
    public static func remove(name:String) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0]
        let imagePath = path + "/\(name)"
        
        try? FileManager.default.removeItem(atPath: imagePath)
        if FileManager.default.fileExists(atPath: imagePath) {
            print("移除成功",imagePath)
        }
    }
}
