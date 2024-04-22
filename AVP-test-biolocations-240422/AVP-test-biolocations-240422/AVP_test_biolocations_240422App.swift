//
//  AVP_test_biolocations_240422App.swift
//  AVP-test-biolocations-240422
//
//  Created by Derrick Hsu on 4/22/24.
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

        ImmersiveSpace(id: "GlobeSpace") {
            GlobeView()
                .environment(viewModel)
            
        }
        
    }
}

