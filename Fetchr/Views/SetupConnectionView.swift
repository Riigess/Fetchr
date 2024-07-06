//
//  SetupConnectionView.swift
//  REST Requester
//
//  Created by Austin Bennett on 7/1/24.
//

import SwiftUI
import SwiftData

struct SetupConnectionView: View {
    @Environment(\.modelContext) private var modelContext
    private var requestData: RequestData
    
    @State private var urlField:String
    private let deviceWidth:CGFloat
    private let deviceHeight:CGFloat
    
    init(requestData:RequestData, deviceWidth:CGFloat, deviceHeight:CGFloat) {
        self.requestData = requestData
        self.deviceWidth = deviceWidth
        self.deviceHeight = deviceHeight
        
        print(requestData.description)
        urlField = requestData.url
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text("")
                    .frame(width: 5)
                TextField("URL", text: $urlField)
                #if os(iOS)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                #endif
                    .padding(.horizontal)
                
                Section {
                    Text("Header Data")
                        .font(.headline)
                        .padding(.horizontal)
                    ForEach(requestData.headerData.headerRows, id: \.self) { headerRow in
                        HStack {
                            ConnectionHeaderRow(headerRow: headerRow,
                                                deviceWidth: self.deviceWidth,
                                                deviceHeight: self.deviceHeight)
                                .frame(width: self.deviceWidth)
                                .onAppear {
                                    print("DeviceWidth passed: \(deviceWidth)")
                                }
                                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onEnded { value in
                                    if value.translation.width < 0 { //On Swipe left
                                        requestData.headerData.headerRows.removeAll(where: {
                                            headerRow == $0
                                        })
                                    }
                                })
                        }
                    }
                    Button {
                        print("Button pressed")
                        let headerRow = HeaderRow(key: "", value: "")
                        requestData.headerData.headerRows.append(headerRow)
                        do {
                            try modelContext.save()
                        } catch {
                            print("Unable to save due to error \(error)")
                        }
                    } label: {
                        Text("Add")
                            .frame(width: 240, height: 30, alignment: .center)
                            .foregroundStyle(Color.green)
                    }
                }
            }
        }
        .onAppear {
            #if DEBUG
            print("RequestData: \(requestData.description)")
            #endif
        }
    }
}

struct SetupConnectionView_Preview: PreviewProvider {
    static let deviceWidth:CGFloat = UIScreen.main.bounds.width
    static let deviceHeight:CGFloat = UIScreen.main.bounds.height
    static var previews: some View {
        SetupConnectionView(requestData: RequestData(url: "https://api.riotgames.com/v3/blah/blah/nah/nah", method: .GET, name: "Test00"),
                            deviceWidth: deviceWidth,
                            deviceHeight: deviceHeight)
    }
}
