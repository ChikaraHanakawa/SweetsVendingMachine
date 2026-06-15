#include "aplay.h"
#include <SFML/Audio.hpp>

void zundamon_wav(std::string path){
    sf::SoundBuffer buffer;

    if(!buffer.loadFromFile(path)){
        std::cerr << "[Error] 音声ファイル読み込みに失敗" << std::endl;
    }

    sf::Sound sound;
    sound.setBuffer(buffer);

    std::cout << "WAVファイルを再生中・・・" << std::endl;
    sound.play();

    while(sound.getStatus() == sf::Sound::Status::Playing){
        sf::sleep(sf::milliseconds(100));
    }
    std::cout << "再生終了" << std::endl;
}

void chime_wav(){
    std::string path = "database/wav/good_children.wav";
    sf::Music music;
    if(!music.openFromFile(path)){
        std::cerr << "[Error] 音声ファイル読み込みに失敗" << std::endl;;
    }

    music.setLoop(true);
    music.play();

    while(music.getStatus() == sf::Music::Playing){
        sf::sleep(sf::seconds(200));
    }
}
