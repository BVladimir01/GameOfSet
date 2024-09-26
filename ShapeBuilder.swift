//
//  ShapeBuilder.swift
//  GameOfSet
//
//  Created by Vladimir on 25.09.2024.
//

import SwiftUI


//struct to build multiple shapes
struct MultipleShapeBuilder: Shape {
    
//    dictates number of shapes
    private let count: FieldOfThree
//    dictates shape
    private let shape: FieldOfThree
//    padding between shapes
    private let padding: CGFloat
    
//    draws multiple shapes in rect
    func path(in rect: CGRect) -> Path {
        let origin = rect.origin
        let width = rect.width
        let height = rect.height
        
        var p = Path()
    
        let count = count.rawValue + 1
        let number = CGFloat(count)
        var localRect: CGRect
        
        for i in 1...count {
            let i = CGFloat(i)
            localRect = CGRect(x: origin.x, y: origin.y + height * (i - 1) / number, width: width, height: height / number)
            p.addPath(singleShapePath(in: localRect))
        }
        return p
    }
    
//    func to draw single shape inside rect
    func singleShapePath(in rect: CGRect) -> Path {
        let rect = rect.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
        let centerX = rect.midX
        let centerY = rect.midY
        let center = CGPoint(x: centerX, y: centerY)
        
        let width = rect.width
        let height = rect.height
        
        let radius = min(width, height) / 2
        let newHeight = width / 2
        let newWidth = width
        
        var p = Path()
        switch shape {
//            Сircle
        case .zero:
            p.addArc(center: center, radius: radius, startAngle: Angle(radians: .zero), endAngle: Angle(radians: .pi * 2), clockwise: true)
            p.closeSubpath()
//            Вiamond
        case .one:
            p.move(to: CGPoint(x: centerX, y: centerY - newHeight / 2))
            p.addLine(to: CGPoint(x: centerX + newWidth / 2, y: centerY))
            p.addLine(to: CGPoint(x: centerX, y: centerY + newHeight / 2))
            p.addLine(to: CGPoint(x: centerX - newWidth / 2, y: centerY))
            p.closeSubpath()
        case .two:
//            Swoosh
            let rect = CGRect(x: centerX - width / 2, y: centerY - width / 4, width: width, height: width / 2)
//            p.addRoundedRect(in: rect, cornerSize: CGSize(width: rect.height / 2 , height: rect.height / 2))
            p.addRoundedRect(in: rect,
                             cornerRadii: RectangleCornerRadii(
                                topLeading: rect.height / 2,
                                bottomLeading: 0,
                                bottomTrailing: rect.height / 2,
                                topTrailing: 0))
            p.closeSubpath()
        }
        
        return p
        
    }
    
//    init sets singleshapebuilder, shape and count
    init(count: FieldOfThree, shape: FieldOfThree, padding: CGFloat) {
        self.count = count
        self.shape = shape
        self.padding = padding
    }
}
