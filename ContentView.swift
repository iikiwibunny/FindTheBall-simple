import SwiftUI
import RealityKit

struct ContentView: View {
    @State private var isModelVisible = true  // Track visibility

    var body: some View {
        if #available(iOS 18.0, *) {
            RealityView { content in
                if isModelVisible {  // Only add if model should be visible
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

                    content.subscribe(to: TouchEvents.TouchStarted.self) { event in
                        if event.entity == sphereEntity {
                            DispatchQueue.main.async {
                                isModelVisible = false  // Hide the model
                            }
                        }
                    }
                }
            }
        } else {
            Text("Please upgrade to iOS 18 or later.")
        }
    }
}
