//
//  GameScene.swift
//  iGame
//
//  Created by KX on 2025/8/19.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let player: UInt32 = 1
    static let enemy: UInt32 = 2
    static let bomb: UInt32 = 4
    static let explosion: UInt32 = 8
    static let wall: UInt32 = 16
    static let block: UInt32 = 32
    static let powerUp: UInt32 = 64
}

struct GridPosition {
    let x: Int
    let y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Grid constants - horizontal layout (wider than tall)
    private let gridWidth = 17
    private let gridHeight = 9
    private let tileSize: CGFloat = 32
    
    // Game objects
    private var player: SKSpriteNode?
    private var playerGridPos = GridPosition(1, 1)
    private var gameGrid: [[Int]] = []
    private var bombs: [SKSpriteNode] = []
    private var enemies: [SKSpriteNode] = []
    
    // UI
    private var controlPad: SKNode?
    private var bombButton: SKLabelNode?
    private var scoreLabel: SKLabelNode?
    private var score = 0
    
    // Game state
    private var isPlayerMoving = false
    private var canPlaceBomb = true
    private var maxBombs = 1
    private var explosionRadius = 1
    
    override func didMove(to view: SKView) {
        setupPhysics()
        setupGrid()
        setupPlayer()
        setupEnemies()
        setupUI()
    }
    
    private func setupPhysics() {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
    }
    
    private func setupGrid() {
        // Initialize grid (0 = empty, 1 = wall, 2 = destructible block)
        gameGrid = Array(repeating: Array(repeating: 0, count: gridWidth), count: gridHeight)
        
        // Create border walls
        for x in 0..<gridWidth {
            gameGrid[0][x] = 1
            gameGrid[gridHeight-1][x] = 1
        }
        for y in 0..<gridHeight {
            gameGrid[y][0] = 1
            gameGrid[y][gridWidth-1] = 1
        }
        
        // Create internal wall pattern
        for y in stride(from: 2, to: gridHeight-1, by: 2) {
            for x in stride(from: 2, to: gridWidth-1, by: 2) {
                gameGrid[y][x] = 1
            }
        }
        
        // Add destructible blocks
        for y in 1..<gridHeight-1 {
            for x in 1..<gridWidth-1 {
                if gameGrid[y][x] == 0 && (x > 2 || y > 2) && arc4random_uniform(3) == 0 {
                    gameGrid[y][x] = 2
                }
            }
        }
        
        renderGrid()
    }
    
    private func renderGrid() {
        // Clear existing grid nodes
        enumerateChildNodes(withName: "grid_*") { node, _ in
            node.removeFromParent()
        }
        
        let startX = -CGFloat(gridWidth) * tileSize / 2 + tileSize / 2
        let startY = CGFloat(gridHeight) * tileSize / 2 - tileSize / 2
        
        for y in 0..<gridHeight {
            for x in 0..<gridWidth {
                let posX = startX + CGFloat(x) * tileSize
                let posY = startY - CGFloat(y) * tileSize
                
                var node: SKSpriteNode
                
                switch gameGrid[y][x] {
                case 1: // Wall
                    node = SKSpriteNode(color: .darkGray, size: CGSize(width: tileSize, height: tileSize))
                    node.name = "grid_wall"
                case 2: // Destructible block
                    node = SKSpriteNode(color: .brown, size: CGSize(width: tileSize, height: tileSize))
                    node.name = "grid_block"
                default: // Empty
                    node = SKSpriteNode(color: .lightGray, size: CGSize(width: tileSize, height: tileSize))
                    node.alpha = 0.3
                    node.name = "grid_floor"
                }
                
                node.position = CGPoint(x: posX, y: posY)
                addChild(node)
            }
        }
    }
    
    private func setupPlayer() {
        player = SKSpriteNode(color: .white, size: CGSize(width: tileSize * 0.8, height: tileSize * 0.8))
        player?.name = "player"
        
        // Add blue border to represent Bomberman
        let border = SKShapeNode(rect: CGRect(x: -tileSize * 0.4, y: -tileSize * 0.4, width: tileSize * 0.8, height: tileSize * 0.8))
        border.strokeColor = .blue
        border.lineWidth = 3
        border.fillColor = .clear
        player?.addChild(border)
        
        updatePlayerPosition()
        
        // Physics
        player?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: tileSize * 0.8, height: tileSize * 0.8))
        player?.physicsBody?.categoryBitMask = PhysicsCategory.player
        player?.physicsBody?.contactTestBitMask = PhysicsCategory.enemy | PhysicsCategory.explosion | PhysicsCategory.powerUp
        player?.physicsBody?.collisionBitMask = 0
        player?.physicsBody?.isDynamic = false
        
        addChild(player!)
    }
    
    private func setupEnemies() {
        // Add a few Ballom enemies - adjusted for horizontal layout
        let enemyPositions = [(15, 7), (13, 1), (3, 7), (9, 3)]
        
        for (x, y) in enemyPositions {
            if gameGrid[y][x] == 0 {
                let enemy = SKSpriteNode(color: .red, size: CGSize(width: tileSize * 0.7, height: tileSize * 0.7))
                enemy.name = "enemy"
                
                let startX = -CGFloat(gridWidth) * tileSize / 2 + tileSize / 2
                let startY = CGFloat(gridHeight) * tileSize / 2 - tileSize / 2
                enemy.position = CGPoint(x: startX + CGFloat(x) * tileSize, y: startY - CGFloat(y) * tileSize)
                
                enemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: tileSize * 0.7, height: tileSize * 0.7))
                enemy.physicsBody?.categoryBitMask = PhysicsCategory.enemy
                enemy.physicsBody?.contactTestBitMask = PhysicsCategory.explosion
                enemy.physicsBody?.collisionBitMask = 0
                enemy.physicsBody?.isDynamic = false
                
                enemies.append(enemy)
                addChild(enemy)
                
                // Simple random movement
                let moveAction = SKAction.repeatForever(SKAction.sequence([
                    SKAction.wait(forDuration: 1.0),
                    SKAction.run { [weak self] in
                        self?.moveEnemyRandomly(enemy)
                    }
                ]))
                enemy.run(moveAction)
            }
        }
    }
    
    private func setupUI() {
        // Score label - positioned for horizontal layout
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel?.fontSize = 20
        scoreLabel?.fontName = "Arial-BoldMT"
        scoreLabel?.position = CGPoint(x: -size.width/2 + 80, y: size.height/2 - 30)
        addChild(scoreLabel!)
        
        // Control pad (virtual D-pad)
        setupControlPad()
        
        // Bomb button - repositioned for horizontal layout
        bombButton = SKLabelNode(text: "💣")
        bombButton?.fontSize = 35
        bombButton?.name = "bombButton"
        bombButton?.position = CGPoint(x: size.width/2 - 50, y: -size.height/2 + 60)
        addChild(bombButton!)
    }
    
    private func setupControlPad() {
        controlPad = SKNode()
        controlPad?.name = "controlPad"
        controlPad?.position = CGPoint(x: -size.width/2 + 80, y: -size.height/2 + 80)
        
        let directions = [
            ("↑", CGPoint(x: 0, y: 35), "up"),
            ("↓", CGPoint(x: 0, y: -35), "down"),
            ("←", CGPoint(x: -35, y: 0), "left"),
            ("→", CGPoint(x: 35, y: 0), "right")
        ]
        
        for (symbol, offset, name) in directions {
            let button = SKLabelNode(text: symbol)
            button.fontSize = 25
            button.name = name
            button.position = offset
            controlPad?.addChild(button)
        }
        
        addChild(controlPad!)
    }
    
    private func updatePlayerPosition() {
        let startX = -CGFloat(gridWidth) * tileSize / 2 + tileSize / 2
        let startY = CGFloat(gridHeight) * tileSize / 2 - tileSize / 2
        let newPosition = CGPoint(
            x: startX + CGFloat(playerGridPos.x) * tileSize,
            y: startY - CGFloat(playerGridPos.y) * tileSize
        )
        
        player?.position = newPosition
    }
    
    private func movePlayer(dx: Int, dy: Int) {
        if isPlayerMoving { return }
        
        let newX = playerGridPos.x + dx
        let newY = playerGridPos.y + dy
        
        if newX >= 0 && newX < gridWidth && newY >= 0 && newY < gridHeight {
            if gameGrid[newY][newX] == 0 {
                isPlayerMoving = true
                playerGridPos = GridPosition(newX, newY)
                
                let moveAction = SKAction.move(to: CGPoint(
                    x: -CGFloat(gridWidth) * tileSize / 2 + tileSize / 2 + CGFloat(newX) * tileSize,
                    y: CGFloat(gridHeight) * tileSize / 2 - tileSize / 2 - CGFloat(newY) * tileSize
                ), duration: 0.2)
                
                player?.run(moveAction) { [weak self] in
                    self?.isPlayerMoving = false
                }
            }
        }
    }
    
    private func placeBomb() {
        if !canPlaceBomb || bombs.count >= maxBombs { return }
        
        let bombX = playerGridPos.x
        let bombY = playerGridPos.y
        
        // Check if there's already a bomb here
        for bomb in bombs {
            let bombPos = gridToWorldPosition(GridPosition(bombX, bombY))
            if bomb.position.x == bombPos.x && bomb.position.y == bombPos.y {
                return
            }
        }
        
        let bomb = SKSpriteNode(color: .black, size: CGSize(width: tileSize * 0.6, height: tileSize * 0.6))
        bomb.name = "bomb"
        bomb.position = gridToWorldPosition(GridPosition(bombX, bombY))
        
        // Add fuse animation
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.5)
        let scaleDown = SKAction.scale(to: 0.8, duration: 0.5)
        let pulse = SKAction.repeatForever(SKAction.sequence([scaleUp, scaleDown]))
        bomb.run(pulse)
        
        bombs.append(bomb)
        addChild(bomb)
        
        // Explode after 3 seconds
        let explodeAction = SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run { [weak self] in
                self?.explodeBomb(bomb, at: GridPosition(bombX, bombY))
            }
        ])
        bomb.run(explodeAction)
    }
    
    private func explodeBomb(_ bomb: SKSpriteNode, at position: GridPosition) {
        bomb.removeFromParent()
        bombs.removeAll { $0 === bomb }
        
        // Create explosion at center
        createExplosion(at: position)
        
        // Create explosions in 4 directions
        let directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]
        for (dx, dy) in directions {
            for distance in 1...explosionRadius {
                let explodeX = position.x + dx * distance
                let explodeY = position.y + dy * distance
                
                if explodeX < 0 || explodeX >= gridWidth || explodeY < 0 || explodeY >= gridHeight {
                    break
                }
                
                let tileType = gameGrid[explodeY][explodeX]
                
                if tileType == 1 { // Wall - stop explosion
                    break
                } else if tileType == 2 { // Destructible block
                    gameGrid[explodeY][explodeX] = 0
                    createExplosion(at: GridPosition(explodeX, explodeY))
                    renderGrid()
                    
                    // Chance to spawn power-up
                    if arc4random_uniform(3) == 0 {
                        spawnPowerUp(at: GridPosition(explodeX, explodeY))
                    }
                    break
                } else { // Empty space
                    createExplosion(at: GridPosition(explodeX, explodeY))
                }
            }
        }
    }
    
    private func createExplosion(at position: GridPosition) {
        let explosion = SKSpriteNode(color: .orange, size: CGSize(width: tileSize, height: tileSize))
        explosion.name = "explosion"
        explosion.position = gridToWorldPosition(position)
        explosion.alpha = 0.8
        
        explosion.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: tileSize, height: tileSize))
        explosion.physicsBody?.categoryBitMask = PhysicsCategory.explosion
        explosion.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.enemy
        explosion.physicsBody?.collisionBitMask = 0
        explosion.physicsBody?.isDynamic = false
        
        addChild(explosion)
        
        // Remove explosion after short time
        let removeAction = SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.fadeOut(withDuration: 0.2),
            SKAction.removeFromParent()
        ])
        explosion.run(removeAction)
    }
    
    private func spawnPowerUp(at position: GridPosition) {
        let powerTypes = ["🔥", "💣", "⚡", "🛡️"]
        let randomType = powerTypes[Int(arc4random_uniform(UInt32(powerTypes.count)))]
        
        let powerUp = SKLabelNode(text: randomType)
        powerUp.fontSize = 24
        powerUp.name = "powerUp"
        powerUp.position = gridToWorldPosition(position)
        
        powerUp.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: tileSize, height: tileSize))
        powerUp.physicsBody?.categoryBitMask = PhysicsCategory.powerUp
        powerUp.physicsBody?.contactTestBitMask = PhysicsCategory.player
        powerUp.physicsBody?.collisionBitMask = 0
        powerUp.physicsBody?.isDynamic = false
        
        addChild(powerUp)
        
        // Floating animation
        let float = SKAction.moveBy(x: 0, y: 5, duration: 1.0)
        let floatSequence = SKAction.repeatForever(SKAction.sequence([float, float.reversed()]))
        powerUp.run(floatSequence)
    }
    
    private func gridToWorldPosition(_ gridPos: GridPosition) -> CGPoint {
        let startX = -CGFloat(gridWidth) * tileSize / 2 + tileSize / 2
        let startY = CGFloat(gridHeight) * tileSize / 2 - tileSize / 2
        return CGPoint(
            x: startX + CGFloat(gridPos.x) * tileSize,
            y: startY - CGFloat(gridPos.y) * tileSize
        )
    }
    
    private func moveEnemyRandomly(_ enemy: SKSpriteNode) {
        let directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]
        let randomDirection = directions[Int(arc4random_uniform(UInt32(directions.count)))]
        
        // Simple movement - just move in random direction if possible
        let currentPos = enemy.position
        let newPos = CGPoint(
            x: currentPos.x + CGFloat(randomDirection.0) * tileSize,
            y: currentPos.y - CGFloat(randomDirection.1) * tileSize
        )
        
        // Basic boundary check (simplified)
        if abs(newPos.x) < CGFloat(gridWidth) * tileSize / 2 && abs(newPos.y) < CGFloat(gridHeight) * tileSize / 2 {
            let moveAction = SKAction.move(to: newPos, duration: 0.5)
            enemy.run(moveAction)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if let nodeName = touchedNode.name {
                switch nodeName {
                case "up":
                    movePlayer(dx: 0, dy: -1)
                case "down":
                    movePlayer(dx: 0, dy: 1)
                case "left":
                    movePlayer(dx: -1, dy: 0)
                case "right":
                    movePlayer(dx: 1, dy: 0)
                case "bombButton":
                    placeBomb()
                default:
                    break
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        if (nodeA?.name == "player" && nodeB?.name == "enemy") ||
           (nodeA?.name == "enemy" && nodeB?.name == "player") {
            gameOver()
        }
        
        if (nodeA?.name == "player" && nodeB?.name == "explosion") ||
           (nodeA?.name == "explosion" && nodeB?.name == "player") {
            gameOver()
        }
        
        if (nodeA?.name == "enemy" && nodeB?.name == "explosion") ||
           (nodeA?.name == "explosion" && nodeB?.name == "enemy") {
            let enemy = nodeA?.name == "enemy" ? nodeA : nodeB
            enemy?.removeFromParent()
            enemies.removeAll { $0 === enemy as? SKSpriteNode }
            
            score += 100
            scoreLabel?.text = "Score: \(score)"
        }
        
        if (nodeA?.name == "player" && nodeB?.name == "powerUp") ||
           (nodeA?.name == "powerUp" && nodeB?.name == "player") {
            let powerUp = nodeA?.name == "powerUp" ? nodeA as? SKLabelNode : nodeB as? SKLabelNode
            collectPowerUp(powerUp)
        }
    }
    
    private func collectPowerUp(_ powerUp: SKLabelNode?) {
        guard let powerUp = powerUp else { return }
        
        switch powerUp.text {
        case "🔥":
            explosionRadius += 1
        case "💣":
            maxBombs += 1
        case "⚡":
            // Speed boost (could implement faster movement)
            break
        case "🛡️":
            // Shield (could implement temporary invincibility)
            break
        default:
            break
        }
        
        powerUp.removeFromParent()
        score += 50
        scoreLabel?.text = "Score: \(score)"
    }
    
    private func gameOver() {
        // Simple game over - restart scene
        let gameOverLabel = SKLabelNode(text: "GAME OVER")
        gameOverLabel.fontSize = 48
        gameOverLabel.fontName = "Arial-BoldMT"
        gameOverLabel.position = CGPoint(x: 0, y: 0)
        gameOverLabel.zPosition = 100
        addChild(gameOverLabel)
        
        let restartAction = SKAction.sequence([
            SKAction.wait(forDuration: 2.0),
            SKAction.run { [weak self] in
                guard let self = self else { return }
                let newScene = GameScene(size: self.size)
                newScene.scaleMode = .aspectFill
                self.view?.presentScene(newScene)
            }
        ])
        run(restartAction)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Game update loop - could add enemy AI updates here
    }
}
