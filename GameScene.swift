//
//  GameScene.swift
//  SpaceExplorer
//
//  Created by Khan, Owais on 2/10/25.
//

import SpriteKit
import AVFoundation

@MainActor
class GameScene: SKScene, SKPhysicsContactDelegate {
    let player = SKSpriteNode(imageNamed: "spaceship")
    let star = SKSpriteNode(imageNamed: "star")
    let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    var score = 0
    var starSound: AVAudioPlayer?

    override func didMove(to view: SKView) {
        backgroundColor = .black
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self

        // Player setup
        let spaceshipTexture = SKTexture(imageNamed: "spaceship")
        print("Spaceship texture: \(spaceshipTexture)")
        if let texture = spaceshipTexture {
            player.texture = texture
            player.position = CGPoint(x: size.width / 2, y: size.height / 8)
            player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
            player.physicsBody?.isDynamic = false
            player.physicsBody?.categoryBitMask = PhysicsCategory.player
            player.physicsBody?.contactTestBitMask = PhysicsCategory.star
            player.physicsBody?.collisionBitMask = PhysicsCategory.none
            addChild(player)
        } else {
            print("Error: Could not load spaceship texture. Check Assets.xcassets.")
        }

        // Star setup
        let starTexture = SKTexture(imageNamed: "star")
        print("Star texture: \(starTexture)")
        if let texture = starTexture {
            star.texture = texture
            star.physicsBody = SKPhysicsBody(circleOfRadius: star.size.width / 2)
            star.physicsBody?.isDynamic = false
            star.physicsBody?.categoryBitMask = PhysicsCategory.star
            star.physicsBody?.contactTestBitMask = PhysicsCategory.player
            star.physicsBody?.collisionBitMask = PhysicsCategory.none
        } else {
            print("Error: Could not load star texture. Check Assets.xcassets.")
        }

        // Score label
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.9)
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = .yellow
        addChild(scoreLabel)

        // Star spawning (Corrected Timer Handling)
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task {
                await self.addStar() // Call addStar on the main actor
            }
        }


        // Load sound
        if let soundURL = Bundle.main.url(forResource: "starSound", withExtension: "mp3") {
            do {
                starSound = try AVAudioPlayer(contentsOf: soundURL)
            } catch {
                print("Could not load sound: \(error)")
            }
        } else {
            print("Could not find sound file")
        }
    }

    func addStar() {
        let starCopy = SKSpriteNode(texture: star.texture)
        starCopy.position = CGPoint(x: CGFloat.random(in: star.size.width/2...size.width - star.size.width/2), y: size.height + star.size.height/2)
        starCopy.physicsBody = SKPhysicsBody(circleOfRadius: star.size.width/2)
        starCopy.physicsBody?.isDynamic = true
        starCopy.physicsBody?.categoryBitMask = PhysicsCategory.star
        starCopy.physicsBody?.contactTestBitMask = PhysicsCategory.player
        starCopy.physicsBody?.collisionBitMask = PhysicsCategory.none
        starCopy.physicsBody?.velocity = CGVector(dx: 0, dy: -300)
        addChild(starCopy)

        let waitAction = SKAction.wait(forDuration: 5.0)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([waitAction, removeAction])
        starCopy.run(sequence)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        player.position.x = location.x
    }

    nonisolated func didBegin(_ contact: SKPhysicsContact) {
        Task {
            let categoryA = contact.bodyA.categoryBitMask
            let categoryB = contact.bodyB.categoryBitMask
            let nodeA = contact.bodyA.node?.copy() as? SKSpriteNode
            let nodeB = contact.bodyB.node?.copy() as? SKSpriteNode

            await self.handleContact(categoryA: categoryA, categoryB: categoryB, nodeA: nodeA, nodeB: nodeB)
        }
    }

    @MainActor
    private func handleContact(categoryA: UInt32, categoryB: UInt32, nodeA: SKSpriteNode?, nodeB: SKSpriteNode?) {

        if (categoryA == PhysicsCategory.player && categoryB == PhysicsCategory.star) ||
           (categoryB == PhysicsCategory.player && categoryA == PhysicsCategory.star) {

            if let starNode = nodeA, starNode.name == nil {
                starNode.name = "collected"
                starNode.removeFromParent()
                score += 1
                scoreLabel.text = "Score: \(score)"
                starSound?.play()

            } else if let starNode = nodeB, starNode.name == nil {
                starNode.name = "collected"
                starNode.removeFromParent()
                score += 1
                scoreLabel.text = "Score: \(score)"
                starSound?.play()
            }
        }
    }
}

struct PhysicsCategory {
    static let none: UInt32             = 0
    static let all: UInt32              = UInt32.max
    static let player: UInt32           = 0b1       // 1
    static let star: UInt32             = 0b10      // 2
}
