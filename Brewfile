profiles = ENV.fetch('HOMEBREW_DOTFILES_PROFILE', '').split(',')
raise 'Set HOMEBREW_DOTFILES_PROFILE to exactly one of: earth, mars' unless (profiles & %w[earth mars]).one?

brew 'btop'
brew 'coreutils'
brew 'git'
brew 'gmp'
brew 'gnupg'
brew 'libpq'
brew 'libyaml'
brew 'tree-sitter-cli'
brew 'wget'

cask '1password'
cask '1password-cli'
cask 'daisydisk'
cask 'google-chrome'
cask 'medis'
cask 'orbstack'
cask 'postman'
cask 'slack'
cask 'tableplus'
cask 'telegram'
cask 'the-unarchiver'
cask 'visual-studio-code'
cask 'yandex-music'
cask 'omniwm'
cask 'tinycast'
brew 'kanata'
brew 'deja'
cask 'ghostty'
cask 'claude'

cask 'font-fira-code-nerd-font'
cask 'font-ioskeley-mono'
cask 'font-jetbrains-mono'
cask 'font-jetbrains-mono-nerd-font'
cask 'font-lilex'
cask 'font-maple-mono-nf'
cask 'font-symbols-only-nerd-font'
cask 'font-ubuntu-mono'

if profiles.include?('earth')
  brew 'mole'

  cask 'istat-menus'
  cask 'affinity'
  cask 'chatgpt'
  cask 'discord'
  cask 'iina'
  cask 'ledger-wallet'
  cask 'microsoft-excel'
  cask 'microsoft-word'
  cask 'sparrow'
  cask 'tailscale-app'
  cask 'transmission'
  cask 'whatsapp'
  cask 'forklift'
  cask 'openin'
end

if profiles.include?('mars')
  cask 'unifi-identity-enterprise' 
end
