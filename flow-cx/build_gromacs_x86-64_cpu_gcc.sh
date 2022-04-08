#!/bin/bash

VERSION=2021.4
ARCH=x86_64
COMPILER=gcc
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
module load gcc/10.3.0 openmpi/4.1.2 cmake/3.21.1

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
export CC=gcc
export CXX=g++
export F77=gfortran
export F90=gfortran
export FC=gfortran

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
   -DGMX_BUILD_OWN_FFTW=ON
# \
#   -DREGRESSIONTEST_DOWNLOAD=OFF \
#   -DREGRESSIONTEST_PATH=${REGRESSION_PATH}
#make -j${PARALLEL} && make check && make install
make -j${PARALLEL} && make install
cd ..

exit 0

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
   -DGMX_BUILD_OWN_FFTW=ON
# \
#   -DREGRESSIONTEST_DOWNLOAD=OFF \
#   -DREGRESSIONTEST_PATH=${REGRESSION_PATH}
#make -j${PARALLEL} && make check && make install
make -j${PARALLEL} && make install
cd ..

# compiler setting for MPI versions
export CC=mpicc
export CXX=mpicxx
export F77=mpif77
export F90=mpif90
export FC=mpif90

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
   -DGMX_BUILD_OWN_FFTW=ON
# \
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
   -DGMX_BUILD_OWN_FFTW=ON
# \
#   -DREGRESSIONTEST_DOWNLOAD=OFF \
#   -DREGRESSIONTEST_PATH=${REGRESSION_PATH}
#make -j${PARALLEL} && make check && make install
make -j${PARALLEL} && make install
cd ..

exit 0
