//
//  Extensions.swift
//  Draculapp
//
//  Created by Mark Larah on 04/09/2015.
//  Copyright (c) 2015 magicmark. All rights reserved.
//

func radians (degrees: CGFloat) -> CGFloat {
    return CGFloat(degrees) * CGFloat(M_PI) / 180.0
}

extension UIImage {
    func cropImage(toRect rect: CGRect) -> UIImage? {
        
        let imageRef = CGImageCreateWithImageInRect(self.CGImage, rect)
        let bitmapInfo = CGImageGetBitmapInfo(imageRef)
        let colorSpaceInfo = CGImageGetColorSpace(imageRef)
        let bitmap: CGContextRef = CGBitmapContextCreate(nil, Int(rect.size.width), Int(rect.size.height), CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo)
        
        if self.imageOrientation == UIImageOrientation.Left {
            CGContextRotateCTM(bitmap, radians(90))
            CGContextTranslateCTM(bitmap, 0, -rect.size.height)
        } else if (self.imageOrientation == .Right) {
            CGContextRotateCTM(bitmap, radians(-90))
            CGContextTranslateCTM(bitmap, -rect.size.width, 0)
        } else if (self.imageOrientation == .Up) {
            //
        } else if (self.imageOrientation == .Down) {
            CGContextTranslateCTM(bitmap, rect.size.width, rect.size.height)
            CGContextRotateCTM (bitmap, radians(-180))
        }
        
        CGContextDrawImage(bitmap, CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height), imageRef)
        let ref = CGBitmapContextCreateImage(bitmap)
        let resultImage = UIImage(CGImage: ref)
        return resultImage
    }
    
    
    func cropImage2(toRect rect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        let drawRect = CGRect(x: -rect.origin.x, y: -rect.origin.y, width: self.size.width, height: self.size.height)
        CGContextClipToRect(context, CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height));
        self.drawInRect(rect)
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return croppedImage
    }
//    }
//    - (UIImage *)captureScreenInRect:(CGRect)captureFrame
//    {
//    
//    CALayer *layer;
//    layer = self.view.layer;
//    UIGraphicsBeginImageContext(self.view.frame.size);
//    CGContextClipToRect (UIGraphicsGetCurrentContext(),captureFrame);
//    [layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return screenImage;
//    }
}