# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.15

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /Applications/CLion.app/Contents/bin/cmake/mac/bin/cmake

# The command to remove a file.
RM = /Applications/CLion.app/Contents/bin/cmake/mac/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/lorenaneagu/Year3Sem2/IP/Lab3/OpenCVApplication-VS2017_OCV340_basic

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/lorenaneagu/Year3Sem2/IP/Lab3/OpenCVApplication-VS2017_OCV340_basic/cmake-build-debug

# Include any dependencies generated for this target.
include CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/flags.make

CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/OpenCVApplication.cpp.o: CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/flags.make
CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/OpenCVApplication.cpp.o: ../OpenCVApplication.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/lorenaneagu/Year3Sem2/IP/Lab3/OpenCVApplication-VS2017_OCV340_basic/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/OpenCVApplication.cpp.o"
	/Library/Developer/CommandLineTools/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/OpenCVApplication.cpp.o -c /Users/lorenaneagu/Year3Sem2/IP/Lab3/OpenCVApplication-VS2017_OCV340_basic/OpenCVApplication.cpp

CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/OpenCVApplication.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/OpenCVApplication.cpp.i"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/lorenaneagu/Year3Sem2/IP/Lab3/OpenCVApplication-VS2017_OCV340_basic/OpenCVApplication.cpp > CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/OpenCVApplication.cpp.i

CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/OpenCVApplication.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/OpenCVApplication.cpp.s"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/lorenaneagu/Year3Sem2/IP/Lab3/OpenCVApplication-VS2017_OCV340_basic/OpenCVApplication.cpp -o CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/OpenCVApplication.cpp.s

# Object files for target OpenCVApplication_VS2017_OCV340_basic
OpenCVApplication_VS2017_OCV340_basic_OBJECTS = \
"CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/OpenCVApplication.cpp.o"

# External object files for target OpenCVApplication_VS2017_OCV340_basic
OpenCVApplication_VS2017_OCV340_basic_EXTERNAL_OBJECTS =

OpenCVApplication_VS2017_OCV340_basic: CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/OpenCVApplication.cpp.o
OpenCVApplication_VS2017_OCV340_basic: CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/build.make
OpenCVApplication_VS2017_OCV340_basic: /usr/local/lib/libopencv_dnn.3.4.9.dylib
OpenCVApplication_VS2017_OCV340_basic: /usr/local/lib/libopencv_highgui.3.4.9.dylib
OpenCVApplication_VS2017_OCV340_basic: /usr/local/lib/libopencv_ml.3.4.9.dylib
OpenCVApplication_VS2017_OCV340_basic: /usr/local/lib/libopencv_objdetect.3.4.9.dylib
OpenCVApplication_VS2017_OCV340_basic: /usr/local/lib/libopencv_shape.3.4.9.dylib
OpenCVApplication_VS2017_OCV340_basic: /usr/local/lib/libopencv_stitching.3.4.9.dylib
OpenCVApplication_VS2017_OCV340_basic: /usr/local/lib/libopencv_superres.3.4.9.dylib
OpenCVApplication_VS2017_OCV340_basic: /usr/local/lib/libopencv_videostab.3.4.9.dylib
OpenCVApplication_VS2017_OCV340_basic: /usr/local/lib/libopencv_calib3d.3.4.9.dylib
OpenCVApplication_VS2017_OCV340_basic: /usr/local/lib/libopencv_features2d.3.4.9.dylib
OpenCVApplication_VS2017_OCV340_basic: /usr/local/lib/libopencv_flann.3.4.9.dylib
OpenCVApplication_VS2017_OCV340_basic: /usr/local/lib/libopencv_photo.3.4.9.dylib
OpenCVApplication_VS2017_OCV340_basic: /usr/local/lib/libopencv_video.3.4.9.dylib
OpenCVApplication_VS2017_OCV340_basic: /usr/local/lib/libopencv_videoio.3.4.9.dylib
OpenCVApplication_VS2017_OCV340_basic: /usr/local/lib/libopencv_imgcodecs.3.4.9.dylib
OpenCVApplication_VS2017_OCV340_basic: /usr/local/lib/libopencv_imgproc.3.4.9.dylib
OpenCVApplication_VS2017_OCV340_basic: /usr/local/lib/libopencv_core.3.4.9.dylib
OpenCVApplication_VS2017_OCV340_basic: CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/lorenaneagu/Year3Sem2/IP/Lab3/OpenCVApplication-VS2017_OCV340_basic/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable OpenCVApplication_VS2017_OCV340_basic"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/build: OpenCVApplication_VS2017_OCV340_basic

.PHONY : CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/build

CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/cmake_clean.cmake
.PHONY : CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/clean

CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/depend:
	cd /Users/lorenaneagu/Year3Sem2/IP/Lab3/OpenCVApplication-VS2017_OCV340_basic/cmake-build-debug && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/lorenaneagu/Year3Sem2/IP/Lab3/OpenCVApplication-VS2017_OCV340_basic /Users/lorenaneagu/Year3Sem2/IP/Lab3/OpenCVApplication-VS2017_OCV340_basic /Users/lorenaneagu/Year3Sem2/IP/Lab3/OpenCVApplication-VS2017_OCV340_basic/cmake-build-debug /Users/lorenaneagu/Year3Sem2/IP/Lab3/OpenCVApplication-VS2017_OCV340_basic/cmake-build-debug /Users/lorenaneagu/Year3Sem2/IP/Lab3/OpenCVApplication-VS2017_OCV340_basic/cmake-build-debug/CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/OpenCVApplication_VS2017_OCV340_basic.dir/depend

