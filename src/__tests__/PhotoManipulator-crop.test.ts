import { NativeModules } from "react-native";
import "jest-extended"
import PhotoManipulator from "../PhotoManipulator"
import { toImageNative } from "../ParamUtils"

describe("Photo Manipulator", () => {
    describe("crop()", () => {
        const imageUrl = "https://image.freepik.com/free-photo/tulips-bouquet-pink-background-with-copyspace_24972-271.jpg"
        const imageRequire = require.resolve("../../docs/test.png")
        const cropRegion = { x: 30, y: 10, height: 400, width: 300 }
        const targetSize = { width: 300, height: 200 }

        test("all parameters", () => {
            PhotoManipulator.crop(imageUrl, cropRegion, targetSize)
            expect(NativeModules.RNPhotoManipulator.crop).toBeCalledWith(imageUrl, cropRegion, targetSize);
        })

        test("missing targetSize", () => {
            PhotoManipulator.crop(imageUrl, cropRegion)
            expect(NativeModules.RNPhotoManipulator.crop).toBeCalledWith(imageUrl, cropRegion, undefined);
        })

        test("require image source", () => {
            PhotoManipulator.crop(imageRequire, cropRegion)
            expect(NativeModules.RNPhotoManipulator.crop).toBeCalledWith(toImageNative(imageRequire), cropRegion, undefined);
        })
    });
});