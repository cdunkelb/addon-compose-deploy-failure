docker run --rm -it   -v /var/run/docker.sock:/var/run/docker.sock   --name ucp   docker/ucp:3.1.1 uninstall-ucp --interactive --purge-config
