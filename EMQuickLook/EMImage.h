//http://blog.10to1.be/cocoa/2012/01/27/creating-a-quick-look-plugin/
//
//  EM_CGImage.h
//  Viewer
//  Created by Thomas Hrabe on 18.10.10.
//  Copyright 2010 Max Planck Institut Biochemie. All rights reserved.
//

#import <ApplicationServices/ApplicationServices.h>
#import <Foundation/Foundation.h>

typedef struct {
    int8_t machine;             /**< Byte 1: Machine Coding
								 (OS-9;      0),
								 (VAX;       1),
								 (Convex;    2),
								 (SGI;       3),
								 (Mac;       5),
								 (PC;        6). */
    int8_t oldOS9;               /**< General purpose. On OS-9 system: 0 old version 1 is new version. */
    int8_t byte3;               /**< Not used in standard EM-format, if this byte is 1 the header is abandoned. */
    int8_t datatype;                /**< Data Type Coding. */
    uint32_t sizeX;
	uint32_t sizeY;
	uint32_t sizeZ;
    int8_t comment[80];         /**< 80 Characters as comment. */
    int32_t emdata[40];         /**< 40 long integers (4 x 40 bytes) are user defined parameters. */
    int8_t  userdata[256];      /**< 256 Byte with userdata, i.e. the username. */
} EM_Header;


@interface EMImage: NSObject{
	EM_Header fileHeader;
	CGImageRef theImageRef;
}

@property (assign) EM_Header fileHeader;
@property (assign) CGImageRef theImageRef;

+ (EMImage*) EMDataFromFile:(NSString*) filename;
- (id) initFromData:(NSData *)fileData;
- (void *) prepareDataForDisplay:(void*) originalImageData;

@end

