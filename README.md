# 🚀 DUMMY GAME - Web Game connecting us

## 🎯 I. Description - Product Vision

### 1. Game Approach
- The game bridges the gap between entertainment and education.
- Instead of studying dry academic concepts, students can have fun while solving famous logical puzzles—the very same puzzles they can later apply to real-world coding assignments.

### 2. Game Concept
- A multiplayer social deduction game where players collaborate to complete tasks while identifying and eliminating an impostor, inspired by titles like Among Us and Goose Goose Duck.
- Genres: Strategy, Puzzle, Social Deduction, Sci-Fi.
- Platform: Web-based Game
- Target Audience: Players aged 14+ who want to enjoy casual gaming sessions with friends while learning practical logic puzzles.

### 3. Strategic "Why" (Project Motivation)
- We chose this project to gain hands-on experience navigating real-world software development scenarios and collaborating effectively within an engineering team.
- Building a multiplayer game allows us to explore diverse aspects of product development—such as real-time networking, state synchronization, and interactive UI design—which will keep the team highly motivated and engaged throughout the course life cycle.

## 👥 II. Members

- Huỳnh Đắc Uy
- Phạm Nguyễn Minh Quân
- Lê Đức Nhân
- Nguyễn Sỹ Nguyên
- Lê Trương Nguyên
- Lê Trần Gia Bảo

## 🛠️ III. Tech Stack

- Frontend: [...]
- Backend: [...]
- Database: [...]
- [...]

## 🔗 IV. Project Links

- 📋 [Trello - Task Management](https://trello.com/b/wHDXNywp/dummy-game)
- 📄 [Workspace Google Drive](https://drive.google.com/drive/folders/1h1P41XgIxmWGoj_YTWr0CQ9Qd5MxfALe?usp=sharing)

## 💻 V. Getting Started - How to set up

### For standard uses

[...]

### For contributors

#### 1. Clone the repo to your PC
- Note: We should not clone directly from upstream.
- First, **create a new fork** of this repo [Dummy-Game]("https://github.com/phamnguyenminhquan/Dummy-Game.git").
- Then, clone the repo which you have forked:
```bash
git clone <your-forked-repo-link>
```
- Move into the project directory and link your local repo back to the original group repo (upstream):
```bash
cd <project-directory>
git remote add upstream https://github.com/phamnguyenminhquan/Dummy-Game.git
```
- Verify your remotes (you should see both `origin` pointing to your fork, and `upstream` pointing to the group repo):
    ```bash
    git remote -v
    ```

#### 2. Config Repo locally
- Set up the mandatory commit template for this repository:
```bash
git config --local commit.template .gitmessage
```
- **Note:** This only affect this **current** repo, other projects in your PC stay unchanged.

#### 3. Create your own branch
- When working, we don't make change directly on the branch **main**.
- Branch **main** will be the **product stable state**.
- Instead, we create **our own branch** and work on that branch.
```bash
git switch -c "<your_displayname>/<your_working_feature>"
```
- After verifying, your branch will be merged into main through **Pull Request (PR)**.

#### 4. Commit your work
- Stage your change:
```bash
git add .
```
- A template commit message has been set up, so you won't use `git commit -m`.
- Instead, use `git commit` without flag `-m`, then a **text editor** (vim/nvim/nano/vscode) will open a **template message**.
- You only need to edit the message in that **template message**, then save and exit.
- **Note:** Based on your OS and when you downloaded git, if you didn't change the default config, the text editor could
mostly be **vim**.
- Here is how to edit:
  - If you are in **normal mode** (the cursor will be **block**), press `i` to enter **insert mode**.
  - Edit your message, e.g: `docs: add README.md`.
  - Then, press `Esc` to be back in **normal mode** and type `:wq` and press `Enter` to save your commit.
- Or if you don't get used to with that, try config to change text editor to vscode:
```bash
git config --local core.editor "code --wait"
```
- Check your commit message:
``` bash
git log
```
- **Note:** If after you commit your work and want to change the message (only use just after your last commit):
```bash
git commit --amend
```

#### 5. Push your work
- Push your local branch to your personal forked repository (`origin`) for the first time:
```bash
git push -u origin <your_own_branch>
```

#### 6. Create Pull Request (PR)
- Go to your forked repository on GitHub website.
- You will see a yellow banner with a button: **Compare & pull request**.
- Click it, write a clear description of your changes, and submit the PR to the original group repo (`upstream/main`).

#### 7. Pull & Update locally:
- To keep your local machine up-to-date with new changes merged by other team members into the group repo, run these commands:
```bash
# Switch back to your local main branch
git switch main

# Fetch and merge changes from the group upstream
git pull upstream main

# Push the updated main to your personal GitHub fork
git push origin main
```