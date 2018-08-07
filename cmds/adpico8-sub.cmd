require adpico8,1.0.0-rc1
require busy,1.7.0
require calc,3.7.0
require autosave,5.9.0
require iocStats,1856ef5

epicsEnvSet("TOP", "$(E3_CMD_TOP)/..")
epicsEnvSet("DB_TOP", "$(TOP)/template")

epicsEnvSet("P", "JPARC")
epicsEnvSet("R", "APTM")
epicsEnvSet("IOC", "$(P)-$(R)")

epicsEnvSet("PREFIX", "$(IOC):")
    
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

# Create a pico8 driver
# Pico8Configure(const char *portName, const char *devicePath, 
#             int numPoints, int dataType,
#             int maxBuffers, int maxMemory,
#             int priority, int stackSize)
#dataType Initial data type of the detector data. These are the enum values for NDDataType_t, i.e.
#    0=NDInt8
#    1=NDUInt8
#    2=NDInt16
#    3=NDUInt16
#    4=NDInt32
#    5=NDUInt32
#    6=NDFloat32
#    7=NDFloat64
epicsEnvSet("PORT_1", "PICO8_1")
epicsEnvSet("PORT_2", "PICO8_2")
epicsEnvSet("PORT_3", "PICO8_3")

Pico8Configure("$(PORT_1)", "/dev/amc_pico_0000:05:00.0", $(YSIZE), 6, 0, 0, 0, 0)
Pico8Configure("$(PORT_2)", "/dev/amc_pico_0000:07:00.0", $(YSIZE), 6, 0, 0, 0, 0)
Pico8Configure("$(PORT_3)", "/dev/amc_pico_0000:08:00.0", $(YSIZE), 6, 0, 0, 0, 0)

# Image$(UNIT) is defined in substitutions
NDStdArraysConfigure("Image1", 3, 0, "$(PORT_1)", 0)
NDStdArraysConfigure("Image2", 3, 0, "$(PORT_2)", 0)
NDStdArraysConfigure("Image3", 3, 0, "$(PORT_3)", 0)

# TS$(UNIT) is defined in substitutions
NDTimeSeriesConfigure("TS1", $(QSIZE), 0, "$(PORT_1)", 0, 8)
NDTimeSeriesConfigure("TS2", $(QSIZE), 0, "$(PORT_2)", 0, 8)
NDTimeSeriesConfigure("TS3", $(QSIZE), 0, "$(PORT_3)", 0, 8)


# FFT$(UNIT)-N are defined in substitutions

NDFFTConfigure("FFT1-1", $(QSIZE), 0, "TS1", 0)
NDFFTConfigure("FFT1-2", $(QSIZE), 0, "TS1", 1)
NDFFTConfigure("FFT1-3", $(QSIZE), 0, "TS1", 2)
NDFFTConfigure("FFT1-4", $(QSIZE), 0, "TS1", 3)
NDFFTConfigure("FFT1-5", $(QSIZE), 0, "TS1", 4)
NDFFTConfigure("FFT1-6", $(QSIZE), 0, "TS1", 5)
NDFFTConfigure("FFT1-7", $(QSIZE), 0, "TS1", 6)
NDFFTConfigure("FFT1-8", $(QSIZE), 0, "TS1", 7)

NDFFTConfigure("FFT2-1", $(QSIZE), 0, "TS2", 0)
NDFFTConfigure("FFT2-2", $(QSIZE), 0, "TS2", 1)
NDFFTConfigure("FFT2-3", $(QSIZE), 0, "TS2", 2)
NDFFTConfigure("FFT2-4", $(QSIZE), 0, "TS2", 3)
NDFFTConfigure("FFT2-5", $(QSIZE), 0, "TS2", 4)
NDFFTConfigure("FFT2-6", $(QSIZE), 0, "TS2", 5)
NDFFTConfigure("FFT2-7", $(QSIZE), 0, "TS2", 6)
NDFFTConfigure("FFT2-8", $(QSIZE), 0, "TS2", 7)

NDFFTConfigure("FFT3-1", $(QSIZE), 0, "TS3", 0)
NDFFTConfigure("FFT3-2", $(QSIZE), 0, "TS3", 1)
NDFFTConfigure("FFT3-3", $(QSIZE), 0, "TS3", 2)
NDFFTConfigure("FFT3-4", $(QSIZE), 0, "TS3", 3)
NDFFTConfigure("FFT3-5", $(QSIZE), 0, "TS3", 4)
NDFFTConfigure("FFT3-6", $(QSIZE), 0, "TS3", 5)
NDFFTConfigure("FFT3-7", $(QSIZE), 0, "TS3", 6)
NDFFTConfigure("FFT3-8", $(QSIZE), 0, "TS3", 7)


dbLoadTemplate("$(DB_TOP)/amc-pico8-ess.substitutions", "PREFIX=$(PREFIX), UNIT=1, PORT=$(PORT_1), TIMEOUT=1, NELEMENTS=$(NELEMENTS), TSPOINTS=$(TSPOINTS)")
dbLoadTemplate("$(DB_TOP)/amc-pico8-ess.substitutions", "PREFIX=$(PREFIX), UNIT=2, PORT=$(PORT_2), TIMEOUT=1, NELEMENTS=$(NELEMENTS), TSPOINTS=$(TSPOINTS)")
dbLoadTemplate("$(DB_TOP)/amc-pico8-ess.substitutions", "PREFIX=$(PREFIX), UNIT=3, PORT=$(PORT_3), TIMEOUT=1, NELEMENTS=$(NELEMENTS), TSPOINTS=$(TSPOINTS)")

## Load all other plugins using commonPlugins.cmd
< $(TOP)/cmds/adpico8_commonPlugins.cmd



# P, R, IOC should be defined
< $(TOP)/cmds/save_restore_before_init.cmd


iocInit()

# P, R, IOC should be defined
< $(TOP)/cmds/save_restore_after_init.cmd


dbl > "$(TOP)/$(P)_$(R)_PVs.list"

# save things every thirty seconds
#create_monitor_set("auto_settings.req", 30, "P=$(PREFIX)")

