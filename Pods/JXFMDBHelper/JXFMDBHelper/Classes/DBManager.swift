//
//  DBManager.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/8/15.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import Foundation
import FMDB

private let userPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]

public class DBManager {
    
    static let `default` = DBManager(name: "DBManager")
    
    var databaseQueue : FMDatabaseQueue?
    var tableName : String = "DBManager"
    
//    /// 表名
//    static var name : String {
//        return dbName
//    }
    static var path : String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    }
    
    /// 检查表是否存在
    public var isExist: Bool {
        return examine()
    }
    init(name:String = dbName) {
        self.tableName = name
        let path = DBManager.path.appending("/\(name).db")
        databaseQueue = FMDatabaseQueue(path: path)
        print("数据库地址：\(path)")
    }
    /// 检查sql语句
    ///
    /// - Parameters:
    ///   - db: 数据库对象
    ///   - sql: sql语句
    /// - Returns: 结果
    func validateSql(db:FMDatabase?,sql:String) -> Bool {
        var result : Bool = false
        do {
            let _ = try db?.validateSQL(sql)
            result = true
        } catch {
            print("SQL: \(sql) \n Error: \(error.localizedDescription)")
            result = false
        }
        return result
    }
    /// 建表
    /// - sql语句:
    ///   -create table if not exists DBManager (id integer primary key autoincrement,UserGender text,UserName text);
    ///
    /// - Parameters:
    ///   - name: 表名
    ///   - keys: 字段
    /// - Returns: 结果
    func createTable(keys:Array<String>) -> Bool {
        guard keys.isEmpty == false else {
            return false
        }
        var result : Bool = false
        
        databaseQueue?.inDatabase({ (db) in
            var sql = "create table if not exists \(self.tableName) (id integer primary key autoincrement"
            for i in 0..<keys.count {
                sql.append(",\(keys[i]) text")
                if i == keys.count - 1{
                    sql.append(");")
                }
            }
            if
                self.validateSql(db: db, sql: sql) == true,
                db.executeUpdate(sql, withArgumentsIn: []) == true{
                result = true
                print("Create Table Success :\(self.tableName).db")
            }else{
                result = false
                print("Create Table Error: \(String(describing: db.lastErrorMessage))")
            }
        })
        return result
    }
    /// 删除表
    ///
    /// - Parameter name: 表名
    /// - Returns: 返回结果
    func dropTable() -> Bool {
        if isExist == false {
            return false
        }
        var result = false
        databaseQueue?.inDatabase({ (db) in
            let sql = "drop table \(self.tableName)"
            if
                self.validateSql(db: db, sql: sql) == true,
                db.executeUpdate(sql, withArgumentsIn: []) == true{
                result = true
            }else{
                result = false
                print("Drop Table Error: \(String(describing: db.lastErrorMessage))")
            }
            //db?.executeUpdate(sql, values: nil)
        })
        return result
        
    }
    func examine() -> Bool {
        var result = false
        databaseQueue?.inDatabase({ (db) in
            if db.tableExists(self.tableName) == true{
                result = true
            }else{
                result = false
                print("Table not exists")
            }
        })
        return result
    }
    /// 插入数据
    /// - sql语句:
    ///   - insert into DBManager (UserGender,UserName) values (?,?)
    ///
    /// - Parameters:
    ///   - name: 表名
    ///   - datas: 数据
    /// - Returns: 是否成功
    func insertData(data:Dictionary<String,Any>) -> Bool {
        if isExist == false {
            return false
        }
        var result : Bool = false
        var sql = "insert into \(self.tableName) ("
        var value = ") values ("
        let lazyMapCollection = data.keys
        let keys = Array(lazyMapCollection)
        let values = Array(data.values)
        
        for i in 0..<data.keys.count {
            sql.append(keys[i])
            value.append("?")
            if i < data.keys.count - 1{
                sql.append(",")
                value.append(",")
            }
        }
        sql.append("\(value))")
        databaseQueue?.inDatabase({ (db) in
            if
                self.validateSql(db: db, sql: sql) == true,
                db.executeUpdate(sql, withArgumentsIn: values) == true{
                result = true
                print("Insert Data Success \(self.tableName).db")
            }else{
                result = false
                print("Insert Data Error: \(String(describing: db.lastErrorMessage))")
            }
        })
        return result
    }
    /// 插入数据
    /// - sql语句:
    ///   - insert into DBManager (UserGender,UserName) values (?,?)
    ///
    /// - Parameters:
    ///   - datas: 数据
    /// - Returns: 是否成功
    func insertDatas(datas:Array<Dictionary<String,Any>>) -> Bool {
        if isExist == false {
            return false
        }
        var result : Bool = false
        var sql = "insert into \(self.tableName) ("
        var value = ") values ("
        let data = datas[0]
        let lazyMapCollection = data.keys
        let keys = Array(lazyMapCollection)
        
        for i in 0..<data.keys.count {
            sql.append(keys[i])
            value.append("?")
            if i < data.keys.count - 1{
                sql.append(",")
                value.append(",")
            }
        }
        sql.append("\(value))")
        var num = 0
        databaseQueue?.inTransaction({ (db, rollBack) in
            if self.validateSql(db: db, sql: sql) == false{
                return
            }
            datas.forEach({ (dict) in
                num += 1
                if db.executeUpdate(sql, withArgumentsIn: Array(dict.values)) == true{
                    result = true
                    print("Insert Datas Success \(num)")
                }else{
                    rollBack.pointee = true
                    result = false
                    print("Insert Datas Error \(num): \(String(describing: db.lastErrorMessage))")
                    return
                }
            })
        })
        return result
    }
    /// 查询数据
    ///
    /// - sql语句:
    ///   - select * from DBManager                                    全字段查询
    ///   - select * from DBManager where UserID = 1                   按条件 全字段查询
    ///   - select UserName,UserImage from DBManager                   部分字段查询
    ///   - select UserName,UserImage from DBManager where UserID = 3  按条件 部分字段查询
    ///
    /// - Parameters:
    ///   - keys: 要查询的字段
    ///   - condition: 查询条件
    /// - Returns: 查询结果
    func selectData(keys:Array<String> = [],condition:Array<String>? = nil) -> Array<Any>? {
        if isExist == false {
            return nil
        }
        //var result = false
        var resultArray : Array<Any>?
        
        let isWhole = keys.isEmpty
        
        databaseQueue?.inDatabase({ (db) in
            var sql = "select "
            if isWhole == false{
                for i in 0..<keys.count{
                    sql.append(keys[i])
                    if i < keys.count - 1{
                        sql.append(",")
                    }
                }
                sql.append(" from \(self.tableName)")
            }else{
                sql.append("* from \(self.tableName)")
            }
            
            //筛选条件
            if
                let condition = condition,
                condition.isEmpty == false{
                sql.append(" where ")
                for i in 0..<condition.count{
                    sql.append(condition[i])
                    if i < keys.count - 1 && condition.count > 1{
                        sql.append(" and ")
                    }
                }
            }
           
//            let sss = try? db.executeQuery(sql, values: [])
//            let ss = sss
            
            
            if
                self.validateSql(db: db, sql: sql) == true,
                let rs = try? db.executeQuery(sql, values: []) {
                
                resultArray = Array<Any>()
                while rs.next(){
                    var dict = Dictionary<String,Any>()
                    if isWhole {
                        for i in 0..<rs.columnNameToIndexMap.allKeys.count{
                            dict[rs.columnName(for: Int32(i))!] = rs.string(forColumn: rs.columnName(for: Int32(i))!)
                        }
                    }else{
                        for i in 0..<keys.count{
                            dict[keys[i]] = rs.string(forColumn: keys[i])
                        }
                    }
                    resultArray?.append(dict)
                }
            }else{
                print("Select Error: \(String(describing: db.lastErrorMessage))")
            }
        })
        return resultArray
    }
    /// 更新数据
    ///
    /// - sql语句:
    ///   - update DBManager set UserName='Me',UserAge='28'               更新 全部数据 字段
    ///   - update DBManager set UserName='Me',UserAge='28' where id = 1  更新 符合条件数据 字段
    ///
    /// - Parameters:
    ///   - keyValues: 要更新的字段
    ///   - condition: 查询条件,default：[],更新整个表，否则更新符合条件的数据
    /// - Returns: 更新结果
    func updateData(keyValues:Dictionary<String,Any> = Dictionary<String,Any>(),condition:Array<String> = []) -> Bool {
        if isExist == false {
            return false
        }
        var result = false
        databaseQueue?.inDatabase({ (db) in
            var sql = "update \(self.tableName) set "
            for (key,value) in keyValues{
                sql.append("\(key)='\(value)',")
            }

            //var Sql = sql.substring(to: sql.index(before: sql.endIndex))
            let substring = sql.prefix(sql.count - 1)
            var Sql = String.init(substring)
            
            if condition.isEmpty == false {
                Sql.append(" where ")
                for i in 0..<condition.count {
                    Sql.append("\(condition[i])")
                    if i < condition.count - 1 && condition.count > 1{
                        Sql.append(" and ")
                    }
                }
            }
            if self.validateSql(db: db, sql: Sql) == false{
                return
            }
            do {
                try db.executeUpdate(Sql, values: [])
                result = true
            } catch {
                print("Update Error: \(error.localizedDescription)")
                result = false
            }
        })
        
        return result
    }
    /// 删除数据
    ///
    /// - sql语句:
    ///   - delete from DBManager               删除 全部数据
    ///   - delete from DBManager where id = 4  删除 符合条件数据
    ///
    /// - Parameters:
    ///   - condition: 条件
    /// - Returns: 结果
    func deleteData(condition:Array<String> = []) -> Bool {
        if isExist == false {
            return false
        }
        var result = false
        databaseQueue?.inDatabase({ (db) in
            var sql = "delete from \(self.tableName)"
            if condition.isEmpty == false {
                sql.append(" where ")
                for i in 0..<condition.count{
                    sql.append("\(condition[i])")
                    if i < condition.count - 1 && condition.count > 1{
                        sql.append(" and ")
                    }
                }
            }
            
            if
                self.validateSql(db: db, sql: sql) == true,
                db.executeUpdate(sql, withArgumentsIn: []) == true{
                result = true
            }else{
                result = false
                print("Delete Error: \(String(describing: db.lastErrorMessage))")
            }
        })
        return result
    }
    /// 查询数据条数
    ///
    /// - sql语句:
    ///   - select count ( * ) from DBManager   全部数据
    ///   - select count (name) from DBManager  
    ///
    /// - Parameters:
    ///   - name: 表名
    ///   - key: 字段名
    ///   - condition: 查询条件
    /// - Returns: 返回条数
    func selectDataCount(key:String = "",condition:Array<String> = []) -> Int {
        if isExist == false {
            return 0
        }
        var count = 0
        databaseQueue?.inDatabase({ (db) in
            var sql = "select count"
            if key.isEmpty == false{
                sql.append(" (\(key)) from \(self.tableName)")
            }else{
                sql.append(" ( * ) from \(self.tableName)")
            }
            if condition.isEmpty == false {
                sql.append(" where ")
                for i in 0..<condition.count {
                    sql.append("\(condition[i])")
                    if i < condition.count - 1 && condition.count > 1{
                        sql.append(" and ")
                    }
                }
            }
            if
                self.validateSql(db: db, sql: sql) == true,
                let rs = try? db.executeQuery(sql, values: []){
                while rs.next() {
//                    if key.isEmpty == false{
//                        count = Int(rs.int(forColumn: key))
//                    }else{
                        count = Int(rs.int(forColumnIndex: 0))
//                    }
                }
            }else{
                print("SelectCount Error: \(String(describing: db.lastErrorMessage))")
            }
        })
        return count
    }
}
