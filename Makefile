SRC = main.c
OUT_JS = main.js
OUT_WASM = main.wasm
HTML = index.html

EMCC_FLAGS = -O3 -sEXPORTED_FUNCTIONS="['_start_timer','_tick']" \
             -sEXPORTED_RUNTIME_METHODS="['ccall','cwrap']" \
             -o $(OUT_JS)

all: build

# Build WASM + JS
build:
	@echo "Compiling $(SRC) to WASM..."
	emcc $(SRC) $(EMCC_FLAGS)
	@echo "Build complete: $(OUT_JS) + $(OUT_WASM)"

# Serve locally with live-reload
serve: build
	@echo "Serving at http://localhost:8000 (auto-rebuild on changes)"
	@trap "echo 'Stopping server...'; kill $$PID; exit 0" SIGINT; \
	while true; do \
		python3 -m http.server 8000 & \
		PID=$$!; \
		sleep 1; \
		# Watch only source files, ignore output
		inotifywait -e modify --exclude '$(OUT_JS)|$(OUT_WASM)' $(SRC) $(HTML); \
		echo "Changes detected. Rebuilding..."; \
		make build; \
		kill $$PID; \
	done

# Clean build artifacts
clean:
	@echo "Cleaning build files..."
	rm -f $(OUT_JS) $(OUT_WASM)
