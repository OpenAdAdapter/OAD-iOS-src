//
//  OADConfig.h
//  OpenAdAdapterApp
//
//  Created by Artem Babenko on 5/3/15.
//  Copyright (c) 2015 Artem Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OADStAd : NSObject
{
    NSString * name;
    NSString * type;
    NSString * preload;
}
-(void)setupWithString:(NSString*)s1;
-(void)setupWithDictionary:(NSDictionary*)d1;
-(NSString *) name;
-(NSString *) type;
-(NSString *) preload;
@end




@interface OADStrategyLine : NSObject
{
    NSMutableArray * list;
    NSMutableArray * list1;
    NSString * strategy;
    int pos, shift;
}
-(void)setup:(NSDictionary*)d1;
-(void)start;
-(OADStAd*)next;
@end




@interface OADStrategy : NSObject
{
    OADStrategyLine * banner;
    OADStrategyLine * fullscreen;
    OADStrategyLine * video;
    OADStrategyLine * rewarded;
}
-(void)setup:(NSDictionary*)d1;
-(OADStrategyLine *) banner;
-(OADStrategyLine *) fullscreen;
-(OADStrategyLine *) video;
-(OADStrategyLine *) rewarded;

@end




@interface OADConfig : NSObject
{
    OADStrategy * strategy;
}
-(void)setup:(NSDictionary*)d1;
-(OADStrategy *) strategy;
@end









