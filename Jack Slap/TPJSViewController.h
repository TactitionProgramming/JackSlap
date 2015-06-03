//
//  TPJSViewController.h
//  Jack Slap
//
//  Created by Christopher Stockbridge on 3/1/14.
//  Copyright (c) 2014 Christopher Stockbridge. All rights reserved.
//
//  This game is a raw reaction time test/race for one or two players
//  Added features include debouncing the ready button, and scores with average time of each player
//  It works on both iPhone and iPad devices
//
//  Jack Slap is licensed under the MIT license shown below:

//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

#import <UIKit/UIKit.h>

@interface TPJSViewController : UIViewController{
    IBOutlet UIImageView  *jackView;
    IBOutlet UIButton *p1Ready;
    IBOutlet UIButton *p2Ready;
    IBOutlet UIButton *p1Slap;
    IBOutlet UIButton *p2Slap;
    IBOutlet UILabel *p1Score;
    IBOutlet UILabel *p2Score;
    IBOutlet UILabel *p1Time;
    IBOutlet UILabel *p2Time;
    IBOutlet UILabel *p1Average;
    IBOutlet UILabel *p2Average;
    IBOutlet UIButton *resetButton;
    IBOutlet UILabel *singlePlayerLabel;
    IBOutlet UISwitch *singlePlayerSwitch;
    
    NSArray *slapArray;
    NSArray *readyArray;
    NSArray *slapTime;
    NSArray *averageLabelArray;
    NSArray *jackImageArray;
    NSTimer *delayTimer;
    NSTimer *debounceTimer;
    BOOL debounced;
    UIColor *transRed;
    UIColor *transGreen;
    
    int score[2];
    
    double startTime;
    double winnerTime;
    int winnerWinner;
    unsigned count[2];
    double sum[2];
    
}

@property BOOL slapReady;


-(IBAction)readyPress:(id)sender;
-(IBAction)readyRelease:(id)sender;
-(IBAction)slapPress:(id)sender;
-(IBAction)reset:(id)sender;
-(void)itIsSlapTime;
-(void)updateScore;
-(void)setDebounce;
//-(int)scoreForPlayer:(int)player;


@end
