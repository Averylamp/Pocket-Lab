//
//  Wrapper.m
//  Draculapp
//
//  Created by Avery Lamp on 9/4/15.
//  Copyright (c) 2015 magicmark. All rights reserved.
//

#import "Wrapper.h"
#import <opencv2/highgui/highgui_c.h>
#import <opencv2/imgproc/imgproc_c.h>
#import <opencv2/core/core_c.h>
#import <vector>

using std::vector;
using namespace cv;


@implementation Wrapper
static UIImage* cvMatToUIImage(const cv::Mat& m) {
    CV_Assert(m.depth() == CV_8U);
    NSData *data = [NSData dataWithBytes:m.data length:m.elemSize()*m.total()];
    CGColorSpaceRef colorSpace = m.channels() == 1 ?
    CGColorSpaceCreateDeviceGray() : CGColorSpaceCreateDeviceRGB();
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    // Creating CGImage from cv::Mat
    
    CGImageRef imageRef = CGImageCreate(m.cols, m.rows, m.elemSize1()*8, m.elemSize()*8,
                                        m.step[0], colorSpace, kCGImageAlphaNoneSkipLast|kCGBitmapByteOrderDefault,
                                        provider, NULL, false, kCGRenderingIntentDefault);
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef); CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace); return finalImage;
}

static void cvUIImageToMat(const UIImage* image, cv::Mat& m) {
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width, rows = image.size.height;
    m.create(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    CGContextRef contextRef = CGBitmapContextCreate(m.data, m.cols, m.rows, 8, m.step[0], colorSpace, kCGImageAlphaNoneSkipLast |kCGBitmapByteOrderDefault);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    //    CGColorSpaceRelease(colorSpace);
}
+(UIImage*)processImage:(UIImage *)image{
    cv::Mat img;
    cv::Mat resultImg;
    cvUIImageToMat(image, img);
    cvUIImageToMat(image, resultImg);
    cv::cvtColor(img, img, cv::COLOR_RGB2GRAY);
    cv::Canny(img, img, 50, 150);
    
    vector<vector<cv::Point> > contours;

    cv::findContours( img, contours, RETR_TREE, CHAIN_APPROX_SIMPLE);
    
    /// Draw contours
    double allRadiiMean = 0.0;
    int allGood = 0;
    int allBad = 0;
    int distrib[25];
    for (int z=0; z<25; z++) {
        distrib[z] = 0;
    }
    
    int z = 0;
    for (int i = 0; i < contours.size(); i++){ // for each contour
        if (contours[i].size() > 25) {
            double xMean = 0.0;
            double yMean = 0.0;
            for (int z = 0; z < contours[i].size(); z++){
                xMean = xMean + contours[i][z].x;
                yMean = yMean + contours[i][z].y;
            }
            xMean = xMean / contours[i].size();
            yMean = yMean / contours[i].size();
            
            double radii[contours[i].size()];
            double radiiMean = 0.0;
            for (int z = 0; z < contours[i].size(); z++) {
                double xVal = abs(xMean - contours[i][z].x);
                xVal = xVal * xVal;
                double yVal = abs(yMean - contours[i][z].y);
                yVal = yVal * yVal;
                radii[z] = sqrt(xVal + yVal);
                radiiMean = radiiMean + radii[z];
            }
            radiiMean = radiiMean / contours[i].size();
            allRadiiMean = allRadiiMean + radiiMean;
            double std = 0.0;
            for (int z = 0; z< contours[i].size(); z++) {
                std = std + pow(abs(radii[z]- radiiMean), 2);
            }
            std = std / contours[i].size();
            std = sqrt(std);
            distrib[(int)std] ++;
//            NSLog(@"Standard Deviation: %f", std);
            if(std<5){
                cv::drawContours(resultImg , contours, i, cv::Scalar(146,222,64), 5);
                allGood ++;
            }else{
                cv::drawContours(resultImg , contours, i, cv::Scalar(176,31,22), 5);
                allBad++;
            }
            
//            NSLog(@"Contour Drawn - %d",z);
            z++;
        }
        
    }
    
    allRadiiMean = allRadiiMean / contours.size();
    
    NSLog(@"Radii Mean - %f\nGood: %d,\nBad: %d\nPercentage: %f",allRadiiMean,allGood,allBad, allGood /((double)(allGood + allBad)));
    for (int i=0 ; i<25; i++) {
        NSLog(@"Dist %d:  %d", i , distrib[i]);
    }
    
//    UIImage *result = cvMatToUIImage(img);
    UIImage *result = cvMatToUIImage(resultImg);
    img.release();
    resultImg.release();
    return result;
}

+(UIImage*)isolateYellow:(UIImage *)image {
    cv::Mat inputImage;
    cv::Mat resultImg;
    cvUIImageToMat(image, inputImage);
    cvUIImageToMat(image, resultImg);
    cv::inRange(inputImage, cv::Scalar(25, 146, 190), cv::Scalar(62, 174, 250), resultImg);
    UIImage *result = cvMatToUIImage(resultImg);
    inputImage.release();
    resultImg.release();
    return result;
}

@end
