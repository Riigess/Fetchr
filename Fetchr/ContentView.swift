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
    @Query private var requestsData:[RequestData]

    var body: some View {
        NavView()
            .modelContext(modelContext)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: RequestData.self, inMemory: true)
}
