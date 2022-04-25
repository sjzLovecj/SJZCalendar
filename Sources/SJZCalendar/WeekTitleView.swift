//
//  WeekTitleView.swift
//  Demo
//
//  Created by SJZ on 2022/4/24.
//

import UIKit

class WeekTitleView: UIView {
    var configure: CalendarConfigure
    
    // WeakTitle 信息
    private lazy var weekTitleLabels: [UILabel] = []
    
    init(configure: CalendarConfigure) {
        self.configure = configure
        super.init(frame: .zero)
        
        for (index, title) in configure.weekTitleArr.enumerated() {
            let label = UILabel()
            label.text = title
            label.textAlignment = .center
            label.textColor = configure.weekTitleColor
            label.font = configure.weekTitleFont
            addSubview(label)
            
            weekTitleLabels.append(label)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 布局
        let labelWidth = frame.size.width / 7
        for (index, label) in weekTitleLabels.enumerated() {
            label.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.left.equalTo(labelWidth * CGFloat(index))
                make.width.equalTo(labelWidth)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
