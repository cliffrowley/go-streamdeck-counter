#
# This Makefile isn't really necessary, but makes it easier for me to test.
#

PLUGIN_UUID=com.github.cliffrowley.go-streamdeck.counter
PLUGIN_DIR=$(PLUGIN_UUID).sdPlugin
DIST_DIR=dist
BINARY_NAME=counter
RELEASE_DIR=release

SD_DISTRO_TOOL=sd-distro-tool
SD_PLUGIN_DIR=$(HOME)/Library/Application Support/com.elgato.StreamDeck/Plugins

build: build-mac build-windows

build-mac:
	GOOS=darwin GOARCH=amd64 go build -o $(PLUGIN_DIR)/$(BINARY_NAME)

build-windows:
	GOOS=windows GOARCH=amd64 go build -o $(PLUGIN_DIR)/$(BINARY_NAME).exe

clean:
	go clean
	rm -rf $(PLUGIN_DIR)/$(BINARY_NAME)
	rm -rf $(PLUGIN_DIR)/$(BINARY_NAME).exe

dist: build-mac build-windows
	rm -rf $(DIST_DIR)
	mkdir -p $(DIST_DIR)
	$(SD_DISTRO_TOOL) $(PLUGIN_DIR) $(DIST_DIR)

dist-clean:
	rm -rf $(DIST_DIR)

install: build
	osascript -e 'quit app "Stream Deck"'
	sleep 1
	rm -rf "$(SD_PLUGIN_DIR)/$(PLUGIN_DIR)"
	cp -r $(PLUGIN_DIR) "$(SD_PLUGIN_DIR)"
	open -a "Stream Deck"

install-clean:
	osascript -e 'quit app "Stream Deck"'
	sleep 1
	rm -rf "$(SD_PLUGIN_DIR)/$(PLUGIN_DIR)"
	open -a "Stream Deck"

release: dist
	rm -rf $(RELEASE_DIR)
	cp -R $(DIST_DIR) $(RELEASE_DIR)

clean-all: clean dist-clean install-clean
