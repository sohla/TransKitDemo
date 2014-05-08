//
//  SOBaseCue.m
//  TransKitDemo
//
//  Created by Stephen OHara on 8/05/2014.
//  Copyright (c) 2014 Steph OHara. All rights reserved.
//

#import "SOBaseCue.h"

@interface SOBaseCue()

@end

@implementation SOBaseCue


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
    NSLog(@"did ENTER %@",[[userInfo[@"transition"] destinationState] name]);
    
}


@end
