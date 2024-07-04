//
//  ConnectionHeaderRow.swift
//  REST Requester
//
//  Created by Austin Bennett on 7/1/24.
//

import SwiftUI
import SwiftData

struct ConnectionHeaderRow: View {
    var id:UUID
//    @Query(filter: #Predicate { $0.id == self.id }) var row: [RequestData]
    @Environment(\.modelContext) private var modelContext
    private var headerRow:HeaderRow
    
    init(id:UUID) {
        self.id = id
        self.headerRow = Query(filter: #Predicate { id == $0.id }).wrappedValue.first!
    }
    
    var body: some View {
        HStack {
//            TextField("Key", text: headerRow.$key)
            Text("Key: \(headerRow.key)")
                .padding(.horizontal)
            #if os(iOS)
                .border(.bar, width: 2)
            #endif
//            TextField("Value", text: headerRow.$value)
            Text("Value: \(headerRow.value)")
                .padding(.horizontal)
            #if os(iOS)
                .border(.bar, width: 2)
            #endif
            Text("")
                .frame(width: 1)
        }
    }
}

struct ConnectionHeaderRow_Previews: PreviewProvider {
    @State static var key:String = ""
    @State static var value:String = ""
    static var uuid:UUID = UUID()
    
    static var previews: some View {
        ConnectionHeaderRow(id: uuid)
    }
}
