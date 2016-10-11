//
//  WeatherVC.m
//  Grossum
//
//  Created by Alexandr Chernyy on 10/10/16.
//  Copyright © 2016 Alexandr Chernyy. All rights reserved.
//

#import "WeatherVC.h"
#import "Constants.h"
#import "OpenWeatherManager.h"

@interface WeatherVC ()
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic) IBOutlet UILabel *tIcon;
@property (weak, nonatomic) IBOutlet UILabel *tLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *cloudsLabel;
@end

@implementation WeatherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWeatherForLoaction];
    _cityLabel.text = @"";
    _cityLabel.adjustsFontSizeToFitWidth = true;
    _cloudsLabel.adjustsFontSizeToFitWidth = true;
    _iconLabel.text = @"";
    _tIcon.text = ICON_T;
    _tLabel.text = @"";
    _cloudsLabel.text = @"";
    _tIcon.font = FONT_NAME_WEATHER(80);
    _iconLabel.font = FONT_NAME_WEATHER(90);
    _errorLabel.hidden = true;
    [_cancelButton setTitle:TEXT_OK forState:UIControlStateNormal];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) fillWeatherFields:(WeatherModel *)weatherModel {
    _errorLabel.hidden = true;
    _cityLabel.text = weatherModel.name;
    WeatherModelWeather * wetherItemModel = [weatherModel.weather lastObject];
    if(wetherItemModel) {
        _cloudsLabel.text = wetherItemModel.main;
        _iconLabel.text = [[OpenWeatherManager sharedManager] getIconByCode:wetherItemModel.icon];
        _tLabel.text = [NSString stringWithFormat:@"%.01f", [weatherModel.main.temp doubleValue]];
    } else {
        _iconLabel.text = @"";
        _cloudsLabel.text = @"";
    }
}

-(void) loadWeatherForLoaction {
    [[OpenWeatherManager sharedManager] setLanguage:_inputLang];
    NSLog(@"_searchResult: %@", _searchResult.placeID);
    if(_searchResult) {
        [[OpenWeatherManager sharedManager] searchWeatherForCity:[_searchResult.attributedPrimaryText.string stringByReplacingOccurrencesOfString:@" " withString:@"+"] completionHandler:^(WeatherModel *weatherModel, NSError *error) {
            if(error) {
                _errorLabel.hidden = false;
                _errorLabel.text = error.localizedDescription;
            } else {
                [self fillWeatherFields:weatherModel];
            }
            NSLog(@"weatherModel: %@", weatherModel);
        }];
    } else {
        [[OpenWeatherManager sharedManager] searchWeatherByCoordinate:_touchMapCoordinate completionHandler:^(WeatherModel *weatherModel, NSError *error) {
            if(error) {
                _errorLabel.hidden = false;
                _errorLabel.text = error.localizedDescription;
                
            } else {
                [self fillWeatherFields:weatherModel];
            }
            NSLog(@"weatherModel: %@", weatherModel);
        }];
    }
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:^{
        _searchResult = nil;
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
