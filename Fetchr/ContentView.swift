//
//  ContentView.swift
//  REST Requester
//
//  Created by Austin Bennett on 6/21/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Item]
    @Query private var requestsData:[RequestData]

    var body: some View {
        NavView()
            .modelContext(modelContext)
    }

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
}

#Preview {
    ContentView()
        .modelContainer(for: RequestData.self, inMemory: true)
}
