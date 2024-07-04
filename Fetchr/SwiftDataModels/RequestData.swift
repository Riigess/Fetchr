//
//  HeaderData.swift
//  REST Requester
//
//  Created by Austin Bennett on 7/1/24.
//

import Foundation
import SwiftData

@Model
final class RequestData: CustomStringConvertible {
    var id:UUID
    var name:String
    var url:String
    var headerData:HeaderData
    var bodyData:BodyData
    var method:RequesterMethod
    
    var description:String {
        return "<\(type(of: self)): id=\(id.uuidString) | name=\(name) | url=\(url) | headerData=\(headerData.description) | bodyData=\(bodyData.description) | method=\(method.rawValue)>"
    }
    
    init(url:String = "", method:RequesterMethod = .GET, name:String = "") {
        id = UUID()
        headerData = HeaderData()
        bodyData = BodyData(strContent: nil, jsonBodyString: nil)
        self.name = name
        self.url = url
        self.method = method
    }
}
