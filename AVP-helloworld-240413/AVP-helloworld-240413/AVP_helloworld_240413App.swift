//
//  AVP_helloworld_240413App.swift
//  AVP-helloworld-240413
//
//  Created by Derrick Hsu on 4/13/24.
//

import SwiftUI

@main
struct AVP_helloworld_240413App: App {
    
    @State private var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }
    }
}
