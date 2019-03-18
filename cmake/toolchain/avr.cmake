set( CMAKE_SYSTEM_NAME Linux)
set( CMAKE_SYSTEM_PROCESSOR avr)

set(MCU_FLAGS "-mmcu=atmega328p")

include( ${CMAKE_CURRENT_LIST_DIR}/common/avr-gcc.cmake )
