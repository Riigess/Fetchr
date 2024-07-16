//
//  AssetVersionInfo.swift
//  Fetchr
//
//  Created by Austin Bennett on 7/11/24.
//

import Foundation

struct AssetVersionInfo:Codable {
    var AssetVersionGroup:Int
    var AssetVersionLong:String
    var AssetVersionTuple:String
    var BuildVersionTuple:String
    var BundleVersionTuple:String
}
