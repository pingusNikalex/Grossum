//
//  WeatherModel.h
//  Grossum
//
//  Created by Alexandr Chernyy on 10/10/16.
//  Copyright © 2016 Alexandr Chernyy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol WeatherModelClouds
@end

@interface WeatherModelClouds : JSONModel
@property (nonatomic, strong) NSString<Optional> * all;
@end

@protocol WeatherModelCoord
@end

@interface WeatherModelCoord : JSONModel
@property (nonatomic, strong) NSString<Optional> * lat;
@property (nonatomic, strong) NSString<Optional> * lon;
@end

@protocol WeatherModelMain
@end

@interface WeatherModelMain : JSONModel
@property (nonatomic, strong) NSString<Optional> * grnd_level;
@property (nonatomic, strong) NSString<Optional> * humidity;
@property (nonatomic, strong) NSString<Optional> * pressure;
@property (nonatomic, strong) NSString<Optional> * sea_level;
@property (nonatomic, strong) NSString<Optional> * temp;
@property (nonatomic, strong) NSString<Optional> * temp_max;
@property (nonatomic, strong) NSString<Optional> * temp_min;
@end

@protocol WeatherModelSys
@end

@interface WeatherModelSys : JSONModel
@property (nonatomic, strong) NSString<Optional> * country;
@property (nonatomic, strong) NSString<Optional> * message;
@property (nonatomic, strong) NSDate<Optional> * sunrise;
@property (nonatomic, strong) NSDate<Optional> * sunset;
@end

@protocol WeatherModelWind
@end

@interface WeatherModelWind : JSONModel
@property (nonatomic, strong) NSString<Optional> * deg;
@property (nonatomic, strong) NSString<Optional> * speed;
@end

@protocol WeatherModelWeather
@end

@interface WeatherModelWeather : JSONModel
@property (nonatomic, strong) NSString<Optional> * description;
@property (nonatomic, strong) NSString<Optional> * icon;
@property (nonatomic) NSInteger id;
@property (nonatomic, strong) NSString<Optional> * main;
@end

@interface WeatherModel : JSONModel

@property (nonatomic, strong) NSString<Optional> * base;
@property (nonatomic, strong) WeatherModelClouds<Optional> * clouds;
@property (nonatomic, strong) WeatherModelCoord<Optional> * coord;
@property (nonatomic, strong) WeatherModelMain<Optional> * main;
@property (nonatomic, strong) WeatherModelSys<Optional> * sys;
@property (nonatomic, strong) NSArray<WeatherModelWeather, Optional> * weather;
@property (nonatomic, strong) WeatherModelWind<Optional> * wind;

@property (nonatomic, strong) NSString<Optional> * cod;
@property (nonatomic, strong) NSDate<Optional, Ignore> * dt;
@property (nonatomic) NSInteger id;
@property (nonatomic, strong) NSString<Optional> * name;

@end
