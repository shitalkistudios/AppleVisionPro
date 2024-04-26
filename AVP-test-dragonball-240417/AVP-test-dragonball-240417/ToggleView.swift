//
//  ToggleView.swift
//  AVP-test-dragonball-240417
//
//  Created by Derrick Hsu on 4/21/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ToggleView: View {
    
    //declare view models and ability to open/close windows
    @Environment(ViewModel.self) private var viewModel
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    var body: some View {
        VStack{
            Button {
                viewModel.showImmersiveSpace.toggle()
                print("Toggle Test")
                
            } label: {
                Text("さようなら...")
                    .padding(20)
                    .font(.largeTitle)
            }
            .background(.gray)
            .buttonStyle(.plain)
            .clipShape(RoundedRectangle(cornerRadius: 60.0))
            .rotation3DEffect(.degrees(-25), axis: (x: 1, y: 0, z: 0), anchor: .center)
        }//end of VStack
        .onChange(of: viewModel.showImmersiveSpace) { _, newValue in
            Task {
                if viewModel.immersiveSpaceIsShown {
                    dismissWindow(id: "ToggleWindow")
                    await dismissImmersiveSpace()
                    openWindow(id:"MainWindow")
                    viewModel.immersiveSpaceIsShown = false
                }
            }
        }//end of onChange
    }//end of body
}//end of ToggleView

#Preview(windowStyle: .plain) {
    ToggleView()
        .environment(ViewModel())
}
