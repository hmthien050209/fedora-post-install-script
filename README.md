# fedora-post-install-script

## How to run?

1. Make sure `git`, `dnf` and `python3` are usable
2. Open Terminal, type: 
```sh
git clone https://github.com/davidhoang05022009/fedora-post-install-script
cd ./fedora-post-install-script
``` 
3. Run it: 
```sh 
sudo python3 ./post-install.py
```

## What does this script do?
1. Speed-up and optimize `dnf`
2. Check update for your system
3. Install some CLI tools
4. Enable RPMFusion, Flathub
5. Install media codecs
6. Uninstall Plymouth and enable verbose boot mode(make your boot screen look like hacker's screen XD)
7. Install Google's fonts, Cascadia Code fonts, Powerline and Dracula theme
8. Install ibus-bamboo for Vietnamese user(available when choosing Vietnamese)

### Special thanks to:
1. Google for the fonts(with OFL License)
2. Microsoft for the [Cascadia Code fonts](https://github.com/microsoft/cascadia-code)(with OFL-1.1 License)
3. The Dracula team and their contributors for the [Dracula Theme for GTK](https://github.com/dracula/gtk)(with GPL-3.0 License)
4. The [TechHut YouTube channel](https://www.youtube.com/c/TechHutHD) for the video ['5 Things You MUST DO After Installing Fedora 35'](https://www.youtube.com/watch?v=-NwWE9YFFIg)
5. The official Fedora Magazine for the guide [how to install Powerline](https://fedoramagazine.org/add-power-terminal-powerline/)
6. The [StackOverflow](https://stackoverflow.com), [AskUbuntu](https://askubuntu.com) community for helping me writing themes, fonts install script
7. [ibus-bamboo](https://github.com/BambooEngine/ibus-bamboo) and [OpenBuildService](https://software.opensuse.org//download.html?project=home%3Alamlng&package=ibus-bamboo) for the Vietnamese input service on Linux(thanks to OpenBuildService for the Fedora ibus-bamboo build)