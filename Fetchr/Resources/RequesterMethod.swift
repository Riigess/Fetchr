//
//  RequesterMethod.swift
//  REST Requester
//
//  Created by Austin Bennett on 6/21/24.
//

import Foundation

enum RequesterMethod:String, Codable {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
    case HEAD = "HEAD"
    case OPTIONS = "OPTIONS"
    case TRACE = "TRACE"
}
