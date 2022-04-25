//
//  MonthTitleView.swift
//  Demo
//
//  Created by SJZ on 2022/4/24.
//

import UIKit

class MonthTitleView: UIView {
    // 上个月、下个月
    var monthStr: String = "" {
        didSet {
            monthLabel.text = monthStr
        }
    }
    
    var configure: CalendarConfigure
    private lazy var monthLabel: UILabel = UILabel()
    
    init(configure: CalendarConfigure) {
        self.configure = configure
        super.init(frame: .zero)
        
        // 设置monthLabel
        monthLabel.textColor = configure.monthTitleColor
        monthLabel.font = configure.monthTitleFont
        addSubview(monthLabel)
        monthLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
