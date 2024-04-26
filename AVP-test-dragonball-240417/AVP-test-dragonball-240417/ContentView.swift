//
//  ContentView.swift
//  AVP-test-dragonball-240417
//
//  Created by Derrick Hsu on 4/17/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

//    @State private var showImmersiveSpace = false
//    @State private var immersiveSpaceIsShown = false
    
    //declare view Model and ability to close open windows
    @Environment(ViewModel.self) private var viewModel
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow

    var body: some View {
        
        VStack{
            
            RealityView { content in
                // Add the initial RealityKit content
                if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                    
                    content.add(scene)
                    
                }//end of scene closure
                
            }//end of Reality View
            .frame(width: 300, height: 400)
            .offset(z: -25)
            
            Text("Choose A Character")
                .font(.extraLargeTitle)
                .offset(y: 15)
                .offset(z: 125)
            
            //add character selection with tasks
            HStack {
                Spacer ()
                
                Button {
                    viewModel.charSelectedName = "Goku_kidnimbus"
                    print("Chose Kid Goku")
                } label: {
                    ZStack{
                        Image("gokukid-bg")
                            .resizable()
                            .frame(width: 300, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        Image("gokukid-fg")
                            .resizable()
                            .frame(width: 300, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            .offset(z: 25)
                    }
                }
//                .buttonStyle(.borderless)
                
                Button {
                    viewModel.charSelectedName = "Goku_adult"
                    print("Chose Adult Goku")
                } label: {
                    ZStack{
                        Image("gokuadult-bg")
                            .resizable()
                            .frame(width: 300, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        Image("gokuadult-fg")
                            .resizable()
                            .frame(width: 300, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            .offset(z: 25)
                    }
                }
                .buttonStyle(.borderless)
                Spacer ()
            }//end of HStack
            .padding(.bottom)
            .padding(25)
            .offset(z: 110)
            
            Button {
                viewModel.showImmersiveSpace.toggle()
                print("Immersive Button Test")

            } label: {
              Text("行くぞ！")
                .padding(40)
                .font(.extraLargeTitle)
                .cornerRadius(6.0)
            }
            .background(.blue)
            .buttonStyle(.plain)
            .clipShape(RoundedRectangle(cornerRadius: 80.0))
            .offset(z: 125)
            
            
        }//end of VStack
        .onChange(of: viewModel.showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    switch await openImmersiveSpace(id: "ImmersiveSpace") {
                    case .opened:
                        viewModel.immersiveSpaceIsShown = true
                        dismissWindow(id: "MainWindow")
                    case .error, .userCancelled:
                        fallthrough
                    @unknown default:
                        viewModel.immersiveSpaceIsShown = false
                        viewModel.showImmersiveSpace = false
                    }
                } else if viewModel.immersiveSpaceIsShown {
                    await dismissImmersiveSpace()
                    viewModel.immersiveSpaceIsShown = false
                }
            } //end Task
        } //end onChange
        
    }//end of body
}//end of ContentView

#Preview(windowStyle: .volumetric) {
    ContentView()
        .environment(ViewModel())
}
