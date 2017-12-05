/*
  Additional tools for Minizip
  Code: Xavier Roche '2004
  License: Same as ZLIB (www.gzip.org)
*/

#ifndef CSIIMADP__zip_tools_H
#define CSIIMADP__zip_tools_H

#ifdef __cplusplus
extern "C" {
#endif

#ifndef CSIIMADP__ZLIB_H
#include "zlib.h"
#endif

#include "CSIIMADPunzip.h"

/* Repair a ZIP file (missing central directory) 
   file: file to recover
   fileOut: output file after recovery
   fileOutTmp: temporary file name used for recovery
*/
extern int ZEXPORT unzRepair(const char* file, 
                             const char* fileOut, 
                             const char* fileOutTmp, 
                             uLong* nRecovered,
                             uLong* bytesRecovered);

#endif
