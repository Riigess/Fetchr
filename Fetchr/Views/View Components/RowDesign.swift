//
//  RowDesign.swift
//  Fetchr
//
//  Created by Austin Bennett on 7/30/24.
//

import SwiftUI

struct RowDesign:View {
    let width:CGFloat
    let height:CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 80, height: height)
                .foregroundStyle(Color.orange)
        }
    }
}
