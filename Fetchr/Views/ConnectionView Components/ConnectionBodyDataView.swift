//
//  ConnectionBodyDataView.swift
//  Fetchr
//
//  Created by Austin Bennett on 7/30/24.
//

import SwiftUI

struct ConnectionBodyDataView: View {
    let deviceWidth:CGFloat
    let deviceHeight:CGFloat
    let sectionBreak:CGFloat
    let textFieldBorderColor:Color
    
    @State var bodySendableType:BodySendableType = .string
    @FocusState var isInputActive:Bool //Taken from https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-a-toolbar-to-the-keyboard
    @Binding var bodyString:String
    
    var body: some View {
        //Body Data Section
        ScrollView {
            HStack {
                Picker("HTTP Body Type", selection: $bodySendableType) {
                    ForEach([BodySendableType.string]) { sendableType in //TODO: Add the the other options
                        Text(sendableType.rawValue)
                            .tag(sendableType)
                    }
                }
                .frame(width: deviceWidth - 120)
                .foregroundStyle(Color.black)
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding(.bottom, 10)
            if bodySendableType == .string {
                TextEditor(text: $bodyString)
                    .frame(width: deviceWidth - 120, height: 300)
                    .border(textFieldBorderColor, width: 1)
                //Warning: This may eventually create strange behavior.. Maybe consider changing it
                    .focused($isInputActive)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button {
                                isInputActive = false
                            } label: {
                                Text("Done")
                                    .foregroundStyle(Color.blue)
                            }
                        }
                    }
                    .onTapGesture(coordinateSpace: .local) { tapLocation in
                        if isInputActive {
                            isInputActive = false
                        }
                    }
            } else if bodySendableType == .json { //TODO: Requirement to add JSON, add in the ability to reuse the Header Data <--> tabs as Body Data tabs
                //                        Button {
                //                            bodyRows.append(BodyData(strContent: nil, jsonBodyString: ""))
                //                        } label: {
                //                            ZStack {
                //                                RoundedRectangle(cornerRadius: 20)
                //                                    .frame(width: deviceWidth - 120, height: 40)
                //                                    .foregroundStyle(Color(UIColor.systemGray4))
                //                                Text("Add Body Row")
                //                            }
                //                        }
            }
        }
        .padding(.top, 10)
    }
}

struct ConnectionBodyDataView_Preview: PreviewProvider {
    static let deviceWidth:CGFloat = UIScreen.main.bounds.width
    static let deviceHeight:CGFloat = UIScreen.main.bounds.height
    static let sectionBreak:CGFloat = 15.0
    static let textFieldBorderColor = Color(red: 225.0 / 255.0,
                                            green: 225.0 / 255.0,
                                            blue: 225.0 / 255.0)
    @State static var bodyString:String = ""
    
    static var previews: some View {
        ConnectionBodyDataView(deviceWidth: deviceWidth,
                               deviceHeight: deviceHeight,
                               sectionBreak: sectionBreak,
                               textFieldBorderColor: textFieldBorderColor,
                               bodyString: $bodyString)
    }
}
