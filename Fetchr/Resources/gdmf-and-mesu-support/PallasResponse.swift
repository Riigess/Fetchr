//
//  PallasResponse.swift
//  Fetchr
//
//  Created by Austin Bennett on 7/11/24.
//

import Foundation

struct PallasResponse:Codable, CustomStringConvertible {
    var Nonce:String
    var PallasNonce:String
    var SessionId:String
    var LegacyXmlUrl:String
    var PostingDate:String
    var Transformations:Transformations
    var Assets:[Asset]
    var AssetSetId:String
    var AssetAudience:String
    
    var description:String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            return String(data: try encoder.encode(self), encoding: .utf8)!
        } catch {
            let someNonce = Nonce.count > 0 ? Nonce : (PallasNonce.count > 0 ? PallasNonce : SessionId)
            return "<PallasResponse \(someNonce)>"
        }
    }
}
