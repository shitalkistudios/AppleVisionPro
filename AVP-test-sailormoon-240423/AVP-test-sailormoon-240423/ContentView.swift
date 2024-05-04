//
//  ContentView.swift
//  AVP-test-sailormoon-240423
//
//  Created by Derrick Hsu on 4/23/24.
//

import SwiftUI
import RealityKit
import AVFoundation
import RealityKitContent

struct ContentView: View {

    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false
    
    //Declare entities for scene
    @State public var sailorMoon: Entity? = nil
    @State public var sailorMoonAnimResource: AnimationResource? = nil
    @State private var Particle1: Entity? = nil
    @State private var Particle2: Entity? = nil
    @State private var Particle3: Entity? = nil
    @State private var magicParticle: Entity? = nil
    @State private var soundUrl: URL? = nil
    @State public var soundPlayer: AVAudioPlayer? = nil
    
    //Declare open and close environments
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    //Declare variables for button height and widths
    @State private var buttonWidth: CGFloat = 180
    @State private var buttonHeight: CGFloat = 180
    @State private var buttonCornerRad: CGFloat = 15
    @State private var button1IsSelect: Bool = false
    @State private var button2IsSelect: Bool = false
    @State private var button3IsSelect: Bool = false
    

    var body: some View {
        VStack{
            
        RealityView { content in
            // Add the initial RealityKit content
            if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                
                //declare entites, animation, and particles
                guard let sailorMoon = scene.findEntity(named: "sailormoon_salsa") else { return }
                guard let sailorMoonAnimResource = sailorMoon.availableAnimations.first else { return }
                
                //declare particles
                guard let Particle1 = scene.findEntity(named: "ParticleEmitter1") else { return }
                Particle1.components[ParticleEmitterComponent.self]?.isEmitting = false
                
                guard let Particle2 = scene.findEntity(named: "ParticleEmitter2") else { return }
                Particle2.components[ParticleEmitterComponent.self]?.isEmitting = false
                
                guard let Particle3 = scene.findEntity(named: "ParticleEmitter3") else { return }
                Particle3.components[ParticleEmitterComponent.self]?.isEmitting = false
                
                let magicParticle = Particle1
                magicParticle.components[ParticleEmitterComponent.self]?.restart()
                magicParticle.components[ParticleEmitterComponent.self]?.isEmitting = false
                
                //                magicParticle.components.set(ParticleEmitterComponent())
                
                //add sounds
                guard let path = Bundle.main.path(forResource: "magic-sparkle", ofType:"mp3") else { return }
                let soundUrl = URL(fileURLWithPath: path)
                
                //add to content
                content.add(sailorMoon)
                content.add(Particle1)
                content.add(Particle2)
                content.add(Particle3)
                content.add(magicParticle)
                
                //async tasks to assign to entities to use outside of closure
                Task {
                    self.sailorMoon = sailorMoon
                    self.sailorMoonAnimResource = sailorMoonAnimResource
                    self.Particle1 = Particle1
                    self.Particle2 = Particle2
                    self.Particle3 = Particle3
                    self.magicParticle = magicParticle
                    self.soundUrl = soundUrl
                }
            }//end content closure
        }//end Reality View
        .frame(width: 400, height: 600)
        .offset(z: -25)
        .gesture(TapGesture().targetedToAnyEntity().onEnded { _ in
            
            do {
                soundPlayer = try AVAudioPlayer(contentsOf: soundUrl!)
                soundPlayer?.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            magicParticle!.components[ParticleEmitterComponent.self]?.isEmitting = true
            magicParticle!.components[ParticleEmitterComponent.self]?.restart()
            sailorMoon!.playAnimation(sailorMoonAnimResource!)
            
        })
    //        .onChange(of: showImmersiveSpace) { _, newValue in
    //            Task {
    //                if newValue {
    //                    switch await openImmersiveSpace(id: "ImmersiveSpace") {
    //                    case .opened:
    //                        immersiveSpaceIsShown = true
    //                    case .error, .userCancelled:
    //                        fallthrough
    //                    @unknown default:
    //                        immersiveSpaceIsShown = false
    //                        showImmersiveSpace = false
    //                    }
    //                } else if immersiveSpaceIsShown {
    //                    await dismissImmersiveSpace()
    //                    immersiveSpaceIsShown = false
    //                }
    //            }
    //        }
            
    //        .toolbar {
    //            ToolbarItemGroup(placement: .bottomOrnament) {
    //                VStack (spacing: 12) {
    //                    Toggle("Show ImmersiveSpace", isOn: $showImmersiveSpace)
    //                }
    //            }
    //        }
        
            //
            Text("Choose A Effect")
                .font(.extraLargeTitle)
                .offset(y: 15)
                .offset(z: 125)
            
            HStack{
                Button {
                    magicParticle = Particle1
                    button1IsSelect = true
                    button2IsSelect = false
                    button3IsSelect = false
                    print("Chose Particle 1")
                } label: {
                    ZStack{
                        Image("Particle1-bg")
                            .resizable()
                            .frame(width: buttonWidth, height: buttonHeight)
                            .clipShape(RoundedRectangle(cornerRadius: buttonCornerRad))
                        Image("Particle1-fg")
                            .resizable()
                            .frame(width: buttonWidth, height: buttonHeight)
                            .clipShape(RoundedRectangle(cornerRadius: buttonCornerRad))
                            .offset(z: 25)
                    }
                }
                .shadow(color: .white, radius: button1IsSelect ?  /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/ : 0)
                
                Button {
                    magicParticle = Particle2
                    button1IsSelect = false
                    button2IsSelect = true
                    button3IsSelect = false
                    print("Chose Particle 2")
                } label: {
                    ZStack{
                        Image("Particle2-bg")
                            .resizable()
                            .frame(width: buttonWidth, height: buttonHeight)
                            .clipShape(RoundedRectangle(cornerRadius: buttonCornerRad))
                        Image("Particle2-fg")
                            .resizable()
                            .frame(width: buttonWidth, height: buttonHeight)
                            .clipShape(RoundedRectangle(cornerRadius: buttonCornerRad))
                            .offset(z: 25)
                    }
                }
                .shadow(color: .white, radius: button2IsSelect ?  /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/ : 0)
                
                Button {
                    magicParticle = Particle3
                    button1IsSelect = false
                    button2IsSelect = false
                    button3IsSelect = true
                    print("Chose Particle 3")
                } label: {
                    ZStack{
                        Image("Particle3-bg")
                            .resizable()
                            .frame(width: buttonWidth, height: buttonHeight)
                            .clipShape(RoundedRectangle(cornerRadius: buttonCornerRad))
                        Image("Particle3-fg")
                            .resizable()
                            .frame(width: buttonWidth, height: buttonHeight)
                            .clipShape(RoundedRectangle(cornerRadius: buttonCornerRad))
                            .offset(z: 25)
                    }
                }
                .shadow(color: .white, radius: button3IsSelect ?  /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/ : 0)
                
                
            }//end HStack
        }//end VStack
    }//end body
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
