#include <emscripten.h>
#include <stdbool.h>

int remaining_time = 0;
bool running = false;

// JS callback to update the display
EM_JS(void, js_update, (int seconds_left, bool finished), {
    if (Module.onTick) Module.onTick(seconds_left, finished);
});

// Timer tick function
EMSCRIPTEN_KEEPALIVE
void tick() {
    if (!running) return;

    if (remaining_time > 0) {
        remaining_time--;
        js_update(remaining_time, false);
    } else {
        running = false;
        js_update(0, true); // timer finished
    }
}

// Start the timer with initial value
EMSCRIPTEN_KEEPALIVE
void start_timer(int seconds) {
    remaining_time = seconds;
    running = true;
    js_update(remaining_time, false); // immediately display starting value
}
