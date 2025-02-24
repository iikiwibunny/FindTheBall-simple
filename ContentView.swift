import SwiftUI
import RealityKit
import ARKit

struct ContentView: View {
    @State private var isModelVisible = true

    var body: some View {
        if #available(iOS 18.0, *) {
            ARRealityView(isModelVisible: $isModelVisible)
                .ignoresSafeArea()
        } else {
            Text("Please upgrade to iOS 18 or later.")
        }
    }
}

struct ARRealityView: UIViewRepresentable {
    @Binding var isModelVisible: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(isModelVisible: $isModelVisible)
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        // Run a basic AR session.
        let config = ARWorldTrackingConfiguration()
        arView.session.run(config)
        
        // Add a tap gesture recognizer to the ARView.
        let tapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap(_:))
        )
        arView.addGestureRecognizer(tapGesture)
        
        // Create an anchor for the content.
        let anchor = AnchorEntity(world: .zero)
        arView.scene.anchors.append(anchor)
        
        // Add the sphere if needed.
        if isModelVisible {
            let sphereEntity = createSphereEntity()
            sphereEntity.name = "SphereEntity"  // Unique name for identification.
            sphereEntity.generateCollisionShapes(recursive: true)
            anchor.addChild(sphereEntity)
            context.coordinator.sphereEntity = sphereEntity
        }

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // Update the ARView when isModelVisible changes.
        if !isModelVisible, let sphere = context.coordinator.sphereEntity {
            sphere.removeFromParent()
            context.coordinator.sphereEntity = nil
        } else if isModelVisible, context.coordinator.sphereEntity == nil {
            if let anchor = uiView.scene.anchors.first {
                let sphereEntity = createSphereEntity()
                sphereEntity.name = "SphereEntity"
                sphereEntity.generateCollisionShapes(recursive: true)
                anchor.addChild(sphereEntity)
                context.coordinator.sphereEntity = sphereEntity
            }
        }
    }
    
    private func createSphereEntity() -> ModelEntity {
        let simpleMaterial = SimpleMaterial(color: .blue, isMetallic: true)
        let sphereMesh = MeshResource.generateSphere(radius: 0.5)
        let sphereEntity = ModelEntity(mesh: sphereMesh, materials: [simpleMaterial])
        return sphereEntity
    }
    
    class Coordinator: NSObject {
        @Binding var isModelVisible: Bool
        var sphereEntity: Entity?

        init(isModelVisible: Binding<Bool>) {
            _isModelVisible = isModelVisible
        }
        
        @MainActor @objc func handleTap(_ sender: UITapGestureRecognizer) {
            guard let arView = sender.view as? ARView else { return }
            let tapLocation = sender.location(in: arView)
            // Use ARView's hit-testing to get the tapped entity.
            if let tappedEntity = arView.entity(at: tapLocation),
               tappedEntity.name == "SphereEntity" {
                // Hide the sphere if it was tapped.
                isModelVisible = false
                var sparklePlayer = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "sparkle", withExtension: "m4a")!)
                sparklePlayer.play()
            }
        }
    }
}
