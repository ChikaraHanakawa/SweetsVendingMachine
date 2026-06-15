#include "leaving_time.h"

OutputTimeObject get_current_time(){
    std::time_t now = std::time(nullptr);
    std::tm* localTime = std::localtime(&now);
    return OutputTimeObject(localTime->tm_mday,
                            localTime->tm_hour,
                            localTime->tm_min);
}

OutputTimeObject get_leave_time(int hour, int min){
    if(hour == 21 && min == 30)chime_wav();
}
