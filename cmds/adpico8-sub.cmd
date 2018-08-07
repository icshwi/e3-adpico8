require adpico8,1.0.0-rc1
require busy,1.7.0
require calc,3.7.0
require autosave,5.9.0
require iocStats,1856ef5


epicsEnvSet("TOP", "$(E3_CMD_TOP)/..")
epicsEnvSet("DB_TOP", "$(TOP)/template")

epicsEnvSet("P", "JPARC:")
epicsEnvSet("R", "APTM")
epicsEnvSet("IOC", "$(P)$(R)")

epicsEnvSet("PREFIX", "$(IOC):")

## IocStats
dbLoadRecords("iocAdminSoft.db", "IOC=$(IOC):IocStats")


# The queue size for all plugins
epicsEnvSet("QSIZE",  "20")
# The maximim image width; used for row profiles in the NDPluginStats plugin
epicsEnvSet("XSIZE",  "8")
# The maximim image height; used for column profiles in the NDPluginStats plugin
epicsEnvSet("YSIZE",  "100000")
# The maximum number of time series points in the NDPluginTimeSeries plugin
epicsEnvSet("TSPOINTS", "2048")
# The maximum number of time series points in the NDPluginStats plugin
# epicsEnvSet("NCHANS", "2048")
# NCHANS is internally replaced with TSPOINTS
# The maximum number of frames buffered in the NDPluginCircularBuff plugin
epicsEnvSet("CBUFFS", "500")
# This creates a waveform large enough for 100000x8 arrays.
epicsEnvSet("NELEMENTS", "800000")

epicsEnvSet("EPICS_CA_MAX_ARRAY_BYTES", "10000000")

epicsEnvSet("PICO_1", "PICO8_1")
epicsEnvSet("PICO_2", "PICO8_2")
epicsEnvSet("PICO_3", "PICO8_3")
#
# Pico8Configure(const char *portName, const char *devicePath, int numPoints, int dataType, int maxBuffers, int maxMemory, int priority, int stackSize)
# 6=NDFloat32
Pico8Configure("$(PICO_1)", "/dev/amc_pico_0000:05:00.0", $(YSIZE), 6, 0, 0, 0, 0)
Pico8Configure("$(PICO_2)", "/dev/amc_pico_0000:07:00.0", $(YSIZE), 6, 0, 0, 0, 0)
Pico8Configure("$(PICO_3)", "/dev/amc_pico_0000:08:00.0", $(YSIZE), 6, 0, 0, 0, 0)

# Image$(UNIT) is defined in substitutions
NDStdArraysConfigure("Image1", 3, 0, "$(PICO_1)", 0)
NDStdArraysConfigure("Image2", 3, 0, "$(PICO_2)", 0)
NDStdArraysConfigure("Image3", 3, 0, "$(PICO_3)", 0)

# TS$(UNIT) is defined in substitutions
NDTimeSeriesConfigure("TS1", $(QSIZE), 0, "$(PICO_1)", 0, 8)
NDTimeSeriesConfigure("TS2", $(QSIZE), 0, "$(PICO_2)", 0, 8)
NDTimeSeriesConfigure("TS3", $(QSIZE), 0, "$(PICO_3)", 0, 8)


# FFT$(UNIT)N are defined in substitutions

NDFFTConfigure("FFT11", $(QSIZE), 0, "TS1", 0)
NDFFTConfigure("FFT12", $(QSIZE), 0, "TS1", 1)
NDFFTConfigure("FFT13", $(QSIZE), 0, "TS1", 2)
NDFFTConfigure("FFT14", $(QSIZE), 0, "TS1", 3)
NDFFTConfigure("FFT15", $(QSIZE), 0, "TS1", 4)
NDFFTConfigure("FFT16", $(QSIZE), 0, "TS1", 5)
NDFFTConfigure("FFT17", $(QSIZE), 0, "TS1", 6)
NDFFTConfigure("FFT18", $(QSIZE), 0, "TS1", 7)

NDFFTConfigure("FFT21", $(QSIZE), 0, "TS2", 0)
NDFFTConfigure("FFT22", $(QSIZE), 0, "TS2", 1)
NDFFTConfigure("FFT23", $(QSIZE), 0, "TS2", 2)
NDFFTConfigure("FFT24", $(QSIZE), 0, "TS2", 3)
NDFFTConfigure("FFT25", $(QSIZE), 0, "TS2", 4)
NDFFTConfigure("FFT26", $(QSIZE), 0, "TS2", 5)
NDFFTConfigure("FFT27", $(QSIZE), 0, "TS2", 6)
NDFFTConfigure("FFT28", $(QSIZE), 0, "TS2", 7)

NDFFTConfigure("FFT31", $(QSIZE), 0, "TS3", 0)
NDFFTConfigure("FFT32", $(QSIZE), 0, "TS3", 1)
NDFFTConfigure("FFT33", $(QSIZE), 0, "TS3", 2)
NDFFTConfigure("FFT34", $(QSIZE), 0, "TS3", 3)
NDFFTConfigure("FFT35", $(QSIZE), 0, "TS3", 4)
NDFFTConfigure("FFT36", $(QSIZE), 0, "TS3", 5)
NDFFTConfigure("FFT37", $(QSIZE), 0, "TS3", 6)
NDFFTConfigure("FFT38", $(QSIZE), 0, "TS3", 7)


dbLoadTemplate("$(DB_TOP)/amc-pico8-ess.substitutions", "PREF=$(PREFIX),UNIT=1,PICO_DEV=$(PICO_1),TOUT=1,N_ELEMENTS=$(NELEMENTS),TS_POINTS=$(TSPOINTS)")
dbLoadTemplate("$(DB_TOP)/amc-pico8-ess.substitutions", "PREF=$(PREFIX),UNIT=2,PICO_DEV=$(PICO_2),TOUT=1,N_ELEMENTS=$(NELEMENTS),TS_POINTS=$(TSPOINTS)")
dbLoadTemplate("$(DB_TOP)/amc-pico8-ess.substitutions", "PREF=$(PREFIX),UNIT=3,PICO_DEV=$(PICO_3),TOUT=1,N_ELEMENTS=$(NELEMENTS),TS_POINTS=$(TSPOINTS)")

##
## 
## Common Plugins for PICO_1
iocshLoad "$(TOP)/cmds/adpico8_commonPlugins.cmd" "UNIT=1,PREFIX=$(PREFIX),PORT=$(PICO_1),QSIZE=$(QSIZE),XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(TSPOINTS),CBUFFS=$(CBUFFS)"

##
##
##Common Plugins for PICO_2
iocshLoad "$(TOP)/cmds/adpico8_commonPlugins.cmd" "UNIT=2,PREFIX=$(PREFIX),PORT=$(PICO_2),QSIZE=$(QSIZE),XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(TSPOINTS),CBUFFS=$(CBUFFS)"

##
##
##Common Plugins for PICO_3
iocshLoad "$(TOP)/cmds/adpico8_commonPlugins.cmd" "UNIT=3,PREFIX=$(PREFIX),PORT=$(PICO_3),QSIZE=$(QSIZE),XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(TSPOINTS),CBUFFS=$(CBUFFS)"


#-#
#-#
#-# AutoSave before INIT :  P, R, IOC should be defined
< $(TOP)/cmds/save_restore_before_init.cmd



iocInit()

#-#
#-#
#-# AutoSave after INIT :  P, R, IOC should be defined
< $(TOP)/cmds/save_restore_after_init.cmd


dbl > "$(TOP)/$(P)$(R)_PVs.list"


