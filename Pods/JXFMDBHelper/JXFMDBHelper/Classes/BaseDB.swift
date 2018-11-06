//
//  BaseDB.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/8/15.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import Foundation
import FMDB

public let dbName = "BaseDB"

open class BaseDB {
    public static let `default` = BaseDB(name: dbName)
    
    public var manager : DBManager!
    var tableName : String = dbName
    
    public init(name:String = dbName) {
        tableName = name
        manager = DBManager(name: name)
    }
    /// 建表
    /// - Parameters:
    ///   - name: 表名
    ///   - keys: 字段
    /// - Returns: 结果
    public func createTable(keys:Array<String>) -> Bool {
        return self.manager.createTable(keys: keys)
    }
    /// 删除表
    /// - Parameter name: 表名
    /// - Returns: 返回结果
    public func dropTable() -> Bool {
        return self.manager.dropTable()
    }
    /// 插入数据
    /// - Parameters:
    ///   - name: 表名
    ///   - datas: 数据
    /// - Returns: 是否成功
    public func insertData(data:Dictionary<String,Any>) -> Bool {
        return self.manager.insertData(data: data)
    }
    /// 插入数据
    /// - Parameters:
    ///   - name: 表名
    ///   - datas: 数据
    /// - Returns: 是否成功
    public func insertDatas(datas:Array<Dictionary<String,Any>>) -> Bool {
        return self.manager.insertDatas(datas: datas)
    }
    /// 查询数据
    /// - Parameters:
    ///   - name: 表名
    ///   - keys: 要查询的字段
    ///   - condition: 查询条件
    /// - Returns: 查询结果
    public func selectData(keys:Array<String> = [],condition:Array<String>? = nil) -> Array<Any>? {
        return self.manager.selectData(keys: keys, condition: condition)
    }
    /// 更新数据
    /// - Parameters:
    ///   - name: 表名
    ///   - keyValues: 要更新的字段
    ///   - condition: 查询条件,default：[],更新整个表，否则更新符合条件的数据
    /// - Returns: 更新结果
    public func updateData(keyValues:Dictionary<String,Any>,condition:Array<String> = []) -> Bool {
        return self.manager.updateData(keyValues: keyValues, condition: condition)
    }
    /// 删除数据
    /// - Parameters:
    ///   - name: 表名
    ///   - condition: 条件
    /// - Returns: 结果
    public func deleteData(condition:Array<String> = []) -> Bool {
        return self.manager.deleteData(condition: condition)
    }
    /// 查询数据条数
    /// - Parameters:
    ///   - name: 表名
    ///   - key: 字段名
    ///   - condition: 查询条件
    /// - Returns: 返回条数
    public func selectDataCount(key:String = "",condition:Array<String> = []) -> Int {
        return self.manager.selectDataCount(key: key, condition: condition)
    }
}
