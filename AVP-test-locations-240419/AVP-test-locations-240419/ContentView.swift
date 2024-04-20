//
//  ContentView.swift
//  AVP-test-locations-240419
//
//  Created by Derrick Hsu on 4/19/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false
    @State private var textShown = "PICK A LOCATION"
    @State private var imageURL = "city-default"
    @Environment(ViewModel.self) var viewModel
    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
            HStack{
                
                List {
                    Button("Mexico City") {
                        viewModel.toLat = 19.432608
                        viewModel.toLong = -99.133209
                        viewModel.isChangeLoc.toggle()
                        textShown = "Mexico City"
                        imageURL = "mexicocity"
                    }
                    .buttonStyle(.borderless)
                    
                    Button("Shanghai") {
                        viewModel.toLat = 31.230391
                        viewModel.toLong = 121.473701
                        viewModel.isChangeLoc.toggle()
                        textShown = "Shanghai"
                        imageURL = "shanghai"
                    }
                    .buttonStyle(.borderless)
                    
                    Button("New York City") {
                        viewModel.toLat = 40.712776
                        viewModel.toLong = -74.005974
                        viewModel.isChangeLoc.toggle()
                        textShown = "New York City"
                        imageURL = "newyorkcity"
                    }
                    .buttonStyle(.borderless)
                    
                    Button("Singapore") {
                        viewModel.toLat = 1.352083
                        viewModel.toLong = 103.819839
                        viewModel.isChangeLoc.toggle()
                        textShown = "Singapore"
                        imageURL = "singapore"
                    }
                    .buttonStyle(.borderless)
                    
                    Button("Lagos") {
                        viewModel.toLat = 6.524379
                        viewModel.toLong = 3.379206
                        viewModel.isChangeLoc.toggle()
                        textShown = "Lagos"
                        imageURL = "lagos"
                    }
                    .buttonStyle(.borderless)
                    
                    Button("Buenos Aires") {
                        viewModel.toLat = -34.603683
                        viewModel.toLong = -58.381557
                        viewModel.isChangeLoc.toggle()
                        textShown = "Buenos Aires"
                        imageURL = "buenosaires"
                    }
                    .buttonStyle(.borderless)
                    
                }//End List
                .listStyle(.insetGrouped)
                
                ZStack{
                    Image(imageURL)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 15)
                        .animation(.default, value: imageURL)
                        
                    
                    Text(textShown)
                        .font(.extraLargeTitle2)
                        .offset(z: 15)
                        .offset(y: -315)
                        .offset(x: -105)
                        .bold()
                        .animation(.default, value: textShown)
                }//end of ZStack
                .offset(y: -28)
                
            }//end HStack
            .onAppear( perform: {
                Task {
                    await openImmersiveSpace(id: "GlobeSpace")
                }
            })
    }
    
}

#Preview(windowStyle: .plain) {
    ContentView()
        .environment(ViewModel())
}
