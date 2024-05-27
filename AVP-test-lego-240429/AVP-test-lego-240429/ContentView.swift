//
//  ContentView.swift
//  AVP-test-lego-240429
//
//  Created by Derrick Hsu on 4/29/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false
    
    @State private var faceURL = "lego_diffuse_smile"
    @State private var faceURLs: [String] = [
        "lego_diffuse_smile",
        "lego_diffuse_frown",
        "lego_diffuse_laugh"
        ]
    @State private var legoHeadModel: ModelEntity? = nil

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        RealityView { content, attachments in
            // Add the initial RealityKit content
            if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                
                //add Lego Model
                guard let legoHead = scene.findEntity(named: "head_geometry") else { return }
                
                //Add Materials
                let faceMaterial = ContentView.loadImageMat(imageURL: "lego_diffuse_smile")
                let legoHeadModel = legoHead as! ModelEntity
                legoHeadModel.model?.materials = [faceMaterial]
                
                //add Control Pangel attachment
                guard let legoFaceControls = attachments.entity(for: "legoControls") else { return }
                legoFaceControls.position = SIMD3<Float>(0.2, 0.05, 0)
                scene.addChild(legoFaceControls)
                
                //add content
                content.add(scene)
                
                //async Tasks
                Task{
                    self.legoHeadModel = legoHeadModel
                }
                
                
            }//end if let closure
        }//end Reality View
    attachments: {
        Attachment(id: "legoControls"){
            Text("How are YOU feeling?")
                .font(.largeTitle)
            
            Grid(alignment: .top, horizontalSpacing: 5, verticalSpacing: 50)
            {
                GridRow {
                    Button {
                        faceURL = "lego_diffuse_smile"
                        print("Smile Selected")
                    } label: {
                        Image("lego_smile_thumb")
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                            .frame(width: 120, height: 120)
                    }
                    
                    Button {
                        faceURL = "lego_diffuse_frown"
                        print("Frown Selected")
                    } label: {
                        Image("lego_frown_thumb")
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                            .frame(width: 120, height: 120)
                    }
                    
                    Button {
                        faceURL = "lego_diffuse_laugh"
                        print("Laugh Selected")
                    } label: {
                        Image("lego_laugh_thumb")
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                            .frame(width: 120, height: 120)
                    }
                }//end Grid Row
                
                GridRow{
                    Button {
                        print("Animate Button")
                        var delay = 0.25
                        
                        for _ in 1 ... 3 {
                            for i in 0 ... (faceURLs.count - 1) {
                                Task {
                                    //delay timer
                                    let timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { timer in
                                        //change the face texture
                                        print(faceURLs[i])
                                        faceURL = faceURLs[i]
                                    }
                                    delay += 0.25
                                }//end async Tasks
                            }//end inner for loop
                        }//end outer for loop
                    } label: {
                        Text("Animate")
                    }
                    .gridCellColumns(3)
                    .controlSize(.large)
                    
                    
                }
            }
            
        }
    }//end of Attachements
    .rotation3DEffect(.degrees(-15), axis: (x: 0, y: 1, z: 0), anchor: .center)
    .onChange(of: faceURL) { _, newValue in
            Task{
                let faceMaterialSelected = ContentView.loadImageMat(imageURL: faceURL)
                legoHeadModel?.model?.materials = [faceMaterialSelected]
            }
    }//end of onChange
    .animation(.default, value: faceURL)
    
        
    }// end body
    
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
        
}//end View

#Preview(windowStyle: .volumetric) {
    ContentView()
}
