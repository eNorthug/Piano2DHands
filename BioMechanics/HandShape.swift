
//
//  HandShape.swift
//  BioMechanics
//
//  Created by Even Northug on 28/02/2022.
//

import SwiftUI


/// 6 points, encircled and connected by lines
struct HandShape: Shape {
    
    var controlPoints: AnimatableVector
    var circleWidth: CGFloat

    var animatableData: AnimatableVector {
        set { self.controlPoints = newValue }
        get { return self.controlPoints }
    }

    init(points: [CGPoint], circleWidth: CGFloat) {
        var xys = [Double]()
        for point in points {
            xys.append(point.x)
            xys.append(point.y)
        }
        controlPoints = AnimatableVector(values: xys)
        self.circleWidth = circleWidth
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let size = CGSize(width: circleWidth, height: circleWidth)
        
        var point = CGPoint(x: controlPoints.values[0], y: controlPoints.values[1])
        path.move(to: point)
        path.addEllipse(in: CGRect(origin: point, size: size), transform: CGAffineTransform(translationX: -circleWidth/2, y: -circleWidth/2))
        path.move(to: point)
        
        var i = 2;
        while i < controlPoints.values.count-1 {
            point = CGPoint(x: controlPoints.values[i],
                               y: controlPoints.values[i+1])
            path.addLine(to: point)
            path.addEllipse(in: CGRect(origin: point, size: size), transform: CGAffineTransform(translationX: -circleWidth/2, y: -circleWidth/2))
            path.move(to: point)
            i += 2;
        }

        return path
    }
    
}



import enum Accelerate.vDSP


struct AnimatableVector: VectorArithmetic {
    
    static var zero = AnimatableVector(values: [0.0])

    static func + (lhs: AnimatableVector, rhs: AnimatableVector) -> AnimatableVector {
        let count = min(lhs.values.count, rhs.values.count)
        return AnimatableVector(values: vDSP.add(lhs.values[0..<count], rhs.values[0..<count]))
    }

    static func += (lhs: inout AnimatableVector, rhs: AnimatableVector) {
        let count = min(lhs.values.count, rhs.values.count)
        vDSP.add(lhs.values[0..<count], rhs.values[0..<count], result: &lhs.values[0..<count])
    }

    static func - (lhs: AnimatableVector, rhs: AnimatableVector) -> AnimatableVector {
        let count = min(lhs.values.count, rhs.values.count)
        return AnimatableVector(values: vDSP.subtract(lhs.values[0..<count], rhs.values[0..<count]))
    }

    static func -= (lhs: inout AnimatableVector, rhs: AnimatableVector) {
        let count = min(lhs.values.count, rhs.values.count)
        vDSP.subtract(lhs.values[0..<count], rhs.values[0..<count], result: &lhs.values[0..<count])
    }

    var values: [Double]

    mutating func scale(by rhs: Double) {
        vDSP.multiply(rhs, values, result: &values)
    }

    var magnitudeSquared: Double {
        vDSP.sum(vDSP.multiply(values, values))
    }
}


