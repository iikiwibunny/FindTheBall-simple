# FindTheBall-simple

FindTheBall-simple is a simple AR application built with SwiftUI, RealityKit, and ARKit for iOS 18 and later. The app displays a blue metallic sphere in an augmented reality scene. When the sphere is tapped, it performs a brief shake animation before moving to a new, random location.

---

## Features

- **Augmented Reality:** Utilizes ARKit for world tracking and RealityKit for rendering 3D content.
- **Interactive Sphere:** A sphere entity that responds to tap gestures.
- **Shake Animation:** The sphere shakes briefly (moves slightly right and left) before relocating.
- **Random Movement:** After shaking, the sphere moves to a new, randomly generated position.
- **SwiftUI Integration:** Embeds AR content in SwiftUI using a custom `UIViewRepresentable` wrapper.

---

## Requirements

- **iOS:** iOS 18 or later
- **Xcode:** Xcode 14 or later
- **Device:** An iOS device with ARKit support (or use the ARKit simulator if available)

---

## Installation

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/yourusername/FindTheBall-simple.git
   ```

2. **Open the Project in Xcode:**

   ```bash
   open FindTheBall-simple.xcodeproj
   ```

3. **Build and Run:**
   
   Build and run the project on a supported iOS device.

---

## Project Structure

- **ContentView.swift:**
  Contains the main SwiftUI view and the ARRealityView implementation.
  - **ARRealityView:**
    A `UIViewRepresentable` that wraps an ARView. It sets up the AR session, adds the sphere entity to the scene, and attaches a UITapGestureRecognizer for tap detection.
  - **Coordinator:**
    Handles tap gestures, performs hit-testing to detect taps on the sphere, executes a shake animation sequence, and moves the sphere to a new random location.

---

## Usage

- **Launch the App:**
  When you run the app, it will display an AR scene with a blue metallic sphere.

- **Interact with the Sphere:**
  Tap on the sphere. It will:
  1. Perform a quick shake animation.
  2. Move to a new random position in the scene.

Enjoy the interactive AR experience!

---

## Customization

- **Shake Animation:**
  Adjust the `shakeDistance` and animation durations in the `Coordinator` class within `ContentView.swift` to modify the shake effect.

- **Sphere Appearance:**
  Modify the `createSphereEntity()` function to change the sphere's color, material, or size.

- **Movement Range:**
  Change the random coordinate range in the `handleTap(_:)` function to alter how far the sphere can move.

---

## Acknowledgments

This project leverages Apple’s ARKit and RealityKit frameworks. For more detailed information on these technologies, please refer to the [Apple Developer Documentation](https://developer.apple.com/documentation/arkit).

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
