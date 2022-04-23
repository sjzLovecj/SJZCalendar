//
//  CalendarManager.swift
//  Demo
//
//  Created by SJZ on 2022/4/18.
//

import Foundation

struct CalendarManager {
//    static var shared = CalendarManager()
    
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC") ?? TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    lazy var currentCalendar: Calendar = {
        var current = Calendar.current
        current.timeZone = TimeZone(abbreviation: "UTC") ?? TimeZone.current
        return current
    }()
    
    lazy var lunarCalendar = Calendar(identifier: .chinese)
    // 农历
    lazy var lunarFormatter: DateFormatter = {
        let lunarFormatter = DateFormatter()
        lunarFormatter.locale = Locale(identifier: "zh_CN")
        lunarFormatter.dateStyle = .medium
        lunarFormatter.calendar = lunarCalendar
        return lunarFormatter
    }()
    
    // 当前月的下标
    var currentMonthIndex = 0
    
    /// 获取参数日期所在月份的天数
    /// - Parameter date: 给定日期，默认为当前时间
    /// - Returns: 参数date所在月的天数
    mutating func days(ofMonthFromDate date: Date = Date()) -> Int? {
        guard let range = currentCalendar.range(of: .day, in: .month, for: date) else {
            return nil
        }
        return range.count
    }
    
    /// 获取给定日期是星期几
    /// - Parameter date: 给定日期，默认为当前时间
    /// - Returns: 返回数组1-7
    mutating func weekly(OrdinalityFromDate date: Date = Date()) -> Int? {
        guard let num = currentCalendar.ordinality(of: .day, in: .weekOfMonth, for: date) else {
            return nil
        }
        return num
    }
    
    /// 获取给定日期是星期几
    /// - Parameter date: 给定日期，默认为当前时间
    /// - Returns: 返回数组1-7
    mutating func getWeekday(date: Date = Date()) -> Int? {
        let components = components(date: date)
        return components.weekday
    }
    
    /// 获取指定日期所在月第一天
    /// - Parameter date: 给定日期，默认为当前时间
    /// - Returns: 第一天日期
    mutating func firstDay(ofMonthFromDate date: Date = Date()) -> Date? {
        guard let interval = currentCalendar.dateInterval(of: .month, for: date) else {
            return nil
        }
        return interval.start
    }
    
    /// 获取指定日期所在月最后一天
    /// - Parameter date: 给定日期，默认为当前时间
    /// - Returns: 最后一天日期
    mutating func lastDay(ofMonthFromDate date: Date = Date()) -> Date? {
        guard let interval = currentCalendar.dateInterval(of: .month, for: date) else {
            return nil
        }
        return getDate(date: interval.end, byAdding: -1)
    }
    
    /// 获取与给定日期相差days天数的日期
    /// - Parameters:
    ///   - date: 给定日期，默认为当前时间
    ///   - days: 相差的天数
    /// - Returns: 获取到的日期
    mutating func getDate(date PreviousOrFollowDate: Date = Date(), byAdding days: Int) -> Date? {
        guard days != 0 else { return PreviousOrFollowDate }
        
        var dateComponents = DateComponents()
        dateComponents.day = days
        return currentCalendar.date(byAdding: dateComponents, to: PreviousOrFollowDate)
    }
    
    /// 获取与给定日期相差months个月的日期
    /// - Parameters:
    ///   - date: 给定日期，默认为当前时间
    ///   - months: 相差的天月数
    /// - Returns: 获取到的日期（如果date为31日，获取的日期没有31日，那么他会获取当前月份的最后一天返回）
    mutating func getMonth(date PreviousOrFollowDate: Date = Date(), byAdding months: Int) -> Date? {
        guard months != 0 else { return PreviousOrFollowDate }
        
        var dateComponents = DateComponents()
        dateComponents.month = months
        return currentCalendar.date(byAdding: dateComponents, to: PreviousOrFollowDate)
    }
    
    /// 获取给定日期的年月日
    /// - Parameter date: 给定日期，默认为当前时间
    /// - Returns: 返回 DateComponents 对象
    mutating func components(date: Date = Date()) -> DateComponents {
        return currentCalendar.dateComponents([.year, .month, .day, .weekday], from: date)
    }
    
    /// 获取指定开始时间 与 指定结束时间之间的每个月的日期数组, 由于
    /// - Parameters:
    ///   - startDate: 指定开始时间
    ///   - endDate: 指定结束时间
    /// - Returns: 每个月的日期数组
    mutating func getMonthDaysArr(startDate: Date, endDate: Date) -> [[CalendarModel]] {
        let startComponents = components(date: startDate)
        let endComponents = components(date: endDate)
        
        guard let startYear = startComponents.year, let endYear = endComponents.year,
              let startMonth = startComponents.month, let endMonth = endComponents.month,
              (startYear != endYear) || (startMonth != endMonth) else {
            let indexDate = getMonthDays(date: startDate)
            return [indexDate]
        }
        
        // 获取月份个数
        let months = (endYear - startYear - 1) * 12 + (12 - startMonth + 1) + endMonth
        
        // 获取每个月日期数组
        var monthDaysArr: [[CalendarModel]] = []
        for index in 0..<months {
            if let indexDate = getMonth(date: startDate, byAdding: index) {
                // 获取当前月，第一次滚动使用
                if isCurrentMonth(date: indexDate) {
                    currentMonthIndex = index
                }
                let modelArr = getMonthDays(date: indexDate)
                monthDaysArr.append(modelArr)
            }
        }
        
        return monthDaysArr
    }
    
    /// 获取给定日期所在月的日期数组
    /// - Parameter date: 给定日期
    /// - Returns: 返回日期数组
    mutating func getMonthDays(date: Date) -> [CalendarModel] {
        let components = components(date: date)
        guard let dayCounts = days(ofMonthFromDate: date), let year = components.year, let month = components.month else {
            return []
        }
        
        var modelArr: [CalendarModel] = []
        
        // 上个月
        let previousArr = getPreviousMonthDays(date: date)
        if !previousArr.isEmpty {
            modelArr.append(contentsOf: previousArr)
        }
        
        // 当前月
        for index in 1...dayCounts {
            var model = CalendarModel(year: year, month: month, day: index)
            model.monthType = .currentMonth
//            model.isCurrentDay = isCurrentDate(date: date)
            modelArr.append(model)
        }
        
        // 下个月
        let followArr = getNextMonthDays(date: date)
        if !followArr.isEmpty {
            modelArr.append(contentsOf: followArr)
        }
        return modelArr
    }
    
    /// 如果指定日期所在月的第一天不为周一，需要拿上个月的后几天补充
    /// - Parameter date: 给定日期
    /// - Returns: 返回补充日期数组
    mutating func getPreviousMonthDays(date: Date) -> [CalendarModel] {
        guard let firstDate = firstDay(ofMonthFromDate: date),
              let weekly = getWeekday(date: firstDate), weekly - 1 != 0,
              let previousDate = getMonth(date: date, byAdding: -1),
              let previousDayCounts = days(ofMonthFromDate: previousDate) else {
            return []
        }
        
        let components = components(date: previousDate)
        guard let year = components.year, let month = components.month else {
            return []
        }
        
        // 获取上个月的日期
        var modelArr: [CalendarModel] = []
        for index in previousDayCounts - (weekly - 1) + 1...previousDayCounts {
            var model = CalendarModel(year: year, month: month, day: index)
            model.monthType = .previousMonth
            modelArr.append(model)
        }
        
        return modelArr
    }
    
    /// 如果指定日期所在月的最后一天不为周天，需要拿下个月的前几天补充进来
    /// - Parameter date: 给定日期
    /// - Returns: 返回补充日期数组
    mutating func getNextMonthDays(date: Date) -> [CalendarModel] {
        guard let lastDate = lastDay(ofMonthFromDate: date),
              let weekly = getWeekday(date: lastDate), weekly != 7,
              let followDate = getMonth(date: date, byAdding: 1) else {
            return []
        }
        
        let components = components(date: followDate)
        guard let year = components.year, let month = components.month else {
            return []
        }
        
        var modelArr: [CalendarModel] = []
        for index in 1...(7 - weekly) {
            var model = CalendarModel(year: year, month: month, day: index)
            model.monthType = .nextMonth
            modelArr.append(model)
        }
        
        return modelArr
    }
    
    /// 判断给定日期是否为今天
    /// - Parameter date: 指定日期
    /// - Returns: 是否为今天
    mutating func isCurrentDate(date: Date) -> Bool {
        let currentComPonents = components()
        let dateComPonents = components(date: date)
        
        if currentComPonents.year == dateComPonents.year,
           currentComPonents.month == dateComPonents.month,
           currentComPonents.day == dateComPonents.day,
           currentComPonents.weekday == dateComPonents.weekday {
            return true
        }
        
        return false
    }
    
    /// 判断指定日期是否为当前月
    /// - Parameter date: 指定日期
    /// - Returns: 是否为当前月
    mutating func isCurrentMonth(date: Date) -> Bool {
        let currentComPonents = components()
        let dateComPonents = components(date: date)
        
        if currentComPonents.year == dateComPonents.year,
           currentComPonents.month == dateComPonents.month {
            return true
        }
        
        return false
    }
    
    mutating func date(form: String) -> Date? {
        return formatter.date(from: form)
    }
    
    mutating func configureModule(dateStr: String, model: inout CalendarModel) {
        // 获取日期
        if let date = self.date(form: dateStr) {
            model.date = date                           // 日期
            model.weekday = getWeekday(date: date) ?? 0 // 星期几
            
            model.isCurrentDay = isCurrentDate(date: date)
            
            let lunarStrArr = lunarFormatter.string(from: date).components(separatedBy: "年")
            if !lunarStrArr.isEmpty {
                let lunarArr = lunarStrArr.last?.components(separatedBy: "月")
                if let lunarArr = lunarArr, lunarArr.count == 2 {
                    model.lunarMonth = "\(lunarArr.first ?? "")月"
                    model.lunarDay = lunarArr.last ?? ""
                }
            }
        }
    }
}
