//
//  SettingsData.swift
//  Fetchr
//
//  Created by Austin Bennett on 7/13/24.
//

import Foundation
import SwiftData

@Model
final class SettingsData:CustomStringConvertible {
    var id:UUID
    var storeDataInMemoryOnly:Bool
    var storeDataLocally:Bool
    var storeDataOniCloud:Bool
    var storeDataInFile:Bool
    
    var shareViaSlack:Bool
    var shareViaiMessage:Bool
    var shareViaDiscord:Bool
    var shareViaEmail:Bool
    
    var licenses:[LicenseData]
    
    var description: String {
        return ""
    }
    
    init(id:UUID=UUID(),
         storeDataInMemoryOnly:Bool,
         storeDataLocally:Bool,
         storeDataOniCloud:Bool,
         storeDataInFile:Bool,
         shareViaSlack:Bool,
         shareViaiMessage:Bool,
         shareViaDiscord:Bool,
         shareViaEmail:Bool) {
        self.id = id
        
        self.storeDataInMemoryOnly = true
        self.storeDataLocally = false
        self.storeDataOniCloud = false
        self.storeDataInFile = false
        
        self.shareViaSlack = true
        self.shareViaiMessage = true
        self.shareViaDiscord = true
        self.shareViaEmail = true
        
        self.licenses = []
        
    }
}
