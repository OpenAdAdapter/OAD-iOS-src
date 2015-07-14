//
//  OADAdapterAdcolony.m
//  OpenAdAdapterApp
//
//  Created by Artem Babenko on 5/5/15.
//  Copyright (c) 2015 Artem Babenko. All rights reserved.
//

#import "OpenAdAdapter.h"
#import "OADAdapterAdcolony.h"
#import <AdColony/AdColony.h>

@implementation OADAdapterAdcolony
{
    OpenAdAdapter * oad;
    NSString * name;
    NSString * _id;
    NSString * videoId;
    NSString * rewardedId;
    BOOL gotFullscreen;
    BOOL gotRewarded;
}


-(void)start:(OpenAdAdapter*)oad1 WithDictionary:(NSDictionary*)d1{
    self->oad = oad1;
    self->name = [d1 objectForKey:@"name"];
    self->_id = [d1 objectForKey:@"id"];
    self->videoId = [d1 objectForKey:@"videoId"];
    self->rewardedId = [d1 objectForKey:@"rewardedId"];
    NSMutableArray * ids = [[NSMutableArray alloc] init];
    if(self->videoId){
        [ids addObject:self->videoId];
    }
    if(self->rewardedId){
        if(![self->rewardedId isEqualToString:self->videoId]){
            [ids addObject:self->rewardedId];
        }
    }
    
    [AdColony configureWithAppID:self->_id zoneIDs:ids delegate:self logging:YES];
}
-(BOOL)available{
    if(NSClassFromString(@"AdColony")){
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
    //if(self->gotFullscreen)
    if([AdColony zoneStatusForZone:self->videoId] == ADCOLONY_ZONE_STATUS_ACTIVE)
    {
        self->gotFullscreen = NO;
        if([self->videoId isEqualToString:self->rewardedId]){
            self->gotRewarded = NO;
        }
        [AdColony playVideoAdForZone:self->videoId withDelegate:self];
        return YES;
    }
    return NO;
}
-(BOOL)showVideo:(UIViewController *)rootViewController{
    //if(self->gotFullscreen)
    if([AdColony zoneStatusForZone:self->videoId] == ADCOLONY_ZONE_STATUS_ACTIVE)
    {
        self->gotFullscreen = NO;
        if([self->videoId isEqualToString:self->rewardedId]){
            self->gotRewarded = NO;
        }
        [AdColony playVideoAdForZone:self->videoId withDelegate:self];
        return YES;
    }
    return NO;
}
-(BOOL)showRewarded:(UIViewController *)rootViewController{
    //if(self->gotRewarded)
    if([AdColony zoneStatusForZone:self->rewardedId] == ADCOLONY_ZONE_STATUS_ACTIVE)
    {
        // self->gotRewarded = NO;
        if([self->rewardedId isEqualToString:self->videoId]){
            //     self->gotFullscreen = NO;
        }
        [AdColony playVideoAdForZone:self->rewardedId withDelegate:self withV4VCPrePopup:YES andV4VCPostPopup:YES];
        return YES;
    }
    return NO;
}
-(void)controller:(UIViewController *)rootViewController{
    
}
-(NSString*)name{
    return self->name;
}

















- ( void ) onAdColonyAdAvailabilityChange:( BOOL )available inZone:( NSString * )zoneID{
    NSLog(@"oad adcolony onAdColonyAdAvailabilityChange %d %@", available, zoneID);
    if(zoneID){
        if([zoneID isEqualToString:self->videoId]){
            self->gotFullscreen = available;
        }
        if([zoneID isEqualToString:self->rewardedId]){
            self->gotRewarded = available;
        }
        
    }
    
}


/** @name Virtual Currency Rewards (V4VC) */

/**
 * Notifies your app when a virtual currency transaction has completed as a result of displaying an ad.
 * In your implementation, check for success and implement any app-specific code that should be run when
 * AdColony has successfully rewarded. Client-side V4VC implementations should increment the user's currency
 * balance in this method. Server-side V4VC implementations should contact the game server to determine
 * the current total balance for the virtual currency.
 * @param success Whether the transaction succeeded or failed.
 * @param currencyName The name of currency to reward.
 * @param amount The amount of currency to reward.
 * @param zoneID The affected zone.
 */
- ( void ) onAdColonyV4VCReward:( BOOL )success currencyName:( NSString * )currencyName currencyAmount:( int )amount inZone:( NSString * )zoneID{
    NSLog(@"oad adcolony onAdColonyV4VCReward %d %@ %d %@", success, currencyName, amount, zoneID);
    
    
    
    
    OADReward * _reward = [[OADReward alloc] initWithNetwork:self->name amount:amount currency:currencyName];
    [self->oad addReward:_reward];
    
}


































/**
 * Notifies your app that an ad will actually play in response to the app's request to play an ad.
 * This method is called when AdColony has taken control of the device screen and is about to begin
 * showing an ad. Apps should implement app-specific code such as pausing a game and turning off app music.
 * @param zoneID The affected zone.
 */
- ( void ) onAdColonyAdStartedInZone:( NSString * )zoneID{
    NSLog(@"oad adcolony %@", zoneID);
    
}

/**
 * Notifies your app that an ad completed playing (or never played) and control has been returned to the app.
 * This method is called when AdColony has finished trying to show an ad, either successfully or unsuccessfully.
 * If an ad was shown, apps should implement app-specific code such as unpausing a game and restarting app music.
 * @param shown Whether an ad was actually shown.
 * @param zoneID The affected zone.
 */
- ( void ) onAdColonyAdAttemptFinished:(BOOL)shown inZone:( NSString * )zoneID{
    NSLog(@"oad adcolony %@ %@", shown, zoneID);
    
}

/**
 * Alternative for `- onAdColonyAdAttemptFinished:inZone` that passes an AdColonyAdInfo object to the delegate. The AdColonyAdInfo object can be queried
 * for information about the ad session: whether or not the ad was shown, the associated zone ID, whether or not the video was an In-App Purchase Promo (IAPP),
 * the type of engagement that triggered an IAP, etc. If your application is showing IAPP advertisements, you will need to implement this callback
 * instead of `- onAdColonyAdAttemptFinished:inZone` so you can decide what action to take once the ad has completed.
 * @param info An AdColonyAdInfo object containing metadata about the associated ad.
 * @see onAdColonyAdAttemptFinished:inZone
 * @see AdColonyAdInfo
 */
- ( void ) onAdColonyAdFinishedWithInfo:( AdColonyAdInfo * )info{
    NSLog(@"oad adcolony ");
}














@end
