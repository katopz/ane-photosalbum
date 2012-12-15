//
//  PhotosAlbum.m
//  PhotosAlbum
//
//  Created by Todsaporn Banjerdkit on 12/9/12.
//  Copyright (c) 2012 Todsaporn Banjerdkit (katopz). All rights reserved.
//

#import <AssetsLibrary/ALAssetsLibrary.h>

//------------------------------------
//
// FRE Helper.
//
//------------------------------------

#import "FlashRuntimeExtensions.h"

#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
#define MAP_FUNCTION(fn, data) { (const uint8_t*)(#fn), (data), &(fn) }

/*
 ANE @see http://help.adobe.com/en_US/air/extensions/WSb464b1207c184b14-62b8e11f12937b86be4-7ff5.html
 
 ctx = An FREContext. This value is the FREContext variable that the extension context received in its context initialization function.
 
 code = A pointer to a uint8_t. The runtime sets the code property of the StatusEvent object to this value. Use UTF-8 encoding for the string and terminate it with the null character.
 
 level = A pointer to a uint8_t. This parameter is a utf8-encoded, null-terminated string. The runtime sets the level property of the StatusEvent object to this value.
 
 AS3 @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/events/StatusEvent.html
 
 code : String
 A description of the object's status.
 
 level : String
 The category of the message, such as "status", "warning" or "error".
 */
#define DISPATCH_STATUS_EVENT(extensionContext, code, level) FREDispatchStatusEventAsync((extensionContext), (uint8_t*)code, (uint8_t*)level)

NSData *toNSDataByteArray(FREObject *ba)
{
    FREByteArray byteArray;
    FREAcquireByteArray(ba, &byteArray);
    
    NSData *d = [NSData dataWithBytes:(void *)byteArray.bytes length:(NSUInteger)byteArray.length];
    FREReleaseByteArray(ba);
    
    return d;
}

//------------------------------------
//
// Core Methods.
//
//------------------------------------

DEFINE_ANE_FUNCTION(saveImage)
{
    // Argument 0 is raw image encoded byte data
    NSData *d = toNSDataByteArray(argv[0]);
    
    // TODO : add metadata, album name
    ALAssetsLibrary *library = [[[ALAssetsLibrary alloc] init] autorelease];
    [library writeImageDataToSavedPhotosAlbum:d metadata:nil
                              completionBlock:^(NSURL *assetURL, NSError *error){
                                  if (error != NULL) {
                                      DISPATCH_STATUS_EVENT( context, (uint8_t*)[@"error" UTF8String], (uint8_t*)[@"error" UTF8String] );
                                      NSLog(@"Error: %@", error);
                                  } else {
                                      DISPATCH_STATUS_EVENT( context, (uint8_t*)[@"complete" UTF8String], (uint8_t*)[@"status" UTF8String]);
                                      NSLog(@"Complete!");
                                  }
                              }];
    return NULL;
}

//------------------------------------
//
// FRE Required Methods.
//
//------------------------------------

// The context initializer is called when the runtime creates the extension context instance.

void PhotosAlbumContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet)
{
    static FRENamedFunction functionMap[] =
    {
        MAP_FUNCTION(saveImage, NULL)
    };
    
    *numFunctionsToSet = sizeof( functionMap ) / sizeof( FRENamedFunction );
	*functionsToSet = functionMap;
}

// The context finalizer is called when the extension's ActionScript code
// calls the ExtensionContext instance's dispose() method.
// If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls ContextFinalizer().

void PhotosAlbumContextFinalizer(FREContext ctx)
{
	return;
}

// The extension initializer is called the first time the ActionScript side of the extension
// calls ExtensionContext.createExtensionContext() for any context.

void PhotosAlbumExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
	*extDataToSet = NULL;
	*ctxInitializerToSet = &PhotosAlbumContextInitializer;
	*ctxFinalizerToSet = &PhotosAlbumContextFinalizer;
}

// The extension finalizer is called when the runtime unloads the extension. However, it is not always called.

void PhotosAlbumExtFinalizer(void* extData)
{
	return;
}

