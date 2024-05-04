//
//  AVP_test_sailormoon_240423App.swift
//  AVP-test-sailormoon-240423
//
//  Created by Derrick Hsu on 4/23/24.
//

import SwiftUI

@main
struct AVP_test_sailormoon_240423App: App {
    var body: some Scene {
        WindowGroup(id: "MainWindow"){
            ContentView()
        }.windowStyle(.volumetric).defaultSize(width: 600, height: 1000, depth: 10)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.progressive), in: .progressive)
    }
}
