//
//  License.swift
//  Fetchr
//
//  Created by Austin Bennett on 7/13/24.
//

import Foundation
import SwiftData

@Model
final class LicenseData:CustomStringConvertible {
    var id:UUID
    var name:String
    var license:String
    
    var description:String {
        return "<LicenseData id=\(id.uuidString)>"
    }
    
    init(id:UUID=UUID(), name:String, license:String) {
        self.id = id
        self.name = name
        self.license = license
    }
}
