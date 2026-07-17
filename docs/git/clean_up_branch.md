# 🧹 CLEAN UP 🗑️

## 1. Clean up Local/Remote Branches (MANUAL - OPTIONAL based on your case)

### Step 1: Clean the Local branches:
* **Important:** Switch back to branch **main** first.
```bash
git switch main
```
* Check all branches (including local + remote branches):
```bash
git branch -a
```
* Delete branch **SAFE** (recommended): **only allows** to delete a branch that is **fully merged** into current branch (**main** in this case).
```bash
git branch -d <branch_name>
# E.g: git branch -d feat/network
```
* Delete branch **FORCE**: use when you want to delete a branch **completely (force)** even **without being merged**.
```bash
git branch -D <branch_name>
```
### Step 2: Clean the Remote branches:
```bash
git push origin --delete <branch_name>
# E.g: you just deleted branch feat/network locally, then use:
# git push origin --delete feat/network
```

## 2. Clean up Branches (RECOMMENDED)
* Go to your GitHub Page -> Click **branch button** on the left side -> Click **Views all branches**.
* At **Your branches** tab -> Choose **delete branch** (the **trash bin** button) on branches that you want to delete.
* Then back to your local machine and run:
```bash
# Remove remote-tracking branch
git fetch --prune

# Remove local redundant branch
git branch -d <branch_name> # See 1 for more information
```