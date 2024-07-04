//
//  HeaderData.swift
//  REST Requester
//
//  Created by Austin Bennett on 7/1/24.
//

import Foundation
import SwiftData

@Model
final class HeaderData:CustomStringConvertible {
    var id:UUID
    var headerRows:[HeaderRow]
    
    var description: String {
        return "<\(type(of: self)): id=\(id.uuidString) | headerRows=\(headerRows.description)>"
    }
    
    init() {
        id = UUID()
        headerRows = []
    }
}
