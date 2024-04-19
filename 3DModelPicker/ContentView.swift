//
//  ContentView.swift
//  3DModelPicker
//
//  Created by Chetan Dhowlaghar on 4/17/24.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    var models: [Model] = {
        let fileManager = FileManager.default
        
        guard let path = Bundle.main.resourcePath, let files = try? fileManager.contentsOfDirectory(atPath: path) else {
           return []
        }
        var availableModels: [Model] = []
        
        for fileName in files where fileName.hasSuffix("usdz") {
               
            let modelName = fileName.replacingOccurrences(of: ".usdz", with: "")
            let model =  Model(modelName: modelName)
            availableModels.append(model)
        }
        return availableModels
    }()
    @State var modelConfirmendForPlacement: Model?
    @State var selectedModel: Model? = nil
    @State var isPlacementEnabled = false
    
    //["pancakes", "toy_biplane_idle", "sneaker_pegasustrail"]
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(modelConfirmedForPlacement: $modelConfirmendForPlacement).edgesIgnoringSafeArea(.all)
            
            if !isPlacementEnabled {
                ModelPickerView(models: models, selectedModel: $selectedModel, isPlacementEnabled: $isPlacementEnabled)
            } else {
                PlacementButtonsView(isPlacementEnabled: $isPlacementEnabled, selectedModel: $selectedModel, modelConfirmedForPlacement: $modelConfirmendForPlacement)
            }
           
 
        }
     
    }
    
    func loadModels() {
        
    }
}

struct PlacementButtonsView: View {
    
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: Model?
    @Binding var modelConfirmedForPlacement: Model?
    var body: some View {
        
        HStack(spacing: 16) {
            Spacer()
            Button(action: {
               reset()
            }, label: {
                Image(systemName: "xmark")
                    .font(.title)
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(30)
            })
            Button(action: {
                self.modelConfirmedForPlacement = self.selectedModel
              reset()
            }, label: {
                Image(systemName: "checkmark")
                    .font(.title)
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(30)
            })
            Spacer()
        }
        
       
    }
    func reset() {
        self.isPlacementEnabled = false
        self.selectedModel = nil
    }
    
}
struct ARViewContainer: UIViewRepresentable {
    
    @Binding var modelConfirmedForPlacement: Model?
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)

//        // Create a cube model
//        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
//        let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
//        let model = ModelEntity(mesh: mesh, materials: [material])
//        model.transform.translation.y = 0.05
//
//        // Create horizontal plane anchor for the content
//        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
//        anchor.children.append(model)
//
//        // Add the horizontal plane anchor to the scene
//        arView.scene.anchors.append(anchor)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
            
        }
        arView.session.run(config)

        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        
        if let modelName = self.modelConfirmedForPlacement {
            print("added model to scene: \(modelName)")
            
            let model = modelConfirmedForPlacement?.modelEntity
            let anchorEntity = AnchorEntity(plane: .any)
            if let model = model{
                anchorEntity.addChild(model)
            }
            uiView.scene.addAnchor(anchorEntity)
           
            
            DispatchQueue.main.async {
                self.modelConfirmedForPlacement = nil
            }
        }
        
    }
    
}

struct ModelPickerView: View {
    
    var models: [Model]
    
    @Binding var selectedModel: Model?
    @Binding var isPlacementEnabled: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 25) {
                ForEach(0..<self.models.count) { index in
                        Button(action: {
                            self.selectedModel = models[index]
                            isPlacementEnabled = true
                        }, label: {
                            Image(uiImage: models[index].image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding()
                        })
                }
            }.background(Color.gray)
        }
    }
}

//#Preview {
//    ContentView(models: <#[Model]#>)
//}
