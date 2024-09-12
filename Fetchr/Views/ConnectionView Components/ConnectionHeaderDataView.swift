//
//  HeaderData.swift
//  Fetchr
//
//  Created by Austin Bennett on 7/30/24.
//

import SwiftUI

struct ConnectionHeaderDataView: View {
    let deviceWidth:CGFloat
    let deviceHeight:CGFloat
    let sectionBreak:CGFloat
    @Binding var headerRows: [HeaderRow]
    @FocusState var isInputActive:Bool
    
    let defaultSystemGray = Color(UIColor.systemGray4)
    
    var body: some View {
        ScrollView {
            ForEach($headerRows, id: \.self) { headerRow in
                ZStack {
                    DeleteButton(headerRows: $headerRows, headerRow: headerRow.wrappedValue, onDelete: deleteRow)
                        .offset(x: (deviceWidth/2) - 60) //Offset from (deviceWidth/2, deviceHeight/2) as origin
                        .foregroundStyle(Color.white)
                    HStack {
                        ConnectionHeaderRow(headerRow: headerRow.wrappedValue,
                                            deviceWidth: self.deviceWidth,
                                            deviceHeight: self.deviceHeight,
                                            headerRows: headerRows)
                        .frame(width: self.deviceWidth)
                        .scrollDismissesKeyboard(.interactively)
                        .focused($isInputActive)
                    }
                }
            }
            .onDelete(perform: { idxSet in
                headerRows.remove(atOffsets: idxSet)
            })
        }
        .padding(.top, 10)
    }
    
    func deleteRow(at offsets:IndexSet) {
        self.headerRows.remove(atOffsets: offsets)
    }
}

struct ConnectionHeaderDataView_Preview: PreviewProvider {
    static let deviceWidth:CGFloat = UIScreen.main.bounds.width
    static let deviceHeight:CGFloat = UIScreen.main.bounds.height
    static let sectionBreak:CGFloat = 15.0
    @State static var headerRows:[HeaderRow] = [
        HeaderRow(key: "Test", value: "Some val"),
        HeaderRow(key: "ABC", value: "DEF")
    ]
    
    static var previews: some View {
        ConnectionHeaderDataView(deviceWidth: deviceWidth,
                                 deviceHeight: deviceHeight,
                                 sectionBreak: sectionBreak,
                                 headerRows: $headerRows)
    }
}
