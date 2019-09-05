
#import "RNPhotoManipulator.h"
#import "ImageUtils.h"
#import "ParamUtils.h"

#import <React/RCTConvert.h>
#import <React/RCTImageLoader.h>

#import <SDWebImage/SDWebImage.h>
#import <WCPhotoManipulator/MimeUtils.h>
#import <WCPhotoManipulator/UIImage+PhotoManipulator.h>

@implementation RNPhotoManipulator

@synthesize bridge = _bridge;

const CGFloat DEFAULT_QUALITY = 100;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(batch:(NSURLRequest *)uri
                  operations:(NSArray *)operations
                  cropRegion:(NSDictionary *)cropRegion
                  targetSize:(NSDictionary *)targetSize
                  quality:(NSInteger)quality
                  mimeType:(NSString *)mimeType
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    [self.bridge.imageLoader loadImageWithURLRequest:uri callback:^(NSError *error, UIImage *image) {
        if (error) {
            reject(@(error.code).stringValue, error.description, error);
            return;
        }

        [self image:image operations:operations cropRegion:cropRegion targetSize:targetSize quality:quality mimeType:mimeType resolve:resolve reject:reject];
    }];
}

RCT_EXPORT_METHOD(imageWithSize:(NSDictionary *)imageSize
                  operations:(NSArray *)operations
                  cropRegion:(NSDictionary *)cropRegion
                  targetSize:(NSDictionary *)targetSize
                  quality:(NSInteger)quality
                  mimeType:(NSString *)mimeType
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    UIImage *image = [self imageWithColor:UIColor.clearColor andSize:CGSizeMake([imageSize[@"width"] doubleValue], [imageSize[@"height"] doubleValue])];
    [self image:image operations:operations cropRegion:cropRegion targetSize:targetSize quality:quality mimeType:mimeType resolve:resolve reject:reject];
}

- (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size

{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;

}


- (void)
    image:(UIImage *)image
    operations:(NSArray *)operations
    cropRegion:(NSDictionary *)cropRegion
    targetSize:(NSDictionary *)targetSize
    quality:(NSInteger)quality
    mimeType:(NSString *)mimeType
    resolve:(RCTPromiseResolveBlock)resolve
    reject:(RCTPromiseRejectBlock)reject
{

  UIImage *result = [ImageUtils image:image crop:[RCTConvert CGRect:cropRegion] displaySize:[RCTConvert CGSize:targetSize]];

    for (NSDictionary *operation in operations) {
        result = [self processBatchOperation:result operation:operation];
    }

	    NSString *uri = [ImageUtils saveTempFile:result mimeType:mimeType quality:quality];
    resolve(uri);
}

- (UIImage *)processBatchOperation:(UIImage *)image operation:(NSDictionary *)operation {
    NSString *type = [RCTConvert NSString:operation[@"operation"]];

    if ([type isEqual:@"overlay"]) {
        NSURL *url = [RCTConvert NSURL:operation[@"overlay"]];
        CGPoint position = [RCTConvert CGPoint:operation[@"position"]];
        UIImage *overlay = [ImageUtils imageFromUrl:url];

        return [image overlayImage:overlay position:position];
    } else if ([type isEqual:@"text"]) {
        NSDictionary *options = [RCTConvert NSDictionary:operation[@"options"]];

        NSString *text = [RCTConvert NSString:options[@"text"]];
        CGPoint position = [RCTConvert CGPoint:options[@"position"]];
        CGFloat textSize = [RCTConvert CGFloat:options[@"textSize"]];
        UIColor *color = [ParamUtils color:options[@"color"]];
        CGFloat thickness = [RCTConvert CGFloat:options[@"thickness"]];

        return [image drawText:text position:position color:color size:textSize thickness:thickness];
    }
    return image;
}

RCT_EXPORT_METHOD(crop:(NSURLRequest *)uri
                  cropRegion:(NSDictionary *)cropRegion
                  targetSize:(NSDictionary *)targetSize
                  mimeType:(NSString *)mimeType
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    [self.bridge.imageLoader loadImageWithURLRequest:uri callback:^(NSError *error, UIImage *image) {
        if (error) {
            reject(@(error.code).stringValue, error.description, error);
            return;
        }

        UIImage *result = nil;
        if (targetSize == nil) {
            result = [image sd_croppedImageWithRect:[RCTConvert CGRect:cropRegion]];
        }

      result = [image sd_resizedImageWithSize:[RCTConvert CGSize:targetSize] scaleMode:SDImageScaleModeFill];

        NSString *uri = [ImageUtils saveTempFile:result mimeType:mimeType quality:DEFAULT_QUALITY];
        resolve(uri);
    }];
}

RCT_EXPORT_METHOD(overlayImage:(NSURLRequest *)uri
                  icon:(NSURLRequest *)icon
                  position:(NSDictionary *)position
                  mimeType:(NSString *)mimeType
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(__unused RCTPromiseRejectBlock)reject)
{
    [self.bridge.imageLoader loadImageWithURLRequest:uri callback:^(NSError *error, UIImage *image) {
        if (error) {
            reject(@(error.code).stringValue, error.description, error);
            return;
        }

        [self->_bridge.imageLoader loadImageWithURLRequest:icon callback:^(NSError *error, UIImage *icon) {
            if (error) {
                reject(@(error.code).stringValue, error.description, error);
                return;
            }

            UIImage *result = [image overlayImage:icon position:[RCTConvert CGPoint:position]];

            NSString *uri = [ImageUtils saveTempFile:result mimeType:mimeType quality:DEFAULT_QUALITY];
            resolve(uri);
        }];
    }];
}

RCT_EXPORT_METHOD(printText:(NSURLRequest *)uri
                  list:(NSArray *)list
                  mimeType:(NSString *)mimeType
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(__unused RCTPromiseRejectBlock)reject)
{
    [self.bridge.imageLoader loadImageWithURLRequest:uri callback:^(NSError *error, UIImage *image) {
        if (error) {
            reject(@(error.code).stringValue, error.description, error);
            return;
        }
        for (id options in list) {
            NSString *text = [RCTConvert NSString:options[@"text"]];
            CGPoint position = [RCTConvert CGPoint:options[@"position"]];
            CGFloat textSize = [RCTConvert CGFloat:options[@"textSize"]];
            UIColor *color = [ParamUtils color:options[@"color"]];
            CGFloat thickness = [RCTConvert CGFloat:options[@"thickness"]];

            image = [image drawText:text position:position color:color size:textSize thickness:thickness];
        }

        NSString *uri = [ImageUtils saveTempFile:image mimeType:mimeType quality:DEFAULT_QUALITY];
        resolve(uri);
    }];
}

RCT_EXPORT_METHOD(optimize:(NSURLRequest *)uri
                  quality:(NSInteger)quality
                  mimeType:(NSString *)mimeType
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(__unused RCTPromiseRejectBlock)reject)
{
    [self.bridge.imageLoader loadImageWithURLRequest:uri callback:^(NSError *error, UIImage *image) {
        if (error) {
            reject(@(error.code).stringValue, error.description, error);
            return;
        }

        NSString *uri = [ImageUtils saveTempFile:image mimeType:mimeType quality:quality];
        resolve(uri);
    }];
}

@end
