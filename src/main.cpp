#include "common.h"
#include "nfc_bridge.h"
#include "aplay.h"
#include "leaving_time.h"
#include <algorithm>
#include <thread>
#include <csignal>
#include <atomic>
#include <chrono>

std::atomic<bool> running{true};

void signal_handler(int signum){
    std::cout << "\n[Info] 終了シグナルを受信 (signal: " << signum << ")" << std::endl;
    running = false;
}

int main(){
    std::signal(SIGINT, signal_handler);
    std::signal(SIGTERM, signal_handler);

    std::thread reader(nfc_py_read);
    std::thread timer(loop_timer);

    reader.join();
    timer.join();

    std::cout << "[Info] システムを終了します" << std::endl;
    return 0;
}
