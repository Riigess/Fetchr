//
//  BodySendableType.swift
//  Fetchr
//
//  Created by Austin Bennett on 7/8/24.
//

import Foundation

enum BodySendableType:String, CaseIterable, Identifiable {
    case string, data, json
    
    var id: String {
        return rawValue
    }
}
