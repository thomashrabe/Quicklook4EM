//
//  MRCImage.m
//  EMQuickLook
//
//  Created by Thomas on 30.10.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MRCImage.h"
#define RGBSIZE 1

@implementation MRCImage

@synthesize fileHeader;
@synthesize theImageRef;

+ (MRCImage*) MRCDataFromFile:(NSString*) filename{
    NSError *error = nil;
	NSData *fileData = [NSData dataWithContentsOfFile:filename options:NSDataReadingMappedIfSafe error:&error];
	//NSData *fileData = [NSData dataWithContentsOfFile:filename];
	MRCImage* mrcImage = [[MRCImage alloc] initFromData:fileData];
	
	return mrcImage;
}


- (id) initFromData:(NSData *)fileData{
	if (self = [super init]) {	
		NSData* imageData = [fileData subdataWithRange: NSMakeRange(1024, [fileData length] - 1024)];
		
		MRC_Header fileHeaderHelp; 
		[fileData getBytes:(void*)(&fileHeaderHelp) length:1024];
		self.fileHeader = fileHeaderHelp;
		
		if(self.fileHeader.nx > 1000000 || self.fileHeader.ny > 1000000 || self.fileHeader.nz > 1000000){
			//
			NSLog(@"Header not understood! Aborting");
			return nil;
		}
		
		size_t allImagePixels = self.fileHeader.nx * self.fileHeader.ny;
		
		const void *bitmapData = [self prepareDataForDisplay:(void*)imageData.bytes];
		
		CGDataProviderRef providerRef = CGDataProviderCreateWithData(NULL, (const void*) bitmapData,
																	 allImagePixels, NULL);
		
		self.theImageRef = CGImageCreate((size_t)self.fileHeader.nx ,(size_t)self.fileHeader.nx, 
										 8*sizeof(int),8*RGBSIZE*sizeof(int),
										 self.fileHeader.nx*sizeof(int), 
										 CGColorSpaceCreateDeviceGray(),
										 kCGBitmapByteOrderDefault, 
										 providerRef,
										 NULL, 
										 YES, 
										 kCGRenderingIntentDefault);
		
		
		if (self.theImageRef == NULL) {
			NSLog(@"Error initializing the image ref!");
		}
		
	}
	return self;
}



-(void *) prepareDataForDisplay:(void*) originalImageData{


	unsigned long totalNumberPixels = self.fileHeader.nx * self.fileHeader.ny * self.fileHeader.nz;
	void *returnData = NULL;
	
	if (self.fileHeader.mode == 0) {
		char max = -128;
		char min = 127;
		
		char *originalData = malloc(sizeof(long)*totalNumberPixels); 
		memcpy((void*)originalData,originalImageData,sizeof(char)*totalNumberPixels);
		
		
		unsigned long tomogramSliceOffset = 0;
		unsigned long numberPixelsInPlane = self.fileHeader.nx * self.fileHeader.ny;
		
		if(self.fileHeader.nz >1){
			tomogramSliceOffset = self.fileHeader.nx * self.fileHeader.ny * (self.fileHeader.nz /2);
		}
		
		for(unsigned long i=0;i<numberPixelsInPlane;i++){
			if(min > originalData[i+tomogramSliceOffset]){
				min = originalData[i+tomogramSliceOffset];
			}
		}
		for(unsigned long i=0;i<numberPixelsInPlane;i++){
			if(max < (originalData[i+tomogramSliceOffset]-min)){
				max = originalData[i+tomogramSliceOffset]-min;
			}
		}
		
		int* bitmapData = (int*)malloc(sizeof(int)*numberPixelsInPlane * RGBSIZE); //for RGB
		int value;
		
		for(unsigned long j=0;j<(numberPixelsInPlane);j++){
			
			value = (int)((originalData[j+ tomogramSliceOffset]-min)*255/max);
			if (value > 255) {
				value = 255;
			}
			if (value < 0) {
				value = 0;
			}
			
			bitmapData[j] = value;			
		}
		
		free(originalData);
		returnData = (void*)bitmapData;
	}
	else if(self.fileHeader.mode == 1) {
		short max = -32768;
		short min = 32767;
		
		short *originalData = malloc(sizeof(short)*totalNumberPixels); 
		memcpy((void*)originalData,originalImageData,sizeof(short)*totalNumberPixels);
		
		
		unsigned long tomogramSliceOffset = 0;
		unsigned long numberPixelsInPlane = self.fileHeader.nx * self.fileHeader.ny;
		
		if(self.fileHeader.nz >1){
			tomogramSliceOffset = self.fileHeader.nx * self.fileHeader.ny * (self.fileHeader.nz /2);
		}
		
		for(unsigned long i=0;i<numberPixelsInPlane;i++){
			if(min > originalData[i+tomogramSliceOffset]){
				min = originalData[i+tomogramSliceOffset];
			}
		}
		for(unsigned long i=0;i<numberPixelsInPlane;i++){
			if(max < (originalData[i+tomogramSliceOffset]-min)){
				max = originalData[i+tomogramSliceOffset]-min;
			}
		}
		
		int* bitmapData = (int*)malloc(sizeof(int)*numberPixelsInPlane * RGBSIZE); //for RGB
		int value;
		
		for(unsigned long j=0;j<(numberPixelsInPlane);j++){
			
			value = (int)((originalData[j+ tomogramSliceOffset]-min)*255/max);
			if (value > 255) {
				value = 255;
			}
			if (value < 0) {
				value = 0;
			}
			
			bitmapData[j] = value;			
		}
		
		free(originalData);
		returnData = (void*)bitmapData;
	}else if(self.fileHeader.mode == 2) {
		float max = -10000000000000;
		float min = 10000000000000;
		
		float *originalData = malloc(sizeof(float)*totalNumberPixels); 
		memcpy((void*)originalData,originalImageData,sizeof(float)*totalNumberPixels);
		
		
		unsigned long tomogramSliceOffset = 0;
		unsigned long numberPixelsInPlane = self.fileHeader.nx * self.fileHeader.ny;
		
		if(self.fileHeader.nz >1){
			tomogramSliceOffset = self.fileHeader.nx * self.fileHeader.ny * (self.fileHeader.nz /2);
		}
		
		for(unsigned long i=0;i<numberPixelsInPlane;i++){
			if(min > originalData[i+tomogramSliceOffset]){
				min = originalData[i+tomogramSliceOffset];
			}
		}
		for(unsigned long i=0;i<numberPixelsInPlane;i++){
			if(max < (originalData[i+tomogramSliceOffset]-min)){
				max = originalData[i+tomogramSliceOffset]-min;
			}
		}
		
		int* bitmapData = (int*)malloc(sizeof(int)*numberPixelsInPlane * RGBSIZE); //for RGB
		int value;
		
		for(unsigned long j=0;j<(numberPixelsInPlane);j++){
			
			value = (int)((originalData[j+ tomogramSliceOffset]-min)*255/max);
			if (value > 255) {
				value = 255;
			}
			if (value < 0) {
				value = 0;
			}
			
			bitmapData[j] = value;			
		}
		
		free(originalData);
		returnData = (void*)bitmapData;
	}
	return returnData;
}

@end
