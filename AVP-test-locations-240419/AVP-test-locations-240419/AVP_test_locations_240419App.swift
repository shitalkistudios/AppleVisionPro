//
//  AVP_test_locations_240419App.swift
//  AVP-test-locations-240419
//
//  Created by Derrick Hsu on 4/19/24.
//

import SwiftUI

@main
struct AVP_test_locations_240419App: App {
    @State private var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
            
        }.windowStyle(.plain)

        ImmersiveSpace(id:"GlobeSpace") {
            GlobeView()
                .environment(viewModel)
            
        }
        
        
    }
}
