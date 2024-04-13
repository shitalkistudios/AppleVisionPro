//
//  ContentView.swift
//  AVP-helloworld-240413
//
//  Created by Derrick Hsu on 4/13/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @Environment(ViewModel.self) private var viewModel
    
    @State private var inputText = ""
    @State private var earthEntity: Entity? = nil
    @State public var rotateDegrees = 0.0
    @State private var isRotating = false
    
    var body: some View {
        
        VStack {
            Spacer()

            Text(inputText)
                .font(.custom("AmericanTypewriter", size: 150))
                .font(.extraLargeTitle)
                .fontWeight(.semibold)
                .padding(-10)
            
            Button("Spin Me") {
                if !isRotating {
//                    print(isRotating)
                    viewModel.flowState = .intro
                    isRotating = true
                } else {
//                    print(isRotating)
                    viewModel.flowState = .idle
                    isRotating = false
                }
            }
            .font(.largeTitle)
            .background(isRotating ? .gray : .blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(40)
            
            Spacer()
                
            //display 3D earth and animate Text using do/let framework
            RealityView { content in
                do {
                    let earthEntity = try await Entity(named: "Scene", in: realityKitContentBundle)
                    
                    content.add(earthEntity)
                    
            //animate Hello World text see function below
                    await animateText(text: "Hello World")
                    
                } catch {
                    print("Error in RealityView: \(error)")
                }
            }
            .padding()
            .rotation3DEffect(.degrees(rotateDegrees), axis: (x: 0, y: 1, z: 0), anchor: .center)
            .rotation3DEffect(.degrees(15), axis: (x: 0, y: 0, z: 1), anchor: .center)
            
            Spacer()
        }
        .gesture(SpatialTapGesture().targetedToAnyEntity().onEnded { _ in
            viewModel.flowState = .intro
        })
        .onChange(of: viewModel.flowState){_, newValue in
            switch newValue {
            case .idle:
                print("idle case")
                withAnimation(.easeInOut(duration: 0.1)) {   rotateDegrees = 0.0 }
                break
            case .intro:
                print("intro case")
                withAnimation(.easeInOut(duration: 1.0).speed(0.9).repeatForever(autoreverses: false)) {   rotateDegrees += 360.0 }
//                    rotateYAxis(entity: earthEntity!)
                break
                }
            }
    }
    
    // function to animate text character by character
    func animateText(text: String) async {
        inputText = ""
        for char in text {
            inputText.append(char)
            let milliseconds = (1 + UInt64.random(in: 0 ... 1)) * 110
            try? await Task.sleep(for: .milliseconds(milliseconds))
            }
        }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
