//
//  OADAdapterChartboost.h
//  OpenAdAdapterApp
//
//  Created by Artem Babenko on 4/29/15.
//  Copyright (c) 2015 Artem Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OADAdapter.h"
@protocol ChartboostDelegate;

@interface OADAdapterChartboost : OADAdapter <ChartboostDelegate>


-(BOOL)available;



@end
