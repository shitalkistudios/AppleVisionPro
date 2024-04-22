//
//  GlobeView.swift
//  AVP-test-biolocations-240422
//
//  Created by Derrick Hsu on 4/22/24.
//

import SwiftUI
import RealityKit
import RealityKitContent


struct GlobeView: View {
    @State public var Globe: Entity? = nil
    @State public var globeMarker:Entity? = nil
    @Environment(ViewModel.self) var viewModel
    
    var body: some View {
        
        RealityView { content in
            // Add the initial scene content (name needs to match)
            if let GlobeScene = try? await Entity(named: "GlobeScene", in: realityKitContentBundle) {
//                content.add(GlobeScene)
                
                guard let Globe = GlobeScene.findEntity(named: "Globe") else { return }
                guard let globeMarker = GlobeScene.findEntity(named: "Globe_marker") else { return }
                
                content.add(Globe)
                content.add(globeMarker)
                
                Task{
                    self.Globe = Globe
                    self.globeMarker = globeMarker
//                    self.globeMarker?.setParent(self.Globe!)
                }
            }
        }//end of Reality View
        .onChange(of: viewModel.isChangeLoc){
            
            //Declare some helper variables to rotate Globe
            //Setting Parent makes the Globe Marker tiny...
//            globeMarker?.setParent(Globe)
            
            var transform = Globe?.transform
            
            let globeRotateLong = viewModel.toLong - viewModel.fromLong
            let globeRotateLongRad = globeRotateLong  * Float.pi / 180
            let rotationY = simd_quatf(angle: -globeRotateLongRad, axis: [0, 1, 0] )
            transform!.rotation *= rotationY
            
            //Rotate the GlobeMarker First and assign the new To lat/longs to From lat/longs
            GlobeView.rotateGlobeMarker(entity: globeMarker!, fromLat: viewModel.fromLat, fromLong: viewModel.fromLong, toLat: viewModel.toLat, toLong: viewModel.toLong)
            viewModel.fromLat = viewModel.toLat
            viewModel.fromLong = viewModel.toLong
            
            var transform1 = globeMarker?.transform
            transform1!.rotation *= rotationY
            
            //Rotate the Globe with duration X
            Globe?.move(
                to: transform!,
                relativeTo: nil,
                duration: 1.5, //timing of the movement
                timingFunction: .easeOut
                )
            
        }//end of OnChange
        .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: viewModel.toLat)
        .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: viewModel.toLong)
        
    }//end of body
    
    
    //FUNCTION to rotate the GlobeMarker
    static func rotateGlobeMarker(entity: Entity, fromLat: Float, fromLong: Float, toLat: Float, toLong: Float){
        
        var currentTransform = entity.transform
        print("FROM LAT/LONG: \(fromLat) / \(fromLong)")
        print("TO LAT/LONG: \(toLat) / \(toLong)")
        
        //declare Latitudes
        let fromLatRad = fromLat  * Float.pi / 180
        let toLatRad = toLat * Float.pi / 180
        let rotateLatRad = toLatRad - fromLatRad
        
        //declare Longitudes, NOT USED since globe is rotating
        let fromLongRad = fromLong * Float.pi / 180
        let toLongRad = toLong * Float.pi / 180
        let rotateLongRad = toLongRad - fromLongRad
        
        let rotationX = simd_quatf(angle: -rotateLatRad, axis: [1, 0, 0] )
        let rotationY = simd_quatf(angle: -rotateLongRad, axis: [0, 1, 0] )
        
//        currentTransform.rotation *= rotationY
        currentTransform.rotation *= rotationX
        
        entity.move(
            to: currentTransform,
            relativeTo: nil,
            duration: 1.7, //timing of the movement
            timingFunction: .easeOut
            )
    }
}

#Preview(immersionStyle: .mixed) {
    GlobeView()
        .environment(ViewModel())
}
