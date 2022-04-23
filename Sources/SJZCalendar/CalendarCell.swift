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
            solarLabel.text = ""
            lunarLabel.text = ""
            return
        }
        
        solarLabel.text = "\(model.day)"
        lunarLabel.text = model.lunarDay
        
        if model.monthType == .currentMonth {
            solarLabel.textColor = configure.currentColor
            solarLabel.font = configure.currentFont
            
            lunarLabel.textColor = configure.currentLunarColor
            lunarLabel.font = configure.currentLunarFont
        }else {
            solarLabel.textColor = configure.notCurrentColor
            solarLabel.font = configure.notCurrentFont
            
            lunarLabel.textColor = configure.notCurrentLunarColor
            lunarLabel.font = configure.notCurrentLunarFont
        }
        
        if model.isCurrentDay {
            solarLabel.textColor = configure.selectColor
            solarLabel.font = configure.selectFont
            
            lunarLabel.textColor = configure.selectLunarColor
            lunarLabel.font = configure.selectLunarFont
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
