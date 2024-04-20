//
//  Locations.swift
//  AVP-test-locations-240419
//
//  Created by Derrick Hsu on 4/19/24.
//

import Foundation
import SwiftUI
import CoreLocation

struct Locations: Hashable, Codable, Identifiable{
    var id: Int
    var name: String
    
    private var imageName: String
    var image: Image{
        Image(imageName)
    }
    
    private var coordinates: Coordinates
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude
        )
    }
    
    struct Coordinates: Hashable, Codable{
        var latitude: Double
        var longitude: Double
    }
}
