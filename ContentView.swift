import SwiftUI
import SpriteKit

struct ContentView: View {
    var body: some View {
        let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)) // Use screen size
        scene.scaleMode = .fill

        return SpriteView(scene: scene)
            .ignoresSafeArea() // Use ignoresSafeArea instead of edgesIgnoringSafeArea
    }
}
