//
//  AVP_test_lego_240429App.swift
//  AVP-test-lego-240429
//
//  Created by Derrick Hsu on 4/29/24.
//

import SwiftUI

@main
struct AVP_test_lego_240429App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.windowStyle(.volumetric).defaultSize(width: .infinity, height: 500, depth: 8)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
