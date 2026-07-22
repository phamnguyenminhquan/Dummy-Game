# Project Structure

## Below is the structure of the main directories and files in the project, along with a brief description of their roles:

```text
res://
│
├── 📂 assets/                          # Static game resources and media
│   ├── 📂 audio/                       # Background music (BGM) and sound effects (SFX)
│   ├── 📂 fonts/                       # Custom typography and font assets
│   └── 📂 textures/                    # 2D visual assets, character sprites, and environment textures
│       └── 📂 tilesets/                # Tilemap resources for level design
│
├── 📂 autoload/                        # Global Singleton scripts running persistently in the background
│   ├── 📜 network_manager.gd           # Handles high-level ENet network connection setup (Host/Join)
│   ├── 📜 game_manager.gd              # Manages core match states (Lobby, Playing, Victory, Defeat)
│   ├── 📜 player_manager.gd            # Tracks active player instances, and peer IDs, data
│   ├── 📜 room_discovery_manager.gd    # Handles local network (LAN) host broadcasting and room discovery
│   ├── 📜 server_manager.gd            # Server-authoritative logic (role assignment, task allocation)
│   ├── 📜 task_manager.gd              # Global task database and assignment manager (loading, randomizing)
│   └── 📜 vote_manager.gd              # Orchestrates voting logic, tallying, and ejection during meetings
│
├── 📂 common/                          # Shared utilities and configurations across the project
│   ├── 📜 constants.gd                 # Global constants (movement speeds, timer durations, scene paths)
│   ├── 📜 enums.gd                     # Global enumerations (Role, GameState, TaskType, etc.)
│   └── 📜 utils.gd                     # Helper functions for math, string formatting, and common logic
│
├── 📂 docs/                            # Documentation and developer guides
│   ├── 📂 git/                         # Git workflow, branching strategy, and commit conventions
│   └── 📜 project_structure.md         # Detailed overview of the project directory structure
│
├── 📂 entities/                        # Game entities and gameplay objects containing self-contained logic
│   ├── 📂 player/                      # Player character assets and logic
│   │   ├── 📜 player.tscn              # Player scene (visuals, collision layers, and interaction areas)
│   │   ├── 📜 player.gd                # Local and networked player movement and input logic
│   │   └── 📂 abilities/               # Specific character abilities (e.g., Impostor Kill, Venting)
│   └── 📂 tasks/                       # Task system modules and specific mini-game tasks
│       ├── 📜 task_resource.gd         # Custom Resource definition storing task data (ID, name, location)
│       ├── 📜 task.tscn                # Reusable UI frame/dialog for displaying active task mini-games
│       ├── 📜 task_base.gd             # Base class containing core logic for mini-game tasks to inherit
│       ├── 📂 resources/               # `.tres` data files defined using `task_resource.gd`
│       ├── 📂 swipe_card/              # Mini-game scene and logic for the "Swipe Card" task
│       └── 📂 fix_wiring/              # Mini-game scene and logic for the "Fix Wiring" task
│
├── 📂 scenes/                          # Game scenes and user interfaces
│   ├── 📂 main_menu/                   # Main menu interface
│   │   ├── 📜 main_menu.gd             # Main menu UI interaction handler
│   │   └── 📜 main_menu.tscn           # Main menu scene
│   ├── 📂 lobby/                       # Pre-game lobby interface
│   │   ├── 📜 lobby.gd                 # Player readiness and lobby configuration logic
│   │   └── 📜 lobby.tscn               # Lobby UI scene
│   ├── 📂 gameplay/                    # Primary gameplay loop scenes and environment
│   │   ├── 📜 gameplay.tscn            # Root gameplay scene housing the map and spawn points
│   │   └── 📂 map_elements/            # Interactive environment objects (doors, emergency button, vents)
│   └── 📂 ui/                          # In-game HUD and modal overlays
│       ├── 📜 hud.tscn                 # In-game heads-up display (action buttons, task list, minimap)
│       ├── 📜 voting_ui.tscn           # Voting interface overlay used during meetings
│       └── 📜 meeting_ui.tscn          # Emergency meeting popup and transition screens
│
├── 📂 tests/                           # Internal test environments and prototyping scripts
│   ├── 📜 lobby.tscn                   # Standalone test scene for lobby interface features
│   ├── 📜 main_test.gd                 # Test script for validating game startup and flow logic
│   ├── 📜 main_test.tscn               # Playground map scene for testing mechanics
│   └── 📜 multiplayer_spawner.gd       # Helper script for testing multiplayer node spawning
│
├── 📜 icon.svg                         # Default Godot project icon
└── 📜 README.md                        # Project introduction, setup instructions, and overview
```