//
//  ViewModel.swift
//  AVP-test-biolocations-240422
//
//  Created by Derrick Hsu on 4/22/24.
//

import Foundation
import SwiftUI
import Observation
import RealityKit
import CoreLocation

@Observable
class ViewModel {
    var fromLat: Float = 0.0
    var fromLong: Float = 0.0
    var toLat: Float = 0.0
    var toLong: Float = 0.0
    var isChangeLoc: Bool = false
    var isDefault: Bool = true
    
    var textShown: String = "Pick a Location"
    var imageURL: String = "default"
    
    var plantCount: Int = 0
    var birdCount: Int = 0
    var reptileCount: Int = 0
    var mammalCount: Int = 0
    
    var locationCoordinate: CLLocationCoordinate2D =
        CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
}
