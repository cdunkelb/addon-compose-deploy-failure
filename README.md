# addon-compose-deploy-failure

Steps to recreate

1. Used docker image `support/train` to deploy standalone RHEL 7.5 instance
2. Used `rhel-1809.sh` to install EE 18.09
3. Used `install.sh` to install UCP 3.1.1
4. Initial install finishes without error, and able to login to the UCP admin UI
5. Uninstall UCP using `uninstall.sh`
6. reboot the host using `sudo shutdown -r now`
7. Run `install.sh` to reproduce the issue.
