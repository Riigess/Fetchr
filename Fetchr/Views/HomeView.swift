//
//  HomeView.swift
//  REST Requester
//
//  Created by Austin Bennett on 6/30/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \RequestData.name) private var searchResults: [RequestData]
    
    let deviceWidth:CGFloat = UIScreen.main.bounds.width
    let deviceHeight:CGFloat = UIScreen.main.bounds.height
    let useThinPlus:Bool = true
    
    @State private var showingDetail = false
    @Binding var searchText:String
    @Binding var reqData:RequestData
    @Binding var navPath:[Int]
    
    init(navTitle:String, searchText:Binding<String>, requestData:Binding<RequestData>, navPath:Binding<[Int]>) {
        self._searchText = searchText
        self._reqData = requestData
        self._navPath = navPath
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                Text("").frame(height: 5)
                ForEach(searchResults, id: \.name) { row in
                    Button {
                        self.reqData = row
                        self.navPath.append(3)
                    } label: {
#if os(tvOS)
                        MenuRow(requestType: row.method,
                                name: row.name,
                                hasData: false,
                                url: row.url,
                                rowWidth: 1600)
                        .frame(width: 1600)
#elseif os(iOS)
                        MenuRow(requestType: row.method,
                                name: row.name,
                                hasData: false,
                                url: row.url,
                                rowWidth: deviceWidth)
#endif
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "sidebar.left")
                            .foregroundStyle(Color.white)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.reqData = RequestData(url: "", method: .GET, name: "")
                        self.navPath.append(3)
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundStyle(Color.white)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Fetchr")
            .navigationBarTitleDisplayMode(.inline)
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
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    @State static var searchText:String = ""
    @State static var rData:RequestData = RequestData()
    @State static var navPath = [0]
    static var previews: some View {
        HomeView(navTitle: "REST Requester", searchText: HomeView_Previews.$searchText, requestData: $rData, navPath: $navPath)
    }
}
