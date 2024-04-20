//
//  AVP_test_manga_240415App.swift
//  AVP-test-manga-240415
//
//  Created by Derrick Hsu on 4/15/24.
//

import SwiftUI

@main
struct AVP_test_manga_240415App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.plain)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.progressive), in: .progressive)
    }
}
