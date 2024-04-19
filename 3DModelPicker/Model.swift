//
//  Model.swift
//  3DModelPicker
//
//  Created by Chetan Dhowlaghar on 4/19/24.
//

import Foundation
import RealityKit
import UIKit
import SwiftUI
import ARKit
import Combine

class Model {
    
    let modelName: String
    let image: UIImage
    var modelEntity: ModelEntity?
    
    private var cancellable: AnyCancellable? = nil
    
    init(modelName: String)  {
        self.modelName = modelName
        self.image = UIImage(named: modelName)!
     
        let fileName = modelName + ".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: fileName)
        .sink { _ in
        } receiveValue: { model in
            self.modelEntity = model
        }
      
    }
}
