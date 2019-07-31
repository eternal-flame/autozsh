# Install zsh
sudo apt install -y zsh
sudo apt install -y powerline fonts-powerline

# Install oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp .zshrc $HOME/

# Install plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Change default shell
chsh -s /usr/bin/zsh

# Copy tmux config
cp .tmux.conf $HOME/

# Relogin to take effect
su - ${USER}
