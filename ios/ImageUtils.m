//
//  ImageUtils.m
//  RNPhotoManipulator
//
//  Created by Woraphot Chokratanasombat on 25/3/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "ImageUtils.h"

#import <WCPhotoManipulator/FileUtils.h>
#import <WebPImageSerialization/WebPImageSerialization.h>

@implementation ImageUtils


+ (NSString *)saveTempFile:(UIImage *)image mimeType:(NSString *)mimeType quality:(CGFloat)quality {
    NSString *file = [FileUtils createTempFile:@"" mimeType:mimeType];

    [ImageUtils saveImageFile:image mimeType:mimeType quality:quality file:file];

    return [NSURL fileURLWithPath:file].absoluteString;
}

+ (void)saveImageFile:(UIImage *)image mimeType:(NSString *)mimeType quality:(CGFloat)quality file:(NSString *)file {
    NSData *data = [ImageUtils imageToData:image mimeType:mimeType quality:quality];

    [data writeToFile:file atomically:YES];
}

+ (NSData *)imageToData:(UIImage *)image mimeType:(NSString *)mimeType quality:(CGFloat)quality {
    if (mimeType == @"image/png") {
        return UIImagePNGRepresentation(image);
    } else if (mimeType == @"image/webp") {
        return UIImageWebPRepresentation(image, quality / 100, (WebPImagePreset)WebPImageDefaultPreset, nil);
    } else if (mimeType == @"image/jpeg") {
        return UIImageJPEGRepresentation(image, quality / 100);
    }
}

@end
