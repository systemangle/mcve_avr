
macro( avr_create_hex TARGET ELF )
    add_custom_command( TARGET ${TARGET} POST_BUILD
                        COMMAND ${OBJCOPY} -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0 ${ELF}.elf ${ELF}.eep
                        COMMAND ${OBJCOPY} -O ihex -R .eeprom ${ELF}.elf ${ELF}.hex
                        COMMENT "Building flash file....."
                     )
endmacro()

macro( avr_show_size TARGET ELF )
    add_custom_command( TARGET ${TARGET} POST_BUILD
                        COMMAND ${SIZE} -A ${ELF}.elf
                        COMMENT ""
                     )       
endmacro()