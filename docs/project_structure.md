## Project structure

```text
res://
│
├── 📂 assets/
│   ├── 📂 audio/
│   ├── 📂 fonts/
│   └── 📂 textures/
│
├── 📂 autoloads/
│   ├── 📜 network_manager.gd
│   ├── 📜 game_manager.gd
│   ├── 📜 player_manager.gd
│   └── 📜 vote_manager.gd
│
├── 📂 common/
│   ├── 📜 constants.gd
│   ├── 📜 enums.gd
│   └── 📜 utils.gd
│
├── 📂 scenes/
│   ├── 📂 main_menu/
│   ├── 📂 lobby/
│   ├── 📂 gameplay/
│   │   ├── 📜 gameplay.tscn
│   │   └── 📂 map_elements/
│   └── 📂 ui/
│       ├── 📜 hud.tscn
│       ├── 📜 voting_ui.tscn
│       └── 📜 meeting_ui.tscn
│
└── 📂 entities/
	├── 📂 player/
	│   ├── 📜 player.tscn
	│   ├── 📜 player.gd
	│   └── 📂 abilities/
	└── 📂 tasks/
		├── 📜 task_base.gd
		├── 📂 swipe_card/
		└── 📂 fix_wiring/
```
