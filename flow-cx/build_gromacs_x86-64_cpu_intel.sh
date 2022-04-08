#!/bin/bash

VERSION=2021.4
ARCH=x86_64
COMPILER=intel
INSTALL_PREFIX=${HOME}/data/bin/${ARCH}/gromacs/${VERSION}/cpu/${COMPILER}

#BASEDIR=/home/users/${USER}/Software/Gromacs/${VERSION}/
#GROMACS_TARBALL=${BASEDIR}/gromacs-${VERSION}.tar.gz
#REGRESSION_TARBALL=${BASEDIR}/regressiontests-${VERSION}.tar.gz
#WORKDIR=/work/users/${USER}
WORKDIR=`pwd`
REGRESSION_PATH=${WORKDIR}/regressiontests-${VERSION}

PARALLEL=20

#---------------------------------------------------------------------
#umask 0022

module purge
module load gcc/10.3.0 cmake/3.21.1
#module load gcc/8.4.0 cmake/3.21.1
. /home/center/opt/x86_64/cores/intel/compilers_and_libraries_2020.4.304/linux/bin/compilervars.sh intel64
#. /home/center/opt/x86_64/cores/intel/compilers_and_libraries_2019.5.281/linux/bin/compilervars.sh intel64

#cd ${WORKDIR}
#if [ -d gromacs-${VERSION} ]; then
#  mv gromacs-${VERSION} gromacs_erase
#  rm -rf gromacs_erase &
#fi
#
#if [ -d regressiontests-${VERSION} ]; then
#  mv regressiontests-${VERSION} regressiontests_erase
#  rm -rf regressiontests_erase &
#fi
#
#tar xzf ${GROMACS_TARBALL}
#tar xzf ${REGRESSION_TARBALL}
#cd gromacs-${VERSION}

# compiler setting
export CC=icc
export CXX=icpc
export F77=ifort
export F90=ifort
export FC=ifort

# single precision, no MPI
mkdir build_${ARCH}_sp_cpu_nompi_${COMPILER}
cd build_${ARCH}_sp_cpu_nompi_${COMPILER}
cmake .. \
   -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
   -DCMAKE_VERBOSE_MAKEFILE=ON \
   -DGMX_MPI=OFF \
   -DGMX_GPU=OFF \
   -DGMX_DOUBLE=OFF \
   -DGMX_THREAD_MPI=ON \
   -DGMX_FFT_LIBRARY=mkl
#   -DGMX_BUILD_OWN_FFTW=ON \
#   -DREGRESSIONTEST_DOWNLOAD=OFF \
#   -DREGRESSIONTEST_PATH=${REGRESSION_PATH}
#make -j${PARALLEL} && make check && make install
make -j${PARALLEL} && make install
cd ..

# double precision, no MPI
mkdir build_${ARCH}_dp_cpu_nompi_${COMPILER}
cd build_${ARCH}_dp_cpu_nompi_${COMPILER}
cmake .. \
   -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
   -DCMAKE_VERBOSE_MAKEFILE=ON \
   -DGMX_MPI=OFF \
   -DGMX_GPU=OFF \
   -DGMX_DOUBLE=ON \
   -DGMX_THREAD_MPI=ON \
   -DGMX_FFT_LIBRARY=mkl
#   -DGMX_BUILD_OWN_FFTW=ON \
#   -DREGRESSIONTEST_DOWNLOAD=OFF \
#   -DREGRESSIONTEST_PATH=${REGRESSION_PATH}
#make -j${PARALLEL} && make check && make install
make -j${PARALLEL} && make install
cd ..

# compiler setting for MPI versions
export CC=mpiicc
export CXX=mpicpc
export F77=mpiifort
export F90=mpiifort
export FC=mpiifort

# single precision, with MPI
mkdir build_${ARCH}_sp_cpu_mpi_${COMPILER}
cd build_${ARCH}_sp_cpu_mpi_${COMPILER}
cmake .. \
   -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
   -DCMAKE_VERBOSE_MAKEFILE=ON \
   -DGMX_MPI=ON \
   -DGMX_GPU=OFF \
   -DGMX_DOUBLE=OFF \
   -DGMX_THREAD_MPI=OFF \
   -DGMX_BUILD_OWN_FFTW=OFF
   -DGMX_FFT_LIBRARY=mkl
#   -DGMX_BUILD_OWN_FFTW=ON \
#   -DREGRESSIONTEST_DOWNLOAD=OFF \
#   -DREGRESSIONTEST_PATH=${REGRESSION_PATH}
#make -j${PARALLEL} && make check && make install
make -j${PARALLEL} && make install
cd ..

# double precision, with MPI
mkdir build_${ARCH}_dp_cpu_mpi_${COMPILER}
cd build_${ARCH}_dp_cpu_mpi_${COMPILER}
cmake .. \
   -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
   -DCMAKE_VERBOSE_MAKEFILE=ON \
   -DGMX_MPI=ON \
   -DGMX_GPU=OFF \
   -DGMX_DOUBLE=ON \
   -DGMX_THREAD_MPI=OFF \
   -DGMX_FFT_LIBRARY=mkl
#   -DGMX_BUILD_OWN_FFTW=ON \
#   -DREGRESSIONTEST_DOWNLOAD=OFF \
#   -DREGRESSIONTEST_PATH=${REGRESSION_PATH}
#make -j${PARALLEL} && make check && make install
make -j${PARALLEL} && make install
cd ..

exit 0
