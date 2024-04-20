//
//  ViewModel.swift
//  AVP-test-locations-240419
//
//  Created by Derrick Hsu on 4/20/24.
//

import Foundation
import SwiftUI
import Observation
import RealityKit

@Observable
class ViewModel {
    var fromLat: Float = 0.0
    var fromLong: Float = 0.0
    var toLat: Float = 0.0
    var toLong: Float = 0.0
    var isChangeLoc: Bool = false
}

