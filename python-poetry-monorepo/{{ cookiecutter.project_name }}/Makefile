SHELL := /bin/bash -e -o pipefail
export PATH := $(HOME)/.local/bin:$(PATH)
PROJECT ?= {{cookiecutter.project_name}}
BRANCH_NAME ?= $(shell git rev-parse --abbrev-ref HEAD | tr '/' '-')
BUILD_NUMBER ?= 0
IMAGE ?= ${PROJECT}:${BRANCH_NAME}-${BUILD_NUMBER}
POETRY ?= "poetry"

SRC_DIR := src
PACKAGES := $(shell ls $(SRC_DIR))

# Package filter: "make lint-local my-package" selects one package
PKG_FILTER := $(filter $(PACKAGES),$(MAKECMDGOALS))
SELECTED_PKGS := $(or $(PKG_FILTER),$(PACKAGES))

# Wire package goal into PROJECT for docker targets
ifeq ($(PROJECT),{{cookiecutter.project_name}})
ifneq ($(PKG_FILTER),)
override PROJECT := $(firstword $(PKG_FILTER))
endif
endif

pkg_to_import = $(subst -,_,$(1))

# Source dirs for selected packages
SRC_DIRS := $(foreach pkg,$(SELECTED_PKGS),$(SRC_DIR)/$(pkg)/$(call pkg_to_import,$(pkg)))

COV_ARGS := $(foreach pkg,$(SELECTED_PKGS),--cov=$(call pkg_to_import,$(pkg)))

# Allow package names as make goals (no-op targets)
ifneq ($(PKG_FILTER),)
$(PKG_FILTER):
	@:
endif

.DEFAULT_GOAL := help

.EXPORT_ALL_VARIABLES:

include makefiles/development.mk
include makefiles/help.mk
include makefiles/images.mk
include makefiles/lint.mk
include makefiles/local.mk
include makefiles/test.mk
