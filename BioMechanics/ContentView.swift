//
//  ContentView.swift
//  BioMechanics
//
//  Created by Even Northug on 15/01/2022.
//

import SwiftUI


struct ContentView: View {
    @State private var tutti: Bool = false
    @State private var pitchPair: [Int] = [0, 0]
    var kb = KeyboardData()
    var mod = HandModel(keyboardData: KeyboardData())
    var lineWidth: CGFloat = 2.0
    var strokeColor: Color = .gray
    
    /// Hands only
    var strippedBody: some View {
        ScrollView([.horizontal], showsIndicators: false) {
            ZStack {
                ForEach(Side.allCases, id: \.self) { side in
                    HandShape(points: mod.points(side: side, pitch: pitchPair[side.rawValue]),
                              circleWidth: kb.pitchWidth)
                        .stroke(strokeColor, lineWidth: lineWidth)
                        .animation(.easeOut(duration: 0.2), value: pitchPair)
                }
            }
        }
    }
    
    /// Hands, torso and keyboard, plus DemoControlPanel
    var body: some View {
        VStack {
            Text("Animating hands").font(.title)
            GeometryReader { geo in
                HStack {
                    Spacer(minLength: (geo.size.width - kb.width) / 2)
                    ScrollView([.horizontal], showsIndicators: false) {
                        ZStack {
                            keyboard().stroke(strokeColor, lineWidth: lineWidth)
                            torso().stroke(strokeColor, lineWidth: lineWidth)
                            ForEach(tutti == true ? kb.range : 0...0, id: \.self) { pitch in
                                let pair = tutti == true ? [0, pitch] : pitchPair
                                ForEach(Side.allCases, id: \.self) { side in
                                    if tutti == false || side == .right {
                                        let points = mod.points(side: side, pitch: pair[side.rawValue])
                                        HandShape(points: points, circleWidth: kb.pitchWidth)
                                            .stroke(strokeColor, lineWidth: lineWidth)
                                            .animation(tutti == true ? nil : .easeOut(duration: 0.2), value: pitchPair)
                                    }
                                }
                            }
                        }.frame(width: kb.width)
                    }
                    Spacer(minLength: (geo.size.width - kb.width) / 2)
                }
            }
            DemoControlView(tutti: $tutti, pitchPair: $pitchPair, range: kb.range)
        }
    }
    
    func keyboard() -> Path {
        let size = CGSize(width: 0, height: kb.height / 4)
        let y = kb.height - size.height
        var path = Path()
        path.addRect(CGRect(origin: .zero, size: CGSize(width: kb.width, height: kb.height)))
        path.addRect(CGRect(origin: CGPoint(x: kb.width * 0.5, y: 0), size: size))
        path.addRect(CGRect(origin: CGPoint(x: mod.bodyCenter.x - mod.handOffsetX, y: y), size: size))
        path.addRect(CGRect(origin: CGPoint(x: mod.bodyCenter.x, y: y), size: size))
        path.addRect(CGRect(origin: CGPoint(x: mod.bodyCenter.x + mod.handOffsetX, y: y), size: size))
        
        return path
    }
    
    func torso() -> Path {
        var sizes = [CGSize]()
        sizes.append(CGSize(width: kb.pitchWidth, height: kb.pitchWidth))
        sizes.append(CGSize(width: kb.pitchWidth * 2, height: kb.pitchWidth * 2))
        sizes.append(CGSize(width: mod.bodyWidth, height: mod.bodyWidth))
        var path = Path()
        for size in sizes {
            let rect = CGRect(origin: mod.bodyCenter, size: size)
            path.addEllipse(in: rect, transform: CGAffineTransform(translationX: -size.width/2, y: -size.height/2))
        }
        return path
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct DemoControlView: View {
    @Binding var tutti: Bool
    @Binding var pitchPair: [Int]
    @State private var sliderValue: Double = 0.45
    var strokeColor: Color = .gray
    var range: ClosedRange<Int>
    
    var body: some View {
        HStack {
            Button(action: {
                tutti.toggle()
            }) {
                Text("All")
                    .frame(width: 80, height: 40)
                    .background(RoundedRectangle(cornerRadius: 10.0).stroke())
                    .padding()
            }
            Slider(value: $sliderValue)
                .onChange(of: sliderValue) { newValue in
                    let pitch = sliderPitch(value: newValue)
                    pitchPair = [pitch, pitch]
                }
                .frame(width: 200)
                .disabled(tutti)
                .id(tutti)
            Button(action: {
                if tutti == false { pitchPair = randomPitchPair() }
            }) {
                Text("Move")
                    .frame(width: 70, height: 70)
                    .background(Circle().stroke())
                    .padding()
            }.disabled(tutti)
        }
        .background(RoundedRectangle(cornerRadius: 10).strokeBorder().foregroundColor(strokeColor))
    }
    
    func randomPitchPair() -> [Int] {
        let armSpan = 50                // overlap 50*2-88 = 12
        let rangeL = range.lowerBound...(range.lowerBound + armSpan)
        let rangeR = (range.upperBound - armSpan)...range.upperBound
        
        return [Int.random(in: rangeL), Int.random(in: rangeR)]
    }
        
    func sliderPitch(value: Double) -> Int {
        let unit = Double(range.count - 1)
        let pitch = range.lowerBound + Int(unit * value)
        
        return pitch
    }
    
}

