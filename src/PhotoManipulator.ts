import { NativeModules } from "react-native";
import {
  ImageSource,
  PhotoBatchOperations,
  PhotoManipulatorStatic,
  Point,
  Rect,
  Size,
  TextOptions,
  MimeType
} from "./PhotoManipulatorTypes";
import * as ParamUtils from "./ParamUtils";

const { RNPhotoManipulator } = NativeModules;

const PhotoManipulator: PhotoManipulatorStatic = {
  batch: (
    image: ImageSource,
    operations: PhotoBatchOperations[],
    cropRegion: Rect,
    targetSize?: Size,
    quality: number = 100,
    mimeType: MimeType = MimeType.jpg
  ) => {
    return RNPhotoManipulator.batch(
      ParamUtils.toImageNative(image),
      operations.map(ParamUtils.toBatchNative),
      cropRegion,
      targetSize,
      quality,
      mimeType
    );
  },
  batchWithTransparentImage: (
    imageSize: Size,
    operations: PhotoBatchOperations[],
    cropRegion: Rect,
    targetSize?: Size,
    quality: number = 100,
    mimeType: MimeType = MimeType.jpg
  ) => {
    return RNPhotoManipulator.imageWithSize(
      imageSize,
      operations.map(ParamUtils.toBatchNative),
      cropRegion,
      targetSize,
      quality,
      mimeType
    );
  },
  crop: (
    image: ImageSource,
    cropRegion: Rect,
    targetSize?: Size,
    mimeType: MimeType = MimeType.jpg
  ) =>
    RNPhotoManipulator.crop(
      ParamUtils.toImageNative(image),
      cropRegion,
      targetSize,
      mimeType
    ),
  overlayImage: (
    image: ImageSource,
    overlay: ImageSource,
    position: Point,
    mimeType: MimeType = MimeType.jpg
  ) =>
    RNPhotoManipulator.overlayImage(
      ParamUtils.toImageNative(image),
      ParamUtils.toImageNative(overlay),
      position,
      mimeType
    ),
  printText: (
    image: ImageSource,
    texts: TextOptions[],
    mimeType: MimeType = MimeType.jpg
  ) =>
    RNPhotoManipulator.printText(
      ParamUtils.toImageNative(image),
      texts.map(ParamUtils.toTextOptionsNative),
      mimeType
    ),
  optimize: (
    image: ImageSource,
    quality: number,
    mimeType: MimeType = MimeType.jpg
  ) =>
    RNPhotoManipulator.optimize(
      ParamUtils.toImageNative(image),
      quality,
      mimeType
    )
};

export default PhotoManipulator;
