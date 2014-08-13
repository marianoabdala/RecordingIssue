//
//  AppDelegate.h
//  RecordingIssue
//
//  Created by Mariano Abdala on 8/13/14.
//  Copyright (c) 2014 Zerously. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, AVCaptureFileOutputDelegate, AVCaptureFileOutputRecordingDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureScreenInput *captureScreenInput;
@property (strong, nonatomic) AVCaptureMovieFileOutput *captureMovieFileOutput;
@property (strong, nonatomic) NSURL *movieCaptureURL;

@end
