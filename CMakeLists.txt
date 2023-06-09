cmake_minimum_required (VERSION 3.24)
project(vulkan-hdr-demo)

set(CMAKE_CXX_STANDARD 20)

set(SRCDIR "${PROJECT_SOURCE_DIR}/src")
set(PCH_SRC "${SRCDIR}/stdafx.h")

find_package(Vulkan REQUIRED)
add_subdirectory(external)

set(EXNAME "vkdemo")

file(GLOB_RECURSE SRC_FILES CONFIGURE_DEPENDS "${SRCDIR}/*.cpp" "${SRCDIR}/*.h")
add_executable (${EXNAME} ${SRC_FILES})

set_target_properties(
    ${EXNAME} PROPERTIES
    VS_DEBUGGER_WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}")

target_precompile_headers(${EXNAME} PRIVATE ${PCH_SRC})

target_include_directories(${EXNAME} PUBLIC ${SRCDIR} ${Vulkan_INCLUDE_DIRS} ${PROJECT_SOURCE_DIR}/external)

target_link_libraries(${EXNAME} 
    ${Vulkan_LIBRARIES}   glfw
)

set(SHADER_DIR "${PROJECT_SOURCE_DIR}/assets/shaders/src")
set(SPV_DIR "${PROJECT_SOURCE_DIR}/assets/shaders/bin")

set(SHADER_SRC ${SPV_DIR}/*)

add_custom_target(glsl_shaders ALL
  DEPENDS ${SHADER_SRC}
  COMMENT "Shaders to compile"
)

add_dependencies(${EXNAME} glsl_shaders)

add_custom_command(
    TARGET glsl_shaders
    COMMAND python3 ${PROJECT_SOURCE_DIR}/compile_shaders.py ${PROJECT_SOURCE_DIR}
    COMMENT "Compiling shaders"
)


#Compile shaders in assets/shaders folder


#add_custom_command(TARGET ${EXNAME} PRE_BUILD
#    COMMAND python3 ${PROJECT_SOURCE_DIR}/compile_shaders.py ${PROJECT_SOURCE_DIR}
#)


