//
//  Network.swift
//  Covid-19
//
//  Created by 김현인 on 2020/09/12.
//  Copyright © 2020 HyunInKim. All rights reserved.
//

import Foundation
import Alamofire

class Network {
    var shared = Network()
    private init() {}
    
    
    static var serviceKey: String = "V0gkf%2Bht8OFhiv%2Bd75Da0vhpyv15AZcnswUwqdRjRL%2Fdy1yhxWVdMeLc7x%2BaOvon087McqgXReWjBZOWmOuwnQ%3D%3D"
    
    static func getCovidStatus(pageNo: Int, numberOfRows: Int, startCreateDt: String, endCreateDt: String, handler: ((Covid?) -> Void)? = nil) {
        
        let deocdeKey =  serviceKey.removingPercentEncoding ?? ""
        let requestURL: String = "http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19InfStateJson"
        
        
        let parameter: [String : Any] = [
            "ServiceKey" : deocdeKey,
            "pageNo" : pageNo,
            "numberOfRows" : numberOfRows,
            "startCreateDt" : startCreateDt,
            "endCreateDt" : endCreateDt
        ]
        Alamofire.request(requestURL, method: .get, parameters: parameter)
            .responseData { (response) in
                var covid: Covid?
                defer {
                    handler?(covid)
                }
                switch response.result {
                case .success(let result):
                    covid = Covid(data: result)
                    //print(covid?.itemList.count)
                case .failure(let error):
                    print(error.localizedDescription, error)
                }
        }
        
    }
}
