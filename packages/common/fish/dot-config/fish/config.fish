set -g fish_greeting

# --- Environment bootstrap ---------------------------------------------------

if test -d /opt/homebrew
    /opt/homebrew/bin/brew shellenv | source
    set -gx HOMEBREW_NO_ENV_HINTS 1
end

if command -q mise
    set -gx MISE_LOG_LEVEL error
    mise activate fish | source
end

# --- Prompt (pure-fish/pure) -------------------------------------------------

set --universal fish_transient_prompt 1
set -g pure_enable_single_line_prompt true
set -g pure_enable_aws_profile true
set -g pure_show_numbered_git_indicator true
set -g pure_symbol_git_dirty ""
set -g pure_symbol_git_stash "󰏗 "
set -g pure_symbol_git_unpulled_commits "󰶹"
set -g pure_symbol_git_unpushed_commits "󰶼"
set -g pure_symbol_ssh_prefix " "
set -g pure_begin_prompt_with_current_directory false
set -g pure_truncate_prompt_current_directory_keeps 3

# Override pure user@host to show only hostname
function _pure_user_at_host
    set --local hostname_color (_pure_set_color $pure_color_hostname)
    echo "$hostname_color$hostname"
end

# Override pure git branch to show nerd font icon
function _pure_prompt_git_branch
    set --local git_branch (_pure_parse_git_branch)
    set --local git_branch_color (_pure_set_color $pure_color_git_branch)
    echo "$git_branch_color $git_branch"
end

# fzf integration handled by PatrickF1/fzf.fish plugin
set -gx FZF_CTRL_R_OPTS "--tmux center,80%,80% --reverse --preview 'echo {}' --preview-window down:3:wrap --bind '?:toggle-preview'"

# z (directory jumping) handled by jethrokuan/z plugin

# --- PATH --------------------------------------------------------------------

fish_add_path ~/.local/bin /opt/homebrew/opt/libpq/bin

# --- Environment variables ---------------------------------------------------

set -gx EDITOR nvim
set -gx GIT_EDITOR nvim
set -gx LANG C.UTF-8
set -gx LC_ALL C.UTF-8
set -gx LG_CONFIG_FILE "$HOME/.config/lazygit/config.yml,$HOME/.local/share/theme/lazygit.yml"
set -gx EZA_CONFIG_DIR "$HOME/.local/share/theme/eza"
set -gx SSH_ASKPASS_REQUIRE never

# --- Abbreviations (fish-idiomatic aliases) ----------------------------------

abbr -a cat bat
abbr -a less bat
abbr -a yy yazi
abbr -a g lazygit
abbr -a gp 'git push'
abbr -a gss 'git status -s'
abbr -a n nvim
abbr -a vim nvim

# --- Keybindings -------------------------------------------------------------

bind \cp history-search-backward
bind \cn history-search-forward
# Cmd+K clear screen + scrollback (ghostty sends \e[76;6u via CSI u, tmux forwards via extended-keys)
bind \e\[76\;6u 'printf "\033[2J\033[3J\033[H"; commandline -f repaint'

bind \cl 'printf "\033[2J\033[3J\033[H"; commandline -f repaint'

# --- Secrets (add secrets.fish if needed) ------------------------------------
# test -f ~/.local/share/secrets.fish; and source ~/.local/share/secrets.fish
