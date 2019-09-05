//
//  ImageUtils.m
//  RNPhotoManipulator
//
//  Created by Woraphot Chokratanasombat on 25/3/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "ImageUtils.h"

#import <WCPhotoManipulator/FileUtils.h>
#import "SDImageWebPCoder.h"

@implementation ImageUtils

+ (UIImage *)image:(UIImage*)image crop:(CGRect)rect displaySize:(CGSize)size {

  BOOL isAnimated = [(SDAnimatedImage*)image animatedImageFrameCount] > 0;

  if (isAnimated) {
    return image;
  } else {
    return [[image sd_croppedImageWithRect:rect] sd_resizedImageWithSize:size scaleMode:SDImageScaleModeFill];
  }
}

+ (NSString *)createTempFile:(NSString *)prefix mimeType:(NSString *)mimeType {
  NSString *extension = @{
    @"image/jpeg": @".jpg",
    @"image/png": @".png",
    @"image/webp": @".webp",
  }[mimeType];

  NSString *fileName = [[[NSUUID UUID] UUIDString] stringByAppendingString:extension];
  return [FileUtils.cachePath stringByAppendingPathComponent:fileName];
}


+ (NSString *)saveTempFile:(UIImage *)image mimeType:(NSString *)mimeType quality:(CGFloat)quality {
    NSString *file = [ImageUtils createTempFile:@"" mimeType:mimeType];

    [ImageUtils saveImageFile:image mimeType:mimeType quality:quality file:file];

    return [NSURL fileURLWithPath:file].absoluteString;
}

+ (void)saveImageFile:(UIImage *)image mimeType:(NSString *)mimeType quality:(CGFloat)quality file:(NSString *)file {
    NSData *data = [ImageUtils imageToData:image mimeType:mimeType quality:quality];

    [data writeToFile:file atomically:YES];
}

+ (NSData *)imageToData:(UIImage *)image mimeType:(NSString *)mimeType quality:(CGFloat)quality {
    if ([mimeType isEqualToString:@"image/png"]) {
        return UIImagePNGRepresentation(image);
    } else if ([mimeType isEqualToString:@"image/webp"]) {
      return [[SDImageWebPCoder sharedCoder] encodedDataWithImage:image format:SDImageFormatWebP options:@{SDImageCoderEncodeCompressionQuality: @(quality / 100.0), SDImageCoderEncodeFirstFrameOnly: @0 }];
    } else if ([mimeType isEqualToString:@"image/jpeg"]) {
        return UIImageJPEGRepresentation(image, quality / 100);
    } else {
        return NULL;
    }
}

@end
