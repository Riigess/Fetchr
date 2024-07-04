//
//  HeaderRowData.swift
//  REST Requester
//
//  Created by Austin Bennett on 7/1/24.
//

import Foundation

class HeaderRowData:Hashable {
    static func == (lhs: HeaderRowData, rhs: HeaderRowData) -> Bool {
        return lhs.key == rhs.key && lhs.value == rhs.value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    var key:String
    var value:String
    
    init(key:String="", value:String="") {
        self.key = key
        self.value = value
    }
}
