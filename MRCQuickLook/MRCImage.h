//
//  EM_CGImage.h
//  Viewer
//  Created by Thomas Hrabe on 18.10.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <ApplicationServices/ApplicationServices.h>
#import <Foundation/Foundation.h>

typedef struct {
	
	/*LONG Word #	Specification
	 */
	
	uint32_t nx; //1	NX       number of columns (fastest changing in map)
	uint32_t ny; //2	NY       number of rows
	uint32_t nz; //3	NZ       number of sections (slowest changing in map)
	
	
    uint32_t mode;            /*4	MODE     data type :
						0        image : signed 8-bit bytes range -128 to 127
						1        image : 16-bit halfwords
						2        image : 32-bit reals
						3        transform : complex 16-bit integers
						4        transform : complex 32-bit reals
						6        image : unsigned 16-bit range 0 to 65535*/
	uint32_t nxstart; //5	NXSTART number of first column in map (Default = 0)
	uint32_t nystart; //6	NYSTART number of first row in map
	uint32_t nzstart; //7	NZSTART number of first section in map
	uint32_t mx;	//8	MX       number of intervals along X
	uint32_t my;	//9	MY       number of intervals along Y
	uint32_t mz;	//10	MZ       number of intervals along Z
	uint32_t cella[3]; //11-13	CELLA    cell dimensions in angstroms
	uint32_t cellb[3]; //14-16	CELLB    cell angles in degrees
	uint32_t mapc;	//17	MAPC     axis corresp to cols (1,2,3 for X,Y,Z)
	uint32_t mapr;	//18	MAPR     axis corresp to rows (1,2,3 for X,Y,Z)
	uint32_t maps;	//19	MAPS     axis corresp to sections (1,2,3 for X,Y,Z)
	uint32_t dmin;	//20	DMIN     minimum density value
	uint32_t dmax;	//21	DMAX     maximum density value
	uint32_t dmean;	//22	DMEAN    mean density value
	uint32_t ispg;  //23	ISPG     space group number 0 or 1 (default=0)
	uint32_t nsymbt;//24	NSYMBT   number of bytes used for symmetry data (0 or 80)
	uint32_t extra[25]; //25-49	EXTRA    extra space used for anything   - 0 by default
	uint32_t origin[3]; //50-52	ORIGIN   origin in X,Y,Z used for transforms
	uint32_t map;	//53	MAP      character string 'MAP ' to identify file type
	uint32_t machst; //54	MACHST   machine stamp
	uint32_t rms;	//55	RMS      rms deviation of map from mean density
	uint32_t nlabl; //56	NLABL    number of labels being used
	uint32_t label[200]; //57-256	LABEL(20,10) 10 80-character text labels
	
} MRC_Header;


@interface MRCImage: NSObject{
	MRC_Header fileHeader;
	CGImageRef theImageRef;
}

@property (assign) MRC_Header fileHeader;
@property (assign) CGImageRef theImageRef;

+ (MRCImage*) MRCDataFromFile:(NSString*) filename;
- (id) initFromData:(NSData *)fileData;
- (void *) prepareDataForDisplay:(void*) originalImageData;

@end

