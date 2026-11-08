#include "common.h"
#include <map>
#include <fstream>

struct InputCsvObject {
    public:
        InputCsvObject() {};
        ~InputCsvObject() {};
        std::map<std::string, std::string> get_lab_member() const {
            return lab_member;
        };         
        void set_lab_member(std::string& id, std::string& name) {
            lab_member.insert(std::make_pair(id, name));
        };
    private:
        std::map<std::string, std::string> lab_member;
};

InputCsvObject reading_csv(const std::string& path = "database/member.csv");
