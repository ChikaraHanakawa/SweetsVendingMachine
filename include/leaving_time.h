#include <iostream>
#include <ctime>

struct OutputTimeObject{    
    public:
        OutputTimeObject(int x, int y, int z) : ret_day(x), ret_hour(y), ret_min(z) {};
        ~OutputTimeObject(){};
        int get_Day() const { return ret_day; }
        int get_Hour() const { return ret_hour; }
        int get_Min() const { return ret_min; } 
    private:
        int ret_day;
        int ret_hour;
        int ret_min;
};

OutputTimeObject what_time();
