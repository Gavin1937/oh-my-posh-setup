#! /bin/bash

# Auto install & setup oh-my-posh, and posh-git
# for Debian/Ubuntu with my custom theme
# This script will use wget, unzip, and fontconfig
# to download & install required programs


# install oh-my-posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# set permission for themes
chmod u+rw ./custom_themes/*json

# install posh-git
sudo wget https://raw.githubusercontent.com/lyze/posh-git-sh/master/git-prompt.sh -O /usr/local/bin/git-prompt.sh
sudo chmod +x /usr/local/bin/git-prompt.sh
sudo source /usr/local/bin/git-prompt.sh

# ask to install fonts
echo -n "Do you want to install all fonts automatically? (y/N): "
read option
option=$(echo -n $option | sed -e 's/\(.*\)/\L\1/' | sed -e 's/ *$//g')
if [[ "$option" == "y" ]]
then
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/CascadiaCode.zip -O ./font/CascadiaCode_v2.2.2.zip
    mkdir ~/.fonts
    unzip ./font/CascadiaCode_v2.2.2.zip -d ~/.fonts/CascadiaCode
    fc-cache -fv
    rm -rf ./font
    echo -e "Remember to change your terminal font to \"CaskaydiaCove NF Mono\"."
fi

# ask to update bashrc profile with template profile
echo -n "Do you want to automatically update your bashrc? (y/N): "
read option
option=$(echo -n $option | sed -e 's/\(.*\)/\L\1/' | sed -e 's/ *$//g')
if [[ "$option" == "y" ]]
then
    BASHRC_PATH=~/.bashrc
    MYPATH=$(pwd)
    TEMP_SRC=$(cat profile_templates/debian_ubuntu.bashrc.template)
    TEMP_SRC=${TEMP_SRC/_REPO_PATH_/"$MYPATH"}
    
    echo -e "We will append following text block to this file:\n$BASHRC_PATH"
    echo "$TEMP_SRC"
    echo -ne "\n\nAre you sure? (y/N): "
    read sure
    sure=$(echo -n $sure | sed -e 's/\(.*\)/\L\1/' | sed -e 's/ *$//g')
    if [[ "$sure" == "y" ]]
    then
        echo "$TEMP_SRC" >> ~/.bashrc
        source ~/.bashrc
    fi
fi


# prompt
echo "Successfully setup oh-my-posh, please restart your shell."

