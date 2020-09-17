//
//  CalenderViewController.swift
//  Covid-19
//
//  Created by 김현인 on 2020/09/12.
//  Copyright © 2020 HyunInKim. All rights reserved.
//

import UIKit
import FSCalendar
class CalenderViewController: UIViewController {

    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var dateSelectButton: UIButton!
    
    let today = NSDate()
    let todays = Date()
    let dateFormatter = DateFormatter()
    let calendar = Calendar.current
    private var firstDate: Date?
    private var lastDate: Date?
    private var datesRange: [Date]?
    var somedays : Array = [String]()
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter1: DateFormatter = {
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
        
        // Do any additional setup after loading the view.
        calendarView.today = nil
//        dateFormatter.dateFormat = "yyyy-MM-dd"
        //setDefaultDate()
        
       
        
    }
    
    private func setDefaultDate() {
        dateFormatter.dateFormat = "YYYY년 MM월 dd일"
        dateFormatter.locale = Locale(identifier: "ko_kr")
        let todayDate = dateFormatter.string(from: today as Date)
        let beforeDayCurrent = calendar.date(byAdding: .day, value: -7, to: today as Date)
        let beforeDay = dateFormatter.string(from: beforeDayCurrent!)
        dateSelectButton.setTitle("\(beforeDay) - \(todayDate) " , for: .normal)
      
        
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }

        var tempDate = from
        var array = [tempDate]

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }

        return array
    }

    
    @IBAction func dateSelectButtonOnclick(_ sender: Any) {
        
    }
    
  
    
    

}
extension CalenderViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
//        somedays = ["2020-09-16",
//                    "2020-09-17"]
//        let dateString: String = dateFormatter1.string(from: date)
//        if self.somedays.contains(dateString){
//            return UIColor.green
//        }else {
//            return nil
//        }
//    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        somedays = ["2020-09-16",
                    "2020-09-17"]
        let dateString: String = dateFormatter1.string(from: date)
        if self.somedays.contains(dateString){
            return UIColor.green
        }else {
            return nil
        }
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // nothing selected:
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            return
        }

        // only first date is selected:
        if firstDate != nil && lastDate == nil {
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]

                print("datesRange contains: \(datesRange!)")

                return
            }

            let range = datesRange(from: firstDate!, to: date)

            lastDate = range.last

            for d in range {
                calendar.select(d)
            }

            datesRange = range

            print("datesRange contains: \(datesRange!)")

            return
        }

        // both are selected:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }

            lastDate = nil
            firstDate = nil

            datesRange = []

            print("datesRange contains: \(datesRange!)")
        }
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // both are selected:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            lastDate = nil
            firstDate = nil
            datesRange = []
        }
    }
}
