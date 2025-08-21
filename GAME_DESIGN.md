# Fart Blaster: Game Design Document

## Overview
**Game Title:** Fart Blaster  
**Genre:** 2D Action/Arcade Shooter  
**Platform:** iOS (SpriteKit)  
**Target Audience:** Casual gamers, ages 8+  
**Development Time:** 2-3 weeks  

## Core Concept
A humorous 2D top-down shooter where players control a character who defeats enemies by shooting powerful fart projectiles. The game combines comedy with engaging arcade gameplay mechanics.

## Game Mechanics

### Player Character
- **Appearance:** Cartoon-style character with expressive animations
- **Movement:** Touch and drag to move around the screen
- **Health:** 3 lives, can be upgraded
- **Special Ability:** Charged fart attack (hold to charge, release for mega blast)

### Fart Projectile System
- **Basic Fart:** Small green/brown projectile with particle trail
- **Charged Fart:** Larger projectile with wider damage radius
- **Special Farts:** 
  - Silent but Deadly (invisible, high damage)
  - Explosive Fart (area of effect damage)
  - Rapid Fire (machine gun style)
  - Ice Fart (freezes enemies)

### Enemy Types
1. **Germ Blob:** Basic slow-moving enemy, 1 hit to kill
2. **Virus Spinner:** Faster enemy that spins and bounces, 2 hits
3. **Bacteria Swarm:** Small enemies that move in groups, 1 hit each
4. **Boss Toilet:** Large enemy with multiple attack patterns, 10 hits

### Controls
- **Movement:** Touch and drag anywhere on screen to move player
- **Shooting:** Tap to shoot basic fart in direction of tap
- **Charged Shot:** Hold finger down to charge, release to fire
- **Special Abilities:** Dedicated UI buttons for special fart types

## Progression System

### Scoring
- Basic enemy kill: 10 points
- Special enemy kill: 25 points  
- Boss kill: 100 points
- Combo multiplier: +10% per consecutive hit without missing
- Distance bonus: Points based on shot distance

### Power-ups
- **Bean Power:** Increases fart damage for 30 seconds
- **Protein Shake:** Rapid fire mode
- **Fiber Boost:** Larger fart projectiles
- **Antacid Shield:** Temporary invincibility
- **Lactose Bomb:** Screen-clearing mega fart

### Levels
- **Wave-based progression:** Increasing difficulty every 5 waves
- **Boss battles:** Every 10 waves
- **Environmental hazards:** Toilets that block movement, wind that affects projectiles
- **Special challenge waves:** Time limits, specific enemy types only

## Visual Design

### Art Style
- **Theme:** Cartoon/comic book style with bright colors
- **Character Design:** Exaggerated, expressive characters
- **Effects:** Colorful particle effects for farts and explosions
- **UI:** Clean, playful interface with toilet/bathroom themed elements

### Animations
- **Player:** Idle, walking, charging fart, taking damage, celebrating
- **Enemies:** Movement patterns, death animations with comedy timing
- **Projectiles:** Spinning/wobbling motion with particle trails
- **Explosions:** Exaggerated cartoon-style with screen shake

### Visual Effects
- **Fart Trails:** Green/brown particle systems
- **Impact Effects:** Star bursts, enemy dissolving animations
- **Screen Shake:** On explosions and charged shots
- **Color Flashes:** Damage indicators, power-up activations

## Audio Design

### Sound Effects
- **Fart Sounds:** Variety of fart noises (short, long, bubbly, squeaky)
- **Enemy Sounds:** Gurgles, pops, splashes when defeated
- **Impact:** Satisfying "splat" sounds
- **Power-ups:** Whoosh sounds, bubbling effects
- **UI:** Button clicks, menu transitions

### Music
- **Background:** Upbeat, playful melody with bathroom/comedy theme
- **Boss Battles:** More intense music with comedic undertones
- **Game Over:** Sad trombone effect
- **Victory:** Triumphant fanfare with fart sound accents

## Technical Implementation

### Core Systems
```swift
// Main game systems to implement:
- PlayerController: Movement and shooting mechanics
- ProjectileManager: Fart projectile physics and collision
- EnemySpawner: Wave-based enemy generation
- ScoreManager: Points, combos, and high scores
- PowerUpSystem: Temporary ability modifications
- AudioManager: Sound effect and music playback
```

### Physics Categories
```swift
enum PhysicsCategory: UInt32 {
    case player = 1
    case enemy = 2
    case fartProjectile = 4
    case powerUp = 8
    case boundary = 16
}
```

### Game States
- **MainMenu:** Title screen with play button
- **GamePlay:** Active game session
- **Paused:** Game paused overlay
- **GameOver:** Score display and restart options
- **Settings:** Audio, difficulty options

## User Interface

### HUD Elements
- **Health Bar:** Visual representation of remaining lives
- **Score Display:** Current score and high score
- **Wave Counter:** Current wave number
- **Special Ability Buttons:** Icons for different fart types
- **Pause Button:** Access to game menu

### Menus
- **Main Menu:** Play, Settings, High Scores, Credits
- **Pause Menu:** Resume, Restart, Main Menu
- **Game Over:** Final Score, New High Score notification, Play Again
- **Settings:** Master Volume, SFX Volume, Music Volume

## Monetization (Future)
- **Power-up Shop:** Purchase special fart abilities with coins
- **Character Skins:** Different character appearances
- **Remove Ads:** One-time purchase
- **Coin Doubler:** Premium currency multiplier

## Development Phases

### Phase 1: Core Gameplay (Week 1)
- [ ] Basic player movement and shooting
- [ ] Simple enemy spawning and collision
- [ ] Basic scoring system
- [ ] Core audio implementation

### Phase 2: Game Systems (Week 2)
- [ ] Multiple enemy types
- [ ] Power-up system
- [ ] Wave progression
- [ ] Visual effects and animations

### Phase 3: Polish & Features (Week 3)
- [ ] Boss battles
- [ ] Special fart types
- [ ] Menu systems
- [ ] High score persistence
- [ ] Final audio and visual polish

## Success Metrics
- **Engagement:** Average session time > 5 minutes
- **Retention:** 50%+ players return within 24 hours
- **Progression:** 80%+ players reach wave 5
- **Fun Factor:** Positive user feedback on comedy and gameplay

## Risk Assessment
- **Technical:** SpriteKit performance with many particles
- **Design:** Balancing humor without being offensive
- **Market:** Ensuring broad appeal despite toilet humor theme

## Conclusion
Fart Blaster combines simple, accessible gameplay with humorous theming to create an entertaining mobile gaming experience. The focus on satisfying shooting mechanics, progressive difficulty, and comedic presentation should appeal to casual gamers looking for lighthearted fun.