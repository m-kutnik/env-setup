# Create a new git worktree with branch
# Usage: git-worktree <branch-name> [--clean]
# Example: git-worktree feature/some-feature
# Example: git-worktree feature/some-feature --clean
# Creates: ../.git-worktrees/<repo-dir>/feature/some-feature
git-worktree() {
  if [[ $# -eq 0 || $# -gt 2 ]]; then
    echo "Usage: git-worktree <branch-name> [--clean]"
    echo "Example: git-worktree feature/some-feature"
    echo "Example: git-worktree feature/some-feature --clean"
    return 1
  fi

  local branch_name="$1"
  local clean_mode="false"
  if [[ $# -eq 2 ]]; then
    if [[ "$2" == "--clean" ]]; then
      clean_mode="true"
    else
      echo "Error: Unknown flag '$2'"
      echo "Usage: git-worktree <branch-name> [--clean]"
      return 1
    fi
  fi

  # Check if we're in a git repository
  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "Error: Not in a git repository"
    return 1
  fi

  # Get the git root directory and worktree path
  local git_root
  git_root=$(git rev-parse --show-toplevel)
  local repo_name="$(basename "$git_root")"
  local worktree_dir="../.git-worktrees/${repo_name}/${branch_name}"
  local full_path="${git_root}/${worktree_dir}"

  local current_branch
  current_branch=$(git rev-parse --abbrev-ref HEAD)

  if [[ "$clean_mode" == "true" ]]; then
    local removed_worktree="false"
    local removed_branch="false"

    if [[ "$current_branch" == "$branch_name" ]]; then
      echo "Error: Cannot clean the currently checked out branch '${branch_name}'"
      return 1
    fi

    if [[ -d "${full_path}" ]]; then
      echo "Removing worktree: ${worktree_dir}"
      git worktree remove --force "${full_path}" || {
        echo "Error: Failed to remove worktree '${worktree_dir}'"
        return 1
      }
      removed_worktree="true"
    else
      echo "Worktree directory not found: ${worktree_dir}"
    fi

    if git show-ref --quiet "refs/heads/${branch_name}" 2>/dev/null; then
      echo "Removing branch: ${branch_name}"
      git branch -D "${branch_name}" || {
        echo "Error: Failed to remove branch '${branch_name}'"
        return 1
      }
      removed_branch="true"
    else
      echo "Branch not found: ${branch_name}"
    fi

    if [[ "${removed_worktree}" == "false" && "${removed_branch}" == "false" ]]; then
      echo "Nothing to clean for '${branch_name}'"
      return 1
    fi

    echo "✓ Cleanup completed for: ${branch_name}"
    return 0
  fi

  # Check if on staging branch and offer options if not
  if [[ "$current_branch" != "staging" ]]; then
    echo "Warning: You are not on the 'staging' branch (currently on: $current_branch)"
    echo ""
    echo "Options:"
    echo "  1) Checkout to staging and pull changes (default)"
    echo "  2) Ignore and continue"
    echo ""
    echo -n "Select option [1/2] (press Enter for 1): "
    read -r choice

    case "$choice" in
    "" | "1")
      echo "Checking out staging and pulling latest changes..."
      git checkout staging || return 1
      git pull origin staging || return 1
      ;;
    "2")
      echo "Continuing with current branch: $current_branch"
      ;;
    *)
      echo "Invalid option. Aborting."
      return 1
      ;;
    esac
  fi

  # Check if staging is up to date with remote
  git fetch origin staging --quiet 2>/dev/null
  local local_commit
  local remote_commit
  local_commit=$(git rev-parse HEAD)
  remote_commit=$(git rev-parse origin/staging 2>/dev/null || echo "")

  if [[ -n "$remote_commit" && "$local_commit" != "$remote_commit" ]]; then
    echo "Warning: Your staging branch is not up to date"
    echo "Local:  ${local_commit:0:7}"
    echo "Remote: ${remote_commit:0:7}"
    echo ""
    echo "Options:"
    echo "  1) Pull latest changes (default)"
    echo "  2) Ignore and continue"
    echo ""
    echo -n "Select option [1/2] (press Enter for 1): "
    read -r choice

    case "$choice" in
    "" | "1")
      echo "Pulling latest changes..."
      git pull origin staging || return 1
      ;;
    "2")
      echo "Continuing with current commit"
      ;;
    *)
      echo "Invalid option. Aborting."
      return 1
      ;;
    esac
  fi

  # Check if worktree already exists
  if [[ -d "$full_path" ]]; then
    echo "Error: Worktree directory already exists: ${worktree_dir}"
    return 1
  fi

  # Create parent directories if they don't exist
  mkdir -p "$(dirname "$full_path")"

  # Check if branch already exists
  if git show-ref --quiet "refs/heads/${branch_name}" 2>/dev/null; then
    echo "Branch '${branch_name}' already exists, checking it out..."
    git worktree add "${full_path}" "${branch_name}"
  else
    echo "Creating new branch '${branch_name}' and worktree..."
    git worktree add -b "${branch_name}" "${full_path}"
  fi

  if [[ $? -eq 0 ]]; then
    echo "✓ Worktree created at: ${worktree_dir}"
    echo "✓ Branch: ${branch_name}"
    echo ""
    echo "To switch to it:"
    echo "  cd ${worktree_dir}"
  else
    echo "Error: Failed to create worktree"
    # Cleanup empty directory if created
    [[ -d "$full_path" ]] && rmdir -p "$(dirname "$full_path")" 2>/dev/null
    return 1
  fi
}
