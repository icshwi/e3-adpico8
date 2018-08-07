#
#-## In order to use the precise VARIABLES, it is highly recommended to use the following rule in ioc startup script
#-## epicsEnvSet("PREFIX" "example")
#-## epicsEnvSet("QSIZE",  "20")
#-## epicsEnvSet("XSIZE",  "8")
#-## epicsEnvSet("YSIZE",  "100000")
#-## epicsEnvSet("TSPOINTS", "2048")
#-## epicsEnvSet("NCHANS", "2048")
#-## epicsEnvSet("CBUFFS", "500")
#-## iocshLoad "$(TOP)/cmds/adpico8_commonPlugins.cmd" "UNIT=1,PREFIX=$(PREFIX),PORT=$(PICO_1),QSIZE=$(QSIZE),XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(TSPOINTS),CBUFFS=$(CBUFFS)"
#-## iocshLoad "$(TOP)/cmds/adpico8_commonPlugins.cmd" "UNIT=2,PREFIX=$(PREFIX),PORT=$(PICO_2),QSIZE=$(QSIZE),XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(TSPOINTS),CBUFFS=$(CBUFFS)"

#- $(UNIT)        If an IOC has more than one PORT, $(UNIT) is used to identified w.r.t $(PORT)
#- $(PREFIX)      Prefix for all records
#- $(PORT)        The port name for the detector.  In autosave.
#- $(QSIZE)       The queue size for all plugins.  In autosave.
#- $(XSIZE)       The maximum image width; used to set the maximum size for row profiles in the NDPluginStats plugin and 1-D FFT
#-                   profiles in NDPluginFFT.
#- $(YSIZE)       The maximum image height; used to set the maximum size for column profiles in the NDPluginStats plugin
#- $(NCHANS)      The maximum number of time series points in the NDPluginStats, NDPluginROIStats, and NDPluginAttribute plugins
#- $(CBUFFS)      The maximum number of frames buffered in the NDPluginCircularBuff plugin
#- $(MAX_THREADS) The maximum number of threads for plugins which can run in multiple threads. Defaults to 5.
#
#
#
# Create a netCDF file saving plugin
NDFileNetCDFConfigure("FileNetCDF$(UNIT)", $(QSIZE), 0, "$(PORT)", 0)
dbLoadRecords("NDFileNetCDF.template","P=$(PREFIX),R=netCDF$(UNIT):,PORT=FileNetCDF$(UNIT),ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")

# Create a TIFF file saving plugin
NDFileTIFFConfigure("FileTIFF$(UNIT)", $(QSIZE), 0, "$(PORT)", 0)
dbLoadRecords("NDFileTIFF.template",  "P=$(PREFIX),R=TIFF$(UNIT):,PORT=FileTIFF$(UNIT),ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")

# Create a JPEG file saving plugin
NDFileJPEGConfigure("FileJPEG$(UNIT)", $(QSIZE), 0, "$(PORT)", 0)
dbLoadRecords("NDFileJPEG.template",  "P=$(PREFIX),R=JPEG$(UNIT):,PORT=FileJPEG$(UNIT),ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")

# Create a NeXus file saving plugin
NDFileNexusConfigure("FileNexus$(UNIT)", $(QSIZE), 0, "$(PORT)", 0)
dbLoadRecords("NDFileNexus.template", "P=$(PREFIX),R=Nexus$(UNIT):,PORT=FileNexus$(UNIT),ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")

# Create an HDF5 file saving plugin
NDFileHDF5Configure("FileHDF$(UNIT)", $(QSIZE), 0, "$(PORT)", 0)
dbLoadRecords("NDFileHDF5.template",  "P=$(PREFIX),R=HDF$(UNIT):,PORT=FileHDF$(UNIT),ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")

# Create a Magick file saving plugin
#NDFileMagickConfigure("FileMagick$(UNIT)", $(QSIZE), 0, "$(PORT)", 0)
#dbLoadRecords("NDFileMagick.template","P=$(PREFIX),R=Magick$(UNIT):,PORT=FileMagick$(UNIT),ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")

# Create 4 ROI plugins
NDROIConfigure("ROI$(UNIT)1", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDROI.template",       "P=$(PREFIX),R=ROI$(UNIT)1:,  PORT=ROI$(UNIT)1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")
NDROIConfigure("ROI$(UNIT)2", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDROI.template",       "P=$(PREFIX),R=ROI$(UNIT)2:,  PORT=ROI$(UNIT)2,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")
NDROIConfigure("ROI$(UNIT)3", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDROI.template",       "P=$(PREFIX),R=ROI$(UNIT)3:,  PORT=ROI$(UNIT)3,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")
NDROIConfigure("ROI$(UNIT)4", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDROI.template",       "P=$(PREFIX),R=ROI$(UNIT)4:,  PORT=ROI$(UNIT)4,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")

# Create 8 ROIStat plugins
NDROIStatConfigure("ROISTAT$(UNIT)", $(QSIZE), 0, "$(PORT)", 0, 8, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDROIStat.template",   "P=$(PREFIX),R=ROIStat$(UNIT):  ,PORT=ROISTAT$(UNIT),ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NCHANS=$(NCHANS)")
dbLoadRecords("NDROIStatN.template",  "P=$(PREFIX),R=ROIStat$(UNIT):1:,PORT=ROISTAT$(UNIT),ADDR=0,TIMEOUT=1,NCHANS=$(NCHANS)")
dbLoadRecords("NDROIStatN.template",  "P=$(PREFIX),R=ROIStat$(UNIT):2:,PORT=ROISTAT$(UNIT),ADDR=1,TIMEOUT=1,NCHANS=$(NCHANS)")
dbLoadRecords("NDROIStatN.template",  "P=$(PREFIX),R=ROIStat$(UNIT):3:,PORT=ROISTAT$(UNIT),ADDR=2,TIMEOUT=1,NCHANS=$(NCHANS)")
dbLoadRecords("NDROIStatN.template",  "P=$(PREFIX),R=ROIStat$(UNIT):4:,PORT=ROISTAT$(UNIT),ADDR=3,TIMEOUT=1,NCHANS=$(NCHANS)")
dbLoadRecords("NDROIStatN.template",  "P=$(PREFIX),R=ROIStat$(UNIT):5:,PORT=ROISTAT$(UNIT),ADDR=4,TIMEOUT=1,NCHANS=$(NCHANS)")
dbLoadRecords("NDROIStatN.template",  "P=$(PREFIX),R=ROIStat$(UNIT):6:,PORT=ROISTAT$(UNIT),ADDR=5,TIMEOUT=1,NCHANS=$(NCHANS)")
dbLoadRecords("NDROIStatN.template",  "P=$(PREFIX),R=ROIStat$(UNIT):7:,PORT=ROISTAT$(UNIT),ADDR=6,TIMEOUT=1,NCHANS=$(NCHANS)")
dbLoadRecords("NDROIStatN.template",  "P=$(PREFIX),R=ROIStat$(UNIT):8:,PORT=ROISTAT$(UNIT),ADDR=7,TIMEOUT=1,NCHANS=$(NCHANS)")


# Create a processing plugin
NDProcessConfigure("PROC$(UNIT)", $(QSIZE), 0, "$(PORT)", 0, 0, 0)
dbLoadRecords("NDProcess.template",   "P=$(PREFIX),R=Proc$(UNIT):,  PORT=PROC$(UNIT),ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")

# Create a scatter plugin
NDScatterConfigure("SCATTER$(UNIT)", $(QSIZE), 0, "$(PORT)", 0, 0, 0)
dbLoadRecords("NDScatter.template",   "P=$(PREFIX),R=Scatter$(UNIT):,  PORT=SCATTER$(UNIT),ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")

# Create a gather plugin with 8 ports
NDGatherConfigure("GATHER$(UNIT)", $(QSIZE), 0, 8, 0, 0)
dbLoadRecords("NDGather.template",    "P=$(PREFIX),R=Gather$(UNIT):,      PORT=GATHER$(UNIT),ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")
dbLoadRecords("NDGatherN.template",   "P=$(PREFIX),R=Gather$(UNIT):, N=1, PORT=GATHER$(UNIT),ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")
dbLoadRecords("NDGatherN.template",   "P=$(PREFIX),R=Gather$(UNIT):, N=2, PORT=GATHER$(UNIT),ADDR=1,TIMEOUT=1,NDARRAY_PORT=$(PORT)")
dbLoadRecords("NDGatherN.template",   "P=$(PREFIX),R=Gather$(UNIT):, N=3, PORT=GATHER$(UNIT),ADDR=2,TIMEOUT=1,NDARRAY_PORT=$(PORT)")
dbLoadRecords("NDGatherN.template",   "P=$(PREFIX),R=Gather$(UNIT):, N=4, PORT=GATHER$(UNIT),ADDR=3,TIMEOUT=1,NDARRAY_PORT=$(PORT)")
dbLoadRecords("NDGatherN.template",   "P=$(PREFIX),R=Gather$(UNIT):, N=5, PORT=GATHER$(UNIT),ADDR=4,TIMEOUT=1,NDARRAY_PORT=$(PORT)")
dbLoadRecords("NDGatherN.template",   "P=$(PREFIX),R=Gather$(UNIT):, N=6, PORT=GATHER$(UNIT),ADDR=5,TIMEOUT=1,NDARRAY_PORT=$(PORT)")
dbLoadRecords("NDGatherN.template",   "P=$(PREFIX),R=Gather$(UNIT):, N=7, PORT=GATHER$(UNIT),ADDR=6,TIMEOUT=1,NDARRAY_PORT=$(PORT)")
dbLoadRecords("NDGatherN.template",   "P=$(PREFIX),R=Gather$(UNIT):, N=8, PORT=GATHER$(UNIT),ADDR=7,TIMEOUT=1,NDARRAY_PORT=$(PORT)")

#
# Create 5 statistics plugins
NDStatsConfigure("STATS$(UNIT)1", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDStats.template","P=$(PREFIX),R=Stats$(UNIT)1:,PORT=STATS$(UNIT)1,ADDR=0,TIMEOUT=1,HIST_SIZE=256,XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(NCHANS),NDARRAY_PORT=$(PORT)")

NDStatsConfigure("STATS$(UNIT)2", $(QSIZE), 0, "ROI$(UNIT)1",    0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDStats.template","P=$(PREFIX),R=Stats$(UNIT)2:,PORT=STATS$(UNIT)2,ADDR=0,TIMEOUT=1,HIST_SIZE=256,XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(NCHANS),NDARRAY_PORT=$(PORT)")
NDStatsConfigure("STATS$(UNIT)3", $(QSIZE), 0, "ROI$(UNIT)2",    0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDStats.template","P=$(PREFIX),R=Stats$(UNIT)3:,PORT=STATS$(UNIT)3,ADDR=0,TIMEOUT=1,HIST_SIZE=256,XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(NCHANS),NDARRAY_PORT=$(PORT)")
NDStatsConfigure("STATS$(UNIT)4", $(QSIZE), 0, "ROI$(UNIT)3",    0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDStats.template","P=$(PREFIX),R=Stats$(UNIT)4:,PORT=STATS$(UNIT)4,ADDR=0,TIMEOUT=1,HIST_SIZE=256,XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(NCHANS),NDARRAY_PORT=$(PORT)")
NDStatsConfigure("STATS$(UNIT)5", $(QSIZE), 0, "ROI$(UNIT)4",    0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDStats.template","P=$(PREFIX),R=Stats$(UNIT)5:,PORT=STATS$(UNIT)5,ADDR=0,TIMEOUT=1,HIST_SIZE=256,XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(NCHANS),NDARRAY_PORT=$(PORT)")

#
# Create a transform plugin
NDTransformConfigure("TRANS$(UNIT)", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDTransform.template", "P=$(PREFIX),R=Trans$(UNIT):,PORT=TRANS$(UNIT),ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")


#
# Create an overlay plugin with 8 overlays
NDOverlayConfigure("OVER$(UNIT)", $(QSIZE), 0, "$(PORT)", 0, 8, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDOverlay.template", "P=$(PREFIX),R=Over$(UNIT):,PORT=OVER$(UNIT),ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")

dbLoadRecords("NDOverlayN.template","P=$(PREFIX),R=Over$(UNIT):1:,NAME=ROI1,SHAPE=1,O=Over$(UNIT):,XPOS=$(PREFIX)ROI1:MinX_RBV,YPOS=$(PREFIX)ROI1:MinY_RBV,XSIZE=$(PREFIX)ROI1:SizeX_RBV,YSIZE=$(PREFIX)ROI1:SizeY_RBV,PORT=OVER$(UNIT),ADDR=0,TIMEOUT=1")

dbLoadRecords("NDOverlayN.template","P=$(PREFIX),R=Over$(UNIT):2:,NAME=ROI2,SHAPE=1,O=Over$(UNIT):,XPOS=$(PREFIX)ROI2:MinX_RBV,YPOS=$(PREFIX)ROI2:MinY_RBV,XSIZE=$(PREFIX)ROI2:SizeX_RBV,YSIZE=$(PREFIX)ROI2:SizeY_RBV,PORT=OVER$(UNIT),ADDR=1,TIMEOUT=1")

dbLoadRecords("NDOverlayN.template","P=$(PREFIX),R=Over$(UNIT):3:,NAME=ROI3,SHAPE=1,O=Over$(UNIT):,XPOS=$(PREFIX)ROI3:MinX_RBV,YPOS=$(PREFIX)ROI3:MinY_RBV,XSIZE=$(PREFIX)ROI3:SizeX_RBV,YSIZE=$(PREFIX)ROI3:SizeY_RBV,PORT=OVER$(UNIT),ADDR=2,TIMEOUT=1")

dbLoadRecords("NDOverlayN.template","P=$(PREFIX),R=Over$(UNIT):4:,NAME=ROI4,SHAPE=1,O=Over$(UNIT):,XPOS=$(PREFIX)ROI4:MinX_RBV,YPOS=$(PREFIX)ROI4:MinY_RBV,XSIZE=$(PREFIX)ROI4:SizeX_RBV,YSIZE=$(PREFIX)ROI4:SizeY_RBV,PORT=OVER$(UNIT),ADDR=3,TIMEOUT=1")

dbLoadRecords("NDOverlayN.template","P=$(PREFIX),R=Over$(UNIT):5:,NAME=Cursor1,SHAPE=1,O=Over$(UNIT):,XPOS=junk,YPOS=junk,XSIZE=junk,YSIZE=junk,PORT=OVER$(UNIT),ADDR=4,TIMEOUT=1")
dbLoadRecords("NDOverlayN.template","P=$(PREFIX),R=Over$(UNIT):6:,NAME=Cursor2,SHAPE=1,O=Over$(UNIT):,XPOS=junk,YPOS=junk,XSIZE=junk,YSIZE=junk,PORT=OVER$(UNIT),ADDR=5,TIMEOUT=1")
dbLoadRecords("NDOverlayN.template","P=$(PREFIX),R=Over$(UNIT):7:,NAME=Box1,SHAPE=1,O=Over$(UNIT):,XPOS=junk,YPOS=junk,XSIZE=junk,YSIZE=junk,PORT=OVER$(UNIT),ADDR=6,TIMEOUT=1")
dbLoadRecords("NDOverlayN.template","P=$(PREFIX),R=Over$(UNIT):8:,NAME=Box2,SHAPE=1,O=Over$(UNIT):,XPOS=junk,YPOS=junk,XSIZE=junk,YSIZE=junk,PORT=OVER$(UNIT),ADDR=7,TIMEOUT=1")

#
# Create 2 color conversion plugins
NDColorConvertConfigure("CC$(UNIT)1", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDColorConvert.template","P=$(PREFIX),R=CC$(UNIT)1:,PORT=CC$(UNIT)1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")
NDColorConvertConfigure("CC$(UNIT)2", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDColorConvert.template","P=$(PREFIX),R=CC$(UNIT)2:,PORT=CC$(UNIT)2,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")

#
# Create a circular buffer plugin
NDCircularBuffConfigure("CB$(UNIT)", $(QSIZE), 0, "$(PORT)", 0, $(CBUFFS), 0)
dbLoadRecords("NDCircularBuff.template", "P=$(PREFIX),R=CB$(UNIT):,PORT=CB$(UNIT),ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")

#
# Create an NDAttribute plugin with 8 attributes
NDAttrConfigure("ATTR$(UNIT)", $(QSIZE), 0, "$(PORT)", 0, 8, 0, 0, 0)
dbLoadRecords("NDAttribute.template", "P=$(PREFIX),R=Attr$(UNIT):,PORT=ATTR$(UNIT),ADDR=0,TIMEOUT=1,NCHANS=$(NCHANS),NDARRAY_PORT=$(PORT)")
#
dbLoadRecords("NDAttributeN.template", "P=$(PREFIX),R=Attr$(UNIT):1:,PORT=ATTR$(UNIT),ADDR=0,TIMEOUT=1,NCHANS=$(NCHANS)")
dbLoadRecords("NDAttributeN.template", "P=$(PREFIX),R=Attr$(UNIT):2:,PORT=ATTR$(UNIT),ADDR=1,TIMEOUT=1,NCHANS=$(NCHANS)")
dbLoadRecords("NDAttributeN.template", "P=$(PREFIX),R=Attr$(UNIT):3:,PORT=ATTR$(UNIT),ADDR=2,TIMEOUT=1,NCHANS=$(NCHANS)")
dbLoadRecords("NDAttributeN.template", "P=$(PREFIX),R=Attr$(UNIT):4:,PORT=ATTR$(UNIT),ADDR=3,TIMEOUT=1,NCHANS=$(NCHANS)")
dbLoadRecords("NDAttributeN.template", "P=$(PREFIX),R=Attr$(UNIT):5:,PORT=ATTR$(UNIT),ADDR=4,TIMEOUT=1,NCHANS=$(NCHANS)")
dbLoadRecords("NDAttributeN.template", "P=$(PREFIX),R=Attr$(UNIT):6:,PORT=ATTR$(UNIT),ADDR=5,TIMEOUT=1,NCHANS=$(NCHANS)")
dbLoadRecords("NDAttributeN.template", "P=$(PREFIX),R=Attr$(UNIT):7:,PORT=ATTR$(UNIT),ADDR=6,TIMEOUT=1,NCHANS=$(NCHANS)")
dbLoadRecords("NDAttributeN.template", "P=$(PREFIX),R=Attr$(UNIT):8:,PORT=ATTR$(UNIT),ADDR=7,TIMEOUT=1,NCHANS=$(NCHANS)")
