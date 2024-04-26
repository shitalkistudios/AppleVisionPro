//
//  AVP_test_dragonball_240417App.swift
//  AVP-test-dragonball-240417
//
//  Created by Derrick Hsu on 4/17/24.
//

import SwiftUI

@main
struct AVP_test_dragonball_240417App: App {
    
    @State private var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup (id: "MainWindow"){
            ContentView()
                .environment(viewModel)
        }.windowStyle(.volumetric).defaultSize(width: 700, height: 1200, depth: -10)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .environment(viewModel)
        }.immersionStyle(selection: .constant(.full), in: .full)
//            .immersionStyle(selection: .constant(.progressive), in: .progressive)
        
        WindowGroup (id: "ToggleWindow"){
            ToggleView()
                .environment(viewModel)
//                .frame(width: 100, height: 30)
        }.windowStyle(.plain).defaultSize(width: 60, height: 30)
    }
}
