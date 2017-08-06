# zenbook-pro-ux501vw-sound-fix

This repository contains scripts aiming to fix the white noise after suspend issue with the Asus Zenbook Pro UX501VW.

The proposed solution automates [this approach](https://askubuntu.com/q/884051).

## Instructions
**NOTE:** This will **replace** any custom `user_ping_config`! If you want to use custom `user_pin_configs` replace the one in the repo.

### Systemd Service
The best solution is to install a systemd service that is triggered automatically after sleep (suspend).

Just run the install script:
```bash
$ ./path-to-repo/install.sh
```
Where `path-to-repo` is the location of the cloned repo.

**Restart** for best results.

### Manual Use
If you don't want to install any systemd services or you don't use systemd you can use the standalone script.

Run the following after each suspend:
```bash
$ ./path-to-repo/fix-audio.sh
```
Where `path-to-repo` is the location of the cloned repo.
