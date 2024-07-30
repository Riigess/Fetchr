//
//  CustomTextField.swift
//  Fetchr
//
//  Created by Austin Bennett on 7/30/24.
//

import SwiftUI

struct CustomTextField:View {
    @Environment(\.colorScheme) private var colorScheme
    
    let label:LocalizedStringKey
    @Binding var text:String
    //    let textColor:Color = Color(UIColor.systemGray4)
    let textColor:Color = .black
    let sampleTextColor:Color = Color(UIColor.systemGray4)
    let cornerRadius:CGFloat
    
    //    init(_ label:LocalizedStringKey, text:State<String>) {
    //        self.label = label
    //        self._text = text
    //    }
    
    var body: some View {
        GeometryReader { geom in
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color(UIColor.systemGray2), lineWidth: 1)
                //TODO: What's a better way to define a Border view
                Text(text)
                    .foregroundStyle(colorScheme == .light ? textColor : .white)
                    .frame(width: geom.size.width - 18, alignment: .leading)
            }
            .frame(width: geom.size.width, height: geom.size.height)
            .task {
                print("Width: \(geom.size.width)")
                print("Height: \(geom.size.height)")
            }
        }
    }
}
