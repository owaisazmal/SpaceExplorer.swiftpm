//
//  GameScene.swift
//  SpaceExplorer
//
//  Created by Khan, Owais on 2/10/25.
//

import SpriteKit

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        self.backgroundColor = .black // Set the background color of the scene
        setupSpaceship() // Initialize the spaceship when the scene loads
    }

    func setupSpaceship() {
        let spaceship = Spaceship()
        spaceship.position = CGPoint(x: frame.midX, y: frame.midY) // Positioning the spaceship in the middle of the screen
        addChild(spaceship) // Adding the spaceship as a child of the scene for it to appear
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // This function handles touch events, allowing the player to interact with the game
    }
}

