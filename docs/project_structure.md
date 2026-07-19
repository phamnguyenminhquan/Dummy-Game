# Project Structure

Below is the structure of the main directories and files in the project, along with a brief description of their roles:

```text
res://
│
├── 📂 assets/                 # Contains static game resources
│   ├── 📂 audio/              # Background music and sound effects (SFX)
│   ├── 📂 fonts/              # Fonts used in the game
│   └── 📂 textures/           # 2D images, character sprites, environment textures
│       └── 📂 tilesets/       # Tilesets for map building
│
├── 📂 autoload/               # Contains Singleton scripts running in the background
│   ├── 📜 network_manager.gd  # Manages network connections (Host/Join), ENet
│   ├── 📜 game_manager.gd     # Manages general game states (win, lose, start match)
│   ├── 📜 player_manager.gd   # Manages player data, lists, and IDs in the lobby
│   ├── 📜 room_discovery_manager.gd # Manages local network room discovery (LAN)
│   ├── 📜 server_manager.gd   # Handles server-side logic (roles, tasks)
│   └── 📜 vote_manager.gd     # Handles voting system logic during meetings
│
├── 📂 common/                 # Contains shared files for the entire project
│   ├── 📜 constants.gd        # Declares constants (speed, time, scene names, etc.)
│   ├── 📜 enums.gd            # Declares enumerations (Role, GameState, etc.)
│   └── 📜 utils.gd            # Contains shared utility functions (math, string formatting)
│
├── 📂 docs/                   # Project documentation
│   ├── 📂 git/                # Git workflow and convention guides
│   └── 📜 project_structure.md# Current file describing the project structure
│
├── 📂 entities/               # Contains entities (characters, objects) with independent logic
│   ├── 📂 player/             # Contains everything related to the player
│   │   ├── 📜 player.tscn     # Scene containing player visuals and collision
│   │   ├── 📜 player.gd       # Movement and interaction control logic
│   │   └── 📂 abilities/      # Special abilities (Impostor's Kill, Vent, etc.)
│   └── 📂 tasks/              # Group of task-related features
│       ├── 📜 task.gd         # Main task logic script
│       ├── 📜 task.tscn       # Main task UI scene
│       ├── 📜 task_base.gd    # Base script for other tasks to inherit
│       ├── 📂 swipe_card/     # Swipe card task
│       └── 📂 fix_wiring/     # Fix wiring task
│
├── 📂 scenes/                 # Contains main screens and game scenes
│   ├── 📂 main_menu/          # Main menu UI directory
│   │   ├── 📜 main_menu.gd    # Main menu script
│   │   └── 📜 main_menu.tscn  # Main menu scene
│   ├── 📂 lobby/              # Lobby UI directory
│   │   ├── 📜 lobby.gd        # Lobby script
│   │   └── 📜 lobby.tscn      # Lobby scene
│   ├── 📂 gameplay/           # Main map and gameplay environment
│   │   ├── 📜 gameplay.tscn   # Root scene containing the game map
│   │   └── 📂 map_elements/   # Interactable map elements (doors, tables, chairs)
│   └── 📂 ui/                 # In-game user interface (Overlay UI)
│       ├── 📜 hud.tscn        # Heads-up display (buttons, minimap)
│       ├── 📜 voting_ui.tscn  # Voting screen UI
│       └── 📜 meeting_ui.tscn # Emergency meeting notification UI
│
├── 📂 tests/                  # Contains scenes for internal logic testing
│   ├── 📜 lobby.tscn          # Draft lobby test scene
│   ├── 📜 main_test.gd        # Game start logic test script
│   ├── 📜 main_test.tscn      # Temporary test map
│   └── 📜 multiplayer_spawner.gd # Networked player spawning support
│
├── 📜 icon.svg                # Default Godot/Game icon
└── 📜 README.md               # Repository introduction and overview
