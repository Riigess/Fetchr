//
//  ConnectionHeaderRowPreviewDevices.swift
//  Fetchr
//
//  Created by Austin Bennett on 7/30/24.
//

import Foundation

enum ConnectionHeaderRowPreviewDevices: String, CaseIterable {
    case iPhone15ProMax = "iPhone 15 Pro Max"
    //    case Coeus = "Coeus" //My Personal Device
    case iPhone15Pro = "iPhone 15 Pro"
    case iPhone15 = "iPhone 15"
    case iPhone13Mini = "iPhone 13 mini"
    
    static var allCases: [String] {
        return ConnectionHeaderRowPreviewDevices.allCases.map { $0.rawValue }
    }
}
