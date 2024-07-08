//
//  DeleteButton.swift
//  Fetchr
//
//  Created by Austin Bennett on 7/8/24.
//

import SwiftUI

struct DeleteButton: View {
    @Binding var headerRows:[HeaderRow]
    let headerRow:HeaderRow
    let onDelete: (IndexSet) -> ()
    
    var body: some View {
        Button {
            if let idx = headerRows.firstIndex(of: headerRow) {
                self.onDelete(IndexSet(integer: idx))
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 80, height: 60)
                    .foregroundStyle(Color.red)
                Text("Delete")
                    .font(.title3)
            }
        }
    }
}

struct DeleteButton_Previews:PreviewProvider {
    @State static var headerRows:[HeaderRow] = [
        HeaderRow(key: "Testing Header Row A", value: "some ridiculous value in a header row that should be very ridiculous to render because it's too long to fit on one line on its own"),
        HeaderRow(key: "Testing Header Row B", value: "short value"),
        HeaderRow(key: "X-Riot-Api-Token", value: "rapi_iuhefwiuhgbuiagbirgiuefwiuewfhuewfijoherghuerghui23456789")
    ]
    static var previews: some View {
        ForEach(headerRows, id: \.self) { headerRow in
            DeleteButton(headerRows: $headerRows, headerRow: headerRow, onDelete: delete)
        }
    }
    
    static func delete(at offsets:IndexSet) {
        withAnimation {
            headerRows.remove(atOffsets: offsets)
        }
    }
}
