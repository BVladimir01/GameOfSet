//
//  ShapeBuilder.swift
//  GameOfSet
//
//  Created by Vladimir on 25.09.2024.
//

import SwiftUI

struct SingleShapeBuilder: Shape {
    let shape: FieldOfThree
    
    func path(in rect: CGRect) -> Path {
        let rect = rect.inset(by: UIEdgeInsets(top: 4, left: 5, bottom: 5, right: 5))
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
        case .zero:
            p.addArc(center: center, radius: radius, startAngle: Angle(radians: .zero), endAngle: Angle(radians: .pi * 2), clockwise: true)
            p.closeSubpath()
        case .one:
            p.move(to: CGPoint(x: centerX, y: centerY - newHeight / 2))
            p.addLine(to: CGPoint(x: centerX + newWidth / 2, y: centerY))
            p.addLine(to: CGPoint(x: centerX, y: centerY + newHeight / 2))
            p.addLine(to: CGPoint(x: centerX - newWidth / 2, y: centerY))
            p.closeSubpath()
        case .two:
            let rect = CGRect(x: centerX - width / 2, y: centerY - width / 4, width: width, height: width / 2)
//            p.addRect(rect)
            p.addEllipse(in: rect)
            p.closeSubpath()
        }
        
        return p
    }
    
}

struct MultipleShapeBuilder: Shape {
    let count: FieldOfThree
    let shape: FieldOfThree
    let singleShapeBuilder: SingleShapeBuilder
    
    func path(in rect: CGRect) -> Path {
        let origin = rect.origin
        let width = rect.width
        let height = rect.height
        
        var p = Path()
        switch count {
        case .zero:
            p.addPath(singleShapeBuilder.path(in: rect))
        case .one:
            let rect1 = CGRect(x: origin.x, y: origin.y, width: width, height: height / 2)
            let rect2 = CGRect(x: origin.x, y: origin.y + height / 2, width: width, height: height / 2)
            p.addPath(singleShapeBuilder.path(in: rect1))
            p.addPath(singleShapeBuilder.path(in: rect2))
        case .two:
            let rect1 = CGRect(x: origin.x, y: origin.y, width: width, height: height / 3)
            let rect2 = CGRect(x: origin.x, y: origin.y + height / 3, width: width, height: height / 3)
            let rect3 = CGRect(x: origin.x, y: origin.y + height * 2 / 3, width: width, height: height / 3)
            p.addPath(singleShapeBuilder.path(in: rect1))
            p.addPath(singleShapeBuilder.path(in: rect2))
            p.addPath(singleShapeBuilder.path(in: rect3))
        }
        return p
    }
    
    init(count: FieldOfThree, shape: FieldOfThree) {
        self.count = count
        self.shape = shape
        singleShapeBuilder = SingleShapeBuilder(shape: shape)
    }
}
