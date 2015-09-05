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
+(NSArray*)processImage:(UIImage *)image{
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
    return @[result,[NSNumber numberWithInt:allGood], [NSNumber numberWithInt:allBad]];
}

int minBallArea = 900;

int* findBiggestContour(vector<vector<cv::Point>> contours,cv::Mat mColorMask) {
    int* response = new int[2];
    
    int maxArea =0;
    int ballSizedContours=0;
    int maxContour_id=-1;
    
    for (int i = 0; i < contours.size(); i++) { // for each contour
        
        cv::Rect rc = cv::boundingRect(contours[i]); // get a bounding box around it
        int diameter = (int)  sqrt( (rc.width * rc.width) + (rc.height * rc.height) );
        int area = (int) contourArea(contours[i]); // calculate the area
        
        
        if (area > minBallArea) {
            ballSizedContours+=1;
            
            cv::drawContours(mColorMask, contours, i, cv::Scalar(255,255,255),-1);
            
            if (maxArea < area) { // if this is the largest area so far
                maxArea = area; // update the variables
                maxContour_id = i;
            }
            
        }
        else {
            cv::drawContours(mColorMask, contours, i, cv::Scalar(255,255,255));
        }
        // if there are any largish contours, consider them ball sized
        //	if (diameter/2 >= BALL_MIN_RADIUS/1.5 && diameter/2 <= BALL_MAX_RADIUS) {
        //		ballSizedContours+=1;
        //	}
        
        
        
        /*
         if (diameter/2 >= BALL_MIN_RADIUS
         && diameter/2 <= BALL_MAX_RADIUS)
         //		&& rc.width <= rc.height * 2 // was both 1.6
         //		&& rc.height <= rc.width * 2)
         {
         
         if (maxArea < area) { // if this is the largest area so far
         maxArea = area; // update the variables
         maxContour_id = i;
         }
         }  */
    } // end for all contours
    
    response[0] = maxContour_id;
    response[1] = ballSizedContours;
    
    return response;
}

Scalar BLUE_COLOR( 0, 176, 217 );

void drawBox(cv::Mat img, cv::Rect roi){
    int thickness = 100;
    
    // Top Left Corner
    int x = roi.x-1;
    int y = roi.y-1;
    cv::line(img, cv::Point(x,y), cv::Point(x, y+roi.height/4), BLUE_COLOR, thickness );
    cv::line(img, cv::Point(x,y), cv::Point(x+roi.width/4, y), BLUE_COLOR, thickness );
    
    // Bottom Left Corner
    y= y+roi.height;
    cv::line(img, cv::Point(x,y), cv::Point(x,y-roi.height/4), BLUE_COLOR, thickness);
    cv::line(img, cv::Point(x,y), cv::Point(x+roi.width/4,y), BLUE_COLOR, thickness);
    
    // Top Right Corner
    x = roi.x+roi.width+1;
    y = roi.y+1;
    cv::line(img, cv::Point(x,y), cv::Point(x-roi.width/4,y), BLUE_COLOR, thickness);
    cv::line(img, cv::Point(x,y), cv::Point(x,y+roi.height/4), BLUE_COLOR, thickness);
    
    // Bottom Right Corner
    x = roi.x+roi.width+1;
    y = roi.y+roi.height+1;
    cv::line(img, cv::Point(x,y), cv::Point(x-roi.width/4,y), BLUE_COLOR, thickness);
    cv::line(img, cv::Point(x,y), cv::Point(x,y-roi.height/4), BLUE_COLOR, thickness);
    
}

+(UIImage*)isolateBlood:(UIImage *)image {
    cv::Mat img;
    cv::Mat imgRedMask;
    cv::Mat mask;
    cv::Mat origImg;
    cvUIImageToMat(image, origImg);

    cvUIImageToMat(image, img);
    cvUIImageToMat(image, imgRedMask);
    cvUIImageToMat(image, mask);
    
    
    cv::transpose(img, img);
    cv::flip(img, img, 1);
    
    cv::transpose(origImg, origImg);
    cv::flip(origImg, origImg, 1);
    
    cv::cvtColor(img, img, cv::COLOR_BGR2RGB);

    // Yellow
    cv::inRange(img, cv::Scalar(15,80,85), cv::Scalar(40,255,255), mask);

    vector<vector<cv::Point>> countours;
    cv::findContours(mask, countours, RETR_TREE, CHAIN_APPROX_SIMPLE);

    int* response = findBiggestContour(countours, mask);
    int maxContour_id = response[0];
    
    cv::Rect rc = cv::boundingRect(countours[maxContour_id]);
  
    cv::Point p1 = cv::Point(rc.x + rc.width/2, rc.y + rc.height);
    cv::Point p2 = cv::Point(rc.x + rc.width/2, rc.y);
    
    
    cv::arrowedLine(origImg, p1, p2, cvScalar(10), 6);
    cv::arrowedLine(origImg, p2, p1, cvScalar(10), 6);
    
    cv::putText(origImg, "23.45%", cv::Point(rc.x + rc.width / 2 + 15, rc.y + rc.height/2 + 10), cv::FONT_HERSHEY_DUPLEX, 1.0, cvScalar(0, 0, 255));
    cv::line(origImg, cv::Point(0, 155), cv::Point(500, 155), cvScalar(10));
    
    // Red
//    cv::inRange(img, cv::Scalar(17, 15, 100), cv::Scalar(80, 80, 200), imgRedMask);
//
//    vector<vector<cv::Point>> countours2;
//    cv::findContours(imgRedMask, countours2, RETR_TREE, CHAIN_APPROX_SIMPLE);
//    int* response2 = findBiggestContour(countours2, imgRedMask);
//    int maxContour_id2 = response2[0];
//    
//    cv::Rect rc2 = cv::boundingRect(countours2[maxContour_id2]);
//    
//    cv::Point p12 = cv::Point(rc2.x + rc2.width/2, rc2.y + rc2.height);
//    cv::Point p22 = cv::Point(rc2.x + rc2.width/2, rc2.y);
//    
//    cv::arrowedLine(origImg, p12, p22, cvScalar(10), 6);
//    cv::arrowedLine(origImg, p22, p12, cvScalar(10), 6);
//    
//    cv::putText(origImg, "23.45%", cv::Point(rc2.x + rc2.width / 2 + 15, rc2.y + rc2.height/2 + 10), cv::FONT_HERSHEY_DUPLEX, 1.0, cvScalar(0, 0, 255));

    
    UIImage *result = cvMatToUIImage(origImg);
    
    mask.release();
    img.release();
    origImg.release();
    imgRedMask.release();
    
    return result;
}

@end
