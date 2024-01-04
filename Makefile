.PHONY: all install clone copy patch build clean
all: install clone copy patch build

## Install llama-cpp-python
install:
    pip install llama-cpp-python[server]==0.2.26

## Clone llama-cpp-python
clone:
    git clone -n git@github.com:abetlen/llama-cpp-python.git
    cd /workspaces/llama-cpp-python-binary/llama-cpp-python && git checkout tags/v0.2.26

## Copy .so binaries from install to cloned repository
copy:
    cp /usr/local/python/3.10.13/lib/python3.10/site-packages/llama_cpp/libllama.so /workspaces/llama-cpp-python-binary/llama-cpp-python/llama_cpp/
    cp /usr/local/python/3.10.13/lib/python3.10/site-packages/llama_cpp/libllava.so /workspaces/llama-cpp-python-binary/llama-cpp-python/llama_cpp/

## Patch llama-cpp-python
patch:
    cp patches/pyproject.toml llama-cpp-python/pyproject.toml

## Build sdist
build:
    pip install build
    cd llama-cpp-python && python -m build

## Clean the workspace
clean:
    git clean -fdX
