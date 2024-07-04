//
//  HeaderRow.swift
//  REST Requester
//
//  Created by Austin Bennett on 7/1/24.
//

import Foundation
import SwiftData

@Model
final class HeaderRow {
    var id:UUID
    var key:String
    var value:String
    
    init(key:String, value:String) {
        self.id = UUID()
        self.key = key
        self.value = value
    }
}
