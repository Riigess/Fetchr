//
//  OSVersionBounds.swift
//  Fetchr
//
//  Created by Austin Bennett on 7/11/24.
//

import Foundation

struct OSVersionBounds:Codable {
    var _MinOSVersion:String
    var _MaxOSVersion:String? = ""
}
