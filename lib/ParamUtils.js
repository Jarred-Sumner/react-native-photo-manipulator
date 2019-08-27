var __assign = (this && this.__assign) || function () {
    __assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return __assign.apply(this, arguments);
};
/**
 * Parameter Utilities Class
 */
import { Image } from "react-native";
// @ts-ignore
import parse from "parse-color";
/**
 * Convert color string to rgba object
 * @param color
 */
export var toColorNative = function (color) {
    var result = parse(color || "#000000").rgba;
    return {
        r: result[0],
        g: result[1],
        b: result[2],
        a: result[3] * 255
    };
};
export var toImageNative = function (source) { return typeof source === "string" ? source : Image.resolveAssetSource(source).uri; };
export var toTextOptionsNative = function (it) { return (__assign({}, it, { color: toColorNative(it.color), thickness: it.thickness || 0 })); };
export var toBatchNative = function (it) {
    if (it.operation === "text")
        return __assign({}, it, { options: toTextOptionsNative(it.options) });
    if (it.operation === "overlay")
        return __assign({}, it, { overlay: toImageNative(it.overlay) });
    return it;
};
