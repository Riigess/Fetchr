//
//  MenuRow.swift
//  REST Requester
//
//  Created by Austin Bennett on 6/29/24.
//

import SwiftUI

struct MenuRow: View {
    let requestType: RequesterMethod
    let name:String
    let hasData:Bool
    let url:String
    
    let rowWidth:CGFloat
    let rowHeight:CGFloat
    
    init(requestType:RequesterMethod = .GET, name:String = "", hasData:Bool = false, url:String = "", rowWidth:CGFloat = UIScreen.main.bounds.width, rowHeight:CGFloat = UIScreen.main.bounds.height) {
        self.requestType = requestType
        self.name = name
        self.hasData = hasData
        self.url = url
        
        self.rowWidth = rowWidth
        self.rowHeight = rowHeight
//        print("rowWidth: \(rowWidth)")
//        print("rowHeight: \(rowHeight)")
    }
    
    func requestTypeButtonColor(requestType:RequesterMethod) -> Color {
        if requestType == .GET {
            return .blue
        } else if requestType == .DELETE {
            return .red
        } else if requestType == .PUT {
            return .cyan
        } else if requestType == .POST {
            return .green
        } else {
            return .black
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("\(name)")
                        .font(.title)
                        .frame(width: rowWidth - 120, alignment:.leading)
                        .foregroundStyle(NavView.isDarkMode ? .white : .black)
                    Text("\(url)")
                        .font(.system(size:18))
                        .frame(width: rowWidth - 100)
                        .foregroundStyle(NavView.isDarkMode ? .white : .black)
                }
                VStack {
                    Text(requestType.rawValue)
                        .bold()
                        .font(.system(size: 18))
                        .foregroundColor(requestTypeButtonColor(requestType: requestType))
                        .frame(width: 70, alignment: .trailing)
                    HStack {
                        Spacer()
                        Image(systemName: hasData ? "square.and.arrow.down" : "arrow.down.circle")
                            .foregroundColor(hasData ? .green : .gray)
                            .padding(.trailing, 10)
                    }
                }
                Spacer()
            }
            Rectangle()
                .frame(width: rowWidth - 40, height: 1)
                .foregroundColor(Color(cgColor: CGColor(gray: 120.0/255.0, alpha: 0.3)))
                .padding(.bottom, 5)
        }
    }
}

struct MenuRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MenuRow(requestType: .GET, name: "TestRow", hasData: true, url: "https://api.riotgames.com/v3/shenanigans/womp/womp/abcdefu")
            MenuRow(requestType: .DELETE, name: "RowB", hasData: false, url: "https://api.riotgames.com/v3/womp/womp/abcdefu")
        }
    }
}
