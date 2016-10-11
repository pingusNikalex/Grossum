//
//  Constants.h
//  Grossum
//
//  Created by Alexandr Chernyy on 10/10/16.
//  Copyright © 2016 Alexandr Chernyy. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#pragma mark SEGUE_NAMES

#define SEGUE_NAME_MAIN                         @"showMain"
#define SEGUE_SHOW_WEATHER                      @"showWeather"

#pragma mark ICONS_FOLDER_NAME

#define iconsFolderName                         @"Icons"
#define iconsFileExtentions                     @"png"

#pragma mark ICONS

#define ICON_MAP                                @"\uf278"
#define ICON_SEARCH                             @"\uf120"

#define ICON_CLEAR_SKY_DAY                      @"\uf00d"
#define ICON_CLEAR_SKY_NIGHT                    @"\uf02e"

#define ICON_FEW_CLOUDS_DAY                     @"\uf002"
#define ICON_FEW_CLOUDS_NIGHT                   @"\uf086"

#define ICON_SCETER_CLOD_DAY                    @"\uf041"
#define ICON_SCETER_CLOD_NIGHT                  @"\uf041"

#define ICON_BROKEN_CLOD_DAY                    @"\uf013"
#define ICON_BROKEN_CLOD_NIGHT                  @"\uf013"

#define ICON_SHOWER_RAIN_DAY                    @"\uf017"
#define ICON_SHOWER_RAIN_NIGHT                  @"\uf017"

#define ICON_RAIN_DAY                           @"\uf017"
#define ICON_RAIN_NIGHT                         @"\uf017"

#define ICON_THUNDERSTORM_DAY                   @"\uf06b"
#define ICON_THUNDERSTORM_NIGHT                 @"\uf06a"

#define ICON_SHOW                               @"\uf01b"

#define ICON_MIST                               @"\uf021"
#define ICON_T                                  @"\uf03c"

#pragma mark TEXT

#define TEXT_LOADING                            NSLocalizedString(@"Loading, please wait", nil)
#define TEXT_SEARCH_WEATHER                     NSLocalizedString(@"Search weather", nil)
#define TEXT_OK                                 NSLocalizedString(@"Ok", nil)

#pragma mark FONTS

#define FONT_NAME_AWESOME(t)                    [UIFont fontWithName:@"FontAwesome" size:t]
#define FONT_NAME_WEATHER(t)                    [UIFont fontWithName:@"Weather Icons" size:t]
#define DEFAULT_ICON_FONT_SIZE                  24

#pragma mark COLORS

#define MAIN_COLOR_BLUE                         [UIColor colorWithRed:88.f/255.f green:189.f/255.f blue:238.f/255.f alpha:1.0]

#pragma mark GOOGLE_API_KEYS

#define GOOGLE_PLACES_KEY                       @"AIzaSyC_eNydsAg7UwX61bcYDnkicYF9rY7DXhI"

#pragma mark OPEN_WEATHER_API_KEYS

#define OPEN_WEATHER_API_KEY                    @"f829446b4e7918a65bffff15bb7ba0be"

#pragma mark SEGMENT_TYPE

enum {
    SEGMENT_TYPE_SEARCH_BY_ADDRESS = 0,
    SEGMENT_TYPE_MAP
};

#endif /* Constants_h */
