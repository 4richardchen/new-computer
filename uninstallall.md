# Uninstalling an old computer

My personal script to uninstall an old computer.

It does an extremely opinionated and highly personalized uninstallation, with my preferences. Please adjust as needed!

It arose from this [original inspiration](https://github.com/18F/laptop). It could be called a wipe script or a leave work (fired, terminated, laid off, discharged, etc.) script. It should take lessons from other such scripts, though I found none. Its spirit for leaving a job should be to ensure user privacy. It may purposefully, superfluously, jealously protect privacy.

Todo list:
* make a marketing site, likely in github-pages
  * if HTTP_REFER is curl, return the script not the marketing site
* Windows version
  * in [Chocolatey](https://chocolatey.org/packages?q=scripting)
  * in [Power Shell](https://docs.microsoft.com/en-us/powershell/scripting/learn/remoting/running-remote-commands?view=powershell-7)

## Install from script:
```sh
#from https://techpulsetoday.com/how-to-execute-a-bash-script-from-github-gist/
sudo bash <(curl -s https://raw.githubusercontent.com/4richardchen/new-computer/master/uninstallall.sh)

#from https://rasa.com/docs/rasa-x/0.28.6/installation-and-setup/one-line-deploy-script/
curl -s https://raw.githubusercontent.com/4richardchen/new-computer/master/uninstallall.sh | sudo bash
```
