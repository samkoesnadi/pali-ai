cmake_minimum_required(VERSION 3.10)

set(BUILD_SHARED_LIBS ON)
#set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

set(GGML_LLAMAFILE OFF)
set(GGML_OPENMP OFF)
set(GGML_VULKAN OFF)
set(LLAMA_BUILD_COMMON ON)
set(LLAMA_BUILD_EXAMPLES ON)

#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DANDROID_ARM_NEON=TRUE -DANDROID_TOOLCHAIN=clang -DANDROID_ABI=arm64-v8a -DANDROID_PLATFORM=android-23")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DANDROID_ARM_NEON=TRUE -DANDROID_TOOLCHAIN=clang -DANDROID_ABI=arm64-v8a -DANDROID_PLATFORM=android-23")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DANDROID_ARM_NEON=TRUE -DANDROID_ABI=arm64-v8a -DANDROID_PLATFORM=android-23 -DANDROID_ABI=arm64-v8a -O3")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DANDROID_ARM_NEON=TRUE -DANDROID_ABI=arm64-v8a -DANDROID_PLATFORM=android-23 -DANDROID_ABI=arm64-v8a -O3")

#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DANDROID_ARM_NEON=TRUE -DANDROID_TOOLCHAIN=clang -DANDROID_ABI=arm64-v8a -DANDROID_PLATFORM=android-33 -DANDROID_ABI=arm64-v8a -O3 -fno-signed-zeros -fno-trapping-math -fassociative-math -freciprocal-math -fapprox-func -fno-rounding-math -fno-signaling-nans -funsafe-math-optimizations -fno-protect-parens")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DANDROID_ARM_NEON=TRUE -DANDROID_TOOLCHAIN=clang -DANDROID_ABI=arm64-v8a -DANDROID_PLATFORM=android-33 -DANDROID_ABI=arm64-v8a -O3 -fno-signed-zeros -fno-trapping-math -fassociative-math -freciprocal-math -fapprox-func -fno-rounding-math -fno-signaling-nans -funsafe-math-optimizations -fno-protect-parens")

# Log the flags
message(STATUS "CMAKE_C_FLAGS: ${CMAKE_C_FLAGS}")

#set(LLAMA_STATIC ON CACHE BOOL "llama: enable static link libraries" FORCE)
set(LLAMA_NATIVE OFF CACHE BOOL "llama: disable -march=native flag" FORCE)

#set(CMAKE_CXX_STANDARD 17)
#set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_library(SumLibrary SHARED src/example.cpp)
target_include_directories(SumLibrary PUBLIC include)

add_subdirectory(llama.cpp)
