//
//  OSVersionCompatibilities.swift
//  Fetchr
//
//  Created by Austin Bennett on 7/11/24.
//

import Foundation

struct OSVersionCompatibilities:Codable {
    var Mac:OSVersionBounds
    var iPad:OSVersionBounds
    var iPhone:OSVersionBounds
    var HomePod:OSVersionBounds
    var Apple_TV:OSVersionBounds
    var Apple_Watch:OSVersionBounds
    var Apple_Vision:OSVersionBounds
    var rProd_Device:OSVersionBounds
    var HomeAccessory:OSVersionBounds
    var iPod:OSVersionBounds?
    
    enum CodingKeys: String, CodingKey {
        case Mac
        case iPad
        case iPhone
        case HomePod
        case Apple_TV = "Apple TV"
        case Apple_Watch = "Apple Watch"
        case Apple_Vision = "Apple Vision"
        case rProd_Device = "rProd Device"
        case HomeAccessory
        case iPod
    }
}
