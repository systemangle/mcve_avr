cmake_minimum_required( VERSION 3.13 )

project( mcve_prj
         VERSION 0.1
         LANGUAGES ASM C CXX )

list( APPEND CMAKE_MODULE_PATH ../cmake/modules )
include(avr)

set( FINAL_TARGET mcve )
set( MCU_SPEC ${CMAKE_CURRENT_LIST_DIR}/mcu_spec/standard )

add_subdirectory( mcve )


