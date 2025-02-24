import SwiftUI
import RealityKit
import ARKit


struct ContentView: View {
    @State private var isModelVisible = true  // Controls sphere creation
    @State private var score = 0
    var body: some View {
        if #available(iOS 18.0, *) {
            ARRealityView(isModelVisible: $isModelVisible, score: $score)
                .ignoresSafeArea()
        } else {
            Text("Please upgrade to iOS 18 or later.")
        }
        //ScoreDisplay(score: $score)
    }
}

struct ARRealityView: UIViewRepresentable {
    @Binding var isModelVisible: Bool
    @Binding var score: Int
    func makeCoordinator() -> Coordinator {
        return Coordinator(score: $score) // Pass the score binding to the coordinator
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        /*
        Text(score.description)
            .font(.title)
            .fontWeight(.semibold)
            .padding(.top)*/
        
        // Configure AR session.
        let config = ARWorldTrackingConfiguration()
        arView.session.run(config)
        
        // Add a tap gesture recognizer to the ARView.
        let tapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap(_:))
        )
        arView.addGestureRecognizer(tapGesture)
        
        // Create an anchor entity at world origin.
        let anchor = AnchorEntity(world: .zero)
        arView.scene.anchors.append(anchor)
        
        // Add the sphere entity if it's visible.
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
        // If the sphere is meant to be visible but hasn't been added, add it.
        if isModelVisible, context.coordinator.sphereEntity == nil {
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
        return ModelEntity(mesh: sphereMesh, materials: [simpleMaterial])
    }
    
    class Coordinator: NSObject {
        @Binding var score: Int
        var sphereEntity: Entity?
        init(score: Binding<Int>) {
            _score = score
        }
        
        @MainActor @objc func handleTap(_ sender: UITapGestureRecognizer) {
            guard let arView = sender.view as? ARView,
                  let tappedEntity = arView.entity(at: sender.location(in: arView)),
                  tappedEntity.name == "SphereEntity" else { return }
            
            // Increment the score by 5 each time the sphere is tapped
            self.score += 5

            // Capture the original position.
            let originalTranslation = tappedEntity.transform.translation
            let shakeDistance: Float = 0.05

            // Step 1: Shake right.
            let modelEntity = tappedEntity as? ModelEntity;

                        // Step 0: Change the sphere's color to a random color.
                        let randomColor = UIColor(
                            red: CGFloat.random(in: 0...1),
                            green: CGFloat.random(in: 0...1),
                            blue: CGFloat.random(in: 0...1),
                            alpha: 1.0
                        )
            modelEntity?.model?.materials = [SimpleMaterial(color: randomColor, isMetallic: true)]
            
            tappedEntity.move(
                to: Transform(translation: originalTranslation + SIMD3<Float>(shakeDistance, 0, 0)),
                relativeTo: tappedEntity.parent,
                duration: 0.05
            )
            
            // Step 2: Shake left.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                tappedEntity.move(
                    to: Transform(translation: originalTranslation - SIMD3<Float>(shakeDistance, 0, 0)),
                    relativeTo: tappedEntity.parent,
                    duration: 0.05
                )
            }
            
            // Step 3: Return to original position.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                tappedEntity.move(
                    to: Transform(translation: originalTranslation),
                    relativeTo: tappedEntity.parent,
                    duration: 0.05
                )
            }
            
            // After the shake, move to a new random location.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                let randomX = Float.random(in: -1.0...1.0)
                let randomY = Float.random(in: -1.0...1.0)
                let randomZ = Float.random(in: -1.0...1.0)
                let newPosition = SIMD3<Float>(randomX, randomY, randomZ)
                tappedEntity.move(
                    to: Transform(translation: newPosition),
                    relativeTo: tappedEntity.parent,
                    duration: 0.3
                )
            }
        }
    }
}
/*
struct ScoreDisplay: View {
    @Binding var score: Int
    
    var body: some View {
        VStack {
            Spacer() // This pushes the score to the bottom
            Text("Score: \(score)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(10) // Add padding to text itself for spacing
                .background(Color.black.opacity(0.5)) // Semi-transparent background around the text
                .cornerRadius(8) // Optional: rounded corners
                .padding(.bottom, 30) // Adjust the distance from the bottom
                .frame(maxWidth: 200) // Shrink the frame around the score to fit the content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom) // Keep the VStack aligned at the bottom
        .background(Color.clear)
    }
} */
