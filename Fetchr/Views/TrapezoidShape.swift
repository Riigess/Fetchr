//
//  TrapezoidShape.swift
//  Fetchr
//
//  Created by Austin Bennett on 7/7/24.
//

import SwiftUI

struct RoundedTrapezoidShape:Shape {
    let slope:CGFloat
    let rightSideRadii:CGFloat = 30
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + (5 * slope), y: rect.maxY)) //Bottom-left point
                path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.maxY),
                            tangent2End: CGPoint(x: rect.maxX, y: rect.maxY - 20),
                            radius: rightSideRadii) //Bottom-right corner
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 20)) //Bottom-right point
        path.addArc(tangent1End: CGPoint(x: rect.maxX, y:rect.minY),
                    tangent2End: CGPoint(x: rect.maxX - 20, y: rect.minY),
                    radius: rightSideRadii) //Top-right corner
        path.addLine(to: CGPoint(x: rect.maxX-20, y: rect.minY)) //Top-right point
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY)) // Top-left point
        path.closeSubpath()
        return path
    }
}

struct RoundedTrapezoidShape_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            RoundedTrapezoidShape(slope: 12)
                .frame(width: UIScreen.main.bounds.width - 60, height: 120)
                .foregroundStyle(Color.green)
            RoundedTrapezoidShape(slope: 7)
                .foregroundStyle(Color.blue)
                .frame(width: UIScreen.main.bounds.width - 120, height: 80)
            RoundedTrapezoidShape(slope: 5)
                .frame(width: UIScreen.main.bounds.width - 200, height: 60)
                .foregroundStyle(Color.red)
        }
    }
}
