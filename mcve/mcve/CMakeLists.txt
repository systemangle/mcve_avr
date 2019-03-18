cmake_minimum_required( VERSION 3.13 )

project( core_prj
         VERSION 0.1
         LANGUAGES ASM C CXX )


add_definitions( -DF_CPU=160000000L )
add_definitions( -DARDUINO=10808 )
add_definitions( -DARDUINO_AVR_UNO )
add_definitions( -DARDUINO_ARCH_AVR )


set( INC_DIR ${CMAKE_CURRENT_LIST_DIR}/inc )
set( SRC_DIR ${CMAKE_CURRENT_LIST_DIR}/src )
set( CORE_SRC_DIR ${CMAKE_CURRENT_LIST_DIR}/src/core )

set( CORE_INC ${INC_DIR}/core )

set( CORE_SRC 
    ${CORE_SRC_DIR}/main.cpp
    ${CORE_SRC_DIR}/abi.cpp
    ${CORE_SRC_DIR}/new.cpp

    ${CORE_SRC_DIR}/HardwareSerial.cpp
    ${CORE_SRC_DIR}/HardwareSerial0.cpp
    ${CORE_SRC_DIR}/HardwareSerial1.cpp
    ${CORE_SRC_DIR}/HardwareSerial2.cpp
    ${CORE_SRC_DIR}/HardwareSerial3.cpp

    ${CORE_SRC_DIR}/CDC.cpp
    ${CORE_SRC_DIR}/USBCore.cpp
    ${CORE_SRC_DIR}/PluggableUSB.cpp

    ${CORE_SRC_DIR}/Print.cpp
    ${CORE_SRC_DIR}/Stream.cpp

    ${CORE_SRC_DIR}/IPAddress.cpp

    ${CORE_SRC_DIR}/Tone.cpp

    ${CORE_SRC_DIR}/hooks.c
    ${CORE_SRC_DIR}/wiring.c
    ${CORE_SRC_DIR}/wiring_analog.c
    ${CORE_SRC_DIR}/wiring_digital.c
    ${CORE_SRC_DIR}/wiring_pulse.c
    ${CORE_SRC_DIR}/wiring_pulse.S
    ${CORE_SRC_DIR}/wiring_shift.c

    ${CORE_SRC_DIR}/WInterrupts.c
    ${CORE_SRC_DIR}/WString.cpp
    ${CORE_SRC_DIR}/WMath.cpp
)

set( SRC 
   ${SRC_DIR}/mcve.cpp 
)


include_directories( ${MCU_SPEC} ${CORE_INC} )

set( CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} -L${CMAKE_BINARY_DIR}/mcve")

add_library( core STATIC ${CORE_SRC} )
target_include_directories( core PUBLIC ${CORE_INC} )

add_executable( ${FINAL_TARGET} ${SRC} )
target_link_libraries( ${FINAL_TARGET} core )
set_target_properties( ${FINAL_TARGET} PROPERTIES OUTPUT_NAME ${FINAL_TARGET}.elf )


avr_create_hex( ${FINAL_TARGET} ${CMAKE_BINARY_DIR}/mcve/${FINAL_TARGET} )
avr_show_size( ${FINAL_TARGET} ${CMAKE_BINARY_DIR}/mcve/${FINAL_TARGET} )
