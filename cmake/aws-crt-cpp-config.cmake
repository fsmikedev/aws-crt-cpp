include(CMakeFindDependencyMacro)

find_dependency(aws-c-http)
find_dependency(aws-c-mqtt)
find_dependency(aws-c-cal)
find_dependency(aws-c-auth)

if (BUILD_SHARED_LIBS)
    include(${CMAKE_CURRENT_LIST_DIR}/shared/@CMAKE_PROJECT_NAME@-targets.cmake)
else ()
    include(${CMAKE_CURRENT_LIST_DIR}/static/@CMAKE_PROJECT_NAME@-targets.cmake)
endif()