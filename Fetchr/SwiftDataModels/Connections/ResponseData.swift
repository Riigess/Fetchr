//
//  ResponseData.swift
//  Fetchr
//
//  Created by Austin Bennett on 7/10/24.
//

import Foundation
import SwiftData

@Model
final class ResponseData:CustomStringConvertible {
    var id:UUID
    var response:String
    var responseHeaders:[HeaderRow]
    
    var description:String {
        return "<\(type(of: self)): id=\(id)>"
    }
    
    init(response:String) {
        id = UUID()
        self.response = response
        self.responseHeaders = []
    }
}
