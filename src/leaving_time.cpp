#include "aplay.h"
#include "leaving_time.h"

extern std::atomic<bool> running;

OutputTimeObject get_current_time(){
    std::time_t now = std::time(nullptr);
    std::tm* localTime = std::localtime(&now);
    return OutputTimeObject(localTime->tm_mday,
                            localTime->tm_hour,
                            localTime->tm_min);
}

void leave_time(int hour, int minutes){
    if (hour == 21 && minutes == 30) chime_wav();
}

void loop_timer(){
    bool fired = false;
    while(running){
        OutputTimeObject t = get_current_time();
        if (t.get_Hour() == 21 && t.get_Min() == 30){
            if (!fired){
                leave_time(t.get_Hour(), t.get_Min());
                fired = true;
            } else {
                fired = false;
            }
            std::this_thread::sleep_for(std::chrono::seconds(1));
        }
    }
    std::cout << "[Info] 時間計測を停止しました" << std::endl;
}
