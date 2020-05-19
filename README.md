# docker-bsp

Embedded BSP Development Docker Environment for U-Boot / Kernel / Yocto / MCU Dev

## What's in

- Minimal Usage
    - Python3
    - nano / wget / curl
    - sudo
    - locales
- Basic development tools
    - libraries: zlib / libssl / libncurses5
    - build-essential
    - git / repo
    - cmake
- Advanced development tools
    - ccls / Bear
- Personal
    + proxychains


## How-to

```bash
$ cd /path/to/docker-bsp
# build image
$ docker build -t ahnniu/bsp .
# Run a new container
$ docker run -p 2222:22 -it --name bsp ahnniu/bsp bash
# Then you can run a new process like this:
$ docker exec -it bsp bash
# You can also manage this container to start / stop / restart
$ docker start bsp
```
