#!/bin/bash

VERSION=2020.4
ARCH=a64fx
COMPILER=fjt
INSTALL_PREFIX=${HOME}/bin/gromacs/${VERSION}/${ARCH}/${COMPILER}

export CC=fccpx
export CXX=FCCpx
export F77=frtpx
export F90=frtpx
export FC=frtpx

PARALLEL=8

# single precision, no MPI
mkdir build_${ARCH}_${COMPILER}
cd build_${ARCH}_${COMPILER}
cmake .. \
   -DCMAKE_TOOLCHAIN_FILE=Toolchain-Fujitsu-Sparc64-mpi.cmake # \
#   -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
#   -DCMAKE_VERBOSE_MAKEFILE=ON \
#   -DGMX_MPI=OFF \
#   -DGMX_GPU=OFF \
#   -DGMX_DOUBLE=OFF \
#   -DGMX_THREAD_MPI=ON \
#   -DGMX_BUILD_OWN_FFTW=OFF \
#   -DREGRESSIONTEST_DOWNLOAD=OFF
#   -DREGRESSIONTEST_PATH=${REGRESSION_PATH}
#make -j${PARALLEL} && make make install
#make -j${PARALLEL} && make check && make install
cd ..
