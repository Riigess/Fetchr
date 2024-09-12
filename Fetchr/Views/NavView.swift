//
//  NavView.swift
//  REST Requester
//
//  Created by Austin Bennett on 6/29/24.
//

import SwiftUI
import SwiftData

struct NavView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var requestData:[RequestData]
    #if os(iOS)
        let tabNavColor:Color = Color(red: Double(0x30) / 255.0, green: Double(0x3A) / 255.0, blue: Double(0xCB) / 255.0) //Background tab view color
    #elseif os(tvOS)
        let tabNavColor:Color = Color(red: Double(0x44) / 255.0, green: Double(0x48) / 255.0, blue: Double(0x82) / 255.0)
    #endif
    
    let deviceWidth:CGFloat = UIScreen.main.bounds.width
    let deviceHeight:CGFloat = UIScreen.main.bounds.height
    let grayTabViewColor:Color = Color(red: 240.0 / 255.0, green: 240.0 / 255.0, blue: 240.0 / 255.0)
    
    static let isDarkMode:Bool = UIScreen.main.traitCollection.userInterfaceStyle == .dark
    
    @State var pinnedRequests:[RequestData] = []
    @State var selectedView:String?
    @State var searchText:String = ""
    @State private var showDetail:Bool = false
    
    //Technically this build a TreeNode-like experience
    //  It will start at the -1 index and work its way to 0, if -1 == 0 (length == 1) then it will only show that one view
    @State private var path = [0]
    @State private var requestItem:RequestData
    @State private var bodyString:String
    
    init() {
        #if os(iOS)
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = UIColor(cgColor: tabNavColor.cgColor!)
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().compactAppearance = coloredAppearance //Not sure when this one shows up.. Maybe when searching?
        UINavigationBar.appearance().standardAppearance = coloredAppearance //When scrolling begins
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance //When Title is BIG
        
        UINavigationBar.appearance().tintColor = coloredAppearance.backgroundColor
        #endif
        
        let tabBarColoredAppearance = UITabBarAppearance()
        tabBarColoredAppearance.configureWithOpaqueBackground()
        tabBarColoredAppearance.backgroundColor = UIColor(cgColor: tabNavColor.cgColor!)
        
        UITabBar.appearance().scrollEdgeAppearance = tabBarColoredAppearance //What happens when there is no content behind it
        UITabBar.appearance().standardAppearance = tabBarColoredAppearance //What happens when there is content behind it
        
        self.requestItem = RequestData(url: "http://127.0.0.1", method: .GET, name: "NoRow")
        self.bodyString = ""
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 40) {
                Text("")
                    .frame(height: 5)
                Button {
                    path = [0]
                    print("Selected path \(path)")
                } label: {
                    NavViewRow(name: "Home", refText: "\(requestData.count > 0 ? requestData.count : 200) rows")
                }
                .frame(width: deviceWidth - 80, height: 40)
                .padding(.bottom, 10)
                Button {
                    path = [1]
                } label: {
                    NavViewRow(name: "Automation", refText: "")
                }
                .frame(width: deviceWidth - 80, height: 40)
                Button{
                    path = [2]
                } label: {
                    NavViewRow(name: "Settings", refText: "")
                }
                .frame(width: deviceWidth - 80, height: 40)
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Fetchr")
            .navigationDestination(for: Int.self) { selection in
                if selection == 0 {
                    HomeView(navTitle: "Fetchr",
                             searchText: $searchText,
                             requestData: $requestItem,
                             navPath: $path)
                    .modelContext(modelContext)
                } else if selection == 1 {
                    AutomationView()
                        .modelContext(modelContext)
                } else if selection == 2 {
                    SettingsView()
                        .modelContext(modelContext)
                        .navigationBarBackButtonHidden(true)
                } else if selection == 3 {
                    SetupConnectionView(requestData: requestItem,
                                        deviceWidth: deviceWidth,
                                        deviceHeight: deviceHeight,
                                        responseBodyData: $requestItem.bodyData,
                                        navPath: $path)
                    .modelContext(modelContext)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                //TODO: Create a way to save data to RequestData if that's not done atomically
                                print("Save button tapped!")
                            } label: {
                                Text("Save")
                                    .foregroundStyle(Color.white)
                            }
                        }
                    }
                } else if selection == 4 {
                    ConnectionHeaderDataView(deviceWidth: deviceWidth,
                                             deviceHeight: deviceHeight,
                                             sectionBreak: 15.0,
                                             headerRows: $requestItem.headerData.headerRows)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                requestItem.headerData.headerRows.append(HeaderRow(key: "", value: ""))
                            } label: {
                                Image(systemName: "plus")
                                    .foregroundStyle(Color.white)
                            }
                        }
                        //I wonder if this will override the default "Back" button placement.. Hm..
                    }
                } else if selection == 5 {
                    ConnectionBodyDataView(deviceWidth: deviceWidth,
                                           deviceHeight: deviceHeight,
                                           sectionBreak: 15.0,
                                           textFieldBorderColor: .black,
                                           bodyString: $bodyString)
                    .navigationBarBackButtonHidden(true)
                    .navigationTitle("Body Data")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                path.remove(at: path.count - 1)
                            } label: {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .foregroundStyle(Color.white)
                        }
                    }
                }
            }
        }
    }
}

struct NavView_Previews: PreviewProvider {
    static var previews: some View {
        NavView()
    }
}
