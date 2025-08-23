# Bomberman Classic: Game Design Document

## Overview
**Game Title:** Bomberman Classic  
**Genre:** 2D Action/Strategy Puzzle  
**Platform:** iOS (SpriteKit)  
**Target Audience:** Puzzle and strategy gamers, ages 8+  
**Development Time:** 3-4 weeks  

## Core Concept
A faithful recreation of the classic Bomberman gameplay where players navigate grid-based mazes, place bombs to destroy obstacles and enemies, and collect power-ups to enhance their abilities. The game combines strategic thinking with fast-paced action in single-player adventure mode.

## Game Mechanics

### Player Character (Bomberman)
- **Appearance:** Classic white/blue Bomberman sprite with smooth animations
- **Movement:** Touch controls or virtual D-pad for grid-based movement
- **Health:** Single hit death (classic mode) or 3 lives (casual mode)
- **Starting Abilities:** 
  - Can place 1 bomb at a time
  - Bomb explosion radius: 1 tile in each direction
  - Movement speed: Normal

### Bomb System
- **Bomb Placement:** Tap to place bomb at current grid position
- **Timer:** 3-second countdown before explosion
- **Explosion Pattern:** Cross-shaped blast extending in 4 directions
- **Chain Reactions:** Bombs can trigger other bombs
- **Limitations:** Player starts with ability to place only 1 bomb at a time

### Grid-Based World
- **Tile Types:**
  - Empty Floor: Walkable space
  - Indestructible Walls: Permanent barriers
  - Destructible Blocks: Can be destroyed by bombs
  - Bombs: Block movement until they explode
- **Grid Size:** 13x11 tiles (classic proportions)
- **Maze Generation:** Mix of predefined layouts and procedural elements

### Enemy Types
1. **Ballom (Balloon):** Moves randomly, slow speed, 100 points
2. **Oneal:** Moves toward player when in line of sight, medium speed, 200 points  
3. **Doll:** Moves randomly but faster than Ballom, 400 points
4. **Minvo:** Moves in straight lines until hitting wall, 800 points
5. **Kondoria:** Can pass through blocks, very dangerous, 1000 points
6. **Ovape:** Fast movement, unpredictable patterns, 2000 points
7. **Pass:** Can pass through bombs, challenging, 4000 points
8. **Pontan:** Boss enemy with special abilities, 8000 points

### Power-Ups (Hidden in destructible blocks)
- **Fire Up:** Increases bomb explosion radius by 1 tile
- **Bomb Up:** Allows player to place an additional bomb
- **Speed Up:** Increases movement speed
- **Wall Pass:** Ability to walk through destructible blocks
- **Bomb Pass:** Ability to walk through bombs
- **Fire Pass:** Immunity to bomb explosions
- **Remote Control:** Bombs explode when button is pressed
- **Full Fire:** Maximum explosion radius
- **Extra Life:** Gain additional life (casual mode only)

### Controls
- **Movement:** Virtual D-pad or swipe gestures for grid movement
- **Bomb Placement:** Tap bomb button or tap current position
- **Remote Detonation:** Special button when power-up is active
- **Pause:** Dedicated pause button

## Level Design

### Stage Progression
- **50 Stages Total:** Increasing difficulty and complexity
- **Stage Elements:**
  - Stage 1-10: Basic enemy types, simple layouts
  - Stage 11-20: Multiple enemy types, more complex mazes
  - Stage 21-30: Advanced enemies, trap-like layouts
  - Stage 31-40: High-speed gameplay, many enemies
  - Stage 41-50: Expert level, all enemy types, challenging layouts

### Victory Conditions
- **Primary:** Eliminate all enemies on the stage
- **Secondary:** Find the exit door (appears after all enemies defeated)
- **Time Limit:** 3 minutes per stage (classic mode)

### Stage Layouts
- **Pattern-Based:** Predefined optimal layouts for each stage
- **Destructible Block Placement:** Strategic positioning for power-ups
- **Enemy Spawn Points:** Balanced distribution across the map
- **Player Start Position:** Always top-left corner (classic)

## Visual Design

### Art Style
- **Theme:** Classic 8-bit/16-bit pixel art style
- **Color Palette:** Bright, vibrant colors with clear contrast
- **Character Sprites:** 32x32 pixel characters with 4-frame walk cycles
- **Tile Graphics:** Clean, recognizable block patterns

### Animations
- **Player:** 4-direction walking, idle, death explosion
- **Enemies:** Unique movement patterns for each enemy type
- **Bombs:** Blinking countdown animation, cross-explosion effect
- **Blocks:** Destruction animation with debris particles
- **Power-ups:** Gentle floating/glowing effect

### Visual Effects
- **Explosion Effects:** Bright flash with expanding fire sprites
- **Screen Shake:** Subtle effect on bomb explosions
- **Particle Systems:** Block debris, explosion sparks
- **UI Feedback:** Score pop-ups, power-up notifications

## Audio Design

### Sound Effects
- **Bomb Placement:** Classic "plop" sound
- **Bomb Explosion:** Satisfying explosion with echo
- **Enemy Death:** Unique sound for each enemy type
- **Power-up Collection:** Pleasant chime
- **Player Death:** Dramatic explosion sound
- **Block Destruction:** Crumbling/breaking sound
- **Footsteps:** Subtle movement audio

### Music
- **Stage Music:** Upbeat, memorable melodies for each stage group
- **Boss Stages:** More intense musical arrangements  
- **Victory:** Short fanfare for stage completion
- **Game Over:** Classic game over melody
- **Menu Music:** Nostalgic, welcoming theme

## Technical Implementation

### Core Systems
```swift
// Main game systems to implement:
- GridManager: Handles tile-based positioning and collision
- BombController: Bomb placement, timing, and explosion logic
- EnemyAI: Different AI patterns for each enemy type
- PowerUpManager: Collection and effect application
- StageManager: Level loading and progression
- ScoreSystem: Points, lives, and high scores
- SaveManager: Progress persistence
```

### Physics Categories
```swift
enum PhysicsCategory: UInt32 {
    case player = 1
    case enemy = 2
    case bomb = 4
    case explosion = 8
    case wall = 16
    case block = 32
    case powerUp = 64
    case exit = 128
}
```

### Game States
- **MainMenu:** Title screen, stage select, options
- **GamePlay:** Active stage gameplay
- **Paused:** Game paused with options
- **StageComplete:** Victory screen with score
- **GameOver:** Death screen with continue option
- **StageSelect:** Level progression overview

## User Interface

### HUD Elements
- **Lives Counter:** Remaining lives display (casual mode)
- **Score Display:** Current score with high score
- **Timer:** Countdown timer for stage completion
- **Stage Number:** Current stage indicator
- **Power-up Indicators:** Active abilities shown as icons

### Menus
- **Main Menu:** Play, Stage Select, Options, Credits
- **Pause Menu:** Resume, Restart Stage, Main Menu
- **Stage Complete:** Score summary, Next Stage, Menu
- **Game Over:** Continue (if lives remaining), Restart, Menu
- **Options:** Audio settings, control preferences, difficulty

### Stage Select
- **Grid Layout:** Visual representation of all 50 stages
- **Progress Tracking:** Completed stages marked with stars
- **Preview:** Stage number and best score display

## Difficulty Modes

### Classic Mode
- **One Life:** Single hit death, no continues
- **3-Minute Timer:** Traditional time pressure
- **Limited Power-ups:** Authentic retro experience
- **High Score Focus:** Emphasis on perfect play

### Casual Mode  
- **3 Lives:** More forgiving for new players
- **5-Minute Timer:** Reduced time pressure
- **Extra Power-ups:** More frequent power-up spawns
- **Continue System:** Option to restart from current stage

### Challenge Mode (Unlockable)
- **Special Conditions:** Unique rules per stage
- **No Power-ups:** Pure skill-based gameplay
- **Speed Run:** Race against the clock
- **Bomb Limited:** Restricted bomb usage

## Progression System

### Scoring
- **Enemy Elimination:** Points based on enemy type
- **Time Bonus:** Remaining time × 10 points per second
- **Stage Clear Bonus:** 1000 points per stage
- **Perfect Clear:** No deaths = 2x bonus
- **Chain Explosions:** Bonus points for multiple enemy kills

### Unlockables
- **Stage Select:** Unlock after completing Stage 10
- **Challenge Mode:** Unlock after completing all 50 stages
- **Character Skins:** Unlocked through achievements
- **Sound Test:** Unlock after first completion

## Development Phases

### Phase 1: Core Framework (Week 1)
- [ ] Grid-based movement system
- [ ] Basic bomb placement and explosion
- [ ] Simple enemy AI (Ballom type)
- [ ] Collision detection and tile management
- [ ] Basic UI and controls

### Phase 2: Game Systems (Week 2)
- [ ] All enemy types with unique AI
- [ ] Complete power-up system
- [ ] Stage progression and loading
- [ ] Score and lives management
- [ ] Audio integration

### Phase 3: Content & Polish (Week 3)
- [ ] All 50 stage layouts
- [ ] Visual effects and animations
- [ ] Menu systems and UI polish
- [ ] Difficulty modes implementation
- [ ] Save/load functionality

### Phase 4: Testing & Optimization (Week 4)
- [ ] Balance testing and adjustments
- [ ] Performance optimization
- [ ] Bug fixes and edge cases
- [ ] Achievement system
- [ ] Final audio and visual polish

## Monetization Strategy

### Free-to-Play Elements
- **Full Game Access:** All 50 stages available
- **Optional Ads:** Watch ad for extra life/continue
- **Cosmetic Purchases:** Character skins and bomb designs

### Premium Upgrade
- **Ad Removal:** One-time purchase
- **Bonus Stages:** Additional challenging levels
- **Developer Mode:** Level editor and sharing

## Success Metrics
- **Completion Rate:** 60%+ players complete first 10 stages
- **Session Length:** Average 10-15 minutes per session
- **Retention:** 40%+ return rate after 24 hours
- **Progression:** 20%+ players reach Stage 30

## Technical Considerations

### Performance Optimization
- **Sprite Batching:** Efficient rendering of grid tiles
- **Memory Management:** Proper texture atlas usage
- **AI Optimization:** Efficient pathfinding for multiple enemies
- **Particle Systems:** Optimized explosion effects

### Platform-Specific Features
- **Touch Controls:** Responsive virtual D-pad
- **Haptic Feedback:** Subtle vibrations for bomb explosions
- **iCloud Save:** Progress sync across devices
- **Game Center:** Leaderboards and achievements

## Risk Assessment
- **Technical:** Grid-based collision complexity with multiple moving objects
- **Design:** Balancing classic difficulty with modern accessibility
- **Market:** Competing with established puzzle/action games
- **Scope:** Managing 50+ unique stage designs within timeline

## Conclusion
Bomberman Classic brings the timeless gameplay of the original Bomberman to modern iOS devices while maintaining the strategic depth and quick action that made the series famous. The combination of classic mechanics, progressive difficulty, and modern polish should appeal to both nostalgia-driven players and newcomers to the franchise.

The focus on tight grid-based gameplay, strategic bomb placement, and risk-reward power-up collection creates an engaging experience that's easy to learn but challenging to master. With multiple difficulty modes and extensive content, the game offers lasting appeal for puzzle and action game enthusiasts.