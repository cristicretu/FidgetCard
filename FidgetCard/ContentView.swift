//
//  ContentView.swift
//  FidgetCard
//
//  Created by Cristian Cretu on 04.09.2022.
//

import SwiftUI

struct ContentView: View {
    @State var isDragging: Bool = false
    @State var dragLocation = CGPoint(x: 0, y: 0)
    
    var color: [Color] = [.red, .purple, .blue, .cyan, .green, .yellow, .orange, .red]
    
    var width: CGFloat = 340
    var height: CGFloat = 240
    var intensity: CGFloat = 10
    
    // normalize data
    func scale(inputMin: CGFloat, inputMax: CGFloat, outputMin: CGFloat, outputMax: CGFloat, value: CGFloat) -> CGFloat {
        return outputMin + (outputMax - outputMin) * (value - inputMin) / inputMax
    }
    
    var body: some View {
        ZStack {
            Color(.black).background().ignoresSafeArea()
            
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(AngularGradient(colors: color, center: .center))
                .frame(width: width, height: height)
            
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(.black))
                .frame(width: width - 4, height: height - 4)
                .rotation3DEffect(.degrees(dragLocation.x), axis: (x: 0, y: 1, z: 0))
                .rotation3DEffect(.degrees(dragLocation.y), axis: (x: 1, y: 0, z: 0))
                .gesture(
                    DragGesture(minimumDistance: 0.0)
                        .onChanged { gesture in
                            let normalizedX = scale(inputMin: 0, inputMax: width - 4, outputMin: -intensity, outputMax: intensity, value: gesture.location.x)
                            let normalizedY = scale(inputMin: 0, inputMax: height - 4, outputMin: intensity, outputMax: -intensity, value: gesture.location.y)
                            
                            print(normalizedX, normalizedY)
                            
                            withAnimation(isDragging ? .interactiveSpring() : .spring()) {
                                dragLocation = CGPoint(x: normalizedX, y: normalizedY)
                            }
                            isDragging = true
                        }
                        .onEnded { _ in
                            isDragging = false
                            withAnimation(.spring()) {
                                dragLocation = .zero
                            }
                        }
                )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
