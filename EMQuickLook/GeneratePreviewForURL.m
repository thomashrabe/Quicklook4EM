#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>
#include "EMImage.h"

/* -----------------------------------------------------------------------------
   Generate a preview for file

   This function's job is to create preview for designated file
   ----------------------------------------------------------------------------- */

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options)
{
	
    NSOperatingSystemVersion version = [[NSProcessInfo processInfo] operatingSystemVersion];
    
    if(version.majorVersion > 10)
        return noErr;
    
	NSString *filePathURL = [ (NSURL *)url absoluteString];

    NSString *filePath = [filePathURL stringByReplacingOccurrencesOfString:@"file://" withString:@""];

	EMImage* emImage = [EMImage EMDataFromFile:filePath];
	
	if(emImage == nil){
			return noErr;
	}
	
	CGSize size;
	size.width = (CGFloat)emImage.fileHeader.sizeX;
	size.height = (CGFloat)emImage.fileHeader.sizeY;
	
	CGContextRef cgContext = QLPreviewRequestCreateContext(preview, size, true, NULL);
	
	if (cgContext) {
		CGContextSaveGState(cgContext);
		
		CGPoint origin;
		origin.x = 0.0f;
		origin.y = 0.0f;
		
		
		CGRect rect;
		rect.origin = origin;
		rect.size = size;
		
		CGImageRef cgImageRef = emImage.theImageRef; 
		
		CGContextDrawImage(cgContext, rect,cgImageRef);
		
		QLPreviewRequestFlushContext(preview,cgContext);
		CGContextRestoreGState(cgContext);

		CGContextRelease(cgContext);	

	}else {
		return noErr;
	}
	return noErr;
} 

void CancelPreviewGeneration(void* thisInterface, QLPreviewRequestRef preview)
{
    // implement only if supported
}
