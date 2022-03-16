//
//  HandModel.swift
//  BioMechanics
//
//  Created by Even Northug on 20/01/2022.
//

import SwiftUI


struct HandModel {
    
    private let kb: KeyboardData
    private var waistCm: CGFloat = 110    // height 183 cm
    private var boneLengthCm: [CGFloat] = [2, 3, 5, 8, 30]
    var bodyCenterPitch = 60
    var bodyCenter: CGPoint
    var bodyWidth: CGFloat
    var boneLength: [CGFloat] = []
    var handOffsetX: CGFloat
    var tipAngularSpan = Angle.degrees(100)
    
    
    init(keyboardData: KeyboardData) {
        kb = keyboardData
        let bodyCenterX = CGFloat(bodyCenterPitch - kb.range.lowerBound) * kb.pitchWidth
        bodyCenter = CGPoint(x: bodyCenterX, y: kb.height * 3.5)
        bodyWidth = waistCm * kb.cmScale / CGFloat.pi * 0.90
        handOffsetX = kb.width * 0.30
        for cmLength in boneLengthCm {
            boneLength.append(cmLength * kb.cmScale)
        }
    }
    
    /// - Parameters:
    ///   - side: Left or right
    ///   - pitch: MIDI Note number
    /// - Returns: An array of 6 points, finger tip to elbow
    public func points(side: Side, pitch: Int) -> [CGPoint] {
        let touchX = CGFloat(pitch > 0 ? touchPointX(pitch: pitch) : bodyCenter.x)
        let unitX = (touchX - (bodyCenter.x + handOffsetX * side.dir())) / kb.width
        var point = CGPoint(x: touchX, y: kb.height)
        var points = [point]
        let angle = Angle.degrees(90) + tipAngularSpan * unitX
        for length in boneLength {
            let offset: CGPoint = circleCoordinates(angle: angle, radius: length)
            point = CGPoint(x: point.x + offset.x, y: point.y + offset.y)
            points.append(point)
        }
        
        return points
    }
    
    func touchPointX(pitch: Int) -> CGFloat {
        return CGFloat(pitch - kb.range.lowerBound) * kb.pitchWidth
    }
    
    func circleCoordinates(angle: Angle, radius: Double) -> CGPoint {
        let theta = angle.radians
        let r = radius
        let x = r * cos(theta)
        let y = r * sin(theta)
        return CGPoint(x: x, y: y)
    }
    
}


enum Side: Int, CaseIterable {
    case left, right
    
    func dir() -> CGFloat {
        return self == .left ? -1.0 : 1.0
    }
}


struct KeyboardData {
    var range: ClosedRange<Int> = 21...108
    var pitchWidth: CGFloat = 10.0
    private var cmWidth: CGFloat = 122.5
    private var cmHeight: CGFloat = 14.5
    var width: CGFloat
    var height: CGFloat
    var paddingPitches: CGFloat = 1.25
    var cmScale: CGFloat
    
    init() {
        width = CGFloat(range.count - 1) * pitchWidth
        height = width * cmHeight / cmWidth
        let cmPitchWidth = cmWidth / ((7.0 + 4/12) * 12.0 - 1.0)
        cmScale = pitchWidth / cmPitchWidth
    }

}

