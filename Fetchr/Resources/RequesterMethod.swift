//
//  RequesterMethod.swift
//  REST Requester
//
//  Created by Austin Bennett on 6/21/24.
//

import Foundation

enum RequesterMethod:String, Codable, CaseIterable, Identifiable {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
    case HEAD = "HEAD"
    case OPTIONS = "OPTIONS"
    case TRACE = "TRACE"
    
    var id: String {
        return rawValue
    }
    
    static var allCases: [String] {
        return [GET.rawValue,
                POST.rawValue,
                PUT.rawValue,
                DELETE.rawValue,
                PATCH.rawValue,
                HEAD.rawValue,
                OPTIONS.rawValue,
                TRACE.rawValue]
    }
}
