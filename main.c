#include <emscripten.h>

// Expose this function to JavaScript
EMSCRIPTEN_KEEPALIVE
int next_time(int t) {
    if (t > 0) {
        return t - 1;
    } else {
        return 0;
    }
}
