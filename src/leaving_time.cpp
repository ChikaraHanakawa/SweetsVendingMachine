#include "leaving_time.h"

OutputTimeObject what_time(){
    std::time_t now = std::time(nullptr);
    std::tm* localTime = std::localtime(&now);
    return OutputTimeObject(localTime->tm_mday,
                            localTime->tm_hour,
                            localTime->tm_min);
}
