#!/bin/bash
# User Guide Installation: http://www.dtcenter.org/met/users/support/online_tutorial/METv5.0/compilation/req_libs.php
# Installing MET
#---------------------------------------------------
# Installing BUFRLIB
gcc -c -DUNDERSCORE *.c
gfortran -c -DUNDERSCORE -fno-second-underscore *.f *.F
ar crv libbufr.a *.o
#----------------------------------------------------
# Installing netCDF & netcdf C++
cd netcdf-4.4.0
setenv CC /usr/bin/gcc
setenv CXX /usr/bin/c++
setenv FC ''
setenv F90 ''
./configure --prefix=/usr/local/netcdf_MET --disable-netcdf-4
make
sudo make install 
# In addtion, the netcdf c++ should be installed
wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-cxx-4.2.tar.gz
tar netcdf-cxx-4.2.tar.gz
./configure --prefix=/usr/local/netcdf_MET
make 
sudo make install
# Please check the /usr/local/netcdf_MET/include to contain netcdf.hh
#------------------------------------------------------
# Installing GSL
wget ftp://ftp.gnu.org/gnu/gsl/gsl-1.11.tar.gz  # http://www.gnu.org/software/gsl/
cd gsl-1.11
./configure  --prefix=/usr/local/GSL_1.11
make
#make check > log 2>&1
sudo make install
#------------------------------------------------------
# Installing g2clib library
wget http://www.nco.ncep.noaa.gov/pmb/codes/GRIB2/g2clib-1.6.0.tar
# Check the INC in makefile
make
# after amiing the library the name of the library should be chnaged from "libg2c_v1.6.0.a"  to "libgrib2c.a"
#--------------------------------------------------
# Installimg HDF4
# We need to install jpeg/zlib/szip before HDF4
## Installing jpeg
wget http://www.hdfgroup.org/ftp/lib-external/jpeg/src/jpegsrc.v6b.tar.gz
./configure
make
make test
make install-lib
#..............................................
wget http://www.hdfgroup.org/ftp/HDF/HDF_Current/src/hdf-4.2.11.tar
./configure --with-zlib=/usr/local/zlib_1.2.8 --with-jpeg=/usr/local64  --with-szlib=/usr/local/szip_2.1 --prefix=/usr/local/hdf4_2.11  --disable-netcdf     
gmake >& gmake.out
gmake check >& check.out
sudo gmake install
gmake install-examples
gmake install check
#------------------------------------------------------
# Installing HDF-EOS2
./configure --prefix=/usr/local/hdfeos2_19.1 --with-hdf4=/usr/local/hdf4_2.11 --with-szlib=/usr/local/szip_2.1 CC="/usr/local/hdf4_2.11/bin/h4cc -Df2cFortran"
make
#make check
sudo make install
#-------------------------------------------------------
# Installing Cairo 
wget https://www.cairographics.org/releases/cairo-1.14.6.tar.xz
./configure --prefix=/usr/local/cairo_1.14.6
make
sudo make install
#------------------------------------------------------------
# Installing FreeType
wget http://download.savannah.gnu.org/releases/freetype/freetype-2.6.tar.gz
sh autogen.sh
./configure --prefix=/usr/local/freetype_2.6
make
sudo make install
#-----------------------------------------------------------
# Optional: Installing Unified Post-Processor
wget http://www.dtcenter.org/upp/users/downloads/UPP_releases/DTC_upp_v3.0.tar.gz
tar -zxvf DTC_upp_v3.0.tar.gz
export WRF_DIR=/home/aliabbasi/WRF/WRFV3
./configure
./compile >& compile_upp.log

# The following environments should be set in ~/.bashrc
export CPPFLAGS="-I/usr/local/hdf5_1.8.16/include -I/usr/local/zlib_1.2.8/include -I/usr/local/netcdf/include -I/home/aliabbasi/WRF/MET/g2clib-1.6.0 -I/usr/local/jasper_1.900.1/include \
                 -I/home/aliabbasi/WRF/MET/hdfeos/gctp/include -I/home/aliabbasi/WRF/MET/hdfeos/include -I/usr/local/szip_2.1/include"
export LDFLAGS="-L/usr/local/hdf5_1.8.16/lib64 -L/usr/local/zlib_1.2.8/lib -L/usr/local/netcdf/lib -L/home/aliabbasi/WRF/MET/g2clib-1.6.0 -L/usr/local/jasper_1.900.1/lib \
                -L/usr/local/hdfeos2_19.1/lib64 -L/usr/local/szip_2.1/lib64"

#export LIBS="-lhdf5 -lz -lnetcdf"
export jasper=/usr/local/jasper_1.900.1
export JASPERLIB=/usr/local/jasper_1.900.1/lib
export JASPERINC=/usr/local/jasper_1.900.1/include
export libpng=/usr/local/libpng_1.6.21

export NCARG_ROOT=/home/aliabbasi/WRF/NCL
PATH=/home/aliabbasi/WRF/NCL/bin:$PATH;export PATH

export WRFIO_NCD_LARGE_FILE_SUPPORT=1
export WRFPLUS_DIR=/home/aliabbasi/WRF/WRFPLUSV3
export WRFDA_DIR=/home/aliabbasi/WRF/WRFDA
#export RTTOV=/home/aliabbasi/WRF/RTTOV
export CRTM=1

# Environment Setting
unset MET_NETCDF
export MET_NETCDFINC=/usr/local/netcdf_MET/include
export MET_NETCDFLIB=/usr/local/netcdf_MET/lib64    # be careful: lib64 instead of lib. Please check the folder to be sure!

unset MET_BUFRLIBINC
unset MET_BUFR
export MET_BUFRLIB=/home/aliabbasi/WRF/MET/BUFRLIB

unset MET_GSL 
export MET_GSLLIB=/usr/local/GSL_1.11/lib64   # be careful: lib64 instead of lib. Please check the folder to be sure!
export MET_GSLINC=/usr/local/GSL_1.11/include

unset MET_GRIB2C
export MET_GRIB2CINC=/home/aliabbasi/WRF/MET/g2clib-1.6.0     
export MET_GRIB2CLIB=/home/aliabbasi/WRF/MET/g2clib-1.6.0

unset MET_HDF
export MET_HDFLIB='/usr/local/hdf4_2.11/lib64 -lsz'    # If you compiled HDF4 with-szlib you should have thsi option!
export MET_HDFINC=/usr/local/hdf4_2.11/include

unset MET_HDFEOS
export MET_HDFEOSINC=/home/aliabbasi/WRF/MET/hdfeos/include
export MET_HDFEOSLIB=/usr/local/hdfeos2_19.1/lib64                              # be careful: lib64 instead of lib. Please check the folder to be sure!

unset MET_CAIRO
export MET_CAIROLIB=/usr/local/cairo_1.14.6/lib64                                     # be careful: lib64 instead of lib. Please check the folder to be sure!
export MET_CAIROINC=/usr/local/cairo_1.14.6/include/cairo                       # be careful: include/cairo instead of include. Please check the folder to be sure!

unset MET_FREETYPE 
export MET_FREETYPELIB=/usr/local/freetype_2.6/lib64                          # be careful: lib64 instead of lib. Please check the folder to be sure!
export MET_FREETYPEINC=/usr/local/freetype_2.6/include/freetype2   # be careful: include/freetype instead of include. Please check the folder to be sure!

export MET_FONT_DIR=/home/aliabbasi/WRF/MET/fonts

export LD_LIBRARY_PATH=${HDF5}/lib:${zlib}/lib:${NetCDF}/lib:${MET_NETCDFLIB}
#=============================================================
# Downloading the Ghostscript fonts
wget https://sourceforge.net/projects/gs-fonts/files/latest/download?source=typ_redirect

# Configuring & Compiling MET_5.1
wget http://www.dtcenter.org/met/users/downloads/MET_releases/met-5.1.20151026.tar.gz
wget http://www.dtcenter.org/met/users/support/known_issues/METv5.1/patches/met-5.1_patches_20160616.tar.gz
#unpack the met-5.1 tarball.
#apply the met-5.1 patches.
#update the Makefiles with the ones that are attached here (in the way I describe below).
#run configure.
#run make install.
#vx_color.Makefile.in
#vx_config.Makefile.in
#Please take vx_color.Makefile.in, rename it to Makefile.in and place it in your src/libcode/vx_color/ directory, replacing the existing Makefile.in file.
#Please take vx_config.Makefile.in, rename it to Makefile.in and place it in your  src/basic/vx_config/ directory, replacing the existing Makefile.in file.
./configure  --prefix=/usr/local/MET_5.1 --enable-grib2 --enable-modis --enable-mode_graphics
sudo make install >& make_install.log 
tail -f make_install.log
# grep Error make_install.log
#More details: Source http://www.dtcenter.org/met/users/support/online_tutorial/METv5.0/compilation/compile.php



