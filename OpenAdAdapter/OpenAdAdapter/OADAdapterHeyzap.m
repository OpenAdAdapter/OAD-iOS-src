//
//  OADAdapterHeyzap.m
//  OpenAdAdapterApp
//
//  Created by Artem Babenko on 4/29/15.
//  Copyright (c) 2015 Artem Babenko. All rights reserved.
//

#import "OpenAdAdapter.h"
#import "OADAdapterHeyzap.h"
#import <HeyzapAds/HeyzapAds.h>


@implementation OADAdapterHeyzap
{
    OpenAdAdapter * oad;
    NSString * name;
    NSString * _id;
    BOOL video, rewarded;
}


-(void)start:(OpenAdAdapter*)oad1 WithDictionary:(NSDictionary*)d1{
    self->oad = oad1;
    self->name = [d1 objectForKey:@"name"];
    self->_id = [d1 objectForKey:@"id"];
    
    self->video = [[d1 objectForKey:@"video"] boolValue];
    self->rewarded = [[d1 objectForKey:@"rewarded"] boolValue];
    
    
    
    [HeyzapAds startWithPublisherID: self->_id];
    [HZInterstitialAd setDelegate:self];
    if(self->rewarded)
        [HZIncentivizedAd fetch];
    [HZIncentivizedAd setDelegate:self];
    if(self->video)
        [HZVideoAd fetch];
}
-(BOOL)available{
    if(NSClassFromString(@"HeyzapAds")){
        return YES;
    }else{
        return NO;
    }
}
-(BOOL)verify{
    return NO;
}
-(void)tick{
    
}
-(void)showTopBanner:(UIViewController *)rootViewController{
    
}
-(void)showBottomBanner:(UIViewController *)rootViewController{
    
}
-(void)hideBanner{
    
}
-(BOOL)showFullscreen:(UIViewController *)rootViewController{
    if([HZIncentivizedAd isAvailable]){
        [HZInterstitialAd show];
        return YES;
    }
//    else if([HZVideoAd isAvailable]){
//        [HZVideoAd show];
//    }
    return NO;
}
-(BOOL)showVideo:(UIViewController *)rootViewController{
    if([HZVideoAd isAvailable]){
        [HZVideoAd show];
        return YES;
    }
    return NO;
}
-(BOOL)showRewarded:(UIViewController *)rootViewController{
    if([HZIncentivizedAd isAvailable]){
        [HZIncentivizedAd show];
        return YES;
    }
    return NO;
}
-(void)controller:(UIViewController *)rootViewController{
    
}
-(NSString*)name{
    return self->name;
}




















- (void) didShowAdWithTag:(NSString *)tag {
    NSLog(@"oad heyzap didShowAdWithTag");
}

- (void) didFailToShowAdWithTag:(NSString *)tag andError:(NSError *)error {
    NSLog(@"oad heyzap didFailToShowAdWithTag");
}

- (void) didClickAdWithTag:(NSString *)tag {
    NSLog(@"oad heyzap didClickAdWithTag");
}

- (void) didHideAdWithTag:(NSString *)tag {
    NSLog(@"oad heyzap didHideAdWithTag");
}

- (void) didReceiveAdWithTag:(NSString *)tag {
    NSLog(@"oad heyzap didReceiveAdWithTag");
}

- (void) didFailToReceiveAdWithTag: (NSString *)tag {
    NSLog(@"oad heyzap didFailToReceiveAdWithTag");
}

- (void) willStartAudio {
    NSLog(@"oad heyzap willStartAudio");
}

- (void) didFinishAudio {
    NSLog(@"oad heyzap didFinishAudio");
}










- (void) didCompleteAdWithTag: (NSString *)tag {
    NSLog(@"oad heyzap didCompleteAdWithTag");
    
    
    OADReward * _reward = [[OADReward alloc] initWithNetwork:self->name amount:1 currency:@""];
    [self->oad addReward:_reward];
    
}

- (void) didFailToCompleteAdWithTag: (NSString *)tag {
    NSLog(@"oad heyzap didFailToCompleteAdWithTag");
}




















@end
