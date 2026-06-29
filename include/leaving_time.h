#include "common.h"
#include <iostream>
#include <ctime>
#include <atomic>
#include <thread>
#include <chrono>

extern std::atomic<bool> running;

struct OutputTimeObject{    
    public:
        OutputTimeObject(int x, int y, int z) : ret_day(x), ret_hrs(y), ret_min(z) {};
        ~OutputTimeObject() {};
        int get_Day() const { return ret_day; }
        int get_Hour() const { return ret_hrs; }
        int get_Min() const { return ret_min; } 
    private:
        int ret_day;
        int ret_hrs;
        int ret_min;
};

OutputTimeObject get_current_time();

void leave_time(int hour, int minutes);

void loop_timer();
