//
//  ConnectionHeaderRow.swift
//  REST Requester
//
//  Created by Austin Bennett on 7/1/24.
//

import SwiftUI
import SwiftData

struct ConnectionHeaderRow: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    var headerRow:HeaderRow
    
    let deviceWidth:CGFloat
    let deviceHeight:CGFloat
    let isHeaderRow:Bool
    
    @State private var headerKey:String
    @State private var headerValue:String
    @State private var offset:CGFloat
    @State var headerRows:[HeaderRow]
    @State var headerTab:Color = .orange
    @FocusState private var valueHeaderIsFocused:Bool
    
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
            HStack(spacing: 0) {
                ZStack {
                    PartialPillShape(roundedCornerRadius: 20)
                        .frame(width: 50)
                        //Force red color if only Value is provided
                        .foregroundStyle(isHeaderRow ? headerTab : (headerTab != .red ? Color.blue : Color.red))
                        .onAppear {
                            if self.headerKey.isEmpty && !self.headerValue.isEmpty {
                                headerTab = .red
                            }
                        }
                    Text(isHeaderRow ? "Header" : "Body")
                        .rotationEffect(Angle(degrees: 90))
                        .foregroundStyle(Color(UIColor.systemGray6))
                        .font(.title3)
                        .padding(.top, 0)
                }
                .offset(x: 10)
                ZStack {
                    GeometryReader { geom in
                        //Background
                        PartialPillShape(roundedCornerRadius: 22)
                            .rotationEffect(Angle(degrees: 180))
                            .foregroundStyle(colorScheme == .light ? Color.black : Color.white)
                        //Foreground (behind CustomTextFields)
                        PartialPillShape(roundedCornerRadius: 20)
                            .rotationEffect(Angle(degrees: 180))
                            .foregroundStyle(colorScheme == .light ? Color.white : Color.black)
                            .frame(width: geom.size.width - 2, height: geom.size.height - 4)
                            .offset(x: 0, y: 2)
                    }
                    VStack(spacing: 12) {
                        CustomTextField(label: "Key", text: $headerKey, cornerRadius: 8)
                            .padding(.leading, 10)
                            .submitLabel(.next)
                            .onSubmit {
                                valueHeaderIsFocused = true
                            }
                        CustomTextField(label: "Value", text: $headerValue, cornerRadius: 8)
                            .padding(.leading, 10)
                            .focused($valueHeaderIsFocused)
//                            .frame(width: self.deviceWidth - 90, height: 26)
                            .submitLabel(SubmitLabel.done)
                            .onSubmit {
                                valueHeaderIsFocused = false
                                if !headerKey.isEmpty {
                                    headerRow.key = headerKey
                                    headerRow.value = headerValue
                                } else if !headerValue.isEmpty {
                                    headerTab = Color.red
                                }
                                attemptSaveData()
                                print("Attempted to save for row named \(headerRow.key)")
                            }
                            .onTapGesture {
                                print("Tapped! CustomTextField with label \"\(self.headerValue)\"")
                            }
                    }
                    .frame(width: deviceWidth - 90, height: 52 + 10)
                    .offset(x: -12)
                }
            }
            .frame(height: 80)
            .offset(x: -10)
        }
        .frame(height: 80)
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
    
    func attemptSaveData(waitForCompletion:Bool = false) {
        let saveQueue = DispatchQueue(label: "Fetchr-savestoreheader-\(headerKey)")
        if !waitForCompletion {
            saveQueue.async {
                do {
                    try modelContext.save()
                } catch {
                    print("Failed to save due to \(error)")
                }
            }
        }else {
            saveQueue.asyncAndWait {
                do {
                    try modelContext.save()
                } catch {
                    print("Failed to save due to \(error)")
                }
            }
        }
    }
}

enum ConnectionHeaderRowPreviewDevices:String, CaseIterable {
    //Devices Supported: A14 & newer
    //All supported device screen sizes for my app
    case iPhone16ProMax = "iPhone 16 Pro Max"               //6.9-inch
    case iPhone16Pro = "iPhone 16 Pro"                      //6.3-inch
    case iPhone16Plus = "iPhone 16 Plus"                    //6.7-inch (Same size as the 15 Pro Max)
    case iPhone16 = "iPhone 16"                             //6.1-inch (same size as the 15 & 15 Pro)
    case iPhoneSE = "iPhone SE (3rd generation)"            //4.7-inch (same size as the base sizes of the iPhone 7, 8, SE 2nd Gen, etc)
    case Mac = "My Mac"                                     //Resizable (minimum should be 600x400)
    case iPadAir = "iPad Air 11-inch (M2)"                  //11-inch, Same size as the A12X -> M2 Pro
    case iPadPro129 = "iPad Pro 12.9-inch (4th generation)" //12.9-inch, Same size as the A9X -> M2 iPad Pros
    case iPadPro = "iPad Pro 13-inch (M4)"                  //13-inch, Same size as the larger M2 iPad Air
    case iPadMini = "iPad mini (6th generation)"            //8.3-inch
    case iPadBase = "iPad (10th generation)"                //10.9-inch, same size as the 4th & 5th gen iPad Air (A14 & M1)
    
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
        HeaderRow(key: "", value: "TEST TEST SCREM")
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
                ZStack {
                    Rectangle()
                        .frame(width: deviceWidth, height: 120)
                        .foregroundStyle(Color.black)
                    ConnectionHeaderRow(headerRow: HeaderRow(key: "Sample Header Text",
                                                             value: "Example Value Text"),
                                        deviceWidth: deviceWidth,
                                        deviceHeight: deviceHeight,
                                        headerRows: headerRows)
                    .colorScheme(ColorScheme.dark)
                }
            }
            .previewDevice(PreviewDevice(rawValue: device))
            .previewDisplayName(device)
        }
    }
}
