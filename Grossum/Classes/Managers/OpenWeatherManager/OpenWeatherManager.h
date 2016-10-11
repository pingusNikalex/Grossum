//
//  OpenWeatherManager.h
//  Grossum
//
//  Created by Alexandr Chernyy on 10/10/16.
//  Copyright © 2016 Alexandr Chernyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherModel.h"
#import <CoreLocation/CoreLocation.h>

typedef void (^OpenWeatherManagerCompletionHandler)(WeatherModel * weatherModel, NSError * error);


@interface OpenWeatherManager : NSObject

+(OpenWeatherManager *) sharedManager;

-(void) initOpenWeatherAPIClient;
-(void) searchWeatherForCity:(NSString *) cityName completionHandler:(OpenWeatherManagerCompletionHandler) handler;
-(void) searchWeatherByCoordinate:(CLLocationCoordinate2D) coordinate completionHandler:(OpenWeatherManagerCompletionHandler) handler;
-(void) setLanguage:(NSString *)lang;

-(NSString *) getIconByCode:(NSString *) iconCode;

@end
