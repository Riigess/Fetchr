//
//  AutomationView.swift
//  REST Requester
//
//  Created by Austin Bennett on 6/30/24.
//

import SwiftUI

struct AutomationView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Text("Test - Automation")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "sidebar.left")
                            .foregroundStyle(Color.white)
                    }
                }
            }
    }
}
