//
//  EM_CGImage.m
//  Viewer
//
//  Created by Thomas Hrabe on 18.10.10.
//  Copyright 2010 Max Planck Institut Biochemie. All rights reserved.
//

#import "EMImage.h"


#define RGBSIZE 1


@implementation EMImage

@synthesize fileHeader;
@synthesize theImageRef;

+ (EMImage*) EMDataFromFile:(NSString*) filename{
    NSError *error = nil;
	NSData *fileData = [NSData dataWithContentsOfFile:filename options:NSDataReadingMappedIfSafe error:&error];
	
	EMImage* emImage = [[EMImage alloc] initFromData:fileData];

	return emImage;
}

- (id) initFromData:(NSData *)fileData{
	if (self = [super init]) {	
		NSData* imageData = [fileData subdataWithRange: NSMakeRange(512, [fileData length] - 512)];
		
		EM_Header fileHeaderHelp; 
		[fileData getBytes:(void*)(&fileHeaderHelp) length:512];
		self.fileHeader = fileHeaderHelp;
		
		if(self.fileHeader.sizeX > 1000000 || self.fileHeader.sizeY > 1000000 || self.fileHeader.sizeZ > 1000000){
			//
			NSLog(@"Header not understood! Aborting");
			return nil;
		}
		
		size_t allImagePixels = self.fileHeader.sizeX * self.fileHeader.sizeY;
		
		const void *bitmapData = [self prepareDataForDisplay:(void*)imageData.bytes];
		
		CGDataProviderRef providerRef = CGDataProviderCreateWithData(NULL, (const void*) bitmapData,
																	 allImagePixels, NULL);
		
		self.theImageRef = CGImageCreate((size_t)self.fileHeader.sizeX ,(size_t)self.fileHeader.sizeY, 
											8*sizeof(int),8*RGBSIZE*sizeof(int),
											self.fileHeader.sizeX*sizeof(int), 
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
	/*				bytes			type
	 byte            1               1
	 short           2               2
	 long int        4               4
	 float           4               5
	 float complex   8               8
	 double          8               9
	 double complex  16              10
	 */
	unsigned long totalNumberPixels = self.fileHeader.sizeX * self.fileHeader.sizeY * self.fileHeader.sizeZ;
	void *returnData = NULL;
	
	if (self.fileHeader.datatype == 1) {
		char max = -128;
		char min = 127;
		
		char *originalData = malloc(sizeof(long)*totalNumberPixels); 
		memcpy((void*)originalData,originalImageData,sizeof(char)*totalNumberPixels);
		
		
		unsigned long tomogramSliceOffset = 0;
		unsigned long numberPixelsInPlane = self.fileHeader.sizeX * self.fileHeader.sizeY;
		
		if(self.fileHeader.sizeZ >1){
			tomogramSliceOffset = self.fileHeader.sizeX * self.fileHeader.sizeY * (self.fileHeader.sizeZ /2);
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
	else if (self.fileHeader.datatype == 2) {
		short max = -32768;
		short min = 32767;
		
		short *originalData = malloc(sizeof(short)*totalNumberPixels); 
		memcpy((void*)originalData,originalImageData,sizeof(short)*totalNumberPixels);
		
		
		unsigned long tomogramSliceOffset = 0;
		unsigned long numberPixelsInPlane = self.fileHeader.sizeX * self.fileHeader.sizeY;
		
		if(self.fileHeader.sizeZ >1){
			tomogramSliceOffset = self.fileHeader.sizeX * self.fileHeader.sizeY * (self.fileHeader.sizeZ /2);
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
	else if (self.fileHeader.datatype == 4) {
		long max = -2147483648;
		long min = 2147483647;
		
		long *originalData = malloc(sizeof(long)*totalNumberPixels); 
		memcpy((void*)originalData,originalImageData,sizeof(long)*totalNumberPixels);
		
		
		unsigned long tomogramSliceOffset = 0;
		unsigned long numberPixelsInPlane = self.fileHeader.sizeX * self.fileHeader.sizeY;
		
		if(self.fileHeader.sizeZ >1){
			tomogramSliceOffset = self.fileHeader.sizeX * self.fileHeader.sizeY * (self.fileHeader.sizeZ /2);
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
	else if (self.fileHeader.datatype == 5) {
		float max = -10000000000000;
		float min = 10000000000000;
		
		float *originalData = malloc(sizeof(float)*totalNumberPixels); 
		memcpy((void*)originalData,originalImageData,sizeof(float)*totalNumberPixels);
		
		
		unsigned long tomogramSliceOffset = 0;
		unsigned long numberPixelsInPlane = self.fileHeader.sizeX * self.fileHeader.sizeY;
		
		if(self.fileHeader.sizeZ >1){
			tomogramSliceOffset = self.fileHeader.sizeX * self.fileHeader.sizeY * (self.fileHeader.sizeZ /2);
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
	else if (self.fileHeader.datatype == 9) {
		double max = -10000000000000;
		double min = 10000000000000;
		
		double *originalData = malloc(sizeof(double)*totalNumberPixels); 
		memcpy((void*)originalData,originalImageData,sizeof(double)*totalNumberPixels);
		
		
		unsigned long tomogramSliceOffset = 0;
		unsigned long numberPixelsInPlane = self.fileHeader.sizeX * self.fileHeader.sizeY;
		
		if(self.fileHeader.sizeZ >1){
			tomogramSliceOffset = self.fileHeader.sizeX * self.fileHeader.sizeY * (self.fileHeader.sizeZ /2);
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
