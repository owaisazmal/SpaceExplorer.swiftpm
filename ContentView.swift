import SwiftUI
import SpriteKit

struct ContentView: View {
    var body: some View {
        // Embedding the custom SpriteKit scene within the SwiftUI environment
        SpriteView(scene: GameScene())
            .frame(width: 300, height: 500) // Defines the view size for the game
            .edgesIgnoringSafeArea(.all) // Ensures the view expands to the entire available screen
    }
}
