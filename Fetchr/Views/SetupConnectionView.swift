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
    @State private var requestMethodType:RequesterMethod
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
    
    
    @State private var requestResponsePopover:Bool = false
    @State private var responseBodyData:BodyData
    @State private var responseHeaderRows:[HeaderRow]
    
    init(requestData:RequestData, deviceWidth:CGFloat, deviceHeight:CGFloat) {
        self.requestData = requestData
        self.urlField = "\(requestData.url)"
        self.deviceWidth = deviceWidth
        self.deviceHeight = deviceHeight
        self.headerRows = []
        self.bodyRows = []
        self.responseBodyData = BodyData(strContent: nil, jsonBodyString: nil)
        self.responseHeaderRows = []
        self.requestMethodType = .GET
        
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
                Picker("Request Method Selector", selection: $requestMethodType) {
                    ForEach(RequesterMethod.allCases) { httpMethod in
                        Text(httpMethod.rawValue)
                            .tag(httpMethod)
                    }
                }
                .pickerStyle(.segmented)
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
                    let isPreview = ProcessInfo.processInfo.environment["PREVIEW"] != nil && ProcessInfo.processInfo.environment["PREVIEW"] == "1"
                    print("Made request for Preview: \(isPreview)")
                    print("HeaderRows:")
                    for row in headerRows {
                        print("\t\"\(row.key)\": \"\(row.value)\"")
                    }
                    print("bodyString: \(bodyString)")
                    //Attempt to add HeaderData to SwiftData and save that
                    if requestData.headerData.headerRows.count != headerRows.count {
                        requestData.headerData.headerRows = headerRows
                    }
                    saveData()
                    if requestData.url != urlField {
                        requestData.url = urlField
                    }
                    if requestData.method != requestMethodType {
                        requestData.method = requestMethodType
                    }
                    print("Attempted to save for Row named \(requestData.name) and URL \(requestData.url)")
                    
                    let requester = Requester()
                    let headerDict = requester.convertHeaderDataToDictionary(headerData: requestData.headerData)
                    requester.makeRequest(url: requestData.url, method: requestData.method, headers: headerDict, body: bodyString) { result, err in
                        if let err = err {
                            fatalError("Error found \(err)")
                        }
                        if let result = result {
                            if !requestData.url.contains("https://(gdmf|mesu).apple.com") {
                                responseBodyData = BodyData(strContent: result, jsonBodyString: nil)
                            } else {
                                if !result.isEmpty {
                                    do {
                                        let decoder = JSONDecoder()
                                        let json = result.data(using: .utf8)!
                                        let prod = try decoder.decode(PallasResponse.self, from: json)
                                        let encoder = JSONEncoder()
                                        encoder.outputFormatting = .prettyPrinted
                                        let data = try encoder.encode(prod)
                                        responseBodyData = BodyData(strContent: String(data: data, encoding: .utf8)!, jsonBodyString: nil)
                                    } catch {
                                        fatalError("unable to convert data to data type with error, \(error)")
                                    }
                                }
                            }
                        }
                        requestResponsePopover = true
                        print("Request completed with response \(bodyString)")
                    }
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
                //For the popover page - https://www.swiftyplace.com/blog/swiftui-popovers-and-popups
                .popover(isPresented: $requestResponsePopover) {
                    ResponseView(headerRows: $responseHeaderRows, bodyData: $responseBodyData, dismiss: $requestResponsePopover)
                }
                //TODO: Create "View Last Request" button if there is a previous request stored in RequestData
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
        SetupConnectionView(requestData: RequestData(url: "https://192.168.15.68:20080/trazadone", method: .GET, name: "Test00"),
                            deviceWidth: deviceWidth,
                            deviceHeight: deviceHeight)
    }
}
