//
//  WeatherVC.h
//  Grossum
//
//  Created by Alexandr Chernyy on 10/10/16.
//  Copyright © 2016 Alexandr Chernyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlaces/GooglePlaces.h>

@interface WeatherVC : UIViewController

@property (nonatomic, strong) GMSAutocompletePrediction* searchResult;
@property (nonatomic, assign) CLLocationCoordinate2D touchMapCoordinate;
@property (nonatomic, strong) NSString * inputLang;


-(void) loadWeatherForLoaction;

@end
