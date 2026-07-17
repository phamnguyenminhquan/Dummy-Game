# 🤯 Git Convention

## 🛠️ Structure of a commit message

```text
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

## 📝 Common Types

* `feat` (Feature): add a new feature.
* `fix` (Bug fix): fix some bugs.
* `docs` (Documentation): modify docs, comment, README.md, etc.
* `style` (Formatting): changes related to appearance, code format (space, semicolon, etc.) without changing the logic.
* `refactor` (Code refactoring): modify code without new features or bug fixed (optimizing, splitting modules, etc.)
* `perf` (Performance): enhance the performance, help the system run more smoothly.
* `chore` (Maintenance): changes related to building proccess or adding new libraries (update .gitignore, config webpack, npm install, etc.)

### 🖇️ Example

* New Feature: `feat(auth): add google oauth2 login`
* Bug fix: `fix(cart): resolve total price calculation bug`
* Writing docs: `docs(readme): update installation steps`
* Refactor code: `refactor(user-service): split monolithic functions into utils`

### 🎯 Best practices

- Use **imperative mood** (thể mệnh lệnh) - use `fix` instead of `fixed`, or `add` instead of `added`.
- **Description** should be short but well-informed.
- No **capitalize** first letter of **description** and no **point** at the end of the line.
- e.g:
  - ✅ `feat: add payment gateway`
  - ❌ `Feat: Add payment gateway.`
