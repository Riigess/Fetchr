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
        ZStack {
            ZStack {
                HStack {
                    RoundedTrapezoidShape(slope: 5)
                        .frame(width: 60, height: 100)
                        .foregroundStyle(Color.orange)
                        .rotationEffect(Angle(degrees: 180))
                        .offset(x: 20)
                    RoundedTrapezoidShape(slope: 5)
                        .frame(width: deviceWidth - 50, height: 100)
                        .offset(x: -20)
                }
                Text("Header")
                    .rotationEffect(Angle(degrees: 75))
                    .foregroundStyle(Color.black)
                    .offset(x: 40 - (deviceWidth / 2))
                    .font(.title3)
            }
            VStack {
                TextField("Key", text: $headerKey)
                    .frame(width: deviceWidth - 90, height: 32)
                    .tag(0)
                    .padding(.leading, 10)
                    .background {
                        RoundedRectangle(cornerRadius: 32.0 / 3.0)
                            .foregroundStyle(Color(UIColor.systemGray4))
                    }
                HStack {
                    Text("")
                        .frame(width: 12)
                    TextField("Value", text: $headerValue)
                        .frame(width: deviceWidth - 110, height: 32)
                        .tag(1)
                        .padding(.leading, 10)
                        .background {
                            RoundedRectangle(cornerRadius: 32.0 / 3.0)
                                .foregroundStyle(Color(UIColor.systemGray4))
                        }
                }
                .padding(.top, 2)
            }
            .frame(alignment: .trailing)
            .offset(x: 16)
        }
    }
}

enum ConnectionHeaderRowPreviewDevices: String, CaseIterable {
    case iPhone15ProMax = "iPhone 15 Pro Max"
    case Coeus = "Coeus" //My Personal Device
    case iPhone15Pro = "iPhone 15 Pro"
    case iPhone15 = "iPhone 15"
    
    static var allCases: [String] {
        return ConnectionHeaderRowPreviewDevices.allCases.map { $0.rawValue }
    }
}
struct ConnectionHeaderRow_Previews: PreviewProvider {
    @State static var key:String = ""
    @State static var value:String = ""
    static var uuid:UUID = UUID()
    
    static let deviceWidth:CGFloat = UIScreen.main.bounds.width
    static let deviceHeight:CGFloat = UIScreen.main.bounds.height
    
    static let previewDevices: [String] = ConnectionHeaderRowPreviewDevices.allCases
    
    static var previews: some View {
        ForEach(previewDevices, id: \.self) { device in
            VStack {
                ConnectionHeaderRow(headerRow: HeaderRow(key: "Testing Header Key A", value: "blah blah blah"),
                                    deviceWidth: deviceWidth,
                                    deviceHeight: deviceHeight)
                ConnectionHeaderRow(headerRow: HeaderRow(key: "Testing Header Key B", value: "nah nah nah"),
                                    deviceWidth: deviceWidth,
                                    deviceHeight: deviceHeight)
                ConnectionHeaderRow(headerRow: HeaderRow(key: "X-Riot-Api-Token", value: "rgapi_arghifjweawgihgiweroasgiaewrighjiargaiefh"),
                                    deviceWidth: deviceWidth,
                                    deviceHeight: deviceHeight)
            }
            .previewDevice(PreviewDevice(rawValue: device))
            .previewDisplayName(device)
        }
    }
}
