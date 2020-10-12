//
//  ViewController.swift
//  Covid-19
//
//  Created by 김현인 on 2020/09/12.
//  Copyright © 2020 HyunInKim. All rights reserved.
//

import UIKit
import Alamofire
import ScrollableGraphView
class ViewController: UIViewController, SendDataDelegate {
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var graphView: ScrollableGraphView!
    
    fileprivate lazy var dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "calendarShow" {
            let viewController: CalenderViewController = segue.destination as! CalenderViewController
            viewController.delegate = self
        }
    }
    internal func sendDateData(startDate: Date?, endDate: Date?) {
        startDateLabel.text = dateFormatter.string(from: startDate!)
        endDateLabel.text = dateFormatter.string(from: endDate!)
    }
}

