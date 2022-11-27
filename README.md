# (home|cloud|VPS) lab

This repo holds the configuration for a hybrid style home/cloud lab. Infrastructure is provisioned through terraform and ansible, and kubernetes ([k3s](https://k3s.io)) is used to host services.

## Architecture

The current architecture consists of one kubernetes master node running on a VPS provider like racknerd, vultr, digitalocean, as well as any number of worker nodes leveraging cloud free tiers like Oracle's offering. This allows ephemeral compute/storage that is resistant to free tier shenanigans.
