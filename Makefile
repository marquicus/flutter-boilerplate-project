#
##
## Vendor: Zentek ST
##
APPVERSION=6.0
APPMAIL="soporte@zentek.com.mx"
GROUPREPO=ztst
NOCLR=\x1b[0m
OKCLR=\x1b[32;01m
ERRCLR=\x1b[31;01m
WARNCLR=\x1b[33;01m
EXECUTABLES=flutter adb avdmanager emulator docker dart dartdoc python pip gitchangelog
include .env
export $(shell sed 's/=.*//' .env)

define usage =
Build and development task automation tool, v${APPVERSION}"

Usage:
  make [task]
endef

## Built in tasks ##

#: help - Show Test info
help: 
	$(info $(usage))
	@echo -e "\n  Available targets:"
	@egrep -o "^#: (.+)" [Mm]akefile  | sed 's/#: /    /'
	@echo "  Please report errors to ${APPMAIL}"

#: check - Check that system requirements are met
check:
	$(info Required programs:)
	$(foreach bin,$(EXECUTABLES),\
	    $(if $(shell command -v $(bin) 2> /dev/null),$(info Found `$(bin)`),$(error Please install `$(bin)`)))
	@flutter doctor

# clean-flutter - Remove flutter cache
clean-flutter:
	@flutter clean

# clean-emulator - Wipe emulator data
clean-emulator:
	@emulator -avd Droid -wipe-data

# clean-containers - Remove docker files
clean-containers:
	@docker system prune --volumes

#: clean - Remove build and python files
clean:
	@echo TODO

#: clean-all - Full clean
clean-all: clean-flutter clean-containers

#: test - Run test suites.
test:
	@echo TODO

#: coverage - Coverage
coverage:
	@echo TODO

#: build-docs - Build docs
build-docs:
	@dartdoc

#: dependencies - Install dependencies
dependencies: 
	@pip install -r requirements.txt
	@flutter pub get

#: fixtures - Load fixtures
fixtures: 
	@flutter packages pub run build_runner build --delete-conflicting-outputs

#: list-emulators - List the configured emulators
list-emulators:
	@avdmanager list avds | grep Name

# run-wsgi - Run development mode
run-emulator:
	@flutter emulators --launch Droid
.PHONY: run-emulator

#: run - Run
run:
	@flutter run

#: stop - Stop
stop:
	@pkill java
	@adb -s emulator-5554 emu kill

#: deploy - Deploy
deploy: run-emulator clean-flutter dependencies fixtures run

# build - Push to upload
build:
	docker login registry.gitlab.com
	docker build -t registry.gitlab.com/zentekmx/${GROUPREPO}/${PROJECT} .

# push - Push to upload
push: build
	docker push registry.gitlab.com/zentekmx/${GROUPREPO}/${PROJECT}

#: release - Build and push
release: build push

#: tag - Generate new tag with current version
tag: 
	git tag -a "v$(shell python manage.py print-version | tail -1 )"
	@gitchangelog > CHANGELOG

# compose - Run with docker compose
compose: build
	docker-compose up

.PHONY: docs clean
.DEFAULT_GOAL := check
