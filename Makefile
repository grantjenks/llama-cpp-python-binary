.PHONY: all install clone copy patch build clean
all: build

## Install llama-cpp-python
install:
	pip install llama-cpp-python[server]==0.2.26

## Clone llama-cpp-python
clone: install
	git clone -n https://github.com/abetlen/llama-cpp-python.git
	cd /workspaces/llama-cpp-python-binary/llama-cpp-python && git checkout tags/v0.2.26

## Copy .so binaries from install to cloned repository
copy: clone
	cp /usr/local/python/3.10.13/lib/python3.10/site-packages/llama_cpp/libllama.so /workspaces/llama-cpp-python-binary/llama-cpp-python/llama_cpp/
	cp /usr/local/python/3.10.13/lib/python3.10/site-packages/llama_cpp/libllava.so /workspaces/llama-cpp-python-binary/llama-cpp-python/llama_cpp/

## Patch llama-cpp-python
patch: copy
	cp patches/pyproject.toml llama-cpp-python/pyproject.toml
	cp patches/MANIFEST.in llama-cpp-python/MANIFEST.in

## Build sdist
build: patch
	rm -rf llama-cpp-python/docker
	rm -rf llama-cpp-python/vendor
	pip install build
	cd llama-cpp-python && python -m build --sdist
	cp -r llama-cpp-python/dist dist

## Clean the workspace
clean:
	rm -rf llama-cpp-python
	rm -rf dist
	git clean -fdX