cmake_minimum_required(VERSION 3.1)

project(aws-crt)
list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE RelWithDebInfo)
endif()

include(ExternalProject)

set(AWS_DEPS_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}" CACHE PATH "Dependencies install directory.")
set(AWS_DEPS_BIN_DIR "${AWS_DEPS_INSTALL_DIR}/bin" CACHE PATH "Dependencies binary install directory.")
set(AWS_DEPS_LIB_DIR "${AWS_DEPS_INSTALL_DIR}/lib" CACHE PATH "Dependencies library install directory.")
set(AWS_DEPS_BUILD_DIR "${CMAKE_BINARY_DIR}/build" CACHE PATH "Dependencies build directory.")
set(AWS_DEPS_DOWNLOAD_DIR "${AWS_DEPS_BUILD_DIR}/downloads" CACHE PATH "Dependencies download directory.")

message("install dir ${AWS_DEPS_INSTALL_DIR}")
set(AWS_C_COMMON_URL "https://github.com/awslabs/aws-c-common.git")
set(AWS_C_COMMON_SHA "v0.4.24")
include(BuildAwsCCommon)

if (UNIX AND NOT APPLE)
    set(S2N_URL "https://github.com/awslabs/s2n.git")
    set(S2N_SHA "b2f784b883a34eb746a13d79e15c593430ede81b")
    include(BuildS2N)
endif()

set(AWS_C_IO_URL "https://github.com/awslabs/aws-c-io.git")
set(AWS_C_IO_SHA "v0.4.20")
include(BuildAwsCIO)

set(AWS_C_COMPRESSION_URL "https://github.com/awslabs/aws-c-compression.git")
set(AWS_C_COMPRESSION_SHA "v0.2.4")
include(BuildAwsCCompression)

set(AWS_C_HTTP_URL "https://github.com/awslabs/aws-c-http.git")
set(AWS_C_HTTP_SHA "v0.4.18")
include(BuildAwsCHttp)

set(AWS_C_MQTT_URL "https://github.com/awslabs/aws-c-mqtt.git")
set(AWS_C_MQTT_SHA "v0.4.22")
include(BuildAwsCMqtt)

set(AWS_C_CAL_URL "https://github.com/awslabs/aws-c-cal.git")
set(AWS_C_CAL_SHA "v0.2.0")
include(BuildAwsCCal)

set(AWS_C_AUTH_URL "https://github.com/awslabs/aws-c-auth.git")
set(AWS_C_AUTH_SHA "v0.3.4")
include(BuildAwsCAuth)

add_dependencies(AwsCCompression AwsCCommon)
add_dependencies(AwsCMqtt AwsCHttp)
add_dependencies(AwsCHttp AwsCIO AwsCCompression)
add_dependencies(AwsCCal AwsCCommon)
add_dependencies(AwsCAuth AwsCHttp AwsCCal)

if (UNIX AND NOT APPLE)
    add_dependencies(AwsCIO S2N AwsCCommon)
else()
    add_dependencies(AwsCIO AwsCCommon )
endif()

