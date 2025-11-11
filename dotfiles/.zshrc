# -------------------------------------------------
# ⚡ Ultra-fast Zsh config with color git prompt
# -------------------------------------------------

# --- PATH ---
export PATH="$HOME/bin:/usr/local/bin:$PATH"

# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=3000
SAVEHIST=3000
setopt HIST_IGNORE_DUPS HIST_SAVE_NO_DUPS


# --- Prompt(with Git branch)  ---
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%F{green}(%b)%f'
setopt prompt_subst

#PROMPT='%F{cyan}%n%f:%F{yellow}%~%f $(git_prompt_info) %# '
PROMPT='%F{blue}❯%f %F{yellow}%~%f %F{green}${vcs_info_msg_0_}%f '

# --- Aliases ---
alias ll='ls -la'
alias ..='cd ..'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias c='clear'

# --- Colors ---
autoload -U colors && colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# --- Speed tweaks ---
setopt NO_BEEP
DISABLE_UNTRACKED_FILES_DIRTY=true  # skip untracked file checks for speed

# --- Optional quality-of-life settings ---
setopt AUTO_CD       # type folder name to cd into it
setopt CORRECT       # correct small typos in commands

# -----------------------------
# Syntax highlighting / completions (optional)
# -----------------------------
# If installed via Homebrew or manually:
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# -------------------------------------------------
# 🧩 asdf (Homebrew) setup
# -------------------------------------------------
# Lazy-load asdf
asdf_lazy_load() {
  . "$(brew --prefix asdf)/libexec/asdf.sh"
  unfunction asdf_lazy_load
  asdf "$@"
}

alias asdf=asdf_lazy_load
