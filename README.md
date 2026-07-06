# 🚀 DUMMY GAME 🤡

## 🎯 I. Description - Product Vision

### 1. Game Approach
* The game bridges the gap between entertainment and education.
* Instead of studying dry academic concepts, students can have fun while solving famous logical puzzles—the very same puzzles they can later apply to real-world coding assignments.

### 2. Game Concept
* A multiplayer social deduction game where players collaborate to complete tasks while identifying and eliminating an impostor, inspired by titles like Among Us and Goose Goose Duck.
* **Genres:** Strategy, Puzzle, Social Deduction, Sci-Fi.
* **Platform:** LAN-based Multiplayer PC Game
* **Target Audience:** Players aged 14+ who want to enjoy casual gaming sessions with friends while learning practical logic puzzles.

### 3. Strategic "Why" (Project Motivation)
* We chose this project to gain hands-on experience navigating real-world software development scenarios and collaborating effectively within an engineering team.
* Building a multiplayer game allows us to explore diverse aspects of product development—such as real-time networking, state synchronization, and interactive UI design—which will keep the team highly motivated and engaged throughout the course life cycle.

## 👥 II. Members

* Huỳnh Đắc Uy
* Phạm Nguyễn Minh Quân
* Lê Đức Nhân
* Nguyễn Sỹ Nguyên
* Lê Trương Nguyên
* Lê Trần Gia Bảo

## 🛠️ III. Tech Stack

* **Game Engine:** Godot Engine
* **Programming Language:** GDScript
* [...]

## 🔗 IV. Project Links

* 📋 [Trello - Task Management](https://trello.com/b/wHDXNywp/dummy-game)
* 📄 [Workspace Google Drive](https://drive.google.com/drive/folders/1h1P41XgIxmWGoj_YTWr0CQ9Qd5MxfALe?usp=sharing)

## 💻 V. Getting Started - How to set up

### For standard uses

[...]

### For contributors

#### 1. Fork & Clone
* First, **create a new fork** of this repository to your personal GitHub account.
* Then, clone **your forked repository** to your local machine:
```bash
git clone <your-forked-repo-link>
```
* Move into the project directory and link your local repo back to the original group repo (upstream):
```bash
cd <project-directory>
git remote add upstream <original-group-repo-link>
```
* Verify your remotes (you should see both `origin` pointing to your fork, and `upstream` pointing to the group repo):
```bash
git remote -v
```

#### 2. Configure Repository locally
* Set up the **mandatory commit template** for this repository:
```bash
git config --local commit.template .gitmessage
```
* (Optional) Configure VSCode as your default commit text editor to avoid Vim:
```bash
git config --local core.editor "code --wait"
```

#### 3. Create your own branch
* Before making any changes, always create a new branch from `main`.
* Branch `main` will be the **product stable state**.
* Name it according to the feature or task (e.g., `feat/login-page`, `docs/update-readme`):
```bash
git switch -c <your-branch-name>
```

#### 4. Commit your work
* Stage your changes:
```bash
git add .
```
* Commit your work **without** the `-m` flag.
* Your configured text editor (VS Code or Vim) will automatically pop up displaying the template:
```bash
git commit
```
* You only need to edit the message in that **template message**, then save and exit.
* ➡️ [How to write a good commit message.](./docs/git_convention.md)
* How to edit in Vim (in case you skip optional config in **step 2**):
  - If you are in **normal mode** (the cursor will be **block**), press `i` to enter **insert mode**.
  - Edit your message, e.g: `docs: add README.md`.
  - Then, press `Esc` to be back in **normal mode** and type `:wq` and press `Enter` to save your commit.
* Check your commit message:
``` bash
git log
```
**Note:** If after you commit your work and want to change the message (only use just after your last commit):
```bash
git commit --amend
```

#### 5. Push your work
* Push your local branch to your personal forked repository (`origin`) for the first time:
```bash
git push -u origin <your_own_branch>
```

#### 6. Create Pull Request (PR)
* Go to your forked repository on GitHub website.
* You will see a yellow banner with a button: **Compare & pull request**.
* Click it, write a clear description of your changes, and submit the PR to the original group repo (`upstream/main`).

#### 7. Pull & Update locally:
* To keep your local machine up-to-date with new changes merged by other team members into the group repo, run these commands:
```bash
# Switch back to your local main branch
git switch main

# Fetch and merge changes from the group upstream
git pull upstream main

# Push the updated main to your personal GitHub fork
git push origin main
```