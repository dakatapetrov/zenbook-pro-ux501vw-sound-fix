# zenbook-pro-ux501vw-sound-fix

This repository contains scripts aiming to fix the white noise after suspend issue with the Asus Zenbook Pro UX501VW.

The proposed solution automates [this approach](https://askubuntu.com/q/884051).

## Instructions
Just clone the repo and run the following after each suspend:
```bash
$ ./path-to-script/fix-audio.sh
```
Where `path-to-script` is the location of the cloned repo.

**NOTE:** This will **replace** any custom `user_ping_config`!

## TODO:
* Integrate with systemd so the scripts are executed automatically after resume (not as trivial as systemd keeps user and system services separate).
