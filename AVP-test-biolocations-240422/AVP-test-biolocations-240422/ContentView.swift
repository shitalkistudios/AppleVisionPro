//
//  ContentView.swift
//  AVP-test-biolocations-240422
//
//  Created by Derrick Hsu on 4/22/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import MapKit

struct ContentView: View {
    
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false
    @Environment(ViewModel.self) var viewModel
    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        VStack{
            HStack{
                
                VStack(alignment: .leading) {
                    Button("Amazon") {
                        viewModel.isDefault = false
                        viewModel.toLat = -2.163106
                        viewModel.toLong = -55.126648
                        viewModel.isChangeLoc.toggle()
                        viewModel.textShown = "Amazon"
                        viewModel.imageURL = "amazon"
                        viewModel.plantCount = 80000
                        viewModel.birdCount = 1300
                        viewModel.reptileCount = 450
                        viewModel.mammalCount = 430
                    }
                    .buttonStyle(.borderless)
                    
                    Button("Australia") {
                        viewModel.isDefault = false
                        viewModel.toLat = -28.865143
                        viewModel.toLong = 141.20990
                        viewModel.isChangeLoc.toggle()
                        viewModel.textShown = "Australia"
                        viewModel.imageURL = "australia"
                        viewModel.plantCount = 19300
                        viewModel.birdCount = 725
                        viewModel.reptileCount = 1130
                        viewModel.mammalCount = 355
                    }
                    .buttonStyle(.borderless)
                    
                    Button("Borneo") {
                        viewModel.isDefault = false
                        viewModel.toLat = 4.820404
                        viewModel.toLong = 116.796783
                        viewModel.isChangeLoc.toggle()
                        viewModel.textShown = "Borneo"
                        viewModel.imageURL = "borneo"
                        viewModel.plantCount = 14000
                        viewModel.birdCount = 720
                        viewModel.reptileCount = 500
                        viewModel.mammalCount = 325
                    }
                    .buttonStyle(.borderless)
                    
                    Button("Congo") {
                        viewModel.isDefault = false
                        viewModel.toLat = -4.322447
                        viewModel.toLong = 15.307045
                        viewModel.isChangeLoc.toggle()
                        viewModel.textShown = "Congo"
                        viewModel.imageURL = "congo"
                        viewModel.plantCount = 8900
                        viewModel.birdCount = 1110
                        viewModel.reptileCount = 310
                        viewModel.mammalCount = 465
                    }
                    .buttonStyle(.borderless)
                    
                    Button("Galapagos") {
                        viewModel.isDefault = false
                        viewModel.toLat = -0.777259
                        viewModel.toLong = -91.142578
                        viewModel.isChangeLoc.toggle()
                        viewModel.textShown = "Galapagos"
                        viewModel.imageURL = "galapagos"
                        viewModel.plantCount = 18400
                        viewModel.birdCount = 1300
                        viewModel.reptileCount = 490
                        viewModel.mammalCount = 390
                    }
                    .buttonStyle(.borderless)
                    
                    Button("Serengeti") {
                        viewModel.isDefault = false
                        viewModel.toLat = -2.3330
                        viewModel.toLong = 34.5670
                        viewModel.isChangeLoc.toggle()
                        viewModel.textShown = "Serengeti"
                        viewModel.imageURL = "serengeti"
                        viewModel.plantCount = 19300
                        viewModel.birdCount = 725
                        viewModel.reptileCount = 345
                        viewModel.mammalCount = 410
                    }
                    .buttonStyle(.borderless)
                    
                }//End VStack 1
                .listStyle(.insetGrouped)
                .frame(width: 300)
                .padding(0)
                .rotation3DEffect(.degrees(15), axis: (x: 0, y: 1, z: 0), anchor: .center)
                
                HStack{
                    ZStack(alignment: .leading){
                        Image(viewModel.imageURL)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(width: 200, height: 300)
                            .shadow(radius: 15)
                            .offset(y: 15)
                            .offset(x: -60)
                            .animation(.default, value: viewModel.imageURL)
                        
                        
                        Text(viewModel.textShown)
                            .font(.largeTitle)
                            .offset(z: 15)
                            .offset(y: -100)
                            .offset(x: -60)
                            .bold()
                            .animation(.default, value: viewModel.textShown)
                    }//end of ZStack
                    VStack(alignment: .leading){
                        Text("Biodiversity")
                            .font(.title3)
                        Text("🌸: \(viewModel.plantCount)")
                            .animation(.default, value: viewModel.plantCount)
                        Text("🐦‍: \(viewModel.birdCount)")
                            .animation(.default, value: viewModel.birdCount)
                        Text("🦎: \(viewModel.reptileCount)")
                            .animation(.default, value: viewModel.reptileCount)
                        Text("🐿️: \(viewModel.mammalCount)")
                            .animation(.default, value: viewModel.mammalCount)
                        Spacer()
                    }//end of VStack 2
                    .opacity(viewModel.isDefault ? 0 : 100)
                    .offset(y: 150)
                    .rotation3DEffect(.degrees(-20), axis: (x: 0, y: 1, z: 0), anchor: .leading)
                    
                }//end HStack 2
                .offset(y: -28)
                
            }//end HStack 1
            
            HStack{
                Spacer()
                MapView(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(viewModel.toLat), longitude: CLLocationDegrees(viewModel.toLong)))
                Spacer()
              }//end HStack
                .opacity(viewModel.isDefault ? 0 : 100)
                .clipShape(RoundedRectangle(cornerRadius: 50))
                .frame(width: 400, height: 250)
                .offset(y: -50)
                .animation(.default, value: viewModel.toLat)
            
        }//end VStack 1
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
