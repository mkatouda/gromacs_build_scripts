#!/bin/sh

VERSION=2021.1
ARCH=x86_64
COMPILER=intel
INSTALL_PREFIX=/home/z43901k/data/bin/${ARCH}/gromacs/${VERSION}/gpu/${COMPILER}

#BASEDIR=/home/users/${USER}/Software/Gromacs/${VERSION}/
#GROMACS_TARBALL=${BASEDIR}/gromacs-${VERSION}.tar.gz
#REGRESSION_TARBALL=${BASEDIR}/regressiontests-${VERSION}.tar.gz
#WORKDIR=/work/users/${USER}
WORKDIR=`pwd`
REGRESSION_PATH=${WORKDIR}/regressiontests-${VERSION}

#PATCH_TEST=${BASEDIR}/tests_CMakelists.patch

PARALLEL=12

#---------------------------------------------------------------------
umask 0022

module purge
module load  intel/2019.5.281
module load cuda/10.2.89_440.33.01
module load cmake/3.17.3
source scl_source enable devtoolset-7

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
#patch -p0 < ${PATCH_TEST}

# compiler setting
export CC=icc
export CXX=icpc
export F77=ifort
export F90=ifort
export FC=ifort

# single precision, no MPI
mkdir build_${ARCH}_sp_gpu_nompi_${COMPILER}
cd build_${ARCH}_sp_gpu_nompi_${COMPILER}
cmake .. \
   -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
   -DCMAKE_VERBOSE_MAKEFILE=ON \
   -DGMX_MPI=OFF \
   -DGMX_GPU=CUDA \
   -DGMX_DOUBLE=OFF \
   -DGMX_THREAD_MPI=ON \
   -DGMX_BUILD_OWN_FFTW=ON \
   -DREGRESSIONTEST_DOWNLOAD=OFF \
   -DREGRESSIONTEST_PATH=${REGRESSION_PATH}
make -j${PARALLEL} && make check && make install
cd ..

# compiler setting for MPI versions
export CC=mpiicc
export CXX=mpiicpc
export F77=mpiifort
export F90=mpiifort
export FC=mpiifort

# single precision, with MPI
mkdir build_${ARCH}_sp_gpu_mpi_${COMPILER}
cd build_${ARCH}_sp_gpu_mpi_${COMPILER}
cmake .. \
   -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
   -DCMAKE_VERBOSE_MAKEFILE=ON \
   -DGMX_MPI=ON \
   -DGMX_GPU=CUDA \
   -DGMX_DOUBLE=OFF \
   -DGMX_THREAD_MPI=OFF \
   -DGMX_BUILD_OWN_FFTW=ON \
   -DREGRESSIONTEST_DOWNLOAD=OFF \
   -DREGRESSIONTEST_PATH=${REGRESSION_PATH}
make -j${PARALLEL} && make check && make install
cd ..
