//
//  RequesterErrors.swift
//  REST Requester
//
//  Created by Austin Bennett on 7/2/24.
//

import Foundation

enum RequesterErrors: Error {
    case invalidURL(String)
    case invalidResponse(String)
    case unableToSaveFile(String)
}
