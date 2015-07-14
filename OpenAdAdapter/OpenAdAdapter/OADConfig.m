//
//  OADConfig.m
//  OpenAdAdapterApp
//
//  Created by Artem Babenko on 5/3/15.
//  Copyright (c) 2015 Artem Babenko. All rights reserved.
//

#import "OADConfig.h"


@implementation OADStAd
-(id)init{
    self = [super init];
    if (self)
    {
    }
    return self;

}
-(void)setupWithString:(NSString*)s1{
    self->name = s1;
}
-(void)setupWithDictionary:(NSDictionary*)d1{
    if(d1 == nil)return;
    self->name = [d1 objectForKey:@"name"];
    self->type = [d1 objectForKey:@"type"];
    self->preload = [d1 objectForKey:@"preload"];
    
}
-(NSString *) name{
    return self->name;
}
-(NSString *) type{
    return self->type;
}
-(NSString *) preload{
    return self->preload;
}
@end
@implementation OADStrategyLine
-(id)init{
    self = [super init];
    if (self)
    {
        self->list = [[NSMutableArray alloc] init];
        self->list1 = [[NSMutableArray alloc] init];
        
    }
    return self;

}
-(void)setup:(NSDictionary*)d1{
    id jaList = [d1 objectForKey:@"list"];
    if([jaList isKindOfClass:[NSArray class]]){
        NSArray * jaList_ = jaList;
        self->list = [[NSMutableArray alloc] init];
        for(int i = 0; i < [jaList count]; i++){
            id o2 = [jaList_ objectAtIndex:i];
            if(o2 == nil)continue;
            OADStAd * x = [[OADStAd alloc] init];
            if([o2 isKindOfClass:[NSString class]]){
                [x setupWithString:o2];
            }else if([o2 isKindOfClass:[NSDictionary class]]){
                [x setupWithDictionary:o2];
            }else{
                // not supported type
                continue;
            }
            [self->list addObject:x];
        }
    }
    id strategy = [d1 objectForKey:@"strategy"];
    if([strategy isKindOfClass:[NSString class]]){
        self->strategy = strategy;
    }else{
        self->strategy = nil;
    }
}
-(void)start{
    self->pos = 0;
    self->list1 = [[NSMutableArray alloc] init];
    int list_size = [self->list count];
    for(int  i = 0; i < list_size; i++){
        [self->list1 addObject:[self->list objectAtIndex:((i+shift)%list_size)]];
    }
    if([@"failsafe" isEqualToString:self->strategy]){
        
    }
    if([@"round-robin" isEqualToString:self->strategy]){
        shift++;
    }
    if([@"random" isEqualToString:self->strategy]){
        NSMutableArray * list2 = [[NSMutableArray alloc] init];
//        int list1_size = [self->list1 count];
        while([self->list1 count] > 0){
            u_int32_t rnd = arc4random();
            int i = rnd % [self->list1 count];
//            int cnt = [self->list1 count];
//            int i1 = rnd % cnt;
            [list2 addObject:[self->list1 objectAtIndex:i]];
            [self->list1 removeObjectAtIndex:i];
        }
        self->list1 = list2;
    }
    
    NSMutableString * slog = [NSMutableString stringWithString:@"start list1: "];
    for(int i = 0; i < [self->list1 count]; i++){
        [slog appendString:[[self->list1 objectAtIndex:i] name]];
        [slog appendString:@" "];
    }
    NSLog(slog);
}
-(OADStAd*)next{
    if(self->list1 == nil)return nil;
    if([self->list1 count] == 0)return nil;
    OADStAd * stad = [self->list1 objectAtIndex:0];
    [self->list1 removeObjectAtIndex:0];
    return stad;
}

@end
@implementation OADStrategy

-(id)init{
    self = [super init];
    if (self)
    {
        self->banner = [[OADStrategyLine alloc] init];
        self->fullscreen = [[OADStrategyLine alloc] init];
        self->video = [[OADStrategyLine alloc] init];
        self->rewarded = [[OADStrategyLine alloc] init];
    }
    return self;

}



-(void)setup:(NSDictionary*)d1{
    if(d1 == nil )return;
    
    {
        id banner1 = [d1 objectForKey:@"banner"];
        if ([banner1 isKindOfClass:[NSDictionary class]]){
            self->banner = [[OADStrategyLine alloc] init];
            [self->banner setup:banner1];
        }
    }
    
    {
        id fullscreen1 = [d1 objectForKey:@"fullscreen"];
        if ([fullscreen1 isKindOfClass:[NSDictionary class]]){
            self->fullscreen = [[OADStrategyLine alloc] init];
            [self->fullscreen setup:fullscreen1];
        }
    }
    
    {
        id video1 = [d1 objectForKey:@"video"];
        if ([video1 isKindOfClass:[NSDictionary class]]){
            self->video = [[OADStrategyLine alloc] init];
            [self->video setup:video1];
        }
    }
    
    {
        id rewarded1 = [d1 objectForKey:@"rewarded"];
        if ([rewarded1 isKindOfClass:[NSDictionary class]]){
            self->rewarded = [[OADStrategyLine alloc] init];
            [self->rewarded setup:rewarded1];
        }
    }
    
    
    
}
-(OADStrategyLine *) banner{
    return self->banner;
}
-(OADStrategyLine *) fullscreen{
    return self->fullscreen;
}
-(OADStrategyLine *) video{
    return self->video;
}
-(OADStrategyLine *) rewarded{
    return self->rewarded;
}
@end




@implementation OADConfig
-(id)init{
    self = [super init];
    if (self)
    {
        self->strategy = [[OADStrategy alloc] init];
    }
    return self;
    
}
-(void)setup:(NSDictionary*)d1{
    if(d1 == nil)return;
    self->strategy = [[OADStrategy alloc] init];
    
    id strategy1 = [d1 objectForKey:@"strategy"];
    if(strategy1 != nil){
        if([strategy1 isKindOfClass:[NSDictionary class]]){
            [self->strategy setup:strategy1];
        }
    }
}
-(OADStrategy *) strategy{
    return self->strategy;
}
@end
