//
//  OADAdapterIad.h
//  OADAdapterIad
//
//  Created by Artem Babenko on 5/26/15.
//  Copyright (c) 2015 Artem Babenko. All rights reserved.
//

#import "OADAdapter.h"
@protocol ADBannerViewDelegate;
@protocol ADInterstitialAdDelegate;
@interface OADAdapterIad : OADAdapter<ADBannerViewDelegate,ADInterstitialAdDelegate>

@end
