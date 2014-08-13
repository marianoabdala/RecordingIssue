//
//  AppDelegate.m
//  RecordingIssue
//
//  Created by Mariano Abdala on 8/13/14.
//  Copyright (c) 2014 Zerously. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.captureSession = [[AVCaptureSession alloc] init];
    
	if ([self.captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        
		[self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    }
    
    self.captureScreenInput = [[AVCaptureScreenInput alloc] initWithDisplayID:CGMainDisplayID()];
    
    [self.captureScreenInput setCropRect:CGRectMake(0, 0, 100, 100)];
    
    if ([self.captureSession canAddInput:self.captureScreenInput]) {
        
        [self.captureSession addInput:self.captureScreenInput];
    }
    
    self.captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    [self.captureMovieFileOutput setDelegate:self];
    
    if ([self.captureSession canAddOutput:self.captureMovieFileOutput])
    {
        [self.captureSession addOutput:self.captureMovieFileOutput];
    }
    
    NSString *moviePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"My recording"];
    self.movieCaptureURL = [NSURL fileURLWithPath:moviePath];
    
    [[NSFileManager defaultManager] removeItemAtURL:self.movieCaptureURL
                                              error:nil];
    
    NSLog(@"Minimum Frame Duration: %f, Crop Rect: %@, Scale Factor: %f, Capture Mouse Clicks: %@, Capture Mouse Cursor: %@, Remove Duplicate Frames: %@",
		  CMTimeGetSeconds([self.captureScreenInput minFrameDuration]),
		  NSStringFromRect(NSRectFromCGRect([self.captureScreenInput cropRect])),
		  [self.captureScreenInput scaleFactor],
		  [self.captureScreenInput capturesMouseClicks] ? @"Yes" : @"No",
		  [self.captureScreenInput capturesCursor] ? @"Yes" : @"No",
		  [self.captureScreenInput removesDuplicateFrames] ? @"Yes" : @"No");
    
    
    NSLog(@"AVCaptureMovieFileOutput connections found: %lu", (unsigned long)self.captureMovieFileOutput.connections.count);
    
    for (AVCaptureConnection *connection in self.captureMovieFileOutput.connections) {
        
        NSLog(@"Connection found %@, Active: %@, Enabled: %@", connection, connection.isActive ? @"YES" : @"NO", connection.isEnabled ? @"YES" : @"NO");
    }
    
    [self.captureMovieFileOutput performSelector:@selector(stopRecording)
                                      withObject:nil
                                      afterDelay:5];
    
    [self.captureMovieFileOutput startRecordingToOutputFileURL:self.movieCaptureURL
                                             recordingDelegate:self];
}

#pragma mark AVCaptureFileOutputDelegate
- (BOOL)captureOutputShouldProvideSampleAccurateRecordingStart:(AVCaptureOutput *)captureOutput {
    
	// We don't require frame accurate start when we start a recording. If we answer YES, the capture output
    // applies outputSettings immediately when the session starts previewing, resulting in higher CPU usage
    // and shorter battery life.
	return NO;
}

#pragma mark AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    
    if (error) {
        
        NSLog(@"Error %@", error);
		return;
    }
    
    NSLog(@"Success!");
}

@end
