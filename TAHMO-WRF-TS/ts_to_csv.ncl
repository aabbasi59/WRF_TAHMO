; Script to read time series of WRF and write them in a csv file

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
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
    ;------------------------------------------------------------------------------------
    DATADir = "../WRF/"
    FILES = systemfunc (" ls -1 " + DATADir + "*.TS")
    print (FILES)
    numFILES = dimsizes(FILES)
    ;print (numFILES)
    do ifil = 0,numFILES-1
        print (ifil)
        string_station_ID = readAsciiHead(FILES(ifil), 1)
        delim = " "
        nfields = str_fields_count(string_station_ID, delim)   ; Count the fields separated 
                                                                                                    ; by one or more spaces.
        print(nfields)                               ; nfields = 20
        print (strlen(string_station_ID))
        
        field =1 
        station_ID_01 = str_get_field(string_station_ID, field, delim)
        ;print (station_ID_01)
        
        station_ID = str_get_cols (station_ID_01, 2,10)
        print (station_ID)
        data = readAsciiTable(FILES(ifil), 19, "float", 1)   ; read the data file
        ; More details on string: http://www.ncl.ucar.edu/Document/Functions/Built-in/str_get_cols.shtml
        ; print (data)
        ;end do
  
        path_dir = "/run/media/aliabbasi/UserData/SyncronizingData/Dropbox/Ph.D_WorkFlows/Python_modelling/finalPythonCodes/inputData/WRF/WRF_TS/"
        csv_filename = path_dir + station_ID+".csv"    ; name of CSV file to create
        dq = str_get_dq()                ; double quote character

        ;---Create dummy mixed data to write to CSV file
        fields = (/"ts_hour", "t", "q", "u", "v", "psfc", "glw", "gsw", "hfx", "lh", "tsk", "tslb", "rainc", "rainnc", "clw"/)
        ;id    = data(:,0) 
        ; print (id)
        ts_hour = data(:,1)*3600.0
        ;id_tsloc = data(:,2)
        ; ix = data(:,3)
        ;iy = data(:,4)
        t = data(:,5)
        q = data(:,6)
        u = data(:,7)
        v = data(:,8)
        psfc = data(:,9)
        glw = data(:,10)
        gsw = data(:,11)
        hfx = data(:,12)
        lh = data(:,13)
        tsk = data(:,14)
        tslb = data(:,15)
        rainc = data(:,16)
        rainnc = data(:,17)
        clw = data(:,18)
  
        fields = dq + fields + dq                      ; Pre/append quotes to field names
        header = [/str_join(fields,",")/]              ; Header is field names separated by commas.

        alist  = [/ts_hour, t, q, u, v, psfc, glw, gsw, hfx, lh, tsk, tslb, rainc, rainnc, clw/]   ; List of variables to write.
        ;format = "%1d,%10.6f,%2.0i,%2.0i,%2.0i,%10.6f,%10.6f,%10.6f,%10.6f,%10.6f,%10.6f,%10.6f,%10.6f,%10.6f,%10.6f,%10.6f,%10.6f,%10.6f,%10.6f"          ; Format to use for each variable.
        format = "%g,%g,%g,%g,%g,%g,%g,%g,%g,%g,%g,%g,%g,%g,%g"          ; Format to use for each variable.
    
        ;; Note: if you don't want spaces in CSV file, use the following format string.
        ;; format = "%d,%g,%g,%g,%s,%d"

        system("rm -rf " + csv_filename)               ; Remove file in case it exists.

        ;write_table(csv_filename, "w", header, "%s")   ; Write header to CSV file.
        write_table(csv_filename, "a", alist, format)  ; Write mixed data to CSV file.

        ;---Echo the new file to the screen so you can see it.
        print("====== Contents of '" + csv_filename + "' ======")
        system("cat " + csv_filename)
        print("========================================")

    end do 
  
end
