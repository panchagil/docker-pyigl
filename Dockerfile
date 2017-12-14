FROM gilureta/opengl:ubuntu16.04

WORKDIR /setup
ADD . /setup

RUN apt-get update && apt-get install -y \
    x-window-system \
    build-essential \
    cmake \
    wget \
    g++-4.8 \
    freeglut3-dev \
    libblas-dev \
    liblapack-dev \
    libglu1-mesa-dev \
    xorg-dev \
    python3.5 \
    python3-pip
    
# make python3 the default
RUN cd /usr/local/bin \
    && ln -s `which pydoc3` pydoc \
    && ln -s `which python3` python \
    && ln -s `which python3-config` python-config \
    && ln -fs `which pip3` pip \
    && pip install --upgrade pip

# Install libigl
RUN git clone --recursive https://github.com/libigl/libigl.git
RUN cd libigl \
    && mkdir external/nanogui/ext/glfw/include/GL \
    && wget --no-check-certificate -P external/nanogui/ext/glfw/include/GL http://www.opengl.org/registry/api/GL/glcorearb.h \
    && cd python \
    && mkdir build \
    && cd build \
    && cmake -DLIBIGL_WITH_NANOGUI=ON -DLIBIGL_USE_STATIC_LIBRARY=ON  -DCMAKE_CXX_COMPILER=g++-4.8 -DCMAKE_C_COMPILER=gcc-4.8 -DLIBIGL_WITH_EMBREE=OFF .. \
    && make -j 2 \
    && cd .. && mv nanogui nanogui.so

# wrapping up libigl core and helper in single module
RUN cp libigl/python/*.so pyigl/ \
    && cp libigl/python/iglhelpers.py pyigl/

# pyigl to global python
RUN ln -s $PWD/pyigl /usr/local/lib/python3.5/dist-packages/pyigl