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
        var headerRowDescriptions:[String] = []
        for row in headerRows {
            headerRowDescriptions.append(row.description)
        }
        let headerRowsDescriptionStr:String = headerRowDescriptions.joined(separator: ", ")
        return "<\(type(of: self)): id=\(id.uuidString) | headerRows=[\(headerRowsDescriptionStr)]>"
    }
    
    init() {
        id = UUID()
        headerRows = []
    }
}
