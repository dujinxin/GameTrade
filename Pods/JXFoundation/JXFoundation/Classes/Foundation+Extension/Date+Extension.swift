//
//  Date+Extension.swift
//  Star
//
//  Created by 杜进新 on 2018/6/4.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

public extension Date {
    
    /*
     YYYY（年）/MM（月）/dd（日） hh（时）:mm（分）:ss（秒） SS（毫秒）
     需要用哪个的话就把哪个格式加上去。
     值得注意的是，如果想显示两位数的年份的话，可以用”YY/MM/dd hh:mm:ss SS”，两个Y代表两位数的年份。
     而且大写的M和小写的m代表的意思也不一样。“M”代表月份，“m”代码分钟
     “HH”代表24小时制，“hh”代表12小时制
     "YYYY-MM-dd HH:mm:ss" //2016-07-08 16:44:37
     "YYYY-MM-dd HH:mm:ss aaa" //2016-07-08 04:44:37 下午
     */
//    dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//2016-07-08 16:44:37
//    //[dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss aaa"];//2016-07-08 04:44:37 下午
//
//    NSDate * date = [NSDate date];
//    dateString = [dateFormatter stringFromDate:date];
    
//    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[entity.AddTime doubleValue]/1000];
//
//    NSString *dateString1 = [dateFormatter stringFromDate:date];
//    NSLog(@"interval = %f  date1 = %@",[entity.AddTime doubleValue]/1000 -8*60*60,dateString1);
//    if (![[dateString substringWithRange:NSMakeRange(0, 4)] isEqualToString:[dateString1 substringWithRange:NSMakeRange(0, 4)]]) {
//    detailLabel.text = [dateString1 substringWithRange:NSMakeRange(0, 10)];
//    }else{
//    if (![[dateString substringWithRange:NSMakeRange(0, 10)] isEqualToString:[dateString1 substringWithRange:NSMakeRange(0, 10)]]) {
//    detailLabel.text = [dateString1 substringWithRange:NSMakeRange(5, 5)];
//    }else{
//    detailLabel.text = [NSString stringWithFormat:@"%@",[dateString1 substringWithRange:NSMakeRange(11, 5)]];
//    }

    public var formatter: DateFormatter {
        return DateFormatter()
    }
    /// Date format
    ///
    /// - Parameter string:
        /*
        YYYY（年）/MM（月）/dd（日） hh（时）:mm（分）:ss（秒） SS（毫秒）
        需要用哪个的话就把哪个格式加上去。
        值得注意的是，如果想显示两位数的年份的话，可以用”YY/MM/dd hh:mm:ss SS”，两个Y代表两位数的年份。
        而且大写的M和小写的m代表的意思也不一样。“M”代表月份，“m”代码分钟
        “HH”代表24小时制，“hh”代表12小时制
        "YYYY-MM-dd HH:mm:ss" //2016-07-08 16:44:37
        "YYYY-MM-dd HH:mm:ss aaa" //2016-07-08 04:44:37 下午
       */
    public func format(_ string:String = "YYYY-MM-dd HH:mm:ss") {
        self.formatter.dateFormat = string
    }
    public func dateFromString(_ string:String) -> Date? {
        return self.formatter.date(from: string)
    }
    public func stringFromDate() -> String {
        return self.formatter.string(from: self)
    }
    //1528180887000
    public static func calculateTimeIntervalFrom(_ timeInterval:TimeInterval) -> String {

        let beforeDate = Date(timeIntervalSince1970: timeInterval)
        let beforeDateStr = beforeDate.stringFromDate()

        return self.calculateTimeStringFrom(beforeDateStr)
    }
    public static func calculateTimeStringFrom(_ beforeDateStr:String) -> String {
        var text : String = ""
 
        let currentDate = Date()
        let currentDateStr = currentDate.stringFromDate()
        
        print("currentDateStr = ",currentDate)
        print("beforeDateStr = ",beforeDateStr)
        
        if currentDateStr.prefix(4) != beforeDateStr.prefix(4) {//不是同一年，返回年月日
            text = String(beforeDateStr.prefix(10))
            print("beforeDateStr1 = ",beforeDateStr.prefix(10))
            print("beforeDateStr2 = ",currentDateStr.prefix(10))
        } else {
            if currentDateStr.prefix(10) != beforeDateStr.prefix(10) {//不是同一天，返回月日
                text = String(beforeDateStr.prefix(10))
                print("beforeDateStr1 = ",beforeDateStr.prefix(10))
            } else {
                text = String(beforeDateStr.suffix(8))              //一天之内的，返回时分秒
                print("beforeDateStr1 = ",beforeDateStr.suffix(8))
            }
        }
        print("text = ",text)
        
        return text
    }
}
