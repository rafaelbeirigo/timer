#include <emscripten.h>
#include <stdio.h>
#include <stdbool.h>

int remaining_time = 0;
bool running = false;

EM_JS(void, js_update, (int seconds_left, bool finished), {
    if (Module.onTick) Module.onTick(seconds_left, finished);
});

void timer_loop() {
    if (!running) return;

    if (remaining_time > 0) {
        remaining_time--;
        js_update(remaining_time, false);
    } else {
        running = false;
        js_update(0, true); // timer finished
    }
}

EMSCRIPTEN_KEEPALIVE
void start_timer(int seconds) {
    remaining_time = seconds;
    running = true;
}

EMSCRIPTEN_KEEPALIVE
void tick() {
    timer_loop();
}
