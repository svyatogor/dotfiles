profiles = ENV.fetch("HOMEBREW_DOTFILES_PROFILE", "").split(",")
raise "Set HOMEBREW_DOTFILES_PROFILE to exactly one of: home, work" unless (profiles & %w[ home work ]).one?

tap "agavra/tap", trusted: { formula: "tuicr" }
tap "asmvik/formulae", trusted: { formula: "skhd" }
tap "nikitabobko/tap", trusted: { cask: "aerospace" }
tap "xykong/tap", trusted: { cask: "flux-markdown" }

brew "bash"
brew "btop"
brew "cocoapods"
brew "coreutils"
brew "git"
brew "git-crypt"
brew "gmp"
brew "gnupg"
brew "libpq"
brew "libyaml"
brew "telnet"
brew "tree-sitter-cli"
brew "wget"
brew "tuicr"

cask "1password"
cask "1password-cli"
cask "codex"
cask "daisydisk"
cask "font-fira-code-nerd-font"
# cask "font-ioskeley-mono"
cask "font-jetbrains-mono"
cask "font-jetbrains-mono-nerd-font"
cask "font-lilex"
cask "font-maple-mono-nf"
cask "font-symbols-only-nerd-font"
cask "font-ubuntu-mono"
cask "forklift"
cask "ghostty"
cask "google-chrome"
cask "macwhisper"
cask "medis"
cask "openin"
cask "orbstack"
cask "postman"
cask "raycast"
cask "slack"
cask "tableplus"
cask "telegram"
cask "the-unarchiver"
cask "visual-studio-code"
cask "yandex-music"
cask "nikitabobko/tap/aerospace"
cask "xykong/tap/flux-markdown"

if profiles.include?("home")
  brew "mole"

  cask "affinity"
  cask "chatgpt"
  cask "codex-app"
  cask "discord"
  cask "iina"
  cask "istat-menus"
  cask "ledger-wallet"
  cask "microsoft-excel"
  cask "microsoft-word"
  cask "sparrow"
  cask "tailscale-app"
  cask "transmission"
  cask "whatsapp"
end

if profiles.include?("work")
  cask "session-manager-plugin"
  cask "unifi-identity-enterprise"
end
