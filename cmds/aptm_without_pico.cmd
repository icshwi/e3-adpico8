###
###
###>>
###>> Required Modules, Version
###>>
#require adpico8,testing
require busy,1.7.0
require calc,3.7.0
require autosave,5.9.0
require iocStats,1856ef5
require mrfioc2,2.2.0-rc2
### Motion
require ecmc,5.0.0
require ecmctraining,4.0.0
require EthercatMC,2.0.1
require stream, 2.7.7
###
###
###>>
###>> Environmet Variables
###>>
epicsEnvSet("ENGINEER","")
epicsEnvSet("LOCATION","")

epicsEnvSet("TOP", "$(E3_CMD_TOP)/..")
epicsEnvSet("DB_TOP", "$(TOP)/template")
epicsEnvSet("CMD_TOP", "$(E3_CMD_TOP)")

epicsEnvSet("IOCSTATS_CMD_TOP", "$(TOP)/../e3-iocStats/cmds")
epicsEnvSet("MRFIOC2_CMD_TOP", "$(TOP)/../e3-mrfioc2/cmds")
epicsEnvSet("AUTOSAVE_CMD_TOP", "$(TOP)/../e3-autosave/cmds")
epicsEnvSet("ECMC_STARTUP_TOP", "$(HOME)/ics_gitsrc/ecmctraining/startup/ecmcProject_jparc")

epicsEnvSet("P", "JPARC:")
epicsEnvSet("R", "APTM")
epicsEnvSet("IOC", "$(P)$(R)")
epicsEnvSet("PREFIX", "$(IOC):")


epicsEnvSet("QSIZE",  "20")
epicsEnvSet("XSIZE",  "8")
epicsEnvSet("YSIZE",  "100000")
epicsEnvSet("NCHANS", "2048")
epicsEnvSet("TSPOINTS", "2048")
epicsEnvSet("CBUFFS", "500")
epicsEnvSet("NELEMENTS", "800000")

epicsEnvSet("EPICS_CA_MAX_ARRAY_BYTES", "10000000")
###
###
###>>
###>> IocStats
###>>
iocshLoad "$(IOCSTATS_CMD_TOP)/iocStats.cmd" "IOC=$(IOC):IocStats"
###
###
###>>
###>> mrfioc2
###>>
iocshLoad "$(MRFIOC2_CMD_TOP)/mtca-evr-300u_bi-aptm.cmd" "UNIT=1, DEVPATH=06:00.0, IOC=$(IOC)"
###
###
###>>
###>> PICO8 #1
###>>
#iocshLoad "$(CMD_TOP)/pico8_n.cmd" "UNIT=1,DEVPATH=/dev/amc_pico_0000:05:00.0,DB_TOP=$(DB_TOP),CMD_TOP=$(CMD_TOP),PREFIX=$(PREFIX),QSIZE=$(QSIZE),XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(NCHANS),TSPOINTS=$(TSPOINTS),CBUFFS=$(CBUFFS),NELEMENTS=$(NELEMENTS)"
###
###
###>>
###>> PICO8 #2
###>>
#iocshLoad "$(CMD_TOP)/pico8_n.cmd" "UNIT=2,DEVPATH=/dev/amc_pico_0000:07:00.0,DB_TOP=$(DB_TOP),CMD_TOP=$(CMD_TOP),PREFIX=$(PREFIX),QSIZE=$(QSIZE),XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(NCHANS),TSPOINTS=$(TSPOINTS),CBUFFS=$(CBUFFS),NELEMENTS=$(NELEMENTS)"
###
###
###>>
###>> PICO8 #3
###>>
#iocshLoad "$(CMD_TOP)/pico8_n.cmd" "UNIT=3,DEVPATH=/dev/amc_pico_0000:08:00.0,DB_TOP=$(DB_TOP),CMD_TOP=$(CMD_TOP),PREFIX=$(PREFIX),QSIZE=$(QSIZE),XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(NCHANS),TSPOINTS=$(TSPOINTS),CBUFFS=$(CBUFFS),NELEMENTS=$(NELEMENTS)"
###
###
###>>
###>> AutoSave before INIT :  P, R, IOC should be defined
###>>
iocshLoad "$(AUTOSAVE_CMD_TOP)/save_restore_before_init.cmd" "P=$(P),R=$(R), IOC=$(IOC), AS_TOP=$(TOP)"
###
###
###
###
iocInit()
###
###
###>>
###>> AutoSave after INIT :  P, R, IOC should be defined
###>>
iocshLoad "$(AUTOSAVE_CMD_TOP)/save_restore_after_init.cmd" "P=$(P),R=$(R), IOC=$(IOC), AS_TOP=$(TOP)"

###
###
###>>
###>> mrfioc2
###>>
iocshLoad "$(MRFIOC2_CMD_TOP)/mtca-evr-300u_bi-aptm_after_init.cmd" "UNIT=1, IOC=$(IOC),CMD_TOP=$(MRFIOC2_CMD_TOP)"

#dbl > "$(TOP)/$(P)$(R)_PVs.list"
