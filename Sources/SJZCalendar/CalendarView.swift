//
//  CalendarView.swift
//  Demo
//
//  Created by SJZ on 2022/4/24.
//

import UIKit

class CalendarView: UIView {

    // MARK: - 本类初始化 需要 初始化的属性
    private var configure: CalendarConfigure
    private var monthTitle: MonthTitleView
    private var calendar: CalendarCollectionView
//    private var oneLineCalendar: CalendarCollectionView
    
    init(configure: CalendarConfigure) {
        self.configure = configure
        
        monthTitle = MonthTitleView(configure: configure)
        calendar = CalendarCollectionView(configure: configure)
//        oneLineCalendar = CalendarCollectionView(configure: configure)
        super.init(frame: .zero)
        
        // 布局子视图
        buildSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildSubView() {
        addSubview(calendar)
//        addSubview(oneLineCalendar)
        addSubview(monthTitle)
        
        monthTitle.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(configure.monthTitleHeight)
        }
        
        calendar.delegate = self
        calendar.snp.makeConstraints { make in
            make.top.equalTo(monthTitle.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(configure.calendarHeight)
        }
        
//        oneLineCalendar.isHidden = true
//        oneLineCalendar.scrollingBehavior = .none
//        oneLineCalendar.collectionView.reloadData()
//        oneLineCalendar.snp.makeConstraints { make in
//            make.top.equalTo(monthTitle.snp.bottom)
//            make.right.left.equalToSuperview()
//            make.height.equalTo(configure.onlyItemCalendarHeight)
//        }
    }
}

extension CalendarView: CalendarCollectionViewDelegate {
    func calendar(_ calendar: CalendarCollectionView, didSelectItem model: CalendarModel) {
        
    }
    
    func calendar(_ calendar: CalendarCollectionView, section: Int) {
        let modeArr = configure.monthModelArr[section]
        for model in modeArr {
            if model.monthType == .showMonth {
                monthTitle.monthStr = "\(model.year)年\(model.month)月"
                break
            }
        }
    }
}
