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

    // 只展示 显示的月日期
    var onlyShowShowMonth: Bool = false
    
    var manager = CalendarManager()
    // 日历数组
    lazy var monthModelArr: [[CalendarModel]] = {
        var monthModelArr: [[CalendarModel]]
        debugPrint(Date())
        monthModelArr = manager.getMonthDaysArr(startDate: startDate, endDate: endDate)
        debugPrint(Date())
        return monthModelArr
    }()
    
    // 单行Cell
    lazy var onlyItemMonthModeArr: [[CalendarModel]] = {
        var onlyItemMonthModeArr: [[CalendarModel]] = []
        
        return onlyItemMonthModeArr
    }()
    
    // MARK: - 整个日历的高度
    var calendarHeight: CGFloat {
        get {
            weekTitleHeight + itemHeight * 6
        }
    }
    
    var onlyItemCalendarHeight: CGFloat {
        get {
            weekTitleHeight + itemHeight
        }
    }
    
    // 日期的高度，如果使用CalendarView，请结合使用itemHeight、weekTitleHeight、monthTitleHeight来计算整体高度
    var itemHeight: CGFloat = 50
    
    // MARK: - 标题设置
    // 星期标题 高度、字体、颜色
    var weekTitleArr: [String] = ["一", "二", "三", "四", "五", "六", "日"]
    var weekTitleHeight: CGFloat = 30
    var weekTitleFont: UIFont = UIFont.font(13)
    var weekTitleColor: UIColor = UIColor(hex: 0xE1E0DF)
    
    // 月份标题 高度、字体、颜色
    var monthTitleHeight: CGFloat = 40
    var monthTitleFont: UIFont = UIFont.medium(15)
    var monthTitleColor: UIColor = UIColor(hex: 0x2A2827)
    
    // MARK: - 农历 和 阳历设置
    // 当前展示月本月文字颜色、字体大小设置，农历的颜色和阳历颜色一致大
    var showMonthColor: UIColor = UIColor(hex: 0x2A2827)
    var showMonthFont: UIFont = UIFont.medium(15)
    var showMonthLunarFont: UIFont = UIFont.font(11)
    
    // 当前显示月的日历非本月的文字颜色，农历的颜色和阳历颜色一致
    var notShowMonthColor: UIColor = UIColor(hex: 0xC4C2C0)
    var notShowMonthFont: UIFont = UIFont.medium(15)
    var notShowMonthLunarFont: UIFont = UIFont.font(11)
    
    // 今天的颜色
    var TodayColor: UIColor = .red
    // 选择日期颜色
    var selectColor: UIColor = .red
    
    // 农历和阳历之间的间隔，只有在显示农历的时候，才有作用
    var solarAndLunarSpace: CGFloat = 3
    
    // MARK: - 日历类型，只有类型展示农历的时候，才会使用农历
    var calendarType: CalendarType = .onlySolar
    var selectType: CalendarSelectType = .circular
}
