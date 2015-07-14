//
//  OpenAdAdapter.m
//  OpenAdAdapter
//
//  Created by Artem Babenko on 5/25/15.
//  Copyright (c) 2015 Artem Babenko. All rights reserved.
//

#import "OpenAdAdapter.h"
#import "OADAdapter.h"
#import "OADConfig.h"
#import <AudioToolbox/AudioToolbox.h>
@import UIKit;


@implementation OADReward
{
    NSString*network;
    float amount;
    NSString*currency;
}
-(id)initWithNetwork:(NSString*)network1 amount:(float)amount1 currency:(NSString*) currency1{
    self = [super init];
    if(self){
        self->network = network1;
        self->amount = amount1;
        self->currency = currency1;
    }
    return self;
}
-(NSString*)network{
    return self->network;
}
-(float)amount{
    return self->amount;
}
-(NSString*)currency{
    return self->currency;
}

@end




@implementation OpenAdAdapter{
    NSMutableArray * networks;
    OADAdapter * bannerAdapter;
    OADAdapter * fullscreenAdapter;
    BOOL top, _showBanner, _bannerShown;
    UIViewController * bannerController;
    UIViewController * fullscreenController;
    OADConfig * config;
    OADStrategyLine * bannerLine;
    BOOL hasReward;
    NSMutableArray*rewards;
    float scale;
}
static OpenAdAdapter * OpenAdAdapter_oad = nil;
- (id)init
{
    self = [super init];
    if (self)
    {
        self->networks = [[NSMutableArray alloc] init];
        self->config = [[OADConfig alloc] init];
        [self tick];
        self->rewards = [[NSMutableArray alloc] init];
        self->scale = 1;
    }
    return self;
}
-(void)tick{
    [self performSelector:@selector(tick) withObject:nil afterDelay:1.0];
    NSLog(@"tick");
    if(self->bannerAdapter != nil){
        [bannerAdapter tick];
    }
    if(self->_showBanner != self->_bannerShown){
        
        if(self->_showBanner){
            NSLog(@"oad show banner START");
            // show banner
            if(bannerAdapter){
                [bannerAdapter hideBanner];
                bannerAdapter = nil;
            }
            if(bannerLine == nil){
                bannerLine =[[OpenAdAdapter_oad->config strategy] banner];
                [bannerLine start];
            }
            
            while(true){
                OADStAd * stad = [bannerLine next];
                if(stad == nil){
                    NSLog(@"oad show banner nil");
                    [bannerLine start];
                    break;
                }
                NSLog(@"oad show banner %@", [stad name]);
                OADAdapter * adapter = [OpenAdAdapter adapter:[stad name]];
                if(adapter == nil)continue;
                //        bannerAdapter = [OpenAdAdapter adapter:@"inmobi"];
                if(adapter != nil){
                    bannerAdapter = adapter;
                    if(self->top){
                        [bannerAdapter showTopBanner:bannerController];
                    }else{
                        [bannerAdapter showBottomBanner:bannerController];
                    }
                    
                    self->scale = [[UIScreen mainScreen] scale];
                    self->_bannerShown = YES;
                    break;
                }
            }
        }else{
            // hide banner
            if(bannerAdapter){
                [bannerAdapter hideBanner];
                bannerAdapter = nil;
            }
            self->_bannerShown = NO;
            //self->_bannerShown = self->_showBanner;
            
        }
    }
    
    if(self->_bannerShown){
        // check if banner has error then remove banner
        
        if(bannerAdapter){
            if([bannerAdapter isBannerFailed]){
                [bannerAdapter hideBanner];
                bannerAdapter = nil;
                self->_bannerShown = NO;
            }
        }
    }
    
    
}
+(void)showTopBanner:(UIViewController *)controller{
    NSLog(@"OAD showTopBanner");
    [OpenAdAdapter setup];
    OpenAdAdapter_oad->top = YES;
    OpenAdAdapter_oad->_showBanner=YES;
    OpenAdAdapter_oad->bannerController = controller;
}
+(void)showBottomBanner:(UIViewController *)controller{
    NSLog(@"OAD showBottomBanner");
   [OpenAdAdapter setup];
    OpenAdAdapter_oad->top = NO;
    OpenAdAdapter_oad->_showBanner=YES;
    OpenAdAdapter_oad->bannerController = controller;
}
+(void)hideBanner{
    NSLog(@"OAD hideBanner");
    [OpenAdAdapter setup];
    OpenAdAdapter_oad->_showBanner=NO;
}
+(void)showFullscreen:(UIViewController *)controller{
    [OpenAdAdapter setup];
    OpenAdAdapter_oad->fullscreenController = controller;
    //OpenAdAdapter_oad->fullscreenAdapter = [OpenAdAdapter adapter:@"inmobi"];
    OpenAdAdapter_oad->fullscreenAdapter = nil;
    
    OADStrategyLine * line = [[OpenAdAdapter_oad->config strategy] fullscreen];
    [line start];
    int step = 0;
    while(true){
        OADStAd * stad = [line next];
        if(stad == nil){
            NSLog(@"OAD fullscreen nil");
            break;
        }
        OADAdapter * adapter = [OpenAdAdapter adapter:[stad name]];
        if(adapter == nil){
            NSLog(@"OAD fullscreen %@ nil", [stad name]);
            continue;
        }
        if([adapter showFullscreen:controller]){
            NSLog(@"OAD fullscreen %@ YES", [stad name]);
            OpenAdAdapter_oad->fullscreenAdapter = adapter;
            break;
        }else{
            NSLog(@"OAD fullscreen %@ NO", [stad name]);
            step++;
        }
    }
}
+(void)showVideo:(UIViewController *)controller{
    [OpenAdAdapter setup];
    OpenAdAdapter_oad->fullscreenController = controller;
    //OpenAdAdapter_oad->fullscreenAdapter = [OpenAdAdapter adapter:@"inmobi"];
    OpenAdAdapter_oad->fullscreenAdapter = nil;
    
    OADStrategyLine * line = [[OpenAdAdapter_oad->config strategy] video];
    [line start];
    int step = 0;
    while(true){
        OADStAd * stad = [line next];
        if(stad == nil)break;
        OADAdapter * adapter = [OpenAdAdapter adapter:[stad name]];
        if(adapter == nil)continue;
        if([adapter showVideo:controller]){
            OpenAdAdapter_oad->fullscreenAdapter = adapter;
            break;
        }else{
            step++;
        }
    }
}
+(void)showRewarded:(UIViewController *)controller{
    [OpenAdAdapter setup];
    OpenAdAdapter_oad->fullscreenController = controller;
    //OpenAdAdapter_oad->fullscreenAdapter = [OpenAdAdapter adapter:@"inmobi"];
    OpenAdAdapter_oad->fullscreenAdapter = nil;
    
    OADStrategyLine * line = [[OpenAdAdapter_oad->config strategy] rewarded];
    [line start];
    int step = 0;
    while(true){
        OADStAd * stad = [line next];
        if(stad == nil)break;
        OADAdapter * adapter = [OpenAdAdapter adapter:[stad name]];
        if(adapter == nil)continue;
        if([adapter showRewarded:controller]){
            OpenAdAdapter_oad->fullscreenAdapter = adapter;
            break;
        }else{
            step++;
        }
    }
}
+(OADAdapter*)adapter:(NSString*)s1{
    if(s1 == nil)return nil;
    
    for(int i = 0; i < [OpenAdAdapter_oad->networks count]; i++){
        OADAdapter * adapter1 = [OpenAdAdapter_oad->networks objectAtIndex:i];
        if ([[adapter1 name] isEqualToString:s1]){
            return adapter1;
        }
    }
    
    return nil;
}
+(BOOL)verifyFramework:(NSString*)s1{
    if (s1 == nil)return NO;
    
    NSString * clss = nil;
    
    if([s1 isEqualToString:@"AdSupport"]){
        clss = @"ASIdentifierManager";
    }else if([s1 isEqualToString:@"AudioToolbox"]){
        clss = @"NA";
    }else if([s1 isEqualToString:@"AVFoundation"]){
        clss = @"AVAsset";
    }else if([s1 isEqualToString:@"CoreGraphics"]){
        clss = @"CGBitmapContext";
    }else if([s1 isEqualToString:@"MessageUI"]){
        clss = @"MFMailComposeViewController";
    }else if([s1 isEqualToString:@"StoreKit"]){
        clss = @"SKPayment";
    }else if([s1 isEqualToString:@"SystemConfiguration"]){
        clss = @"SCNetworkConnection";
    }else if([s1 isEqualToString:@""]){
        clss = @"NA";
    }else if([s1 isEqualToString:@""]){
        clss = @"NA";
    }else{
        clss = @"NA";
    }
    
    if([clss isEqualToString:@"NA"]){
        return YES;
    }
    
    if(NSClassFromString(clss)){
        return YES;
    }else{
        return NO;
    }
    
}
+(void)test3:(UIViewController *)rootViewController{
    [OpenAdAdapter setup];
    
    OADAdapter * adapter1 = [OpenAdAdapter adapter:@"admob"];
    [adapter1 showBottomBanner:rootViewController];
}
+(void)test2:(UIViewController *)rootViewController{
    [OpenAdAdapter setup];
    
    OADAdapter * adapter1 = [OpenAdAdapter adapter:@"admob"];
    
    [adapter1 showFullscreen:rootViewController];
    
}
+(void)test1{
    [OpenAdAdapter setup];
    [OpenAdAdapter verify];
    
    OADAdapter * adapter1 = [OpenAdAdapter adapter:@"admob"];
    BOOL r1 = [adapter1 available];
    BOOL r1a = [adapter1 verify];
    //    OADAdapter * adapter2 = [OpenAdAdapter buildAdapter:@"inmobi"];
    //    BOOL r2 = [adapter2 available];
    //    BOOL r2a = [adapter2 verify];
    //    OADAdapter * adapter3 = [OpenAdAdapter buildAdapter:@"heyzap"];
    //    BOOL r3 = [adapter3 available];
    //    BOOL r3a = [adapter3 verify];
    //    OADAdapter * adapter4 = [OpenAdAdapter buildAdapter:@"chartboost"];
    //    BOOL r4 = [adapter4 available];
    //    BOOL r4a = [adapter4 verify];
    //    OADAdapter * adapter5 = [OpenAdAdapter buildAdapter:@"aerserv"];
    //    BOOL r5 = [adapter5 available];
    //    BOOL r5a = [adapter5 verify];
    //    OADAdapter * adapter6 = [OpenAdAdapter buildAdapter:@"fake"];
    //    BOOL r6 = [adapter6 available];
    //    BOOL r6a = [adapter6 verify];
    
}
+(void)verify{
    if(NSClassFromString(@"ASIdentifierManager")){
        NSLog(@"Has AdSupport framework");
    }else{
        NSLog(@"Missing AdSupport framework");
    }
    
    
    
}
+(void)setup{
    if(OpenAdAdapter_oad != nil)return;
    OAD_dispatchMain(^{
        if(OpenAdAdapter_oad != nil)return;
        OpenAdAdapter_oad = [[OpenAdAdapter alloc] init];
    });
}
-(void)setupNetwork:(NSDictionary*)d1{
    [OpenAdAdapter setup];
    NSString * name = [d1 objectForKey:@"name"];
    // admob heyzap chartboost inmobi aerserv
    //    if(![name isEqualToString:@"aerserv"])
    //        return;
    // aerserv-inmobi
    //    if(![name isEqualToString:@"aerserv"] && ![name isEqualToString:@"inmobi"])
    //        return;
    // aerserv inmobi chartboost
    // problem heyzap
    //    if([name isEqualToString:@"heyzap"])
    //        return;
    OADAdapter * adapter = [OpenAdAdapter buildAdapter:name];
    if(!adapter){
        NSLog(@"OAD no adapter %@", name);
        return;
    }
    if (![adapter available]) {
        NSLog(@"OAD not available %@", name);
        return;
    }
    [adapter start:self WithDictionary:d1];
    [self->networks addObject:adapter];
}
void OAD_dispatchMain(void (^block)(void))
{
    if ([NSThread isMainThread])
    {
        block();
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}
+(OADAdapter *)buildAdapter:(NSString*)name{
    [OpenAdAdapter setup];
    if(name == nil){
        return nil;
    }
    NSLog(@"OAD buildAdapter %@", name);
    NSString * capname = [NSString stringWithFormat:@"%@%@",
                          [[name substringToIndex:1] uppercaseString],
                          [name substringFromIndex:1]];
    
    id object = [[NSClassFromString([NSString stringWithFormat:@"OADAdapter%@", capname]) alloc] init];
    NSLog(@"OAD buildAdapter res %@", object);
    return object;
}
+(void)startWithDictionary:(NSDictionary*)d1{
    [OpenAdAdapter setup];
    if(d1 == nil){
        return;
    }
    OpenAdAdapter_oad->config = [[OADConfig alloc] init];
    [OpenAdAdapter_oad->config setup:d1];
    NSArray * networks = [d1 objectForKey:@"networks"];
    if (networks != nil){
        for(int i = 0; i < [networks count]; i++){
            NSDictionary * network = [networks objectAtIndex:i];
            if(network == nil)continue;
            [OpenAdAdapter_oad setupNetwork:network];
        }
    }
}
+(void)startWithUrl:(NSString*)u{
    [OpenAdAdapter setup];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString * u1 = u;
        int redirCnt = 0;
        do{
            NSError *error;
            NSData * json = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:u1] ];
            
            if(error){
                // load old file if exists
                return;
            }
            
            id o1 = [NSJSONSerialization
                     JSONObjectWithData:json
                     options:0
                     error:&error];
            
            if(error) {
                // load old if exists
                return;
            }
            
            if([o1 isKindOfClass:[NSDictionary class]])
            {
                
                id o2 = [o1 objectForKey:@"redirect"];
                if(o2 != nil){
                    if([o2 isKindOfClass:[NSDictionary class]]){
                        id o3 = [o2 objectForKey:@"url"];
                        if(o3!= nil){
                            if([o3 isKindOfClass:[NSString class]]){
                                if(redirCnt < 10){
                                    u1 = o3;
                                    redirCnt++;
                                    continue;
                                }
                            }
                        }
                    }
                }
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // process dic
                    //                NSDictionary * d1 = o1;
                    
                    [OpenAdAdapter startWithDictionary:o1];
                    
                });
                return;
            }
            break;
        }while(true);
        // load old file if exists
        
    });
}



+(BOOL)hasReward{
    [OpenAdAdapter setup];
    return OpenAdAdapter_oad->hasReward;
}
+(OADReward*)reward{
    [OpenAdAdapter setup];
    
    __block OADReward*result = nil;
    
    OAD_dispatchMain(^{
        if(OpenAdAdapter_oad == nil)return;
        if([OpenAdAdapter_oad->rewards count] > 0){
            result = [OpenAdAdapter_oad->rewards objectAtIndex:0];
            [OpenAdAdapter_oad->rewards removeObjectAtIndex:0];
        }
    });
    return result;
}
-(void)addReward:(OADReward*)reward{
    [rewards addObject:reward];
}
+(float)bannerHeightPts{
    if(OpenAdAdapter_oad == nil)return 0;
    if(OpenAdAdapter_oad->bannerAdapter){
        return [OpenAdAdapter_oad->bannerAdapter heightPts];
    }
    return 0;
}
+(float)bannerHeightPixels{
    if(OpenAdAdapter_oad == nil)return 0;
    if(OpenAdAdapter_oad->bannerAdapter){
        return [OpenAdAdapter_oad->bannerAdapter heightPts] * OpenAdAdapter_oad->scale;
        
    }
    return 0;
}

@end
