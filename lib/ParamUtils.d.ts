import { Color, ImageSource, PhotoBatchOperations, TextOptions } from "./PhotoManipulatorTypes";
/**
 * Convert color string to rgba object
 * @param color
 */
export declare const toColorNative: (color?: string | undefined) => Color;
export declare const toImageNative: (source: ImageSource) => string;
export declare const toTextOptionsNative: (it: TextOptions) => {
    color: Color;
    thickness: number;
    position: import("./PhotoManipulatorTypes").Point;
    text: string;
    textSize?: number | undefined;
};
export declare const toBatchNative: (it: PhotoBatchOperations) => {
    options: {
        color: Color;
        thickness: number;
        position: import("./PhotoManipulatorTypes").Point;
        text: string;
        textSize?: number | undefined;
    };
    operation: "text";
} | {
    overlay: string;
    operation: "overlay";
    position: import("./PhotoManipulatorTypes").Point;
};
//# sourceMappingURL=ParamUtils.d.ts.map