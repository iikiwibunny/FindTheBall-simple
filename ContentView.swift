import SwiftUI
import RealityKit

struct ContentView: View {
    @State private var isModelVisible = true

    var body: some View {
        if #available(iOS 18.0, *) {
            RealityView { content in
                if isModelVisible {
                    let simpleMaterial = SimpleMaterial(color: .blue, isMetallic: true)
                    let sphereMesh = MeshResource.generateSphere(radius: 0.5)
                    let modelComponent = ModelComponent(mesh: sphereMesh, materials: [simpleMaterial])
                    
                    let sphereEntity = Entity()
                    sphereEntity.components.set(modelComponent)
                    sphereEntity.generateCollisionShapes(recursive: true)
                    sphereEntity.gesture

                    // Add tap gesture to remove entity when tapped
                    sphereEntity.components.set(InputTargetComponent())
                    
                    content.add(sphereEntity)
                }
            }
            .coordinateSpace(name: "RealityView")
            // Attach a SwiftUI tap gesture to the entire RealityView
            .gesture(
                TapGesture().onEnded {
                    // When the view is tapped, hide the model
                    isModelVisible = false
                }
            )
        } else {
            Text("Please upgrade to iOS 18 or later.")
        }
    }
}
