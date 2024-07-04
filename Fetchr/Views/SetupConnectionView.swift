//
//  SetupConnectionView.swift
//  REST Requester
//
//  Created by Austin Bennett on 7/1/24.
//

import SwiftUI
import SwiftData

struct SetupConnectionView: View {
    private var requestData: RequestData
    
    @State private var urlField:String
    
    init(requestData:RequestData) {
        self.requestData = requestData
        
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
                            ConnectionHeaderRow(id: headerRow.id)
                            Button {
                                print("Add another header row")
                            } label: {
                                Image(systemName: "plus")
                            }
                            Button {
                                print("Remove a header row")
                            } label: {
                                Image(systemName: "minus")
                            }
                            Text("")
                                .frame(width: 2)
                        }
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
    static var previews: some View {
        SetupConnectionView(requestData: RequestData(url: "https://api.riotgames.com/v3/blah/blah/nah/nah", method: .GET, name: "Test00"))
    }
}
