//
//  NavViewRow.swift
//  Fetchr
//
//  Created by Austin Bennett on 7/30/24.
//

import SwiftUI

struct NavViewRow: View {
    @Environment(\.modelContext) var modelContext
    
    let name:String
    let refText:String
    
    var body: some View {
        GeometryReader { geom in
            HStack {
                VStack {
                    Text(name)
                        .font(.headline)
//                        .frame(width: geom.size.width - 80, //Invalid frame dimension (negative or non-finite)
//                               alignment: .leading)
                    if refText.count > 0 {
                        Text(refText)
                            .font(.subheadline)
//                            .frame(width: geom.size.width - 80, //Invalid frame dimesnion (negative or non-finite)
//                                   alignment: .leading)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
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

struct NavViewRow_Preview: PreviewProvider {
    static let deviceWidth = UIScreen.main.bounds.width
    static var previews: some View {
        NavViewRow(name: "Headline", refText: "Sub-headline")
            .frame(width: deviceWidth - 80, height: 40)
    }
}
