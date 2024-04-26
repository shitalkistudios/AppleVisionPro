//
//  ImmersiveView.swift
//  AVP-test-dragonball-240417
//
//  Created by Derrick Hsu on 4/17/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import AVFoundation

struct ImmersiveView: View {
    
    //declare view models and ability to open/close windows
    @Environment(ViewModel.self) private var viewModel
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    //Declare road property variables
    @State public var roadLength: Float = 4.8
    @State public var curveHeight: Float = 4.8 * 0.165
    @State public var curveWidth: Float = 4.8 * 0.08 //prior was 0.04
    @State public var speedRatio: Float = 0.005
    @State public var speedRatioInv: Int = 200
    @State public var isPlaying: Bool = false
    
    //Declare movement variables
    @State public var charMoveDist: Float = 0.0
    @State public var charMoveDirection: String = ""
    @State public var charMoveDist1: Float = 0.0
    @State public var charMoveDirection1: String = ""
    @State public var curRoadIndex: Int = 0
    @State public var curIteration: Int = 0
    
    //Declare entity variables
    @State public var roads: [Entity] = []
    @State public var roadNoCurve: Entity? = nil
    @State public var roadNoCurve1: Entity? = nil
    @State public var roadNoCurve2: Entity? = nil
    @State public var roadNoCurve3: Entity? = nil
    @State public var roadNoCurveKai: Entity? = nil
    @State public var roadCurveUp: Entity? = nil
    @State public var roadCurveLeft: Entity? = nil
    @State public var roadCurveLeft1: Entity? = nil
    @State public var roadCurveRight: Entity? = nil
    @State public var roadCurveRight1: Entity? = nil
    @State public var bgmMusicPlayer: AVAudioPlayer?
    
    var body: some View {
        
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveScene = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                
                // Add an ImageBasedLight for content
                guard let lightResource = try? await EnvironmentResource(named: "ImageBasedLight") else { return }
                let iblComponent = ImageBasedLightComponent(source: .single(lightResource), intensityExponent: 0.8)
                immersiveScene.components.set(iblComponent)
                immersiveScene.components.set(ImageBasedLightReceiverComponent(imageBasedLight: immersiveScene))

                //Add skybox using function
                let skybox = createSkybox()
                content.add(skybox!)
                
                //Add and play sound
                guard let path = Bundle.main.path(forResource: "DanDan", ofType:"mp3") else { return }
                let url = URL(fileURLWithPath: path)

                do {
                    bgmMusicPlayer = try AVAudioPlayer(contentsOf: url)
                    bgmMusicPlayer?.numberOfLoops = -1
                    bgmMusicPlayer?.play()
                        
                    } catch let error {
                        print(error.localizedDescription)
                    }
                
                //Find and load char models and animations
//                guard let gokuKidNimbus = immersiveScene.findEntity(named: "Goku_kidnimbus") else { return }
//                guard let gokuKidNimbusAnimResource = gokuKidNimbus.availableAnimations.first else { return }
//                
//                guard let gokuAdult = immersiveScene.findEntity(named: "Goku_adult") else { return }
//                guard let gokuAdultAnimResource = gokuAdult.availableAnimations.first else { return }
                
                //Assign to main character
//                let mainChar: Entity = gokuAdult
//                let mainCharAnimResource: AnimationResource = gokuAdultAnimResource
                
                guard let mainChar = immersiveScene.findEntity(named: viewModel.charSelectedName) else { return }
                guard let mainCharAnimResource = mainChar.availableAnimations.first else { return }
                
                //Add characters
//                content.add(gokuKidNimbus)
                content.add(mainChar)
                
                //Apply basic Animation
//             gokuKidNimbus.playAnimation(gokuKidNimbusAnimResource.repeat())
                mainChar.playAnimation(mainCharAnimResource.repeat())
                
                //timer example
//                let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
//                    var transform = gokuKidNimbus.transform
//                    transform.translation += SIMD3(0,0.2,0)
//                    gokuKidNimbus.move(
//                        to: transform,
//                        relativeTo: nil,
//                        duration: 3,
//                        timingFunction: .easeInOut
//                    )
//                }
//                timer.fire()
                
                //Find and load individual road pieces
                guard let roadNoCurve = immersiveScene.findEntity(named: "Road_nocurve") else { return }
                guard let roadNoCurve1 = immersiveScene.findEntity(named: "Road_nocurve_1") else { return }
                guard let roadNoCurve2 = immersiveScene.findEntity(named: "Road_nocurve_2") else { return }
                guard let roadNoCurve3 = immersiveScene.findEntity(named: "Road_nocurve_3") else { return }
                guard let roadNoCurveKai = immersiveScene.findEntity(named: "Road_nocurvekai") else { return }
                guard let roadCurveUp = immersiveScene.findEntity(named: "Road_curveup") else { return }
                guard let roadCurveLeft = immersiveScene.findEntity(named: "Road_curveleft") else { return }
                guard let roadCurveLeft1 = immersiveScene.findEntity(named: "Road_curveleft_1") else { return }
                guard let roadCurveRight = immersiveScene.findEntity(named: "Road_curveright") else { return }
                guard let roadCurveRight1 = immersiveScene.findEntity(named: "Road_curveright_1") else { return }
                
                //set initial positions for the roads
                moveEntityZ(entity: roadCurveLeft, length: roadLength * 4)
                moveEntityZ(entity: roadNoCurve, length: roadLength * 3)
                 moveEntityZ(entity: roadNoCurve1, length: roadLength * 2)
                moveEntityZ(entity: roadCurveRight, length: roadLength * 1)
                moveEntityZ(entity: roadNoCurveKai, length: roadLength * 0)
                moveEntityZ(entity: roadNoCurve2, length: roadLength * -1)
                moveEntityZ(entity: roadCurveUp, length: roadLength * -2)
                moveEntityZ(entity: roadCurveLeft1, length: roadLength * -3)
                 moveEntityZ(entity: roadNoCurve3, length: roadLength * -4)
                moveEntityZ(entity: roadCurveRight1, length: roadLength * -5)
                
                //content add roads
                content.add(roadCurveLeft)
                content.add(roadNoCurve)
                content.add(roadNoCurve1)
                content.add(roadCurveRight)
                content.add(roadNoCurveKai)
                content.add(roadNoCurve2)
                content.add(roadCurveUp)
                content.add(roadCurveLeft1)
                content.add(roadNoCurve3)
                content.add(roadCurveRight1)
                
                //assign local var to local var
                Task {
                    
                    self.roadNoCurve = roadNoCurve
                    self.roadNoCurve1 = roadNoCurve1
                    self.roadNoCurve2 = roadNoCurve2
                    self.roadNoCurve3 = roadNoCurve3
                    self.roadNoCurveKai = roadNoCurveKai
                    self.roadCurveUp = roadCurveUp
                    self.roadCurveLeft = roadCurveLeft
                    self.roadCurveLeft1 = roadCurveLeft1
                    self.roadCurveRight = roadCurveRight
                    self.roadCurveRight1 = roadCurveRight1
                    
                    //add road into array, order matters
                    roads.append(self.roadCurveLeft!)
                    roads.append(self.roadNoCurve!)
                    roads.append(self.roadNoCurve1!)
                    roads.append(self.roadCurveRight!)
                    roads.append(self.roadNoCurveKai!)
                    roads.append(self.roadNoCurve2!)
                    roads.append(self.roadCurveUp!)
                    roads.append(self.roadCurveLeft1!)
                    roads.append(self.roadNoCurve3!)
                    roads.append(self.roadCurveRight1!)
//                    print(roads[0].name)
//                    print(roadNoCurve.name)
                 
                    //moves the road in Z direction and trigger actions when conditions met
                    isPlaying = true
                    
                    while isPlaying {
                        //move road in Z direction
                        roads.forEach(){ road in
                            moveEntityZ(entity: road, length: roadLength * speedRatio)
                        }
                        
                        //checks what current iteration is or what length moved
                        if curIteration == speedRatioInv {
                            //reset current iteration to 0 after one length moved, move "first" road to "back"
                            curIteration = 0
                            moveEntityZConst(entity: roads[curRoadIndex], length: roadLength * -5)
                            
                            //determine which road is character on and how character should move and assign to midRoadIndex
                            var midRoadIndex = curRoadIndex + 6
                            if midRoadIndex > (roads.count - 1) {
                                midRoadIndex -= roads.count
                            }
                            
                            //need a midRoadIndex1 b/c outgoing curve animation are trigger on next set of roads
                            var midRoadIndex1 = curRoadIndex + 5
                            if midRoadIndex1 > (roads.count - 1) {
                                midRoadIndex1 -= roads.count
                            }
                            
                            //check midRoadIndex to trigger initial curve animation
                            if roads[midRoadIndex] == roadCurveUp {
                                charMoveDist = curveHeight
                                charMoveDirection = "y"
                            } else if roads[midRoadIndex] == roadCurveLeft || roads[midRoadIndex] == roadCurveLeft1 {
                                charMoveDist = -curveWidth
                                charMoveDirection = "x"
                            } else if roads[midRoadIndex] == roadCurveRight || roads[midRoadIndex] == roadCurveRight1 {
                                charMoveDist = curveWidth
                                charMoveDirection = "x"
                            } else {
                                charMoveDist = 0
                                charMoveDirection = ""
                            }
                            
                            //check midRoadIndex1 to trigger outgoing curve animation (needs the next road index)
                            if roads[midRoadIndex1] == roadCurveUp {
                                charMoveDist1 = -curveHeight
                                charMoveDirection1 = "y"
                            } else if roads[midRoadIndex1] == roadCurveLeft || roads[midRoadIndex1] == roadCurveLeft1 {
                                charMoveDist1 = curveWidth
                                charMoveDirection1 = "x"
                            } else if roads[midRoadIndex1] == roadCurveRight || roads[midRoadIndex1] == roadCurveRight1 {
                                charMoveDist1 = -curveWidth
                                charMoveDirection1 = "x"
                            } else {
                                charMoveDist1 = 0
                                charMoveDirection1 = ""
                            }
                            
                            
                            //tests
                            print("CURRENT ROAD INDEX: \(curRoadIndex)")
                            let curRoadName = roads[curRoadIndex].name
                            print("CURRENT ROAD NAME: \(curRoadName)")
                            print("MIDROAD INDEX: \(midRoadIndex)")
                            let midRoadName = roads[midRoadIndex].name
                            print("CURRENT ROAD NAME: \(midRoadName)")
                            
                            
                            //reset the road index to 0 once entire set is moved
                            if curRoadIndex == (roads.count - 1) {
                                curRoadIndex = 0
                            } else { curRoadIndex += 1 }
                            
                        } 
                        
                        //On frame X trigger the intial curve animation prior 100
                        else if curIteration == 138 {
                            await moveCharCurve(entity: mainChar, distance: charMoveDist, direction: charMoveDirection, isEaseOut: true)
                            curIteration += 1
                            print(curIteration)
                        }
                        
                        //On frame Y trigger the outgoing curve animation because it crosses one "road length", needs the next road index
                        else if curIteration == 26 {
                            await moveCharCurve(entity: mainChar, distance: charMoveDist1, direction: charMoveDirection1, isEaseOut: false)
                            curIteration += 1
                            print(curIteration)
                        }
                        
                        //step up the current iteration
                        else {
                            curIteration += 1
                            print(curIteration)
                        }
                        
                        //delay timing for each "frame", it pauses entire system, lower is more smooth
                        let milliseconds = (1 + UInt64.random(in: 0 ... 1)) * 15
                        try? await Task.sleep(for: .milliseconds(milliseconds))
                    }
                }//end of async Tasks
                
            }//end if let content
            
        }//end Reality View
        .onAppear( perform: {
            Task { openWindow(id: "ToggleWindow") }
            })
        .onChange(of: viewModel.showImmersiveSpace) { _, newValue in
            Task {
                if viewModel.immersiveSpaceIsShown {
                    bgmMusicPlayer?.stop()
                }
            }
        }//end of onChange
        
    }// end body some View
     
    //FUNCTION to create Skybox
    private func createSkybox() -> Entity? {
        //create empty large sphere as a mesh
        let largeSphere = MeshResource.generateSphere(radius: 80)
        
        //create empty material
        var skyboxMaterial = UnlitMaterial()
        
        //create and add texture to material
        do {
            let texture = try TextureResource.load(named: "skybox_hazy")
            skyboxMaterial.color = .init(texture: .init(texture))
        } catch {
            print("Failed to create skybox material: \(error)")
            return nil
        }
        
        //create skybox Entity and then assign mesh and texture
        let skyboxEntity = Entity()
        skyboxEntity.components.set(ModelComponent(mesh: largeSphere, materials: [skyboxMaterial]))
        
        //inverse the sphere so texture so on inside aka backface culling
        skyboxEntity.scale = .init(x: -1, y:1, z:1)
        
        //return entity so it can be called later
        return skyboxEntity
    }
    
    //FUNCTION to move entity in Z direction in relative position
    private func moveEntityZ(entity: Entity, length: Float)  {
    entity.transform.translation = SIMD3(entity.transform.translation.x, entity.transform.translation.y, entity.transform.translation.z + Float(length))
    }
    
    //FUNCTION to move entity in Z direction to a constant position
    private func moveEntityZConst(entity: Entity, length: Float)  {
    entity.transform.translation = SIMD3(entity.transform.translation.x, entity.transform.translation.y, Float(length))
    }
    
    //FUNCTION to move the character in a direction at a certain timing duration
    private func moveCharCurve(entity: Entity, distance: Float, direction: String, isEaseOut: Bool) async{
        var transform = await entity.transform
        
        if direction == "x" { transform.translation += SIMD3(distance,0,0) }
        else if direction == "y" { transform.translation += SIMD3(0,distance,0) }
        else { transform.translation += SIMD3(0,0,0) }
        
        await entity.move(
            to: transform,
            relativeTo: nil,
            duration: 3.05, //timing of the movement
            timingFunction: isEaseOut ? .easeOut : .easeIn
            )
    }
    
    
}//end Immersive View


#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(ViewModel())
}
