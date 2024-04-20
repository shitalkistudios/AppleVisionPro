//
//  ContentView.swift
//  AVP-test-manga-240415
//
//  Created by Derrick Hsu on 4/15/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    //entity variables to access manga pages
    @State public var leftPage: Entity? = nil
    @State public var rightPage: Entity? = nil
    
    //entity variables to access page animation
    @State private var leftPageAnimModel: Entity? = nil
    @State private var prevTurnAnim: AnimationResource? = nil
    @State private var rightPageAnimModel: Entity? = nil
    @State private var nextTurnAnim: AnimationResource? = nil
    
    //var for reader controls
    @State public var leftPg = 1
    @State public var rightPg = 2
    @State public var maxPg = 10
    @State public var noPrev = true
    @State public var noNext = false
    
    
    var body: some View {
        //start Vstack
        VStack {
            //start Zstack
            ZStack {
                //Instantiate and create view for Manga model
                RealityView { content in
                    if let mangaEntity = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                        
                        //identify page meshes
                        guard let leftPage = mangaEntity.findEntity(named: "Page_Left") else { return }
                        guard let rightPage = mangaEntity.findEntity(named: "Page_Right") else { return }
                        
                        //identify page animation meshes and animation
                        guard let leftPageAnimModel = mangaEntity.findEntity(named: "Page_Left_anim") else { return }
                        guard let prevTurnAnimResource = leftPageAnimModel.availableAnimations.first else {return}
                        guard let rightPageAnimModel = mangaEntity.findEntity(named: "Page_Right_anim") else { return }
                        guard let nextTurnAnimResource = rightPageAnimModel.availableAnimations.first else {return}
                        
                        let prevTurnAnim = try? AnimationResource.sequence(with: [prevTurnAnimResource])
                        let nextTurnAnim = try? AnimationResource.sequence(with: [nextTurnAnimResource])
                        
                        
                        //asynchronous tasks - assign to global vars, load initial images
                        Task{
                            //assign state async for display pages
                            self.leftPage = leftPage
                            self.rightPage = rightPage
                            
                            //assign state async for turn pages
                            self.leftPageAnimModel = leftPageAnimModel
                            self.rightPageAnimModel = rightPageAnimModel
                            self.nextTurnAnim = nextTurnAnim
                            self.prevTurnAnim = prevTurnAnim
                            
                            //load images to change
                            let leftMaterial = ContentView.loadImageMat(imageURL: "pg1")
                            let rightMaterial = ContentView.loadImageMat(imageURL: "pg2")
                            
                            //downcasting Entity into ModelEntity
                            let leftPageModel = leftPage as! ModelEntity
                            let rightPageModel = rightPage as! ModelEntity
                            
                            //change materials on entities
                            leftPageModel.model?.materials = [leftMaterial]
                            rightPageModel.model?.materials = [rightMaterial]
                        }
                        
                        content.add(mangaEntity)
                    }
                } //End of Reality View, adjustments such 3D rotate
                .rotation3DEffect(.degrees(25), axis: (x: 1, y: 0, z: 0), anchor: .center)
                .offset(y: 0)
                
                //Add Controls for Manga Reader in Z Stack
                VStack {
                    //Title
                    Text("Controls")
                        .font(.largeTitle)
                        .bold()
                    
                    HStack {
                        //Button 1 for Prev Page
                        Button {
                            Task{
//                                print(leftPg)
//                                print(rightPg)
//                                print("B1 noPrev is: \(noPrev)")
//                                print("B1 noNext is: \(noNext)")

                                if (leftPg - 1) <= 0 {
                                    noPrev = true
                                } else {
                                    leftPg = leftPg - 2
                                    rightPg = rightPg - 2
                                    noPrev = false
                                    noNext = false
                                    
                                    
                                    //play turn page animation
                                    if let leftPageAnimModel = self.leftPageAnimModel, let prevTurnAnim = self.prevTurnAnim {
                                        await leftPageAnimModel.playAnimation(prevTurnAnim.repeat(count: 1))
                                    }
                                    
                                    //load images to change
                                    let leftMaterial = ContentView.loadImageMat(imageURL: "pg\(leftPg)")
                                    let rightMaterial = ContentView.loadImageMat(imageURL: "pg\(rightPg)")
                                    
                                    //downcasting Entity into ModelEntity
                                    let leftPageModel = leftPage as! ModelEntity
                                    let rightPageModel = rightPage as! ModelEntity
                                    
                                    //change materials on pages (which are entities)
                                    leftPageModel.model?.materials = [leftMaterial]
                                    
                                    //wait to change other page for continuity
                                    let milliseconds = (1 + UInt64.random(in: 0 ... 1)) * 450
                                    try? await Task.sleep(for: .milliseconds(milliseconds))
                                    
                                    rightPageModel.model?.materials = [rightMaterial]
                                    
                                    
                                        
                                }
                            }
                        } label: {
                            Text("Previous")
                        }
                        .foregroundColor( noPrev ? .gray : .white)
                        
                        //Button 2 for Next Page
                        Button {
                            Task{
//                                print(leftPg)
//                                print(rightPg)
//                                print("B2 noPrev is: \(noPrev)")
//                                print("B2 noNext is: \(noNext)")
                                
                                if (rightPg + 1) >= maxPg {
                                    noNext = true
                                } else {
                                    leftPg = leftPg + 2
                                    rightPg = rightPg + 2
                                    noNext = false
                                    noPrev = false
                                    
                                    //play turn page animation
                                    if let rightPageAnimModel = self.rightPageAnimModel, let nextTurnAnim = self.nextTurnAnim {
                                        await rightPageAnimModel.playAnimation(nextTurnAnim.repeat(count: 1))
                                    }
                                    
                                    //load images to change
                                    let leftMaterial = ContentView.loadImageMat(imageURL: "pg\(leftPg)")
                                    let rightMaterial = ContentView.loadImageMat(imageURL: "pg\(rightPg)")
                                    
                                    //downcasting Entity into ModelEntity
                                    let leftPageModel = leftPage as! ModelEntity
                                    let rightPageModel = rightPage as! ModelEntity
                                    
                                    //change materials on pages (which are entities)
                                    rightPageModel.model?.materials = [rightMaterial]
                                    
                                    //wait to change other page for continuity
                                    let milliseconds = (1 + UInt64.random(in: 0 ... 1)) * 450
                                    try? await Task.sleep(for: .milliseconds(milliseconds))
                                    
                                    leftPageModel.model?.materials = [leftMaterial]
                                    
                                }
                            }
                        } label: {
                            Text("Next")
                        }
                        .foregroundColor( noNext ? .gray : .white)
                        
                    }
                } //end of Vstack
                    .offset(z: 10)
                    .offset(y: 210)
                
            } //end of ZStack
            
        } //end of VStack
        
    } //end of body view
    
    //Function to load a material
    static func loadImageMat(imageURL: String) -> SimpleMaterial {
        do {
            let texture = try TextureResource.load(named: imageURL)
            var material = SimpleMaterial()
            let color = SimpleMaterial.BaseColor(texture: MaterialParameters.Texture(texture))
            material.color = color
            return material
        } catch {
            fatalError(String(describing: error))
        }
    } //end of loadImageMat function
    
}

//Controls for the Manga Reader
//var mangaControls: some View {
//        //VStack with Title and then several Buttons
//    VStack {
//        //Title
//        Text("Controls")
//            .font(.largeTitle)
//            .bold()
//        
//        HStack {
//            //Button 1
//            Button {
//                Task{
//                    
//                }
//            } label: {
//                Text("Previous")
//            }
//            
//            //Button 2
//            Button {
//                Task{
//                    
//                }
//            } label: {
//                Text("Next")
//            }
//            
//        }
//        
//    }
//    .offset(z: 10)
//    .offset(y: 250)
//    
//}



#Preview(windowStyle: .automatic) {
    ContentView()
}
