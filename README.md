# mcve_avr

For Make:
 * You need to modify TOOLCHAIN path in Makefile.
 
 For cmake:
 * You need to modify TOOLCHAIN_PATH in cmake command

```
rm -R -f build
mkdir build
cmake -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug -DTOOLCHAIN_PATH=/home/user/arduino/hardware/tools/avr/bin/ -DCMAKE_TOOLCHAIN_FILE=../cmake/toolchain/avr.cmake ../mcve 
cd build
make VERBOSE=1
```
