;   Example script - read and plot data from WRF time series output
;   November 2008

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

 ; type = "x11"
 type = "png"
; type = "ps"
; type = "ncgm"
; __________________ TS data ______________________________
;id, ts_hour, id_tsloc, ix, iy, t, q, u, v, psfc, glw, gsw, hfx, lh, tsk, tslb(1), rainc, rainnc, clw
;id:		grid ID
;ts_hour:	forecast time in hours
;id_tsloc:	time series ID
;ix,iy:		grid location (nearest grid to the station)
;t:		2 m Temperature (K)
;q:		2 m vapor mixing ratio (kg/kg)
;u:		10 m U wind (earth-relative)
;v:		10 m V wind (earth-relative)
;psfc:		surface pressure (Pa)
;glw:		downward longwave radiation flux at the ground (W/m^2, downward is positive)
;gsw:		net shortwave radiation flux at the ground (W/m^2, downward is positive)
;hfx:		surface sensible heat flux (W/m^2, upward is positive)
;lh:		surface latent heat flux (W/m^2, upward is positive)
;tsk:		skin temperature (K)
;tslb(1):	top soil layer temperature (K)
;rainc:		rainfall from a cumulus scheme (mm)
;rainnc:		rainfall from an explicit scheme (mm)
;clw:		total column-integrated water vapor and cloud variables
; --------------------------------------------------------------------------------------
  wks_T2 = gsn_open_wks(type,"Graphs/TS/plt_T2_ts")       ; Create a plot workstation for Temperature at 
  wks_q2 = gsn_open_wks(type,"Graphs/TS/plt_q2_ts")       ; Create a plot workstation for 2 m vapor mixing ratio (kg/kg)
  wks_u10 = gsn_open_wks(type,"Graphs/TS/plt_u10_ts")       ; Create a plot workstation for 10 m U wind (earth-relative)
  wks_v10 = gsn_open_wks(type,"Graphs/TS/plt_v10_ts")       ; Create a plot workstation for 10 m V wind (earth-relative)
  wks_psfc = gsn_open_wks(type,"Graphs/TS/plt_psfc_ts")       ; Create a plot workstation for surface pressure (Pa)
  wks_glw = gsn_open_wks(type,"Graphs/TS/plt_glw_ts")       ; Create a plot workstation for downward longwave radiation flux at the ground (W/m^2, downward is positive)
  wks_gsw = gsn_open_wks(type,"Graphs/TS/plt_gsw_ts")       ; Create a plot workstation for net shortwave radiation flux at the ground (W/m^2, downward is positive)
  wks_hfx = gsn_open_wks(type,"Graphs/TS/plt_hfx_ts")       ; Create a plot workstation for surface sensible heat flux (W/m^2, upward is positive)
  wks_lh = gsn_open_wks(type,"Graphs/TS/plt_lh_ts")       ; Create a plot workstation for surface latent heat flux (W/m^2, upward is positive)
  wks_tsk = gsn_open_wks(type,"Graphs/TS/plt_tsk_ts")       ; Create a plot workstation for skin temperature (K)
  wks_tslb = gsn_open_wks(type,"Graphs/TS/plt_tslb_ts")       ; Create a plot workstation for top soil layer temperature (K)
  wks_rainc = gsn_open_wks(type,"Graphs/TS/plt_rainc_ts")       ; Create a plot workstation for rainfall from a cumulus scheme (mm)
  wks_rainnc = gsn_open_wks(type,"Graphs/TS/plt_rainnc_ts")       ; Create a plot workstation for rainfall from an explicit scheme (mm)
  wks_clw = gsn_open_wks(type,"Graphs/TS/plt_clw_ts")       ; Create a plot workstation for total column-integrated water vapor and cloud variables
;------------------------------------------------------------------------------------
  DATADir = "../WRF/"
  FILES = systemfunc (" ls -1 " + DATADir + "*.TS")
  print (FILES)
  numFILES = dimsizes(FILES)
  ;print (numFILES)
  do ifil = 0,numFILES-1
    print (ifil)
    data = readAsciiTable(FILES(ifil), 19, "float", 1)   ; read the data file
   ; print (data)
  ;end do
    res = True
    res@gsnMaximize       = True      ; Maximize plot in frame
    res@gsnDraw           = True     ; Don't draw plot
    res@gsnFrame          = True     ; Don't advance the frame

    res@tmXTOn         = False        
    res@xyLineThicknesses = 2        
    res@xyLineColor    =  "red"   
    ;------------------------------------------------------------------------
    res@tiYAxisString = "2m Temperature [C]"
    res@tiXAxisString = "Time[hr]"
    name=stringtofloat(str_get_cols(FILES(ifil),7,8))
    res@tiMainString = "Temperature @ " + name
    plot  = gsn_csm_xy(wks_T2,data(:,1),data(:,5)-273.15,res)    ; we know column 2 is time and column 6 is T2
    ;---------------------------------------------------------------------------------------------------
    res@tiYAxisString = "2m vapor mixing ratio [kg/kg]"
    res@tiXAxisString = "Time[hr]"
    res@tiMainString = "Vapor Mixing Ratio @" + name
    plot  = gsn_csm_xy(wks_q2,data(:,1),data(:,6),res)    ; we know column 2 is time and column 7 is q2
    ;---------------------------------------------------------------------------------------------------
    res@tiYAxisString = "10 m U wind (earth-relative)"
    res@tiXAxisString = "Time[hr]"
    res@tiMainString = "u10 @ " + name
    plot  = gsn_csm_xy(wks_u10,data(:,1),data(:,7),res)    ; we know column 2 is time and column 8 is u10
    ;---------------------------------------------------------------------------------------------------
    res@tiYAxisString = "10 m V wind (earth-relative)"
    res@tiXAxisString = "Time[hr]"
    res@tiMainString = "v10 @ " + name
    plot  = gsn_csm_xy(wks_v10,data(:,1),data(:,8),res)    ; we know column 2 is time and column 9 is v10
    ;---------------------------------------------------------------------------------------------------
    res@tiYAxisString = "Surface Pressure [Pa]"
    res@tiXAxisString = "Time[hr]"
    res@tiMainString = "Surface Pressure @  " + name
    plot  = gsn_csm_xy(wks_psfc,data(:,1),data(:,9),res)    ; we know column 2 is time and column 10 is surface pressure (Pa)
    ;---------------------------------------------------------------------------------------------------
    res@tiYAxisString    = "Downward Longwave Radiation[Wm-2]"    ; y-axis label   
    res@tiXAxisString = "Time[hr]"
    res@tiMainString = "Downward Longwave Radiation @ " + name
    plot  = gsn_csm_xy(wks_glw,data(:,1),data(:,10),res)    ; we know column 2 is time and column 11 downward longwave radiation flux at the ground (W/m^2, downward is positive)
    ;---------------------------------------------------------------------------------------------------
     res@tiYAxisString    = "Net Shortwave Radiation [Wm-2]"    ; y-axis label  
    res@tiXAxisString = "Time[hr]"
    res@tiMainString = "Net Shortwave Radiation @" + name
    plot  = gsn_csm_xy(wks_gsw,data(:,1),data(:,11),res)    ; we know column 2 is time and column 12 net shortwave radiation flux at the ground (W/m^2, downward is positive)
    ;---------------------------------------------------------------------------------------------------
    res@tiYAxisString = "Surface Sensible Heat Flux [Wm-2]"
    res@tiXAxisString = "Time[hr]"
    res@tiMainString = "Surface Sensible Heat @   " + name
    plot  = gsn_csm_xy(wks_hfx,data(:,1),data(:,12),res)    ; we know column 2 is time and column 13 surface sensible heat flux (W/m^2, upward is positive)
    ;---------------------------------------------------------------------------------------------------
    res@tiYAxisString = "Surface Latent Heat Flux [Wm-2]"
    res@tiXAxisString = "Time[hr]"   
    res@tiMainString = "Surface Latent Heat @ " + name
    plot  = gsn_csm_xy(wks_lh,data(:,1),data(:,13),res)    ; we know column 2 is time and column 14 surface latent heat flux (W/m^2, upward is positive)
    ;---------------------------------------------------------------------------------------------------
    res@tiYAxisString = "Skin Temperature [C]"
    res@tiXAxisString = "Time[hr]"    
    res@tiMainString = "Skin Temperature @" + name
    plot  = gsn_csm_xy(wks_tsk,data(:,1),data(:,14)-273.15,res)    ; we know column 2 is time and column 15 skin temperature (K)
    ;---------------------------------------------------------------------------------------------------
    res@tiYAxisString = "Top Soil Layer Temperature [C]"
    res@tiXAxisString = "Time[hr]"
    res@tiMainString = "Top Soil Layer Temperature @ " + name
    plot  = gsn_csm_xy(wks_tslb,data(:,1),data(:,15)-273.15,res)    ; we know column 2 is time and column 16 top soil layer temperature (K)
    ;---------------------------------------------------------------------------------------------------
    res@tiYAxisString = "Rainfall From a Cumulus Scheme [mm]"
    res@tiXAxisString = "Time[hr]" 
    res@tiMainString = "Rainfall From a Cumulus Scheme @" + name
    plot  = gsn_csm_xy(wks_rainc,data(:,1),data(:,16),res)    ; we know column 2 is time and column 17 rainfall from a cumulus scheme (mm)
    ;---------------------------------------------------------------------------------------------------
    res@tiYAxisString = "Rainfall From an Explicit Scheme [mm]"
    res@tiXAxisString = "Time[hr]"
    res@tiMainString = "Rainfall From an Explicit Scheme @" + name
    plot  = gsn_csm_xy(wks_rainnc,data(:,1),data(:,17),res)    ; we know column 2 is time and column 18  rainfall from an explicit scheme (mm)
    ;---------------------------------------------------------------------------------------------------
    res@tiYAxisString = "total column-integrated water vapor and cloud variables"
    res@tiXAxisString = "Time[hr]"
    res@tiMainString = "@ " + name
    plot  = gsn_csm_xy(wks_clw,data(:,1),data(:,18),res)    ; we know column 2 is time and column 19 total column-integrated water vapor and cloud variables
        
  end do 
  
end
