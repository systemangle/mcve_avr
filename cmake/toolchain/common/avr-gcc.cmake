
set( TOOLCHAIN_PREFIX       ${TOOLCHAIN_PATH}avr)
set( CMAKE_C_COMPILER       ${TOOLCHAIN_PREFIX}-gcc )
set( CMAKE_CXX_COMPILER     ${TOOLCHAIN_PREFIX}-g++ )
set( AS                     ${TOOLCHAIN_PREFIX}-gcc )
set( AR                     ${TOOLCHAIN_PREFIX}-gcc-ar )
set( OBJCOPY                ${TOOLCHAIN_PREFIX}-objcopy )
set( OBJDUMP                ${TOOLCHAIN_PREFIX}-objdump )
set( SIZE                   ${TOOLCHAIN_PREFIX}-size )


set( COMMON_FLAGS                   "-ffunction-sections -fdata-sections -MMD -flto" )
set( CMAKE_C_FLAGS_INIT             "${MCU_FLAGS} ${COMMON_FLAGS} -std=gnu11 -fno-fat-lto-objects" CACHE INTERNAL "c compiler flags" )
set( CMAKE_CXX_FLAGS_INIT           "${MCU_FLAGS} ${COMMON_FLAGS} -std=gnu++11 -fpermissive -fno-exceptions -fno-threadsafe-statics -Wno-error=narrowing" CACHE INTERNAL "cxx compiler flags" )
set( CMAKE_ASM_FLAGS_INIT           "${MCU_FLAGS} -x assembler-with-cpp -flto -MMD" CACHE INTERNAL "asm compiler flags" )
set( CMAKE_EXE_LINKER_FLAGS_INIT    "${MCU_FLAGS} ${LD_FLAGS} -flto -fuse-linker-plugin -lm -Wl,--gc-sections " CACHE INTERNAL "exe link flags" )



set( CMAKE_AR ${AR} )
set( CMAKE_CXX_ARCHIVE_CREATE "<CMAKE_AR> rcs <TARGET> <LINK_FLAGS> <OBJECTS>" )
set( CMAKE_CXX_ARCHIVE_FINISH true) 
set( CMAKE_C_ARCHIVE_CREATE "<CMAKE_AR> rcs <TARGET> <LINK_FLAGS> <OBJECTS>" )
set( CMAKE_C_ARCHIVE_FINISH  true)


set( CMAKE_C_FLAGS_DEBUG_INIT       "-Os -w" CACHE INTERNAL "c debug compiler flags" )
set( CMAKE_CXX_FLAGS_DEBUG_INIT     "-Os -w" CACHE INTERNAL "cxx debug compiler flags" )
set( CMAKE_ASM_FLAGS_DEBUG_INIT     "-Os -w" CACHE INTERNAL "asm debug compiler flags" )


set( CMAKE_C_FLAGS_RELEASE_INIT      "-Os -g -w" CACHE INTERNAL "c release compiler flags" )
set( CMAKE_CXX_FLAGS_RELEASE_INIT    "-Os -g -w" CACHE INTERNAL "cxx release compiler flags" )
set( CMAKE_ASM_FLAGS_RELEASE_INIT    "" CACHE INTERNAL "asm release compiler flags" )
