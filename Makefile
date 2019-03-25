.PHONY: build install uninstall clean

USR_LOCAL ?= /usr/local

BIN_DIR = $(USR_LOCAL)/bin
LIB_DIR = $(USR_LOCAL)/lib

build:
	swift build -c release --disable-sandbox

install: build
	install ".build/release/swiftconst" "$(BIN_DIR)"
	install ".build/release/libSwiftSyntax.dylib" "$(LIB_DIR)"
	install_name_tool -change \
		".build/x86_64-apple-macosx10.10/release/libSwiftSyntax.dylib" \
		"$(LIB_DIR)/libSwiftSyntax.dylib" \
		"$(BIN_DIR)/swiftconst"

uninstall:
	rm -rf "$(BIN_DIR)/swiftconst"
	rm -rf "$(LIB_DIR)/libSwiftSyntax.dylib"

clean:
	rm -rf .build
