//
//  CalendarModel.swift
//  Demo
//
//  Created by SJZ on 2022/4/19.
//

import Foundation

enum CalendarDateType: Int {
    case previousMonth
    case currentMonth
    case nextMonth
}

struct CalendarModel {
    var year: Int
    var month: Int
    var day: Int
    
    // 是否为当前月
    var monthType: CalendarDateType = .currentMonth
    // 是否为今天
    var isCurrentDay = false
    
    var date: Date?
    // 星期几
    var weekday: Int = 0
    var lunarMonth: String = ""
    var lunarDay: String = ""
    
    init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }
}
