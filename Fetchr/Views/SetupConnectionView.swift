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
    @State private var requestData: RequestData
    
    @State private var urlField:String
    @State private var headerRows: [HeaderRow]
    @State private var bodyRows: [BodyData]
    @State private var bodyString:String = ""
    @State private var offset = CGSize.zero
    @State private var bodySendableType:BodySendableType = .string //Set default text
    @FocusState private var isInputActive:Bool // Taken from https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-a-toolbar-to-the-keyboard
    private let deviceWidth:CGFloat
    private let deviceHeight:CGFloat
    
    private let textFieldGray:CGFloat = 225.0/255.0
    private let textFieldBorderColor:Color
    private let defaultSystemGray:Color = Color(UIColor.systemGray4)
    private let sectionBreak:CGFloat = 15.0
    
    init(requestData:RequestData, deviceWidth:CGFloat, deviceHeight:CGFloat) {
        self.requestData = requestData
        self.urlField = requestData.url
        self.deviceWidth = deviceWidth
        self.deviceHeight = deviceHeight
        self.headerRows = []
        self.bodyRows = []
        
        self.textFieldBorderColor = Color(red: textFieldGray, green: textFieldGray, blue:textFieldGray)
        
//        if let jsonData = requestData.bodyData.jsonBodyString {
//            TODO: Iterate through JSON data to add it in to the array
//        }
//        if let jsonDesc = requestData.bodyData.strContent {
//            TODO: Add a String TextBlock for the content
//        }
        
        let date = Date()
        print("------- SetupConnectionView init called at \(date.description) -------")
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text("")
                    .frame(width: 5)
                    .onAppear {
                        if self.headerRows.count != requestData.headerData.headerRows.count {
                            for row in requestData.headerData.headerRows {
                                self.headerRows.append(row)
                            }
                        }
                    }
                TextField("URL", text: $urlField)
                #if os(iOS)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                #endif
                    .padding(.horizontal)
                
                Section {
                    Text("Header Data")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.top, sectionBreak)
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
                                .scrollDismissesKeyboard(.interactively)
                                .focused($isInputActive)
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
                                .foregroundStyle(defaultSystemGray)
                            Text("Add")
                                .frame(width: 240, height: 30, alignment: .center)
                                .foregroundStyle(Color.blue)
                        }
                    }
                }
                Section {
                    Text("Body Data")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.top, sectionBreak)
                    HStack {
                        Picker("HTTP Body Type", selection: $bodySendableType) {
                            ForEach([BodySendableType.string]) { sendableType in //TODO: Add the the other options
                                Text(sendableType.rawValue)
                                    .tag(sendableType)
                            }
                        }
                        .frame(width: deviceWidth - 120)
                        .foregroundStyle(Color.black)
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding(.bottom, 10)
                    if bodySendableType == .string {
                        TextEditor(text: $bodyString)
                            .frame(width: deviceWidth - 120, height: 400)
                            .border(textFieldBorderColor, width: 1)
                        //Warning: This may eventually create strange behavior.. Maybe consider changing it
                            .focused($isInputActive)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button {
                                        isInputActive = false
                                    } label: {
                                        Text("Done")
                                            .foregroundStyle(Color.blue)
                                    }
                                }
                            }
                            .onTapGesture(coordinateSpace: .local) { tapLocation in
                                if isInputActive {
                                    isInputActive = false
                                }
                            }
                    } else if bodySendableType == .json { //TODO: Requirement to add JSON, add in the ability to reuse the Header Data <--> tabs as Body Data tabs
//                        Button {
//                            bodyRows.append(BodyData(strContent: nil, jsonBodyString: ""))
//                        } label: {
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 20)
//                                    .frame(width: deviceWidth - 120, height: 40)
//                                    .foregroundStyle(Color(UIColor.systemGray4))
//                                Text("Add Body Row")
//                            }
//                        }
                    }
                }
                Button {
                    print("Make request for data (below):")
                    print(requestData.description)
                    print("HeaderRows: ")
                    for row in headerRows {
                        print("\t\"\(row.key)\": \"\(row.value)\"")
                    }
                    //Attempt to add HeaderData to SwiftData and save that
                    if requestData.headerData.headerRows.count != headerRows.count {
                        requestData.headerData.headerRows = headerRows
                    }
                    saveData()
                    print("Attempted to save for Row named \(requestData.name) and URL \(requestData.url)")
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: deviceWidth - 120, height: 40)
                            .foregroundStyle(defaultSystemGray)
                            .padding(.vertical, 10)
                        Text("Make Request")
                            .foregroundStyle(Color.blue)
                    }
                }
            }
        }
    }
    
    func deleteRow(at offsets:IndexSet) {
        self.headerRows.remove(atOffsets: offsets)
    }
    
    func saveData() {
        do {
            try modelContext.save()
        } catch {
            //TODO: Fix with a proper solution
            fatalError("Unable to save data \(error)")
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
