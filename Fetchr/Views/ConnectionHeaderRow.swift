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
    let isHeaderRow:Bool
//    let parentView:any View
    
    @State private var headerKey:String
    @State private var headerValue:String
    @State private var offset:CGFloat
    @State var headerRows:[HeaderRow]
    
    init(headerRow:HeaderRow, deviceWidth:CGFloat, deviceHeight:CGFloat, isHeaderRow:Bool = true, headerRows:[HeaderRow]) {
        self.headerRow = headerRow
        self.deviceWidth = deviceWidth
        self.deviceHeight = deviceHeight
        
        self.headerKey = headerRow.key
        self.headerValue = headerRow.value
        self.isHeaderRow = isHeaderRow
        self.headerRows = headerRows
        self.offset = 0
    }
    
    var body: some View {
        ZStack {
            ZStack {
                HStack {
                    RoundedTrapezoidShape(slope: 5)
                        .frame(width: 60, height: 100)
                        .foregroundStyle(isHeaderRow ? Color.orange : Color.blue)
                        .rotationEffect(Angle(degrees: 180))
                        .offset(x: 20)
                    RoundedTrapezoidShape(slope: 5)
                        .frame(width: deviceWidth - 50, height: 100)
                        .offset(x: -20)
                }
                Text(isHeaderRow ? "Header" : "Body")
                    .rotationEffect(Angle(degrees: 75))
                    .foregroundStyle(Color(UIColor.systemGray6))
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
        .offset(x: offset)
        .gesture(DragGesture(minimumDistance: 2, coordinateSpace: .local).onChanged { value in
            if value.translation.width > -100 && value.translation.width < 0 {
                offset = value.translation.width
            } else if value.translation.width <= -100 {
                offset = -100.0
            } else {
                withAnimation {
                    offset = 0.0
                }
            }
        }.onEnded { value in
            if value.translation.width < -20 {
                withAnimation {
                    offset = -100.0
                }
                print("Ended with translation less than -20")
            } else if value.translation.width > -20 && value.translation.width < 0 {
                withAnimation {
                    offset = 0.0
                }
                print("Ended with translation between 0 and -20")
            } else {
                offset = 0.0
                print("Failed to find valid translation range - \(value.translation.width)")
            }
            print("Ended with offset \(offset)")
        })
    }
    
    func deleteRow(at offsets:IndexSet) {
        self.headerRows.remove(atOffsets: offsets)
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
    
    @State static var headerRows:[HeaderRow] = [
        HeaderRow(key: "Testing Header Key A", value: "blah blah blah"),
        HeaderRow(key: "Testing Header Key B", value: "nah nah nah"),
        HeaderRow(key: "X-Riot-Api-Token", value: "rgapi_ritodev-auto_color_scheme"),
        HeaderRow(key: "Testing Header Key C", value: "blah blah blah"),
        HeaderRow(key: "Testing Header Key D", value: "nah nah nah"),
    ]
    
    static var previews: some View {
        ForEach(previewDevices, id: \.self) { device in
            VStack {
                ForEach(headerRows, id: \.self) { headerRow in
                    ConnectionHeaderRow(headerRow: headerRow,
                                        deviceWidth: deviceWidth,
                                        deviceHeight: deviceHeight,
                                        headerRows: headerRows)
                }
            }
            .previewDevice(PreviewDevice(rawValue: device))
            .previewDisplayName(device)
        }
    }
}
