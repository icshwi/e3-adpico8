

# iocshLoad "$(TOP)/iocStats.cmd" "UNIT=1,DEVPATH=/dev/amc_pico_0000:05:00.0,PREFIX=$(PREFIX),QSIZE=$(QSIZE),XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(NCHANS),TSPOINTS=$(TSPOINTS),CBUFFS=$(CBUFFS),NELEMENTS=$(NELEMENTS)",

epicsEnvSet("PORT_PICO", "PICO8_$(UNIT)")
epicsEnvSet("NUMPOINTS", "$(YSIZE)")
epicsEnvSet("DATATYPE", 6)
epicsEnvSet("MAXBUFFERS", 0)
epicsEnvSet("MAXMEMORY", 0)
epicsEnvSet("PRIORITY", 0)
epicsEnvSet("STACKSIZE", 0)

epicsEnvSet("DBTOP", "$(DB_TOP)")
epicsEnvSet("CMDTOP", "$(CMD_TOP)")


Pico8Configure("$(PORT_PICO)", "$(DEVPATH)", "$(NUMPOINTS)", "$(DATATYPE)", "$(MAXBUFFERS)", "$(MAXMEMORY)", "$(PRIORITY)", "$(STACKSIZE)")


#-http://cars9.uchicago.edu/software/epics/NDPluginStdArrays.html
NDStdArraysConfigure("Image$(UNIT)", 3, 0, "$(PORT_PICO)", 0)
# Why NDStdSArraysConfigure has 3 queuesize instead of QSIZE (20)? 
#-http://cars9.uchicago.edu/software/epics/NDPluginTimeSeries.html
#TS$(UNIT) is defined in substitutions
NDTimeSeriesConfigure("TS$(UNIT)", "$(QSIZE)", 0, "$(PORT_PICO)", 0, 8)


# FFT$(UNIT)-N are defined in substitutions
NDFFTConfigure("FFT$(UNIT)-1", "$(QSIZE)", 0, "TS$(UNIT)", 0)
NDFFTConfigure("FFT$(UNIT)-2", "$(QSIZE)", 0, "TS$(UNIT)", 1)
NDFFTConfigure("FFT$(UNIT)-3", "$(QSIZE)", 0, "TS$(UNIT)", 2)
NDFFTConfigure("FFT$(UNIT)-4", "$(QSIZE)", 0, "TS$(UNIT)", 3)
NDFFTConfigure("FFT$(UNIT)-5", "$(QSIZE)", 0, "TS$(UNIT)", 4)
NDFFTConfigure("FFT$(UNIT)-6", "$(QSIZE)", 0, "TS$(UNIT)", 5)
NDFFTConfigure("FFT$(UNIT)-7", "$(QSIZE)", 0, "TS$(UNIT)", 6)
NDFFTConfigure("FFT$(UNIT)-8", "$(QSIZE)", 0, "TS$(UNIT)", 7)


dbLoadTemplate("$(DBTOP)/amc-pico8-ess.substitutions", "PREF=$(PREFIX),UNIT=$(UNIT),PICO_DEV=$(PORT_PICO),TOUT=1,N_ELEMENTS=$(NELEMENTS),TS_POINTS=$(TSPOINTS)")

## Common Plugins for PICO_1
iocshLoad "$(CMDTOP)/adpico8_commonPlugins.cmd" "PREFIX=$(PREFIX),UNIT=$(UNIT),PORT=$(PORT_PICO),QSIZE=$(QSIZE),XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(NCHANS),CBUFFS=$(CBUFFS)"
