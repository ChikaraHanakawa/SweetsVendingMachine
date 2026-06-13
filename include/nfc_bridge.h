#include "common.h"
#include <algorithm>
#include <chrono>
#include <atomic>
#include <thread>

extern std::atomic<bool> running;
void feedback_play_wav(int state);
void nfc_py_read();
