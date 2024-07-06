//
//  ConnectionHeaderRow.swift
//  REST Requester
//
//  Created by Austin Bennett on 7/1/24.
//

import SwiftUI
import SwiftData

struct ConnectionHeaderRow: View {
    var headerRow:HeaderRow
    
    let deviceWidth:CGFloat
    let deviceHeight:CGFloat
    
    @State private var headerKey:String
    @State private var headerValue:String
    
    init(headerRow:HeaderRow, deviceWidth:CGFloat, deviceHeight:CGFloat) {
        self.headerRow = headerRow
        self.deviceWidth = deviceWidth
        self.deviceHeight = deviceHeight
        
        self.headerKey = headerRow.key
        self.headerValue = headerRow.value
    }
    
    var body: some View {
        HStack {
            TextField("Key", text: $headerKey)
                .frame(width: (deviceWidth / 2) - 30)
            #if os(iOS)
                .border(.bar, width: 2)
            #endif
            TextField("Value", text: $headerValue)
                .frame(width: (deviceWidth / 2) - 30)
            #if os(iOS)
                .border(.bar, width: 2)
            #endif
        }
    }
}

struct ConnectionHeaderRow_Previews: PreviewProvider {
    @State static var key:String = ""
    @State static var value:String = ""
    static var uuid:UUID = UUID()
    
    static let deviceWidth:CGFloat = UIScreen.main.bounds.width
    static let deviceHeight:CGFloat = UIScreen.main.bounds.height
    
    static var previews: some View {
        ConnectionHeaderRow(headerRow: HeaderRow(key: "", value: ""), deviceWidth: deviceWidth, deviceHeight: deviceHeight)
    }
}
