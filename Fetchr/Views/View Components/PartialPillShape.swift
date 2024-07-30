//
//  PartialPillShape.swift
//  Fetchr
//
//  Created by Austin Bennett on 7/30/24.
//

import SwiftUI

struct PartialPillShape:Shape {
    let roundedCornerRadius:CGFloat
    
    func path(in rect:CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY)) //Start at the top-right corner
        path.addLine(to: CGPoint(x: rect.minX + (roundedCornerRadius), y: rect.minY)) //Move to point just before the curve
        path.addArc(center: CGPoint(x: rect.minX + roundedCornerRadius, y: rect.minY + roundedCornerRadius),
                    radius: roundedCornerRadius,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180),
                    clockwise: true)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - (roundedCornerRadius)))
        path.addArc(center: CGPoint(x: rect.minX + (roundedCornerRadius), y: rect.maxY - (roundedCornerRadius)),
                    radius: roundedCornerRadius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 90),
                    clockwise: true)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
