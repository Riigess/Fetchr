//
//  AddButton.swift
//  REST Requester
//
//  Created by Austin Bennett on 6/28/24.
//

import SwiftUI

struct AddButton: View {
    var size:CGFloat
    var thickness:CGFloat = 7
    var widthScale:CGFloat = 0.7
    var shadowRadii:CGFloat = 3.0
    
    let darkButtonBackgroundR = Double(0x30) / 255.0
    let darkButtonBackgroundG = Double(0x3A) / 255.0
    let darkButtonBackgroundB = Double(0xCB) / 255.0
    let darkButtonBackgroundColor:Color
    
    init(size:CGFloat, thickness:CGFloat = 7, widthScale:CGFloat = 0.7, shadowRadii:CGFloat = 3.0) {
        darkButtonBackgroundColor = Color(red: darkButtonBackgroundR, green: darkButtonBackgroundG, blue: darkButtonBackgroundB)
        self.size = size
        self.thickness = thickness
        self.widthScale = widthScale
        self.shadowRadii = shadowRadii
    }
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: size, height: size)
//                .foregroundColor(Color.init(cgColor: CGColor(red: 240.0, green: 240.0, blue: 240.0, alpha: 0.8)))
                .foregroundColor(NavView.isDarkMode ? darkButtonBackgroundColor : .white)
                .shadow(radius: shadowRadii, x:shadowRadii * 0.7, y:shadowRadii * 0.7)
            Rectangle()
                .frame(width: size * widthScale, height: thickness)
                .foregroundColor(NavView.isDarkMode ? .white : .black)
            Rectangle()
                .frame(width: thickness, height: size * widthScale)
                .foregroundColor(NavView.isDarkMode ? .white : .black)
        }
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AddButton(size: 80)
            AddButton(size: 120, thickness: 12.0)
            AddButton(size: 140, widthScale: 0.4)
            AddButton(size: 20, thickness:4.0, widthScale: 0.9)
        }
    }
}
