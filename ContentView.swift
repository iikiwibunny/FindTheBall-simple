import SwiftUI
import RealityKit

//let gradientColors: [Color] = [
    //.gradientTop,
    //.gradientBottom
//]

    struct ContentView: View {
    @State private var tapped = false
    
        /*var dragGesture: any Gesture {
            if #available(iOS 18.0, *) {
                DragGesture()
                    //.targetedToAnyEntity()
            } else {
                // Fallback on earlier versions
            }
        }*/

        
    
    var body: some View {
            /*.background(Gradient(colors: gradientColors))
            .tabViewStyle(.page)*/

        
        if #available(iOS 18.0, *) {
            RealityView { content in
                // Create simple material and mesh
                let simpleMaterial = SimpleMaterial(color: .blue, isMetallic: true)
                let sphereMesh = MeshResource.generateSphere(radius: 0.5)
                
                // Create ModelComponent
                let modelComponent = ModelComponent(mesh: sphereMesh, materials: [simpleMaterial])
                
                // Create the entity, set its model component, and generate collisions
                let sphereEntity = Entity()
                sphereEntity.components.set(modelComponent)
                sphereEntity.generateCollisionShapes(recursive: true)
                
                // Add the entity to the RealityView
                content.add(sphereEntity)
                
                /*@MainActor func installGestures() -> any View {
                    //simultaneousGesture(dragGesture)
                }*/
                
            }
        } else {
            // Fallback on earlier versions
            Text("Please upgrade to iOS 18 or later.")
        }
        StartScreen()
    }
    
}

    
