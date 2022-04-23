//
//  ViewController.swift
//  Demo
//
//  Created by SJZ on 2022/4/18.
//

import UIKit

class ViewController: UIViewController {

    
    var calendar: CalendarView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let form = DateFormatter()
        form.timeZone = TimeZone(abbreviation: "UTC") ?? TimeZone.current
        form.dateFormat = "yyyy-MM-dd"
        
        let string = "2010-05-01"
        let startDate = form.date(from: string)
        
        let endStr = "2050-05-01"
        let endDate = form.date(from: endStr)
        
        let configure = CalendarConfigure()
        configure.calendarType = .solarAndLunar
        configure.startDate = startDate!
        configure.endDate = endDate!
        
        calendar = CalendarView(configure: configure)
        view.addSubview(calendar!)
        calendar?.snp.makeConstraints({ make in
            make.top.equalTo(50)
            make.left.right.equalToSuperview()
            make.height.equalTo(300)
        })
    }

}

