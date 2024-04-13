//
//  ViewModel.swift
//  AVP-helloworld-240413
//
//  Created by Derrick Hsu on 4/13/24.
//

import Foundation
import Observation

enum FlowState {
    case idle
    case intro
}

@Observable
class ViewModel {
    var flowState = FlowState.idle
}
