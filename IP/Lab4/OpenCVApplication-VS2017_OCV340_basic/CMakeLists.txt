cmake_minimum_required(VERSION 3.15)
project(OpenCVApplication_VS2017_OCV340_basic)

find_package(OpenCV REQUIRED)

set(CMAKE_CXX_STANDARD 14)

include_directories(.)

add_executable(OpenCVApplication_VS2017_OCV340_basic
        OpenCVApplication.cpp
        )

include_directories(${OpenCV_INCLUDE_DIRS})
target_link_libraries(OpenCVApplication_VS2017_OCV340_basic ${OpenCV_LIBS})