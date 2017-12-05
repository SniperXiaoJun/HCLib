/* crypt.h -- base code for crypt/uncrypt ZIPfile
 
 
 Version 1.01e, February 12th, 2005
 
 Copyright (C) 1998-2005 Gilles Vollant
 
 This code is a modified version of crypting code in Infozip distribution
 
 The encryption/decryption parts of this source code (as opposed to the
 non-echoing password parts) were originally written in Europe.  The
 whole source package can be freely distributed, including from the USA.
 (Prior to January 2000, re-export from the US was a violation of US law.)
 
 This encryption code is a direct transcription of the algorithm from
 Roger Schlafly, described by Phil Katz in the file appnote.txt.  This
 file (appnote.txt) is distributed with the PKZIP program (even in the
 version without encryption capabilities).
 
 If you don't need crypting in your application, just define symbols
 NOCRYPT and NOUNCRYPT.
 
 This code support the "Traditional PKWARE Encryption".
 
 The new AES encryption added on Zip format by Winzip (see the page
 http://www.winzip.com/aes_info.htm ) and PKWare PKZip 5.x Strong
 Encryption is not supported.
 */

#define CRC32(c, b) ((*(pcrc_32_tab+(((int)(c) ^ (b)) & 0xff))) ^ ((c) >> 8))

/***********************************************************************
 * Return the next byte in the pseudo-random sequence
 */
static int CSIIMADPdecrypt_byte(unsigned long* pkeys, const unsigned long* pcrc_32_tab)
{
    unsigned temp;  /* POTENTIAL BUG:  temp*(temp^1) may overflow in an
                         * unpredictable manner on 16-bit systems; not a problem
                         * with any known compiler so far, though */
    
    temp = ((unsigned)(*(pkeys+2)) & 0xffff) | 2;
    return (int)(((temp * (temp ^ 1)) >> 8) & 0xff);
}

/***********************************************************************
 * Update the encryption keys with the next byte of plain text
 */
static int CSIIMADPupdate_keys(unsigned long* pkeys,const unsigned long* pcrc_32_tab,int c)
{
    (*(pkeys+0)) = CRC32((*(pkeys+0)), c);
    (*(pkeys+1)) += (*(pkeys+0)) & 0xff;
    (*(pkeys+1)) = (*(pkeys+1)) * 134775813L + 1;
    {
        register int keyshift = (int)((*(pkeys+1)) >> 24);
        (*(pkeys+2)) = CRC32((*(pkeys+2)), keyshift);
        }
    return c;
}


/***********************************************************************
 * Initialize the encryption keys and the random header according to
 * the given password.
 */
static void CSIIMADPinit_keys(const char* passwd,unsigned long* pkeys,const unsigned long* pcrc_32_tab)
{
    *(pkeys+0) = 305419896L;
    *(pkeys+1) = 591751049L;
    *(pkeys+2) = 878082192L;
    while (*passwd != '\0') {
        CSIIMADPupdate_keys(pkeys,pcrc_32_tab,(int)*passwd);
        passwd++;
        }
}

#define CSIIMADPzdecode(pkeys,pcrc_32_tab,c) \
(CSIIMADPupdate_keys(pkeys,pcrc_32_tab,c ^= CSIIMADPdecrypt_byte(pkeys,pcrc_32_tab)))

#define CSIIMADPzencode(pkeys,pcrc_32_tab,c,t) \
(t=CSIIMADPdecrypt_byte(pkeys,pcrc_32_tab), CSIIMADPupdate_keys(pkeys,pcrc_32_tab,c), t^(c))

#ifdef INCLUDECRYPTINGCODE_IFCRYPTALLOWED

#define CSIIMADP_RAND_HEAD_LEN  12
/* "last resort" source for second part of crypt seed pattern */
#  ifndef CSIIMADP_ZCR_SEED2
#    define CSIIMADP_ZCR_SEED2 3141592654UL     /* use PI as default pattern */
#  endif

static int CSIIMADPcrypthead(passwd, buf, bufSize, pkeys, pcrc_32_tab, CSIIMADPcrcForCrypting)
const char *passwd;         /* password string */
unsigned char *buf;         /* where to write header */
int bufSize;
unsigned long* pkeys;
const unsigned long* pcrc_32_tab;
unsigned long CSIIMADPcrcForCrypting;
{
    int n;                       /* index in random header */
    int t;                       /* temporary */
    int c;                       /* random byte */
    unsigned char header[CSIIMADP_RAND_HEAD_LEN-2]; /* random header */
    static unsigned calls = 0;   /* ensure different random header each time */
    
    if (bufSize<CSIIMADP_RAND_HEAD_LEN)
        return 0;
    
    /* First generate CSIIMADP_RAND_HEAD_LEN-2 random bytes. We encrypt the
         * output of rand() to get less predictability, since rand() is
         * often poorly implemented.
         */
    if (++calls == 1)
        {
            srand((unsigned)(time(NULL) ^ CSIIMADP_ZCR_SEED2));
            }
    CSIIMADPinit_keys(passwd, pkeys, pcrc_32_tab);
    for (n = 0; n < CSIIMADP_RAND_HEAD_LEN-2; n++)
        {
            c = (rand() >> 7) & 0xff;
            header[n] = (unsigned char)CSIIMADPzencode(pkeys, pcrc_32_tab, c, t);
            }
    /* Encrypt random header (last two bytes is high word of crc) */
    CSIIMADPinit_keys(passwd, pkeys, pcrc_32_tab);
    for (n = 0; n < CSIIMADP_RAND_HEAD_LEN-2; n++)
        {
            buf[n] = (unsigned char)CSIIMADPzencode(pkeys, pcrc_32_tab, header[n], t);
            }
    buf[n++] = CSIIMADPzencode(pkeys, pcrc_32_tab, (int)(CSIIMADPcrcForCrypting >> 16) & 0xff, t);
    buf[n++] = CSIIMADPzencode(pkeys, pcrc_32_tab, (int)(CSIIMADPcrcForCrypting >> 24) & 0xff, t);
    return n;
}

#endif
