//
//  Global.swift
//  Covid-19
//
//  Created by 김현인 on 2020/09/12.
//  Copyright © 2020 HyunInKim. All rights reserved.
//

import Foundation

class Global {
    
    private var _serviceKey: String = "V0gkf%2Bht8OFhiv%2Bd75Da0vhpyv15AZcnswUwqdRjRL%2Fdy1yhxWVdMeLc7x%2BaOvon087McqgXReWjBZOWmOuwnQ%3D%3D"
    
    public var serviceKey: String {
        get {
            return _serviceKey
        }
    }
    public var todayRange: Array = [String]()
}
