# ⚒️ REPOSITORY SETUP ⚙️

## 1. Fork & Clone
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

## 2. Configure Repository locally
* Set up the **mandatory commit template** for this repository:
```bash
git config --local commit.template .gitmessage
```
* (Optional) Configure VSCode as your default commit text editor to avoid Vim:
```bash
git config --local core.editor "code --wait"
```

## NEXT STEP:
* [YOUR WORK FLOW](./your_work_flow.md)