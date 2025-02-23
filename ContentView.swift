import SwiftUI
import SpriteKit
import AVFoundation // For sound

struct ContentView: View {
    var body: some View {
        let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        scene.scaleMode = .fill
        return SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}
