//
//  TPJSViewController.m
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

#import "TPJSViewController.h"

@interface TPJSViewController ()

@end

@implementation TPJSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    transGreen = [UIColor colorWithRed:0 green:1 blue:0 alpha:.5];
    transRed = [UIColor colorWithRed:1 green:0 blue:0 alpha:.5];
    jackView.transform = CGAffineTransformMakeRotation(M_PI/-2);
    p2Ready.transform = CGAffineTransformMakeRotation(M_PI);
    p2Slap.transform = CGAffineTransformMakeRotation(M_PI);
    p1Score.transform = CGAffineTransformMakeRotation(M_PI/-2);
    p2Score.transform = CGAffineTransformMakeRotation(M_PI/-2);
    p1Time.transform = CGAffineTransformMakeRotation(M_PI/-2);
    p2Time.transform = CGAffineTransformMakeRotation(M_PI/-2);
    p1Average.transform = CGAffineTransformMakeRotation(M_PI/-2);
    p2Average.transform = CGAffineTransformMakeRotation(M_PI/-2);
    
    slapArray = [[NSArray alloc] initWithObjects:p1Slap, p2Slap, nil];
    readyArray = [[NSArray alloc]initWithObjects:p1Ready, p2Ready, nil];
    slapTime = [[NSArray alloc]initWithObjects:p1Time, p2Time, nil];
    averageLabelArray =[[NSArray alloc]initWithObjects:p1Average, p2Average, nil];
    
    jackImageArray = [[NSArray alloc]initWithObjects:@"IMG_0008.png", @"jackGrassCrop.png",@"IMG_0026.png",@"IMG_0335.png",@"IMG_0343.png",@"IMG_0805.png",@"IMG_0809.png",@"IMG_0823.png",@"IMG_9372.png",@"IMG_9386.png",@"IMG_9423.png",@"IMG_9560.png",@"IMG_9759.png",@"IMG_9942.png",@"IMG_9943.png",@"IMG_9959.png", nil];
    if(self.view.frame.size.height == 568){ // move the reset, single player buttons for a tall iPhone
        resetButton.center = CGPointMake(274.0f, 529.0f);
        singlePlayerLabel.center = CGPointMake(75.0f,500.0f);
        singlePlayerSwitch.center = CGPointMake(75.0f, 532.0f);
    }else{
        resetButton.transform = CGAffineTransformMakeRotation(M_PI/-2);
        singlePlayerLabel.transform = CGAffineTransformMakeRotation(M_PI/-2);
        singlePlayerSwitch.transform = CGAffineTransformMakeRotation(M_PI/-2);
    }
    srandom(time(NULL));
    [self reset:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)itIsSlapTime{
    _slapReady = TRUE;
    startTime = CACurrentMediaTime();
    int thisRandIndex = (int)(random()%[jackImageArray count]);
    [jackView setImage:[UIImage imageNamed:[jackImageArray objectAtIndex:thisRandIndex]]];
    winnerWinner = 0;
}


-(void)updateScore{
    p1Score.text = [NSString stringWithFormat:@"%d", score[0]];
    p2Score.text = [NSString stringWithFormat:@"%d", score[1]];
}

#pragma mark Button Actions

-(IBAction)readyPress:(id)sender{
    UIButton *thisButton = sender;
    [thisButton setBackgroundColor:[UIColor greenColor]];
    if ([thisButton isEqual:p1Ready]) {
        [thisButton setTitle:@"P1 Ready" forState:UIControlStateNormal];
    }else{
        [thisButton setTitle:@"P2 Ready" forState:UIControlStateNormal];
    }
    // users reported errors with losing points for taping the ready button. Debounce fixes this issue
    // only debounced when actually setting the timer. No need if only 1/2 is ready
    debounced = NO;
    if([debounceTimer isValid]){
        [debounceTimer invalidate];
        debounceTimer = nil;
    }
    NSLog(@"button pressed %@", thisButton);
    if (([p1Ready isTouchInside] && [p2Ready isTouchInside])||[singlePlayerSwitch isOn]) {
        debounceTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(setDebounce) userInfo:nil repeats:NO];
        for (UIButton *slapButton in slapArray) {
            [slapButton setBackgroundColor:nil];
            if([slapButton isEqual:p1Slap]){
                [slapButton setTitle:@"P1 Slap" forState:UIControlStateNormal];
            }
            else{
                [slapButton setTitle:@"P2 Slap" forState:UIControlStateNormal];
            }
        }
        for(UILabel *thisLabel in slapTime){
            thisLabel.text = nil;
        }
        _slapReady = NO;
        [jackView setImage:nil];
        float delayTime = (random()%100)/33.3 +1; //1-4 seconds
        delayTimer = [NSTimer scheduledTimerWithTimeInterval:delayTime target:self selector:@selector(itIsSlapTime) userInfo:nil repeats:NO];
    }
}

-(void)setDebounce{
    debounced = YES;
    //NSLog(@"debounced now");
}

-(IBAction)readyRelease:(id)sender{
    int currentPlayer;
    //NSLog(@"readyRelease called with sender %@", sender);
    if ([sender isEqual:p1Ready]) {
        currentPlayer = 1;
    }else{
        currentPlayer = 2;
    }
    if([debounceTimer isValid]){
        [debounceTimer invalidate];
        debounceTimer = nil;
    }
    if([delayTimer isValid]){
        [delayTimer invalidate];
        delayTimer = nil;
    }
    
    UIButton *thisButton = sender;
    [thisButton setBackgroundColor:nil];
    
    if(!_slapReady && debounced){ //false start only if debounced
        [thisButton setBackgroundColor:[UIColor redColor]];
        [thisButton setTitle:@"FALSE START!" forState:UIControlStateNormal];
        score[currentPlayer-1]--;
        [self updateScore];
    }
}

-(IBAction)slapPress:(id)sender{
    //NSLog(@"slapped with sender %@", sender);
    double thisSlapTime = CACurrentMediaTime();
    int currentPlayer;
    if ([sender isEqual:p1Slap]) {
        currentPlayer = 1;
    }else {
        currentPlayer = 2;
    }
    //check for doubleTouch cheaters:
    UIButton *slapView = [slapArray objectAtIndex:currentPlayer-1];
    UIButton *thisReadyButton = [readyArray objectAtIndex:currentPlayer-1];
    if([thisReadyButton isTouchInside]){ //check for pressing both slap and ready
        [slapView setBackgroundColor:[UIColor redColor]];
        [slapView setTitle:@"Two-Fingered Cheat!" forState:UIControlStateNormal];
        score[currentPlayer-1]--;
        [self updateScore];
    }
//    else if(!_slapReady){
//            if([delayTimer isValid]){
//            [delayTimer invalidate];
//            delayTimer = nil;
//        }
//    }
    else{
        UILabel *thisLabel = [slapTime objectAtIndex:currentPlayer-1];
        thisLabel.text = [NSString stringWithFormat:@"%2.3f", thisSlapTime-startTime];
        sum[currentPlayer-1] += thisSlapTime-startTime;
        count[currentPlayer-1]++;
        if(count[currentPlayer-1]){ // no divide by 0 please
            if([averageLabelArray count]){//not for iPhone: no elements in this array
                NSString *labelString = [NSString stringWithFormat:@"Average:%2.3f", sum[currentPlayer-1]/count[currentPlayer-1]];
                UILabel *thisAverageLabel = [averageLabelArray objectAtIndex:currentPlayer-1];
                thisAverageLabel.text = labelString;
            }
        }
        if(!winnerWinner || [singlePlayerSwitch isOn]){ //if you are the first one to tap
            winnerWinner = currentPlayer;
            winnerTime = thisSlapTime;
            score[currentPlayer-1]++;
            [self updateScore];
            [slapView setBackgroundColor:transGreen];
            
            
        }else{ // if you were the slow one set it red for indication
            [slapView setBackgroundColor:transRed];
            _slapReady = false; //both players are done, so reset, required so that slow player doest lose a point
        }
    }
}

-(IBAction)reset:(id)sender{
    for (UIButton *slapButton in slapArray) {
        [slapButton setBackgroundColor:nil];
        if([slapButton isEqual:p1Slap]){
            [slapButton setTitle:@"P1 Slap" forState:UIControlStateNormal];
        }
        else{
            [slapButton setTitle:@"P2 Slap" forState:UIControlStateNormal];
        }
    }
    for(UILabel *thisLabel in slapTime){
        thisLabel.text = nil;
    }
    for(UILabel *thisLabel in averageLabelArray){
        thisLabel.text = nil;
    }
    _slapReady = NO;
    [jackView setImage:nil];
    score[0] = 0;
    score[1] = 0;
    count[0] = 0;
    count[1] = 0;
    sum[0] = 0;
    sum[1] = 0;
    [self updateScore];
}

//-(int)scoreForPlayer:(int)player{
//    if(player == 1 || player == 2){
//        return score[player-1];
//    }
//    else{
//        return 0;
//    }
//}


@end
