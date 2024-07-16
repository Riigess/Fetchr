//
//  TestPopoverView.swift
//  Fetchr
//
//  Created by Austin Bennett on 7/10/24.
//

import SwiftUI

enum ResponseOptions:String, CaseIterable, Identifiable {
    case Header, Body
    
    var id: String {
        return rawValue
    }
    static var allCases: [String] {
        return ResponseOptions.allCases.map { $0.rawValue }
    }
}

struct ResponseView: View {
    @State var pickerSelection:ResponseOptions
    @Binding var headerRows:[HeaderRow]
    @Binding var bodyData:BodyData
    @Binding var dismissVar:Bool
    
    let deviceHeight:CGFloat = UIScreen.main.bounds.height
    let deviceWidth:CGFloat = UIScreen.main.bounds.width
    let availableOptions:[ResponseOptions]
    
    init(headerRows:Binding<[HeaderRow]>, bodyData:Binding<BodyData>, dismiss:Binding<Bool>) {
        self._headerRows = headerRows
        self._bodyData = bodyData
        self._dismissVar = dismiss
        
        if self._headerRows.count == 0 {
            availableOptions = [.Body]
            pickerSelection = .Body
            print("PickerSelection: \(pickerSelection.rawValue)")
        } else {
            availableOptions = ResponseOptions.allCases
            pickerSelection = .Header
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Response Data Picker", selection: $pickerSelection) {
                    ForEach(availableOptions) { value in
                        Text(value.rawValue)
                            .tag(value)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: deviceWidth - 60)
                if pickerSelection == .Body {
                    Text(bodyData.strContent!)
                        .frame(width: deviceWidth - 80, height: .infinity)
                } else if pickerSelection == .Header {
                    ForEach(headerRows, id: \.self) { headerRow in
                        ConnectionHeaderRow(headerRow: headerRow,
                                            deviceWidth: self.deviceWidth,
                                            deviceHeight: self.deviceHeight,
                                            headerRows: headerRows)
                        .frame(width: self.deviceWidth)
                    }
                }
                Spacer()
            }
            .navigationTitle("Response")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button {
                        dismissVar = false //Explicitly set, but could be !dismissVar
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
    }
}

struct TestPopoverView_Preview:PreviewProvider {
    @State static var headerRows:[HeaderRow] = []
    @State static var bodyData:BodyData = BodyData(strContent: "", jsonBodyString: nil)
    @State static var dismiss:Bool = true
    
    static var previews:some View {
        ResponseView(headerRows: $headerRows, bodyData: $bodyData, dismiss: $dismiss)
    }
}
