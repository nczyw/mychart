cmake_minimum_required(VERSION 3.5)
set(MyChartLib MyChart)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#是否编译成库
set(BuildMyChartLib ON)


include_directories(${CMAKE_CURRENT_LIST_DIR})
include_directories(${CMAKE_CURRENT_LIST_DIR}/inc)
include_directories(${CMAKE_CURRENT_LIST_DIR}/src)

find_package(QT NAMES Qt6 Qt5)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Widgets PrintSupport)
set(QcustomPlot_Headers
        ${CMAKE_CURRENT_LIST_DIR}/inc/mychart.h
        ${CMAKE_CURRENT_LIST_DIR}/inc/qcustomplot.h
    )

set(QcustomPlot_Sources
        ${CMAKE_CURRENT_LIST_DIR}/src/mychart.cpp
        ${CMAKE_CURRENT_LIST_DIR}/src/qcustomplot.cpp
    )

set(QcustomPlot_Project
    ${QcustomPlot_Headers}
    ${QcustomPlot_Sources}
    )

#直接像上层传递工程文件
if(BuildMyChartLib)
    #编译成库
    add_library(${MyChartLib} SHARED
            ${QcustomPlot_Project}
    )
#    if(CMAKE_COMPILER_IS_GNUCXX)
        # 检查GNU编译是否支持 -Wa,-mbig-obj
        include(CheckCXXCompilerFlag)
        check_cxx_compiler_flag("-Wa,-mbig-obj" GNU_BIG_OBJ_FLAG_ENABLE)
        message(STATUS GNU_BIG_OBJ_FLAG_ENABLE=${GNU_BIG_OBJ_FLAG_ENABLE})
        target_compile_options(${MyChartLib}
            PRIVATE
            $<$<CXX_COMPILER_ID:MSVC>:/bigobj>
            $<$<AND:$<CXX_COMPILER_ID:GNU>,$<BOOL:${GNU_BIG_OBJ_FLAG_ENABLE}>>:-Wa,-mbig-obj>
        )
#    endif()
    #给库添加相应依赖
    target_link_libraries(MyChart PRIVATE Qt${QT_VERSION_MAJOR}::Widgets Qt${QT_VERSION_MAJOR}::PrintSupport)
    #在顶层使用target_link_libraries加载该库
endif()
#[[ 如果不编译成库时，需要在顶层cmake中添加如下编译器选项
if(CMAKE_COMPILER_IS_GNUCXX)
    # 检查GNU编译是否支持 -Wa,-mbig-obj
    include(CheckCXXCompilerFlag)
    check_cxx_compiler_flag("-Wa,-mbig-obj" GNU_BIG_OBJ_FLAG_ENABLE)
    message(STATUS GNU_BIG_OBJ_FLAG_ENABLE=${GNU_BIG_OBJ_FLAG_ENABLE})
    target_compile_options(${CMAKE_PROJECT_NAME}
        PRIVATE
        $<$<CXX_COMPILER_ID:MSVC>:/bigobj>
        $<$<AND:$<CXX_COMPILER_ID:GNU>,$<BOOL:${GNU_BIG_OBJ_FLAG_ENABLE}>>:-Wa,-mbig-obj>
    )
endif()
]]

