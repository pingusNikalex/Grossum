//
//  OpenWeatherManager.m
//  Grossum
//
//  Created by Alexandr Chernyy on 10/10/16.
//  Copyright © 2016 Alexandr Chernyy. All rights reserved.
//

#import "OpenWeatherManager.h"
#import "OWMWeatherAPI.h"
#import "Constants.h"

@interface OpenWeatherManager ()

@property(nonatomic, strong) OWMWeatherAPI * weatherAPI;

@end

@implementation OpenWeatherManager

+ (OpenWeatherManager*) sharedManager {
    static OpenWeatherManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OpenWeatherManager alloc] init];
    });
    return manager;
}

-(void) initOpenWeatherAPIClient {
    _weatherAPI = [[OWMWeatherAPI alloc] initWithAPIKey:OPEN_WEATHER_API_KEY];
    [_weatherAPI setTemperatureFormat:kOWMTempCelcius];

}

-(void) setLanguage:(NSString *)lang {
    if([lang isEqualToString:@"ru-RU"])
        [_weatherAPI setLang:@"ua"];
    else
        [_weatherAPI setLang:lang];
}

-(void) searchWeatherForCity:(NSString *) cityName completionHandler:(OpenWeatherManagerCompletionHandler) handler {
    NSLog(@"Start searching with city name: %@", cityName);
    cityName = [cityName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];

    [_weatherAPI currentWeatherByCityName:cityName withCallback:^(NSError *error, NSDictionary *result) {
        if (error) {
            NSLog(@"currentWeatherByCityName error %@", [error localizedDescription]);
            if(error) {
                if(handler)
                    handler(nil, error);
                return;
            }
            // handle the error
            return;
        }
        NSError * jsonError;
        WeatherModel * weatherModel = [[WeatherModel alloc] initWithDictionary:result error:&jsonError];
        if(jsonError) {
            if(handler)
                handler(nil, jsonError);
            return;
        }
        if(handler)
            handler(weatherModel, nil);
    }];
}

-(void) searchWeatherByCoordinate:(CLLocationCoordinate2D) coordinate completionHandler:(OpenWeatherManagerCompletionHandler) handler {
    [_weatherAPI currentWeatherByCoordinate:coordinate withCallback:^(NSError *error, NSDictionary *result) {
        if (error) {
            NSLog(@"currentWeatherByCityName error %@", [error localizedDescription]);
            if(error) {
                if(handler)
                    handler(nil, error);
                return;
            }
            // handle the error
            return;
        }
        NSError * jsonError;
        WeatherModel * weatherModel = [[WeatherModel alloc] initWithDictionary:result error:&jsonError];
        if(jsonError) {
            if(handler)
                handler(nil, jsonError);
            return;
        }
        if(handler)
            handler(weatherModel, nil);
    }];
 
}

-(NSString *) getIconByCode:(NSString *) iconCode {
    NSString * returnValue = @"";
    if([iconCode isEqualToString:@"01d"])
        return ICON_CLEAR_SKY_DAY;
    if([iconCode isEqualToString:@"01n"])
        return ICON_CLEAR_SKY_NIGHT;

    if([iconCode isEqualToString:@"02d"])
        return ICON_FEW_CLOUDS_DAY;
    if([iconCode isEqualToString:@"02n"])
        return ICON_FEW_CLOUDS_NIGHT;

    if([iconCode isEqualToString:@"03d"])
        return ICON_SCETER_CLOD_DAY;
    if([iconCode isEqualToString:@"03n"])
        return ICON_SCETER_CLOD_NIGHT;

    if([iconCode isEqualToString:@"04d"])
        return ICON_BROKEN_CLOD_DAY;
    if([iconCode isEqualToString:@"04n"])
        return ICON_BROKEN_CLOD_NIGHT;

    if([iconCode isEqualToString:@"09d"])
        return ICON_SHOWER_RAIN_DAY;
    if([iconCode isEqualToString:@"09n"])
        return ICON_SHOWER_RAIN_NIGHT;

    if([iconCode isEqualToString:@"10d"])
        return ICON_RAIN_DAY;
    if([iconCode isEqualToString:@"10n"])
        return ICON_RAIN_NIGHT;

    if([iconCode isEqualToString:@"11d"])
        return ICON_THUNDERSTORM_DAY;
    if([iconCode isEqualToString:@"11n"])
        return ICON_THUNDERSTORM_NIGHT;

    if([iconCode isEqualToString:@"13d"])
        return ICON_SHOW;
    if([iconCode isEqualToString:@"13n"])
        return ICON_SHOW;

    if([iconCode isEqualToString:@"50d"])
        return ICON_MIST;
    if([iconCode isEqualToString:@"50n"])
        return ICON_MIST;

    return returnValue;
}

@end
