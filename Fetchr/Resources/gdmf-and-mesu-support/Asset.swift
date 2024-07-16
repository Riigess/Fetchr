//
//  Asset.swift
//  Fetchr
//
//  Created by Austin Bennett on 7/11/24.
//

import Foundation

struct Asset:Codable {
    var ArchiveDecryptionKey:String
    var ArchiveDecryptionKeyFile:String
    var ArchiveID:String
    var AssetFormat:String
    var AssetSpecifier:String
    var AssetType:String
    var AssetVersion:String
    var AssetVersionInfo:AssetVersionInfo
    var Build:String
    var _AssetReceipt:AssetReceipt
    var _CompressionAlgorithm:String
    var _DownloadPolicy:Int
    var _DownloadSize:Int
    var _IsMAAutoAsset:Bool
    var _Measurement:String
    var _MeasurementAlgorithm:String
    var _PreSoftwareUpdateAssetStaging:Bool
    var _RetentionPolicy:Int
    var _UnarchivedSize:Int
    var __BaseURL:String
    var __CanUseLocalCacheServer:Bool
    var __RelativePath:String
    var version:String
    var SupportedDevices:[String]
    var SupportedDeviceNames:[String]
    var _OSVersionCompatibilities:OSVersionCompatibilities
    var Ramp:Bool
}
