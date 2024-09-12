//
//  ConnTogleViewRow.swift
//  Fetchr
//
//  Created by Austin Bennett on 7/31/24.
//

import SwiftUI

struct ConnToggleViewRow: View {
    let name:String
    @Binding var isOn:Bool
    
    var body: some View {
        GeometryReader { geom in
            HStack {
                Text(name)
                Spacer()
                ConnCheckBox(isEnabled: isOn)
            }
            .padding(.horizontal, 20)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black)
                    .frame(width: geom.size.width, height: geom.size.height)
            }
        }
    }
}

struct ConnCheckBox:View {
    let isEnabled:Bool
    
    var body: some View {
        if !isEnabled {
            RoundedRectangle(cornerRadius: 4)
                .frame(width: 20, height: 20)
                .foregroundStyle(Color(UIColor.systemGray5))
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.green)
                
                Image(systemName: "checkmark")
                    .foregroundStyle(Color.white)
                    .frame(width: 15, height: 15)
            }
        }
    }
}

struct ConnToggleViewRow_ToggleTest: View {
    let name:String
    @State var isOn:Bool
    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            ConnToggleViewRow(name: name, isOn: $isOn)
        }
    }
}

struct ConnToggleViewRow_Preview: PreviewProvider {
    @State static var isOn:Bool = true
    @State static var isOff:Bool = false
    static let deviceWidth:CGFloat = UIScreen.main.bounds.width
    
    static var previews: some View {
        VStack {
            ConnToggleViewRow(name: "is on", isOn: $isOn)
                .frame(width: deviceWidth - 55, height: 40)
            ConnToggleViewRow(name: "is off", isOn: $isOff)
                .frame(width: deviceWidth - 55, height: 40)
            ConnToggleViewRow_ToggleTest(name: "is Toggleable", isOn: false)
                .frame(width: deviceWidth - 55, height: 40)
        }
    }
}
