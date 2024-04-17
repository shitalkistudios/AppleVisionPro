//
//  ContentView.swift
//  AVP-test-3Dmodel
//
//  Created by Derrick Hsu on 4/12/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false
    @State private var playSailorMoon = false
    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var body: some View {
        VStack {
            
            RealityView { content in
                // Add the initial scene content (name needs to match)
                if let scene = try? await Entity(named: "Sailormoon", in: realityKitContentBundle) {

                   
                        if let animation = scene.availableAnimations.first {
                            scene.playAnimation(animation.repeat(duration: .infinity),  transitionDuration: 1, startsPaused: false)
                        }
                    
                    content.add(scene)
                }
            }
            
            //3D model via separate view
//            SailorMoonView()
//                .padding(.bottom, 50)
            
            
            //Toggle for Immersive Space. Uses Bool Immersive Space
//            Toggle("Show ImmersiveSpace", isOn: $showImmersiveSpace)
//                .font(.title)
//                .frame(width: 360)
//                .padding(24)
//                .glassBackgroundEffect()
//                .padding()
//            
            //Button for Immersive Space. Uses Bool Immersive Space and SailorMoon
            Button("Moon Prism Power") {
                if showImmersiveSpace { showImmersiveSpace = false
                    playSailorMoon = false
                } else {
                    showImmersiveSpace = true
                    playSailorMoon = true
                }
                }
                .padding()
                .font(.title)
                .foregroundColor(.white)
                .background(.blue)
                .glassBackgroundEffect()
                .shadow(radius: 15)
            
            
            .onChange(of: showImmersiveSpace) { _, newValue in
                Task {
                    if newValue {
                        switch await openImmersiveSpace(id: "ImmersiveSpace") {
                        case .opened:
                            immersiveSpaceIsShown = true
                        case .error, .userCancelled:
                            fallthrough
                        @unknown default:
                            immersiveSpaceIsShown = false
                            showImmersiveSpace = false
                        }
                    } else if immersiveSpaceIsShown {
                        await dismissImmersiveSpace()
                        immersiveSpaceIsShown = false
                    }
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
