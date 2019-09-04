import { NativeModules } from "react-native";
import { MimeType } from "./PhotoManipulatorTypes";
import * as ParamUtils from "./ParamUtils";
var RNPhotoManipulator = NativeModules.RNPhotoManipulator;
var PhotoManipulator = {
    batch: function (image, operations, cropRegion, targetSize, quality, mimeType) {
        if (quality === void 0) { quality = 100; }
        if (mimeType === void 0) { mimeType = MimeType.jpg; }
        return RNPhotoManipulator.batch(ParamUtils.toImageNative(image), operations.map(ParamUtils.toBatchNative), cropRegion, targetSize, quality, mimeType);
    },
    batchWithTransparentImage: function (imageSize, operations, cropRegion, targetSize, quality, mimeType) {
        if (quality === void 0) { quality = 100; }
        if (mimeType === void 0) { mimeType = MimeType.jpg; }
        return RNPhotoManipulator.imageWithSize(imageSize, operations.map(ParamUtils.toBatchNative), cropRegion, targetSize, quality, mimeType);
    },
    crop: function (image, cropRegion, targetSize, quality, mimeType) {
        if (quality === void 0) { quality = 100; }
        if (mimeType === void 0) { mimeType = MimeType.jpg; }
        return RNPhotoManipulator.crop(ParamUtils.toImageNative(image), cropRegion, targetSize, quality, mimeType);
    },
    overlayImage: function (image, overlay, position, mimeType) {
        if (mimeType === void 0) { mimeType = MimeType.jpg; }
        return RNPhotoManipulator.overlayImage(ParamUtils.toImageNative(image), ParamUtils.toImageNative(overlay), position, mimeType);
    },
    printText: function (image, texts, mimeType) {
        if (mimeType === void 0) { mimeType = MimeType.jpg; }
        return RNPhotoManipulator.printText(ParamUtils.toImageNative(image), texts.map(ParamUtils.toTextOptionsNative), mimeType);
    },
    optimize: function (image, quality, mimeType) {
        if (mimeType === void 0) { mimeType = MimeType.jpg; }
        return RNPhotoManipulator.optimize(ParamUtils.toImageNative(image), quality, mimeType);
    }
};
export default PhotoManipulator;
