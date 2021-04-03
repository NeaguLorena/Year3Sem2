cmake_minimum_required(VERSION 3.15)
project(DepthEstimation)

find_package(OpenCV REQUIRED)

set(CMAKE_CXX_STANDARD 14)

include_directories(.)

add_executable(DepthEstimation
        OpenCVApplication.cpp)

include_directories(${OpenCV_INCLUDE_DIRS})
target_link_libraries(DepthEstimation ${OpenCV_LIBS})