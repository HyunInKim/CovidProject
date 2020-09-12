//
//  ViewController.swift
//  Covid-19
//
//  Created by 김현인 on 2020/09/12.
//  Copyright © 2020 HyunInKim. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Network.getCovidStatus(pageNo: 1, numberOfRows: 10, startCreateDt: 20200310, endCreateDt: 20200315) { (covid) in
            guard let result = covid else {return}
            
            print(result.itemList[1])
        }
    }
    


}

