//
//  SOFollowOnCue.m
//  TransKitDemo
//
//  Created by Stephen OHara on 8/05/2014.
//  Copyright (c) 2014 Steph OHara. All rights reserved.
//

#import "SOFollowOnCue.h"

@implementation SOFollowOnCue

-(void)willExit:(NSDictionary *)userInfo{
    NSLog(@"will EXIT %@",[[userInfo[@"transition"] sourceState] name]);
    
}
-(void)didExit:(NSDictionary *)userInfo{
    NSLog(@"did EXIT %@",[[userInfo[@"transition"] sourceState] name]);
    
}


-(void)willEnter:(NSDictionary *)userInfo{
    NSLog(@"will ENTER %@",[[userInfo[@"transition"] destinationState] name]);
    
}


-(void)didEnter:(NSDictionary *)userInfo{

    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        SOCueRunner *cueRunner = [userInfo objectForKey:@"cueRunner"];
        [cueRunner nextState];
        
    });
}

@end
