# A TF2 Server with Linux Game Server Manager (lgsm)

This repository contains the Dockerfile for `jacobtruman/tf2server`, a Docker image containing a dedicated Team Fortress 2 server built with the Linux Game Server Manager, found [here](https://gameservermanagers.com/lgsm/tf2server/)

This image is built with the autoupdate flag (-autoupdate) enabled, which means the server attempts to auto-update itself when an update comes out.

## How to run

You can simply run the image with the default settings:

```
docker run --name=tf2server -it -d --network=host jacobtruman/tf2server
```

You can also specify the server settings explicitly:

```
docker run --name=tf2server -it -d --network=host -e TF2_DEFAULT_MAP=plr_hightower -e TF2_SERVER_IP=172.10.0.1 -v /local/path/to/config:/tf2server/serverfiles/tf/cfg/tf2-server.cfg:rw -v /local/path/to/maps:/tf2server/serverfiles/tf/maps:rw jacobtruman/tf2server
```

## Ports

* **27015/udp** - The main connection port, allowing clients to connect
* **27015/tcp** - RCON port to manage server using admin tools
* **27020/udp** - Source TV port
* **27005/udp** - This is an outgoing connection used by clients
