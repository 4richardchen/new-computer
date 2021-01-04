#!/bin/sh

# Colorize

# Set the colours you can use
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)

# Resets the style
reset=`tput sgr0`

# Color-echo. Improved. [Thanks @joaocunha]
# arg $1 = message
# arg $2 = Color
cecho() {
  echo "${2}${1}${reset}"
  return
}

# Set continue to false by default.
CONTINUE=false

echo ""
cecho "Wipe your computer? (y/n)" $green
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  CONTINUE=true
fi

if ! $CONTINUE; then
  # Check if we're continuing and output a message if not
  cecho "Read the script, it only takes a few minutes" $red
  exit
else
  echo "Cancelled."
fi

# Here we go ...

#uninstall homebrew packages 
#https://darryldias.me/2016/remove-all-installed-homebrew-packages/
brew list -1 | xargs brew rm

#uninstall homebrew
#https://github.com/Homebrew/install
echo "y" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)"

#purge Chrome logins
#https://crunchify.com/how-to-purge-all-your-google-chrome-user-data-on-mac-os-x/
rm -rf ~/Library/Application\ Support/Chrome
rm -rf ~/Library/Caches/com.google.*
rm -rf ~/Library/Google

#erase others' identities before taking
git filter-branch -f --env-filter "GIT_AUTHOR_NAME='Richard Chen'; GIT_AUTHOR_EMAIL='email'; GIT_COMMITTER_NAME='Richard Chen'; GIT_COMMITTER_EMAIL='email';FILTER_BRANCH_SQUELCH_WARNING=1;" HEAD;

#take your files with you
#if iCloud installed
if ! ls -1 ~/Library/*/ | grep Mobile | wc -l &> 0
then
    mv -rf ~/.ssh ~/Library/Mobile\ Documents/com~apple~CloudDocs/
    mv -rf ~/.gnupg ~/Library/Mobile\ Documents/com~apple~CloudDocs/
    mv -r ~/Documents ~/Library/Mobile\ Documents/com~apple~CloudDocs/Documents
else
    echo "No iCloud Drive."
fi

#https://apple.stackexchange.com/questions/60231/using-terminal-how-can-i-find-which-directory-is-my-usb-drive-mounted-in
if ! ls -1 /Volumes/*/ | grep USB\ DISK | wc -l &> 2
then
    #todo: if drive capacity enough
    mv -rf ~/.ssh /Volumes/USB\ DISK
    mv -rf ~/.gnupg /Volumes/USB\ DISK
    mv -r ~/Documents /Volumes/USB\ DISK
    mv -r ~/Dropbox /Volumes/USB\ DISK
else
    echo "No USB Drive."
fi

#take it all out
rm -rf ~/Documents
rm -rf ~/Pictures
rm -rf ~/Downloads
rm -rf ~/Public

#end dropbox
#https://askubuntu.com/questions/996301/unlink-dropbox-account-from-command-line
if ! dropbox -v COMMAND &> /dev/null
then
    dropbox stop
    rm -rf ~/.dropbox
    exit
else
    echo "No dropbox."
fi

#prank git but don't uninstall git as already deleted keys
if ! git -v &> /dev/null
then
    git config --global user.email "abuse@comcast.net"
    git config --global user.name ""
fi

#reset Safari
#https://apple.stackexchange.com/questions/144311/reset-safari-from-command-line
#https://pcmac.biz/reset-safari-without-opening/
mv ~/Library/Safari ~/Desktop/Safari-`date +%Y%m%d%H%M%S`
rm -Rf ~/Library/Caches/Apple\ -\ Safari\ -\ Safari\ Extensions\ Gallery
rm -Rf ~/Library/Caches/Metadata/Safari
rm -Rf ~/Library/Caches/com.apple.Safari
rm -Rf ~/Library/Caches/com.apple.WebKit.PluginProcess
rm -Rf ~/Library/Cookies/Cookies.binarycookies
rm -Rf ~/Library/Preferences/Apple\ -\ Safari\ -\ Safari\ Extensions\ Gallery
rm -Rf ~/Library/Preferences/com.apple.Safari.LSSharedFileList.plist
rm -Rf ~/Library/Preferences/com.apple.Safari.RSS.plist
rm -Rf ~/Library/Preferences/com.apple.Safari.plist
rm -Rf ~/Library/Preferences/com.apple.WebFoundation.plist
rm -Rf ~/Library/Preferences/com.apple.WebKit.PluginHost.plist
rm -Rf ~/Library/Preferences/com.apple.WebKit.PluginProcess.plist
rm -Rf ~/Library/PubSub/Database
rm -Rf ~/Library/Saved\ Application\ State/com.apple.Safari.savedState

#reset iCloud
#https://bencoding.com/2017/02/12/forcing-icloud-logout-on-your-mac/
defaults delete MobileMeAccounts

#cleanup SublimeText unsaved text
FILE=/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl
if test -f "$FILE"; then
    rm -rf ~/Library/Application\ Support/Sublime\ Text\ 3/Local/Session.sublime_session
fi

#change password
passwd

#delete command history
rm ~/.*h_history

#shut down, pack up
#https://osxdaily.com/2017/08/13/shutdown-mac-command-line/
sudo shutdown -h now
