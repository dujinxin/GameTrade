//
//  FileManager+Extension.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/12/6.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import Foundation

let dataPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

//MARK:保存到文件中
public extension FileManager{
    
    /// 保存数据到文件中
    ///
    /// - Parameters:
    ///   - data: 数据
    ///   - name: 数据名称
    /// - Returns: 操作结果
    public static func insert(data:Data,toFile name:String) -> Bool{
        let newPath = dataPath + "/\(name)"
        let dataPathUrl = URL.init(fileURLWithPath: newPath)
        
        try? data.write(to: dataPathUrl)
        
        if FileManager.default.fileExists(atPath: newPath) {
            print("保存成功",newPath)
            return true
        }
        return false
    }
    /// 修改文件中的数据
    ///
    /// - Parameters:
    ///   - data: 数据
    ///   - name: 数据名称
    /// - Returns: 操作结果
    public static func update(inFile data:Data,name:String) -> Bool {
        let newPath = dataPath + "/\(name)"
        let dataPathUrl = URL.init(fileURLWithPath: newPath)
        
        try? FileManager.default.removeItem(atPath: newPath)
        if FileManager.default.fileExists(atPath: newPath) {
            return false
        }
        try? data.write(to: dataPathUrl)
        if FileManager.default.fileExists(atPath: newPath) {
            return true
        }
        
        return false
    }
    /// 获取文件中的数据
    ///
    /// - Parameters:
    ///   - name: 数据名称
    /// - Returns: 操作结果
    public static func select(fromFile name:String) -> Any? {
        let newPath = dataPath + "/\(name)"
        let dataPathUrl = URL.init(fileURLWithPath: newPath)
        
        let data = try? Data.init(contentsOf: dataPathUrl)
        
        return data
    }
    /// 移除文件中数据
    ///
    /// - Parameter name: 数据名称
    /// - Returns: 操作结果
    public static func delete(fromFile name:String) -> Bool{
        let newPath = dataPath + "/\(name)"
        
        try? FileManager.default.removeItem(atPath: newPath)
        if !FileManager.default.fileExists(atPath: newPath) {
            print("移除成功",newPath)
            return true
        }
        return false
    }
}
