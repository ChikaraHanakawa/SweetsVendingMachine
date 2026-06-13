#include "common.h"
#include "nfc_bridge.h"

#include <pybind11/embed.h>

std::atomic<bool> running{true};

void feedback_play_wav(int state){       
    std::string path = "database/wav/";
    path += "good_children.wav";
    zundamon_wav(path);  
}                           

void nfc_py_read(){     
    pybind11::scoped_interpreter guard{};
    std::cout << "[C++ Main] pybind11 認証システムを開始します" << std::endl;
    try {
        pybind11::module_ sys = pybind11::module::import("sys");
        sys.attr("path").cast<pybind11::list>().append("./src/");
        sys.attr("path").cast<pybind11::list>().append(".");

        pybind11::module_ nfc_mod = pybind11::module_::import("nfc_reader");

        std::cout << "カードをかざして下さい" << std::endl;
        while(running){
            std::string student_id = nfc_mod.attr("NFCReader")().attr("read_student_id")().cast<std::string>();

            if(!running) break;
            if(student_id.empty() || student_id.rfind("Error", 0) == 0){
                continue;
            }

            if(!student_id.empty() && student_id.rfind("Error", 0) != 0){
                std::cout << "[Success] 学籍番号: " << student_id << std::endl;
                if(lab_member_id.count(student_id)){
                    std::cout << "[Registered] 登録済みメンバーです" << std::endl;
                    feedback_play_wav(0);
                }else{
                    std::cout << "[Not Registered] 未登録のメンバーです" << std::endl;
                    feedback_play_wav(1);
                }
            }else{
                std::cerr << "[Error] 読み取り失敗; " << student_id << std::endl;
                feedback_play_wav(2);
            }
            std::this_thread::sleep_for(std::chrono::milliseconds(2000));
        }
    }
    catch (pybind11::error_already_set &e){
        if(e.matches(PyExc_KeyboardInterrupt)){
            std::cout << "[Info] KeyboardInterruptを受信しました" << std::endl;
        }else if(running){
            std::cerr << "[Except] Python側での例外発生:\n" << e.what() << std::endl;
        }
    }
    std::cout << "[Info] NFCリーダーを停止しました" << std::endl;
}
