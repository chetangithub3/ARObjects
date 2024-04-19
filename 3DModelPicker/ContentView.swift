//
//  ContentView.swift
//  3DModelPicker
//
//  Created by Chetan Dhowlaghar on 4/17/24.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var models: [String] = {
        let fileManager = FileManager.default
        
        guard let path = Bundle.main.resourcePath, let files = try? fileManager.contentsOfDirectory(atPath: path) else {
            return []
        }
        var availableModels: [String] = []
        
        for fileName in files where fileName.hasSuffix("usdz") {
               
            let modelName = fileName.replacingOccurrences(of: ".usdz", with: "")
      
            availableModels.append(modelName)
        }
        print(availableModels)
        return availableModels
    }()
    
    
    
    
    //["pancakes", "toy_biplane_idle", "sneaker_pegasustrail"]
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer().edgesIgnoringSafeArea(.all)
            
            ModelPickerView(models: models)
        }
     
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)

        // Create a cube model
        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
        let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
        let model = ModelEntity(mesh: mesh, materials: [material])
        model.transform.translation.y = 0.05

        // Create horizontal plane anchor for the content
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
        anchor.children.append(model)

        // Add the horizontal plane anchor to the scene
        arView.scene.anchors.append(anchor)

        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

struct ModelPickerView: View {
    var models: [String]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 25) {
                ForEach(0..<self.models.count) { model in
                    if let image = UIImage(named: models[model]) {
                        
                        Button(action: {
                            
                        }, label: {
                            Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding()
                        })
                       
                    }
                  
                }
            }.background(Color.gray)
        }
    }
}

#Preview {
    ContentView()
}
