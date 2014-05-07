//
//  SOCueRunner.h
//  TransKitDemo
//
//  Created by Stephen OHara on 7/05/2014.
//  Copyright (c) 2014 Steph OHara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TransitionKit/TransitionKit.h>

@interface SOCueRunner : NSObject


-(void)loadJSONCuesWithPath:(NSString*)path completionBlock:(void (^)(NSError *error)) block;


-(void)nextState;

@end
