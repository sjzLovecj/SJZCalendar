//
//  CalendarConfigure.swift
//  Demo
//
//  Created by SJZ on 2022/4/21.
//

import UIKit
import SJZBaseModule

enum CalendarType: Int {
    // 阳历
    case onlySolar
    // 农历
    case solarAndLunar
}

enum CalendarSelectType: Int {
    // 背景圆角
    case circular
    // 圆角矩形
    case roundedRect
}

class CalendarConfigure: NSObject {
    // 日历开始时间
    var startDate: Date = Date()
    // 日历结束时间
    var endDate: Date = Date()
    
    var manager = CalendarManager()
    // 日历数组
    lazy var monthModelArr: [[CalendarModel]] = {
        var monthModelArr: [[CalendarModel]]
        debugPrint(Date())
        monthModelArr = manager.getMonthDaysArr(startDate: startDate, endDate: endDate)
        debugPrint(Date())
        return monthModelArr
    }()
    
    // 当前显示月的本月文字颜色
    var currentColor: UIColor = UIColor(hex: 0x2A2827)
    var currentFont: UIFont = UIFont.medium(15)
    
    // 当前显示月的日历非本月的文字颜色
    var notCurrentColor: UIColor = UIColor(hex: 0xC4C2C0)
    var notCurrentFont: UIFont = UIFont.medium(15)
    
    // 今天 或者 选择日期颜色
    var selectColor: UIColor = .red
    var selectFont: UIFont = UIFont.medium(15)
    
    // MARK: - 是否显示农历
    var calendarType: CalendarType = .onlySolar
    
    // 农历和阳历之间的间隔，只有在显示农历的时候，才有作用
    var solarAndLunarSpace: CGFloat = 3
    
    // 当前显示月的本月农历颜色，只有在显示农历的时候，才有作用
    var currentLunarColor: UIColor = UIColor(hex: 0x2A2827)
    var currentLunarFont: UIFont = UIFont.font(11)
    
    // 当前显示月的日历非本月的农历颜色，只有在显示农历的时候，才有作用
    var notCurrentLunarColor: UIColor = UIColor(hex: 0xC4C2C0)
    var notCurrentLunarFont: UIFont = UIFont.font(11)
    
    // 今天 或者 选择日期颜色
    var selectLunarColor: UIColor = .red
    var selectLunarFont: UIFont = UIFont.font(11)
    
    var selectType: CalendarSelectType = .circular
}