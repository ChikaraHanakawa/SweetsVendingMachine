cmake_minimum_required(VERSION 3.20)
project(StudentCardNFC)

set(CMAKE_CXX_STANDARD 17)

find_package(Python COMPONENTS Interpreter Development Development.Embed REQUIRED)
find_package(SFML 2.5 COMPONENTS audio system REQUIRED)

execute_process(
    COMMAND "${Python_EXECUTABLE}" -c "import pybind11; print(pybind11.get_cmake_dir())"
    OUTPUT_VARIABLE pybind11_DIR
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_QUIET
)

find_package(pybind11 REQUIRED)

add_executable(VendingMachine
    src/main.cpp
    src/aplay.cpp
    src/nfc_bridge.cpp
    src/leaving_time.cpp
)

target_include_directories(VendingMachine PRIVATE
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/include
)

target_link_libraries(VendingMachine PRIVATE
    pybind11::embed
    sfml-audio
    sfml-system
)
