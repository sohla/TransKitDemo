//
//  SOCueProtocol.h
//  TransKitDemo
//
//  Created by Stephen OHara on 8/05/2014.
//  Copyright (c) 2014 Steph OHara. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SOCueProtocol <NSObject>

-(void)willEnter:(NSDictionary *)userInfo;
-(void)didEnter:(NSDictionary *)userInfo;
-(void)willExit:(NSDictionary *)userInfo;
-(void)didExit:(NSDictionary *)userInfo;

@end
