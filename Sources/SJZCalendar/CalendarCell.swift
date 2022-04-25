//
//  CalendarCell.swift
//  Demo
//
//  Created by SJZ on 2022/4/21.
//

import UIKit
import SJZBaseModule
import SnapKit

class CalendarCell: UICollectionViewCell {
    
    var select: Bool = false {
        didSet {
            if select {
                contentView.backgroundColor = .green
            }else {
                contentView.backgroundColor = .white
            }
        }
    }
    
    // 阳历Label
    private lazy var solarLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.textColor = UIColor(hex: 0x2A2827)
        dateLabel.font = UIFont.font(15)
        dateLabel.textAlignment = .center
        return dateLabel
    }()
    
    // 农历Label
    private lazy var lunarLabel: UILabel = {
        let lunarLabel = UILabel()
        lunarLabel.textColor = UIColor(hex: 0xC4C2C0)
        lunarLabel.font = UIFont.font(15)
        lunarLabel.textAlignment = .center
        return lunarLabel
    }()

    private lazy var layoutGuide: UILayoutGuide = {
        let layoutGuide = UILayoutGuide()
        return layoutGuide
    }()
    
    // MARK: - 初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addLayoutGuide(layoutGuide)
        layoutGuide.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        contentView.addSubview(solarLabel)
        
        lunarLabel.isHidden = true
        contentView.addSubview(lunarLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(model: CalendarModel, configure: CalendarConfigure) {
        guard model.year != 0, model.month != 0, model.day != 0 else {
            solarLabel.isHidden = true
            lunarLabel.isHidden = true
            return
        }
        
        if configure.onlyShowShowMonth, model.monthType != .showMonth {
            solarLabel.isHidden = true
            lunarLabel.isHidden = true
            return
        }
        
        solarLabel.isHidden = false
        lunarLabel.isHidden = false
        
        solarLabel.text = "\(model.day)"
        lunarLabel.text = model.lunarDay
        
        if model.monthType == .showMonth {
            solarLabel.textColor = configure.showMonthColor
            solarLabel.font = configure.showMonthFont
            
            lunarLabel.textColor = configure.showMonthColor
            lunarLabel.font = configure.showMonthLunarFont
        }else {
            solarLabel.textColor = configure.notShowMonthColor
            solarLabel.font = configure.notShowMonthFont
            
            lunarLabel.textColor = configure.notShowMonthColor
            lunarLabel.font = configure.notShowMonthLunarFont
        }
        
        if model.isToday && model.monthType == .showMonth {
            solarLabel.textColor = configure.TodayColor
            lunarLabel.textColor = configure.TodayColor
        }
        
        if configure.calendarType == .onlySolar {
            lunarLabel.isHidden = true
            solarLabel.snp.makeConstraints { make in
                make.top.left.right.bottom.equalTo(layoutGuide)
            }
        }else if configure.calendarType == .solarAndLunar {
            lunarLabel.isHidden = false
            
            solarLabel.snp.makeConstraints { make in
                make.top.left.right.equalTo(layoutGuide)
            }
            
            lunarLabel.snp.makeConstraints { make in
                make.left.right.bottom.equalTo(layoutGuide)
                make.top.equalTo(solarLabel.snp.bottom).offset(configure.solarAndLunarSpace)
            }
        }
    }
}
