/* ioapi.h -- IO base function header for compress/uncompress .zip
   files using zlib + zip or unzip API

   Version 1.01e, February 12th, 2005

   Copyright (C) 1998-2005 Gilles Vollant
*/

#ifndef CSIIMADPcrc__ZLIBIOAPI_H
#define CSIIMADPcrc__ZLIBIOAPI_H


#define CSIIMADPcrc_ZLIB_FILEFUNC_CSIIMADP_SEEK_CUR (1)
#define CSIIMADPcrc_ZLIB_FILEFUNC_CSIIMADP_SEEK_END (2)
#define CSIIMADPcrc_ZLIB_FILEFUNC_SEEK_SET (0)

#define CSIIMADPcrc_ZLIB_FILEFUNC_MODE_READ      (1)
#define CSIIMADPcrc_ZLIB_FILEFUNC_MODE_WRITE     (2)
#define CSIIMADPcrc_ZLIB_FILEFUNC_MODE_READWRITEFILTER (3)

#define CSIIMADPcrc_ZLIB_FILEFUNC_MODE_EXISTING (4)
#define CSIIMADPcrc_ZLIB_FILEFUNC_MODE_CREATE   (8)


#ifndef CSIIMADPcrc_ZCALLBACK

#if (defined(WIN32) || defined (WINDOWS) || defined (_WINDOWS)) && defined(CALLBACK) && defined (USEWINDOWS_CALLBACK)
#define CSIIMADPcrc_ZCALLBACK CALLBACK
#else
#define CSIIMADPcrc_ZCALLBACK
#endif
#endif

#ifdef __cplusplus
extern "C" {
#endif

typedef voidpf (CSIIMADPcrc_ZCALLBACK *open_file_func) OF((voidpf opaque, const char* filename, int mode));
typedef uLong  (CSIIMADPcrc_ZCALLBACK *read_file_func) OF((voidpf opaque, voidpf stream, void* buf, uLong size));
typedef uLong  (CSIIMADPcrc_ZCALLBACK *write_file_func) OF((voidpf opaque, voidpf stream, const void* buf, uLong size));
typedef long   (CSIIMADPcrc_ZCALLBACK *tell_file_func) OF((voidpf opaque, voidpf stream));
typedef long   (CSIIMADPcrc_ZCALLBACK *seek_file_func) OF((voidpf opaque, voidpf stream, uLong offset, int origin));
typedef int    (CSIIMADPcrc_ZCALLBACK *close_file_func) OF((voidpf opaque, voidpf stream));
typedef int    (CSIIMADPcrc_ZCALLBACK *testerror_file_func) OF((voidpf opaque, voidpf stream));

typedef struct CSIIMADP_zlib_filefunc_def_s
{
    open_file_func      zopen_file;
    read_file_func      zread_file;
    write_file_func     zwrite_file;
    tell_file_func      ztell_file;
    seek_file_func      zseek_file;
    close_file_func     zclose_file;
    testerror_file_func zerror_file;
    voidpf              opaque;
} CSIIMADP_zlib_filefunc_def;



void CSIIMADP_fill_fopen_filefunc OF((CSIIMADP_zlib_filefunc_def* pzlib_filefunc_def));

#define CSIIMADP_ZREAD(filefunc,filestream,buf,size) ((*((filefunc).zread_file))((filefunc).opaque,filestream,buf,size))
#define CSIIMADP_ZWRITE(filefunc,filestream,buf,size) ((*((filefunc).zwrite_file))((filefunc).opaque,filestream,buf,size))
#define CSIIMADP_ZTELL(filefunc,filestream) ((*((filefunc).ztell_file))((filefunc).opaque,filestream))
#define CSIIMADP_ZSEEK(filefunc,filestream,pos,mode) ((*((filefunc).zseek_file))((filefunc).opaque,filestream,pos,mode))
#define CSIIMADP_ZCLOSE(filefunc,filestream) ((*((filefunc).zclose_file))((filefunc).opaque,filestream))
#define CSIIMADP_ZERROR(filefunc,filestream) ((*((filefunc).zerror_file))((filefunc).opaque,filestream))


#ifdef __cplusplus
}
#endif

#endif

