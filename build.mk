all: build stage control package

CMAKE_MODULE_PATH=/opt/fastcdr

build:
	mkdir -p ./build
	cd build && cmake -DCMAKE_MODULE_PATH="$(CMAKE_MODULE_PATH)" -DCMAKE_INSTALL_PREFIX=/opt/inclination ../src
	cd build && cmake --build .

package = inclination-idl-fastdds
GITHUB_RUN_NUMBER ?= 0
full_version = 0.1.0-$(GITHUB_RUN_NUMBER)
architecture = $(shell dpkg --print-architecture)
STAGE_DIR = $(package)_$(full_version)_$(architecture)
debian_dir = $(PWD)/$(STAGE_DIR)/DEBIAN
control_file = $(debian_dir)/control
maintainer = you@example.com
description = You @ example.com
fastddsgen_STAGE_DIR = .
fastddsgen_BINARY_PACKAGE_NAME = $(STAGE_DIR)

stage:
	cd build && DESTDIR=$(PWD)/$(STAGE_DIR) cmake --install .

control:
	@mkdir -p $(debian_dir)
	@echo "Package: $(package)"                  > $(control_file)
	@echo "Version: $(full_version)"            >> $(control_file)
	@echo "Section: devel"                      >> $(control_file)
	@echo "Priority: optional"                  >> $(control_file)
	@echo "Architecture: $(architecture)"       >> $(control_file)
	@echo "Depends: openjdk-17-jre"             >> $(control_file)
	@echo "Maintainer: $(maintainer)"           >> $(control_file)
	@echo "Description: $(description)"         >> $(control_file)
	@cat $(control_file)

package:
	chmod -R 0755 $(debian_dir)
	cd $(fastddsgen_STAGE_DIR); \
	dpkg-deb --build $(fastddsgen_BINARY_PACKAGE_NAME)


.PHONY: build stage control package

