#include "read_csv.h"

InputCsvObject reading_csv() {
    InputCsvObject obj;
    std::ifstream ifs(path);
    std::string line;
    while (std::getline(ifs, line)) {
        if (line.empty()) continue;
        std::string id = line.substr(0, comma);
        std::string name = line.substr(comma+1);
        obj.set_lab_member(id, name);
    }
    ifs.close();
    return obj;
}
