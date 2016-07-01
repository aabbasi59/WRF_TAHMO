#!/bin/ksh -aeux
#########################################################################
# Script: wrapper_run_gsi_psot.ksh
#
# Purpose: Wrapper for WPS 
#
# Author:  Syed RH Rizvi, MMM/ESSL/NCAR,  Date:04/15/2009
#########################################################################
#export PROJECT=48503002   #DATC ????????????


#export WALLCLOCK=5	#?????????????????
#export QUEUE=premium	#?????????????????
#export NUM_PROCS=8 
set echo
#------------------------------------------------------------------------
# Having run psot set follwing variable true to draw plots, 
# otherwise set it to false                                 
#
#export RUN_PLOT_PSOT=true  
#------------------------------------------------------------------------

export REGION=volta
export EXPT=24hforecast
#Directories:
export        DAT_DIR=/home/camille/DATA        
export        REG_DIR=$DAT_DIR/$REGION              
#export        RC_DIR=$REG_DIR/rc
#export        OB_DIR=$REG_DIR/ob
export	      WPS_DIR=/home/camille/Build_WRF/WPS
export 		REL_DIR=/home/camille/Build_WRF



#export	      RUN_DIR=/home/camille/WRF_TAHMO/wps
#export		RUN_DIR=$REG_DIR/$EXPT/wps
export		RUN_DIR_g=$REG_DIR/$EXPT
export        SCRIPTS_DIR=/home/camille/WRF_TAHMO

#export		RUN_CMD="mpirun -np 6"
export		NUM_PROCS=4
export		SUBMIT=none


#rm -rf $RUN_DIR_g

#-------------------------------------------------------------------------
#Time info
export DATE=2006072300
export INITIAL_DATE=2006072300
#export   FINAL_DATE=2006072400	#$INITIAL_DATE
export	FCST_RANGE=24
export	LBC_FREQ=6	#default value


#-------------------------------------------------------------------------


#---------------------------RUNNING WPS----------------------------------------------


export MAX_DOMAINS=3
export DOMAINS=01,02,03
export NL_E_WE=163,184,184
export NL_E_SN=163,217,280
export NL_E_VERT=51,51,51
export PARENT_ID=1,1,2
export PARENT_GRID_RATIO=1,3,3
export I_PARENT_START=1,51,91
export J_PARENT_START=1,21,31
export MAP_PROJ=lambert
export REF_LAT=16.0
export REF_LON=-2.0
export TRUELAT1=16.0
export TRUELAT2=-2.0
export STAND_LON=-2.0
export NL_DX=27000
export NL_DY=27000

export GEOG_DATA_RES=default
#export WPS_GEOG_DIR=/home/camille/Build_WRF/WPS_GEOG
#export VTABLE_TYPE=GFS
#export METGRID_TABLE_TYPE=ARW



export RUN_DIR=$RUN_DIR_g/wps
rm -rf $RUN_DIR

./da_run_wps.ksh

#-------------------------RUNNING real------------------------------------------------
#export WRF_DIR=/home/camille/Build_WRF/WRFV3

export RUN_DIR=$RUN_DIR_g/real
rm -rf $RUN_DIR

./da_run_real.ksh

#-------------------------------------------------------------------------
