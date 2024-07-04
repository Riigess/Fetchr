//
//  HomeView.swift
//  REST Requester
//
//  Created by Austin Bennett on 6/30/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \RequestData.name) private var searchResults: [RequestData]
    
    var navTitle:String
    
    let deviceWidth:CGFloat = UIScreen.main.bounds.width
    let deviceHeight:CGFloat = UIScreen.main.bounds.height
    let useThinPlus:Bool = true
    
    @State private var showingDetail = false
    @State private var searchText = ""
    
    init(navTitle:String) {
        self.navTitle = navTitle
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    Text("").frame(height: 5)
                    ForEach(searchResults, id: \.name) { row in
                        NavigationLink {
                            SetupConnectionView(requestData: row)
                        } label: {
                            #if os(tvOS)
                                MenuRow(requestType: row.method, name: row.name, hasData: false, url: row.url, rowWidth: 1600)
                                    .frame(width: 1600)
                            #elseif os(iOS)
                                MenuRow(requestType: row.method, name: row.name, hasData: false, url: row.url, rowWidth: deviceWidth)
                            #endif
                        }
                    }.navigationTitle(navTitle)
                }
            }
            .searchable(text: $searchText, prompt: "Row Name")
            .onKeyPress { keypress in
                if keypress.phase == .up {
                    print("Key pressed")
                }
                return KeyPress.Result.handled
            }
            .task {
                print("SearchResults: \(searchResults.description)")
            }
            //Do not leave the Add button in the bottom-right of the screen on tvOS/macOS/xrOS
            #if os(iOS)
                Button {
                    showingDetail = true
                } label: {
                    //Gets +10 size for each device screen size increase
                    AddButton(size: 70 + ((deviceWidth - 393.0) * 0.27),
                              //Gets +2 thickness for each size increase
                              thickness: 5.0 - (useThinPlus ? 2.0 : 0.0) + ((deviceWidth - 393.0) * 0.054))
                }
                //Offset to put button in the bottom-right of the screen from center of display
                .offset(x: (deviceWidth / 2) - 60,
                        y: (deviceHeight / 2) - 160)
                //View-ception
                .sheet(isPresented: $showingDetail) {
                    let dateUtil = DateUtil()
                    let timeZoneOffsetDate = dateUtil.convertFromUTCToTimeZone()
                    ViewThatFits {
                        NavigationView {
//                            SetupConnectionView()
//                                .navigationTitle("New Request")
                            Text("Sample text, TODO: Setup new SetupConnView()")
                        }
                    }
                }
            #endif
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(navTitle: "REST Requester")
    }
}
