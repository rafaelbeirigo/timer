SRC = timer.c
OUT_JS = timer.js
OUT_WASM = timer.wasm
HTML = index.html

EMCC_FLAGS = -O3 -sEXPORTED_FUNCTIONS="['_start_timer','_tick']" \
             -sEXPORTED_RUNTIME_METHODS="['ccall','cwrap']" \
             -o $(OUT_JS)

all: build

build:
	@echo "Compiling $(SRC) to WASM..."
	emcc $(SRC) $(EMCC_FLAGS)
	@echo "Build complete: $(OUT_JS) + $(OUT_WASM)"

serve: build
	@echo "Serving at http://localhost:8000 (auto-rebuild on changes)"
	@while true; do \
		python3 -m http.server 8000 & \
		PID=$$!; \
		sleep 1; \
		inotifywait -e modify $(SRC) $(HTML); \
		echo "Changes detected. Rebuilding..."; \
		make build; \
		kill $$PID; \
	done

clean:
	rm -f $(OUT_JS) $(OUT_WASM)
