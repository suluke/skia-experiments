cmake_minimum_required(VERSION 3.10)
project(skia-test CXX)
set(CMAKE_CXX_STANDARD 17)

add_subdirectory(ext)

add_executable(skiatest main.cpp)
target_link_libraries(skiatest skia)
