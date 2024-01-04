.PHONY: all install clone copy patch build clean
all: build

## Install llama-cpp-python
install:
	pip install llama-cpp-python[server]==0.2.26

## Clone llama-cpp-python
clone: install
	git clone -n https://github.com/abetlen/llama-cpp-python.git
	cd llama-cpp-python && git checkout tags/v0.2.26

## Copy .so binaries from install to cloned repository
copy: clone
	$(eval LLAMA_CPP_DIR=$(shell python -c "import llama_cpp, pathlib; print(pathlib.Path(llama_cpp.__file__).parent)"))
	cp $(LLAMA_CPP_DIR)/libllama.so llama-cpp-python/llama_cpp/
	cp $(LLAMA_CPP_DIR)/libllava.so llama-cpp-python/llama_cpp/

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