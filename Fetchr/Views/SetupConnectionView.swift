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
    
    @State private var nameField:String
    @State private var urlField:String
    @State private var requestMethodType:RequesterMethod
    @State private var headerRows: [HeaderRow]
    @State private var bodyRows: [BodyData]
    @State private var bodyString:String = ""
    @State private var offset = CGSize.zero
    @State private var bodySendableType:BodySendableType = .string //Set default text
    private let deviceWidth:CGFloat
    private let deviceHeight:CGFloat
    
    private let textFieldGray:CGFloat = 225.0/255.0
    private let textFieldBorderColor:Color
    private let defaultSystemGray:Color = Color(UIColor.systemGray4)
    private let sectionBreak:CGFloat = 15.0
    
    @State private var requestResponsePopover:Bool = false
    @Binding private var responseBodyData:BodyData
    @State private var responseHeaderRows:[HeaderRow]
    
    //TODO: Make these part of the initializer
    @State var useJWT:Bool = false
    @State var useBase64:Bool = false
    
    @Binding var navPath:[Int]
    
    init(requestData:RequestData, deviceWidth:CGFloat, deviceHeight:CGFloat, responseBodyData:Binding<BodyData>, navPath:Binding<[Int]>) {
        self.requestData = requestData
        self.urlField = "\(requestData.url)"
        self.nameField = "\(requestData.name)"
        self.deviceWidth = deviceWidth
        self.deviceHeight = deviceHeight
        self.headerRows = []
        self.bodyRows = []
        self.responseHeaderRows = []
        self.requestMethodType = .GET
        
        self.textFieldBorderColor = Color(red: textFieldGray, green: textFieldGray, blue:textFieldGray)
        self._responseBodyData = responseBodyData
        self._navPath = navPath
        
        //        if let jsonData = requestData.bodyData.jsonBodyString {
        //            TODO: Iterate through JSON data to add it in to the array
        //        }
        //        if let jsonDesc = requestData.bodyData.strContent {
        //            TODO: Add a String TextBlock for the content
        //        }
        
        let date = Date()
        #if !RELEASE
        print("------- SetupConnectionView init called at \(date.description) -------")
        #endif
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) { //Using 30 instead of increasing to an extra large padding
                //Name Field
                TextField("Name", text: $nameField)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.top, 5)
                //URL Field
                TextField("URL", text: $urlField)
#if os(iOS)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
#endif
                    .padding(.horizontal)
                
                //TODO: Make this just generically look better
                //Method selector
                ZStack {
                    Picker("Request Method Selector", selection: $requestMethodType) {
                        ForEach(RequesterMethod.allCases) { httpMethod in
                            Text(httpMethod.rawValue)
                                .tag(httpMethod)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(width: deviceWidth - 120, alignment: .trailing)
                    
                    Text("Request Method Selector")
                        .frame(width: 240, alignment: .leading)
                        .offset(x: -20, y: -1)
                }
                .frame(width: deviceWidth - 120, height: 20)
                
                //Header Data Section
                Button {
                    self.navPath.append(4) //4 is the ConnectionHeaderDataView reference in NavView
                } label: {
                    NavViewRow(name: "Header Data",
                               refText: "\(self.requestData.headerData.headerRows.count) keys")
                    .frame(width: deviceWidth - 55, height: 40)
                }
                
                //Body Data Section
                Button {
                    self.navPath.append(5) //5 is the ConnectionBodyDataView reference in NavView
                } label: {
                    NavViewRow(name: "Body Data",
                               refText: "\((self.requestData.bodyData.strContent ?? (self.requestData.bodyData.jsonBodyString ?? "")).count) Content-Length")
                    .frame(width: deviceWidth - 55, height: 40)
                }
                
                //Use JWT for Requests
                Button {
                    useJWT.toggle()
                } label: {
                    ConnToggleViewRow(name: "Use JWT for Request", isOn: $useJWT)
                        .frame(width: deviceWidth - 35, height: 40)
                }
                Button {
                    useBase64.toggle()
                } label: {
                    ConnToggleViewRow(name: "Decode Base64 Response", isOn: $useBase64)
                        .frame(width: deviceWidth - 35, height: 40)
                }
                Button {
//                    let isPreview = ProcessInfo.processInfo.environment["PREVIEW"] != nil && ProcessInfo.processInfo.environment["PREVIEW"] == "1"
                    
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
                    #if !RELEASE
                    print("Attempted to save for Row named \(requestData.name) and URL \(requestData.url)")
                    #endif
                    
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
                        #if !RELEASE
                        print("Request completed with response \(bodyString)")
                        #endif
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: deviceWidth - 55, height: 40)
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
            Button {
                print("Attempted to view cached response!")
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: deviceWidth - 55, height: 40)
                        .foregroundStyle(defaultSystemGray)
                    Text("View Cached Response")
                }
            }
        }
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
    @State static var navPath = [Int]()
    @State static var rData:RequestData = RequestData(url: "https://192.168.15.68:20080/trazadone",
                                               method: .GET,
                                               name: "Test00")
    
    static var previews: some View {
        SetupConnectionView(requestData: rData,
                            deviceWidth: deviceWidth,
                            deviceHeight: deviceHeight,
                            responseBodyData: $rData.bodyData,
                            navPath: $navPath)
    }
}
