//
//  CalenderViewController.swift
//  Covid-19
//
//  Created by 김현인 on 2020/09/12.
//  Copyright © 2020 HyunInKim. All rights reserved.
//

import UIKit
import FSCalendar

protocol SendDataDelegate {
    func sendDateData(startDate: Date?, endDate: Date?)
}
class CalenderViewController: UIViewController {

    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var dateSelectButton: UIButton!
    private let today = Date()
    private var firstDate: Date?
    private var lastDate: Date?
    private var datesRange: [Date]?
    
    
    var delegate: SendDataDelegate?
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.allowsMultipleSelection = true
        calendarView.swipeToChooseGesture.isEnabled = true
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.today = nil
        setDefaultDates(today: today as Date, decrease: 7)  // 현재 날짜에서 일주일 전
    }
    
    private func setDefaultDates(today: Date, decrease: Int) {
        var tempDate = today
        var todayArray : Array = [Date]()
        for i in 0..<decrease {
            if i == 0 {
                todayArray.append(tempDate)
                calendarView.select(tempDate)
            }
            tempDate = Calendar.current.date(byAdding: .day, value: -1, to: tempDate)!
            todayArray.append(tempDate)
            calendarView.select(tempDate)
        }
        dateSelectButton.setTitle("\(dateFormatter.string(from: todayArray.last!)) ~ \(dateFormatter.string(from: todayArray.first!))",for: .normal)
    }
        
    private func datesRange(from: Date, to: Date) -> [Date] {
        
        if from > to { return [Date]() }
        var tempDate = from
        var array = [tempDate]
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
    }

    private func initDate(calendar: FSCalendar, date: Date) {
        for selectedDate in calendar.selectedDates {
            calendar.deselect(selectedDate)
        }
        firstDate = date
        lastDate = nil
        datesRange = []
        calendar.select(date)
        dateSelectButton.setTitle(dateFormatter.string(from: date), for: .normal)
    }
    
    @IBAction func dateSelectButtonOnclick(_ sender: Any) {
        if lastDate == nil {
            lastDate = firstDate
        }
        
        delegate?.sendDateData(startDate: firstDate, endDate: lastDate)
        dateFormatter.dateFormat = "yyyyMMdd"
        Network.getCovidStatus(pageNo: 1,
                               numberOfRows: 10,
                               startCreateDt: dateFormatter.string(from: firstDate!),
                               endCreateDt: dateFormatter.string(from: lastDate!)) { (covid) in
            guard let result = covid else {return}
            print(result.itemList)
            
        }
        dismiss(animated: true, completion: nil)
    }
}
extension CalenderViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if firstDate == nil {   // 첫날 선택
            firstDate = date
            datesRange = [firstDate!]
            //  초기에 선택되었던 날 삭제
            for selectedDate in calendar.selectedDates {
                calendar.deselect(selectedDate)
            }
            calendar.select(date)
            dateSelectButton.setTitle(dateFormatter.string(from: date), for: .normal)
            return
            
        } else if firstDate != nil && lastDate == nil {     // 두쨋날 선택
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]
                dateSelectButton.setTitle(dateFormatter.string(from: date), for: .normal)
                return
            }
            let range = datesRange(from: firstDate!, to: date)
            lastDate = range.last
            for i in range {
                calendar.select(i)
            }
            datesRange = range
            dateSelectButton.setTitle("\(dateFormatter.string(from: (datesRange?.first)!)) ~ \(dateFormatter.string(from: (datesRange?.last)!))", for: .normal)
            return
            
        } else if firstDate != nil && lastDate != nil {     // 새로 선택할 경우
            initDate(calendar: calendar, date: date)
        }
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 선택된 날짜를 선택할 경우 초기화
        initDate(calendar: calendar, date: date)
    }
}
