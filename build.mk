all: source build stage control package

fastddsgen = /opt/fastdds/bin/fastddsgen

source:
	mkdir -p source
	cd idl; $(fastddsgen) -replace -python -d ../source common.idl ohlcv.idl

build:
	mkdir -p ./build
	cd build; \
	cmake -DCMAKE_MODULE_PATH=$(PWD)/cmake -DCMAKE_INSTALL_PREFIX=/opt/inclination ../source; \
	cmake --build .

PROJECT_PACKAGE_NAME = inclination-idl-fastdds
GITHUB_RUN_NUMBER ?= 0
fastddsgen_FULL_VERSION = 0.1.0-$(GITHUB_RUN_NUMBER)
ARCH = $(shell dpkg --print-architecture)
STAGE_DIR = $(PROJECT_PACKAGE_NAME)_$(fastddsgen_FULL_VERSION)_$(ARCH)
debian_dir = $(PWD)/$(STAGE_DIR)/DEBIAN
control_file = $(debian_dir)/control
PROJECT_MAINTAINER = you@example.com
PROJECT_DESCRIPTION = You @ example.com
fastddsgen_STAGE_DIR = .
fastddsgen_BINARY_PACKAGE_NAME = $(STAGE_DIR)

stage:
	cd build; DESTDIR=$(PWD)/$(STAGE_DIR) cmake --install .

control:
	@mkdir -p $(debian_dir)
	@echo "Package: $(PROJECT_PACKAGE_NAME)"     > $(control_file)
	@echo "Version: $(fastddsgen_FULL_VERSION)" >> $(control_file)
	@echo "Section: devel"                      >> $(control_file)
	@echo "Priority: optional"                  >> $(control_file)
	@echo "Architecture: $(ARCH)"               >> $(control_file)
	@echo "Depends: openjdk-17-jre"             >> $(control_file)
	@echo "Maintainer: $(PROJECT_MAINTAINER)"   >> $(control_file)
	@echo "Description: $(PROJECT_DESCRIPTION)" >> $(control_file)
	@cat $(control_file)

package:
	chmod -R 0755 $(debian_dir)
	cd $(fastddsgen_STAGE_DIR); \
	dpkg-deb --build $(fastddsgen_BINARY_PACKAGE_NAME)


.PHONY: source build stage control package

