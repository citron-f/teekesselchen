PLUGIN      := teekesselchen
FORK        := citron-f
VERSION     := 1.9.1

DISTRIBUTOR := $(PLUGIN)-$(FORK)
BUILD       := $(DISTRIBUTOR).lrplugin
DIST        := dist

ZIP         := $(DIST)/$(DISTRIBUTOR)-$(VERSION).zip
SHA         := $(ZIP).sha256

.PHONY: clean build distribution

clean:
	@echo "# Cleaning old build folders..."
	@rm -rf $(BUILD) $(DIST)

# Ensure build and dist folders exists
$(BUILD):
	@mkdir $(BUILD)

$(DIST):
	@mkdir -p "$(DIST)"
	
build: clean $(shell find src -type f) $(BUILD)	
	@echo ""
	@echo "# Building $(BUILD)..."
	
	@if [ -d "src" ]; then \
		echo "Copying src files..."; \
		cp -a src/* $(BUILD); \
	else \
		echo "ERROR: src folder not found. Build aborted."; \
		exit 1; \
	fi

	@if [ -d "3rd/exiftool" ]; then \
		echo "Copying exiftool..."; \
		cp -a 3rd/exiftool/* $(BUILD); \
	else \
		echo "Exiftool folder not found, skipping."; \
	fi


distribution: build $(DIST)
	@echo ""
	@echo "# Creating $(ZIP)..."
	@zip -q -r "$(ZIP)" "$(BUILD)"/*
	@echo "# Writing checksum $(SHA)..."
	@sha256sum "$(ZIP)" | head -c 64 > "$(SHA)"
	
	@echo ""
	@echo "# Done"
