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
    @State private var headerRows: [HeaderRow]
    @State private var bodyRows: [BodyData]
    @State private var bodyString:String = ""
    @State private var offset = CGSize.zero
    @State private var bodySendableType:BodySendableType = .string //Set default text
    private let deviceWidth:CGFloat
    private let deviceHeight:CGFloat
    
    init(requestData:RequestData, deviceWidth:CGFloat, deviceHeight:CGFloat) {
        self.requestData = requestData
        self.urlField = requestData.url
        self.deviceWidth = deviceWidth
        self.deviceHeight = deviceHeight
        self.headerRows = []
        self.bodyRows = []
        
        for row in requestData.headerData.headerRows {
            self.headerRows.append(row)
        }
        
        if let jsonData = requestData.bodyData.jsonBodyString {
            //TODO: Iterate through JSON data to add it in to the array
        }
        if let jsonDesc = requestData.bodyData.strContent {
            //TODO: Add a String TextBlock for the content
        }
        
        let date = Date()
        print("------- SetupConnectionView init called at \(date.description) -------")
//        print(requestData.description)
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
                    ForEach(headerRows, id: \.self) { headerRow in
                        ZStack {
                            DeleteButton(headerRows: $headerRows, headerRow: headerRow, onDelete: deleteRow)
                                .offset(x: (deviceWidth/2) - 60) //Offset from (deviceWidth/2, deviceHeight/2) as origin
                            HStack {
                                ConnectionHeaderRow(headerRow: headerRow,
                                                    deviceWidth: self.deviceWidth,
                                                    deviceHeight: self.deviceHeight,
                                                    headerRows: headerRows)
                                .frame(width: self.deviceWidth)
                                .onAppear {
                                    print("DeviceWidth passed: \(deviceWidth)")
                                }
                            }
                        }
                    }
                    .onDelete(perform: { idxSet in
                        headerRows.remove(atOffsets: idxSet)
                    })
                    Button {
                        let headerRow = HeaderRow(key: "", value: "")
                        self.headerRows.append(headerRow)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 35)
                                .frame(width: deviceWidth - 120, height: 40)
                                .foregroundStyle(Color(UIColor.systemGray4))
                            Text("Add")
                                .frame(width: 240, height: 30, alignment: .center)
                                .foregroundStyle(Color.blue)
                        }
                    }
                }
            }
        }
    }
    
    func deleteRow(at offsets:IndexSet) {
        self.headerRows.remove(atOffsets: offsets)
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
