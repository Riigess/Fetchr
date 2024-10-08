//
//  ConnectionHeaderRow.swift
//  REST Requester
//
//  Created by Austin Bennett on 7/1/24.
//

import SwiftUI
import SwiftData

struct ConnectionHeaderRow: View {
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
                    PartialPillShape(roundedCornerRadius: 20)
                        .rotationEffect(Angle(degrees: 180))
                    VStack(spacing: 12) {
                        TextField("Key", text: $headerKey)
                            .padding(.leading, 10)
                            .background {
                                RoundedRectangle(cornerRadius: 32.0 / 3.0)
                                    .foregroundStyle(Color(UIColor.systemGray4))
                            }
                            .submitLabel(.next)
                            .onSubmit {
                                valueHeaderIsFocused = true
                            }
                        TextField("Value", text: $headerValue)
                            .padding(.leading, 10)
                            .focused($valueHeaderIsFocused)
                            .background {
                                RoundedRectangle(cornerRadius: 32.0 / 3.0)
                                    .foregroundStyle(Color(UIColor.systemGray4))
                            }
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
                    }
                    .frame(width: deviceWidth - 100)
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
                HStack(spacing: 0) {
                    ZStack {
                        PartialPillShape(roundedCornerRadius: 16)
                            .frame(width: 40)
                            .foregroundStyle(Color.orange)
                        Text("Header")
                            .rotationEffect(Angle(degrees: 90))
                            .foregroundStyle(Color(UIColor.systemGray6))
                    }
                    ZStack {
                        PartialPillShape(roundedCornerRadius: 16)
                            .frame(width: 300)
                            .rotationEffect(Angle(degrees: 180))
                            .offset(x: -10)
                        VStack {
                            
                        }
                    }
                }.frame(height: 80)
                    .offset(x: 10)
            }
            .previewDevice(PreviewDevice(rawValue: device))
            .previewDisplayName(device)
        }
    }
}
