#! /bin/bash

# uninstall oh-my-posh
sudo rm /usr/local/bin/oh-my-posh

# clear fonts
echo -n "Do you want to remove all fonts installed by setup script? (y/N): "
read option
option=$(echo -n $option | sed -e 's/\(.*\)/\L\1/' | sed -e 's/ *$//g')
if [[ "$option" == "y" ]]
then
    rm -rf ~/.fonts/CascadiaCode
    fc-cache -fv
fi

# clear posh-git
sudo rm /usr/local/bin/git-prompt.sh

# ask to update bashrc
echo -n "Do you want to automatically remove oh-my-posh from your bashrc? (y/N): "
read option
option=$(echo -n $option | sed -e 's/\(.*\)/\L\1/' | sed -e 's/ *$//g')
if [[ "$option" == "y" ]]
then
    TMP_PATH=./tmpfile
    BASHRC_PATH=~/.bashrc
    
    echo -e "We will remove following text block from this file:\n$BASHRC_PATH"
    sed -n '/# ============================================ oh-my-posh ============================================ #/,/# ============================================ oh-my-posh ============================================ #/p' "$BASHRC_PATH"
    echo -ne "\n\nAre you sure? (y/N): "
    read sure
    sure=$(echo -n $sure | sed -e 's/\(.*\)/\L\1/' | sed -e 's/ *$//g')
    if [[ "$option" == "y" ]]
    then
        sed '/# ============================================ oh-my-posh ============================================ #/,/# ============================================ oh-my-posh ============================================ #/d' $BASHRC_PATH > $TMP_PATH
        mv $TMP_PATH $BASHRC_PATH
        source $BASHRC_PATH
    fi
fi

echo "Successfully uninstall oh-my-posh, please restart your shell."

