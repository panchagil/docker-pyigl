docker-pyigl
=============
A docker image for libigl+python3 applications. 

Overview
--------
This docker image has libigl+python3 binding installed. The project libigl `https://github.com/libigl/libigl` was compiled 
using the default flags for ubuntu with nanogui.

Rendering
--------
This docker is based on `gilureta\opengl`, a fork of `https://github.com/thewtex/docker-opengl`. 
From the original repo, "The session runs Openbox as a non-root user, user that has password-less sudo privileges. 
The browser view is an HTML5 viewer that talks over websockets to a VNC Server. 
The VNC Server displays a running Xdummy session."

Quick Start
--------
Running `./run_tutorials.sh` will start the image on libigl python folder.
From there run the following to test the first tutorial (no ui)
```
PYTHONPATH=. python tutorials/001_BasicTypes.py
```
To run a tutorial with ui, run the following and open `http://localhost:6081/` on your browser
```bash
PYTHONPATH=. python tutorials/102_DrawMesh.py
```

The libigl bindings have been installed on the system python, on your scripr you only need to use
```python
import pyigl as igl
# to use the helper functions simply call
igl.p2e
```

Credits
-------

This configuration was forked from `https://github.com/thewtex/docker-opengl`.
