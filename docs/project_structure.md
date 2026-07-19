# Project Structure

Below is the structure of the main directories and files in the project, along with a brief description of their roles:

```text
res://
│
├── 📂 assets/                 # Contains static game resources
│   ├── 📂 audio/              # Background music and sound effects (SFX)
│   ├── 📂 fonts/              # Fonts used in the game
│   └── 📂 textures/           # 2D images, character sprites, environment textures
│
├── 📂 autoloads/              # Contains Singleton scripts running in the background
│   ├── 📜 network_manager.gd  # Manages network connections (Host/Join), ENet
│   ├── 📜 game_manager.gd     # Manages general game states (win, lose, start match)
│   ├── 📜 player_manager.gd   # Manages player data, lists, and IDs in the lobby
│   └── 📜 vote_manager.gd     # Handles voting system logic during meetings
│
├── 📂 common/                 # Contains shared files for the entire project
│   ├── 📜 constants.gd        # Declares constants (speed, time, scene names, etc.)
│   ├── 📜 enums.gd            # Declares enumerations (Role, GameState, etc.)
│   └── 📜 utils.gd            # Contains shared utility functions (math, string formatting)
│
├── 📂 scenes/                 # Contains main screens and game scenes
│   ├── 📂 main_menu/          # Main menu UI directory
│   ├── 📂 lobby/              # Lobby UI directory
│   ├── 📂 gameplay/           # Main map and gameplay environment
│   │   ├── 📜 gameplay.tscn   # Root scene containing the game map
│   │   └── 📂 map_elements/   # Interactable map elements (doors, tables, chairs)
│   └── 📂 ui/                 # In-game user interface (Overlay UI)
│       ├── 📜 hud.tscn        # Heads-up display (buttons, minimap)
│       ├── 📜 voting_ui.tscn  # Voting screen UI
│       └── 📜 meeting_ui.tscn # Emergency meeting notification UI
│
├── 📂 entities/               # Contains entities (characters, objects) with independent logic
│   ├── 📂 player/             # Contains everything related to the player
│   │   ├── 📜 player.tscn     # Scene containing player visuals and collision
│   │   ├── 📜 player.gd       # Movement and interaction control logic
│   │   └── 📂 abilities/      # Special abilities (Impostor's Kill, Vent, etc.)
│   └── 📂 tasks/              # Group of task-related features
│       ├── 📜 task_base.gd    # Base script for other tasks to inherit
│       ├── 📂 swipe_card/     # Swipe card task
│       └── 📂 fix_wiring/     # Fix wiring task
│
└── 📂 tests/                  # Contains scenes for internal logic testing
    ├── 📜 lobby.tscn          # Draft lobby test scene
    ├── 📜 main_test.tscn      # Temporary test map
    ├── 📜 main_test.gd        # Game start logic test script
    └── 📜 multiplayer_spawner.gd # Networked player spawning support
