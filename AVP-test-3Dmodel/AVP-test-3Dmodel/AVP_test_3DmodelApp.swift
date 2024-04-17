//
//  AVP_test_3DmodelApp.swift
//  AVP-test-3Dmodel
//
//  Created by Derrick Hsu on 4/12/24.
//

import SwiftUI

@main
struct AVP_test_3DmodelApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
