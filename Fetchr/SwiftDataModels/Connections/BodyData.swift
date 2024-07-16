//
//  BodyData.swift
//  REST Requester
//
//  Created by Austin Bennett on 7/1/24.
//

import Foundation
import SwiftData

@Model
final class BodyData: CustomStringConvertible {
    var id:UUID
    var strContent:String?
    var jsonBodyString:String?
    
    var description: String {
        return "<\(type(of: self)): id=\(id.uuidString)>"
    }
    
    init(strContent:String?, jsonBodyString:String?) {
        self.strContent = strContent == nil ? "" : strContent
        self.jsonBodyString = jsonBodyString == nil ? "" : jsonBodyString
        self.id = UUID()
    }
}
