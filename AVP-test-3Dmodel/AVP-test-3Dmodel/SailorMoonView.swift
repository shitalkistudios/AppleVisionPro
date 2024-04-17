//
//  SailorMoonView.swift
//  AVP-test-3Dmodel
//
//  Created by Derrick Hsu on 4/12/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct SailorMoonView: View {
    
    
    var body: some View {
        
        // Show a 3D model. New ProgressView to have resizeable content via reoslveModel3D
        
                    Model3D(named: "Sailormoon", bundle: realityKitContentBundle) { resolvedModel3D in
                        resolvedModel3D
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(0.4)
        
                    } placeholder: {
                        ProgressView()
                    }
                    .padding(.bottom, 50)
        
//        RealityView { content in
//            // Add the initial scene content (name needs to match)
//            if let scene = try? await Entity(named: "Sailormoon", in: realityKitContentBundle) {
//                
//                if let animation = scene.availableAnimations.first {
//                    scene.playAnimation(animation.repeat(duration: .infinity),  transitionDuration: 1, startsPaused: false)
//                }
//                content.add(scene)
//            }
//        }
    }
}

#Preview {
    SailorMoonView()
}
