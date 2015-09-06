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
+(NSArray*)processImage:(UIImage*)image live:(BOOL) live{
    cv::Mat img;
    cv::Mat resultImg;
    cvUIImageToMat(image, img);
    cvUIImageToMat(image, resultImg);
//    cv::cvtColor(img, img, cv::COLOR_BGR2HSV);
    cv::Mat sharpImg;

    
   
    if (live == YES){
//        sharpImg = img;
        NSLog(@"%d,%d,%d",img.at<Vec4b>(0, 0)[0],img.at<Vec4b>(0, 0)[1],img.at<Vec4b>(0, 0)[2]);
        NSLog(@"%d,%d,%d",img.at<Vec4b>(0, 1)[0],img.at<Vec4b>(0, 1)[1],img.at<Vec4b>(0, 1)[2]);
        
        img.at<Vec4b>(0, 1) = Vec4b(0,255,0);
//        NSLog(@"%d,%d,%d",img.at<Vec3b>(0, 0)[0],img.at<Vec3b>(0, 0)[1],img.at<Vec3b>(0, 0)[2]);
//        NSLog(@"%d,%d,%d",img.at<Vec3b>(0, 1)[0],img.at<Vec3b>(0, 1)[1],img.at<Vec3b>(0, 1)[2]);
        long greenValue = 0;
        int count = 0;
        for(int j=0;j<img.rows;j++)
        {
            
            for (int i=0;i<img.cols;i++)
            {
                Vec4b hsvValue =  img.at<Vec4b>(j, i);
                int G = hsvValue.val[1];  // = imgHSV.get(y, x)[1];
                greenValue += G;
                count++;
            }
        }
        
        double meanGreen = greenValue / (double) count;
        
        for(int j=0;j<img.rows;j++)
        {
            
            for (int i=0;i<img.cols;i++)
            {
                
                Vec4b hsvValue =  img.at<Vec4b>(j, i);
                
                int B = hsvValue.val[0];  // = imgHSV.get(y,x)[0];
                int G = hsvValue.val[1];  // = imgHSV.get(y, x)[1];
                int R = hsvValue.val[2];  // = imgHSV.get(y, x)[2];
                
                if (G > meanGreen - 5 ) {
                    img.at<cv::Vec4b>(j,i) = cv::Vec4b(40,40,40);
//                    img.at<cv::Vec3b>(j,i)[1] = 40;
//                    img.at<cv::Vec3b>(j,i)[2] = 40;
//                    img.at<cv::Vec3b>(j,i)[3] = 40;
                }
                
//                NSLog(@"G VAL : %d",G);
//                NSLog(@"pixed Val: %d",img.at<uchar>(j,i));
                
//                if(img.at<uchar>(j,i)> 203){
//                    img.at<uchar>(j, i) += 20;
//                }else{
//                    img.at<uchar>(j,i) -= 20;
//                }
//
//                if( i== j)
//                    img.at<uchar>(j,i) = 255; //white
            }
        }
//        NSLog(@"Sharpening Finished");
//        
//        cv::Laplacian(img, sharpImg, CV_8U);
//        convertScaleAbs( dst, abs_dst );
        
//
        cv::cvtColor(img, img, COLOR_BGR2GRAY);
        cv::Canny(img, img, 100, 210);
    }else{
        cv::Canny(img, img, 50, 150);
    }
    
//    UIImage *result = cvMatToUIImage(img);
//    img.release();
//    resultImg.release();
//    return [[NSArray alloc]initWithObjects:result,[NSNumber numberWithInt:0],[NSNumber numberWithInt:0], nil];

    
    
    vector<vector<cv::Point> > contours;

    cv::findContours( img, contours, RETR_TREE, CHAIN_APPROX_SIMPLE);
    
    for (int i=0; i< contours.size(); i++) {
        cv::drawContours(img, contours, i, cv::Scalar(arc4random() % 255,arc4random() % 255,arc4random() % 255), -5);
    }
    
    

    
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
            if (live){
                if( contours[i].size() > 70){
                    continue;
                }
            }
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
    for (int i=0 ; i<=8; i++) {
        NSLog(@"Dist %d:  %d", i , distrib[i]);
    }
    
//    UIImage *result = cvMatToUIImage(img);
    UIImage *result = cvMatToUIImage(resultImg);
    img.release();
    resultImg.release();
    return @[result,[NSNumber numberWithInt:allGood], [NSNumber numberWithInt:allBad]];
//    return nil;
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

+(NSArray *)isolateBlood:(UIImage *)image {
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
    double plasmaPercentage, redBloodPercentage;
    if (maxContour_id != -1) {
        
        cv::Rect rc = cv::boundingRect(countours[maxContour_id]);
      
        cv::Point p1 = cv::Point(rc.x + rc.width/2, rc.y + rc.height);
        cv::Point p2 = cv::Point(rc.x + rc.width/2, rc.y);

        
        cv::Point q1 = cv::Point(rc.x + rc.width/2, rc.y + rc.height);
        cv::Point q2 = cv::Point(rc.x + rc.width/2, 325);
        
        cv::arrowedLine(origImg, p1, p2, cvScalar(0, 0, 255), 6);
        cv::arrowedLine(origImg, p2, p1, cvScalar(0, 0, 255), 6);

        cv::arrowedLine(origImg, q1, q2, cvScalar(100, 100, 0), 6);
        cv::arrowedLine(origImg, q2, q1, cvScalar(100, 100, 0), 6);
        
        
        // Calculate total blood height
        int totalHeight = 325 - rc.y;
        std::cout << "totalHeight " << totalHeight << "\n";

        int plasmaHeight = rc.height;
        std::cout << "plasmaHeight " << plasmaHeight << "\n";

        int redBloodHeight = totalHeight - plasmaHeight;
        
        plasmaPercentage = ((double)plasmaHeight / totalHeight) * 100;
        redBloodPercentage = 100 - plasmaPercentage;

        std::cout << "plasmaPercentage " << plasmaPercentage << "\n";

        char buffer1 [10];
        char buffer2 [20];

        int n = std::sprintf(buffer1, "%.2f%%", plasmaPercentage);
        int n1 = std::sprintf(buffer2, "%.2f%%", redBloodPercentage);
        
        cv::putText(origImg, buffer1, cv::Point(rc.x + rc.width / 2 + 15, rc.y + rc.height/2 + 10), cv::FONT_HERSHEY_DUPLEX, 1.0, cvScalar(0, 0, 255));

        cv::putText(origImg, buffer2, cv::Point(rc.x + rc.width / 2 + 15, 325 - (redBloodHeight/2) - 10), cv::FONT_HERSHEY_DUPLEX, 1.0, cvScalar(100, 100, 0));
        
        
    //        cv::line(origImg, cv::Point(0, 325), cv::Point(500, 325), cvScalar(10));
        
        
    }
    
    UIImage *result = cvMatToUIImage(origImg);
    
    mask.release();
    img.release();
    origImg.release();
    imgRedMask.release();
    NSNumber *num1 = [NSNumber numberWithDouble:plasmaPercentage];
    NSNumber *num2 = [NSNumber numberWithDouble:redBloodPercentage];
    NSArray* arr = @[result, num1, num2, [NSNull null]];
    return arr;
   // return result;
}

+(UIImage *)cropImage:(UIImage *)image byRect:(CGRect)rect {

    cv::Rect roi = cv::Rect( (int) rect.origin.x, (int) rect.origin.y, 150,150);
    // Top Left Corner is X,Y
    cv::Mat cropImg = cv::Mat(img_scene, roi);
}

@end
