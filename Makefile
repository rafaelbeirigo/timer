# Compiler
EMCC = emcc

# Source files
SRC = main.c

# Output
OUT = main.js

# Compilation flags
CFLAGS = -O2 -sEXPORTED_FUNCTIONS="['_next_time']" -sEXPORTED_RUNTIME_METHODS="['ccall', 'cwrap']"

# Default target
all: $(OUT)

# Build WASM
$(OUT): $(SRC)
	$(EMCC) $(SRC) $(CFLAGS) -o $(OUT)

# Serve locally using Python HTTP server
serve: $(OUT)
	@echo "Serving on http://localhost:8000 ..."
	@python3 -m http.server 8000

# Clean
clean:
	rm -f main.js main.wasm main.mem
