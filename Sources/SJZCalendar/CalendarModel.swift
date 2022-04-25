//
//  CalendarModel.swift
//  Demo
//
//  Created by SJZ on 2022/4/19.
//

import Foundation

enum CalendarDateType: Int {
    case previousMonth  // 上个月
    case showMonth      // 展示月
    case nextMonth      // 下个月
}

class CalendarModel {
    var year: Int
    var month: Int
    var day: Int
    
    // 是否为当前月
    var monthType: CalendarDateType = .showMonth
    // 是否为今天
    var isToday = false
    
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
