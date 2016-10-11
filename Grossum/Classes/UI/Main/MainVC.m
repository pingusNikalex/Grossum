//
//  MainVC.m
//  Grossum
//
//  Created by Alexandr Chernyy on 10/10/16.
//  Copyright © 2016 Alexandr Chernyy. All rights reserved.
//

#import "MainVC.h"
#import "Constants.h"
#import "MainTVC.h"
#import <GooglePlaces/GooglePlaces.h>
#import "WeatherVC.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>


@import GooglePlaces;

@interface MainVC () {
    GMSPlacesClient * placesClient;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) NSMutableArray *searchItems;
@property (nonatomic, strong) GMSAutocompletePrediction* selectedSearchResult;
@property (nonatomic) CLLocationCoordinate2D touchMapCoordinate;
@property (nonatomic, strong) NSString * inputLang;

@end

@implementation MainVC
@synthesize menuButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addMenuButton];
    placesClient = [GMSPlacesClient sharedClient];
    _searchItems = [[NSMutableArray alloc] init];
    
    self.title = TEXT_SEARCH_WEATHER;
    [self hideMap];
    [self addMenuButton];
    
    [self addTouchForMap];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    [self.navigationItem setHidesBackButton:true];
    self.navigationItem.backBarButtonItem = nil;
}

-(void) addTouchForMap {
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5;
    [self.mapView addGestureRecognizer:lpgr];
}

- (void) handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    _touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    [self performSegueWithIdentifier:SEGUE_SHOW_WEATHER sender:self];
}

- (void)addMenuButton {
    menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [menuButton setTitle:ICON_MAP forState:UIControlStateNormal];
    [menuButton.titleLabel setFont:FONT_NAME_AWESOME(DEFAULT_ICON_FONT_SIZE)];
    menuButton.tag = SEGMENT_TYPE_SEARCH_BY_ADDRESS;
    [menuButton setTitleColor:MAIN_COLOR_BLUE forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * _rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    _rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = _rightBarButtonItem;
}

-(void) showMap {
    _mapView.hidden = false;
    _searchBar.hidden = true;
    _tableView.hidden = true;
    [self.view endEditing:true];
    [menuButton setTitle:ICON_SEARCH forState:UIControlStateNormal];
}

-(void) hideMap {
    _mapView.hidden = true;
    _searchBar.hidden = false;
    _tableView.hidden = false;
    [menuButton setTitle:ICON_MAP forState:UIControlStateNormal];
}

-(void) menuBtnAction {
    if(menuButton.tag == SEGMENT_TYPE_SEARCH_BY_ADDRESS) {
        menuButton.tag = SEGMENT_TYPE_MAP;
        [self showMap];
    } else {
        menuButton.tag = SEGMENT_TYPE_SEARCH_BY_ADDRESS;
        [self hideMap];
    }
}

#pragma mark TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchItems.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:true];
    self.searchBar.text = @"";
    _selectedSearchResult = [_searchItems objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:SEGUE_SHOW_WEATHER sender:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTVC * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MainTVC class ])];
    GMSAutocompletePrediction* result = [_searchItems objectAtIndex:indexPath.row];
    cell.cellTitleLabel.text = result.attributedFullText.string;
    [cell layoutSubviews];
    [cell setNeedsLayout];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark GOOGLE PLACE SEARCH
-(void) searchByString:(NSString *) searchString {
    
    UITextInputMode *inputMode = [self.searchBar textInputMode];
    NSString *lang = inputMode.primaryLanguage;
    NSLog(@"lang: %@", lang);
    _inputLang = lang;
    
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    if ([searchString rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        filter.type = kGMSPlacesAutocompleteTypeFilterRegion;
    } else {
        filter.type = kGMSPlacesAutocompleteTypeFilterCity;
    }
    [placesClient autocompleteQuery:searchString
                             bounds:nil
                             filter:filter
                           callback:^(NSArray *results, NSError *error) {
                               if (error != nil) {
                                   NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                   return;
                               }
                               [_searchItems removeAllObjects];
                               for (GMSAutocompletePrediction* result in results) {
                                   [_searchItems addObject:result];
                                   NSLog(@"Result '%@' with placeID %@", result.attributedFullText.string, result.placeID);
                               }
                               dispatch_async(dispatch_get_main_queue(), ^(){
                                   [self.tableView reloadData];
                               });
                           }];
}

#pragma mark UISearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"Text change - %@",searchText);
    [self searchByString: searchText];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [self searchByString: searchBar.text];
}

- (void)didEnterZip:(NSString*)zip
{
    NSLog(@"didEnterZip: %@", zip);
    CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
    [geoCoder geocodeAddressDictionary:@{(NSString*)CNPostalAddressPostalCodeKey : zip}
                     completionHandler:^(NSArray *placemarks, NSError *error) {
                         if ([placemarks count] > 0) {
                             CLPlacemark* placemark = [placemarks objectAtIndex:0];
                             
                             NSString* city = placemark.addressDictionary[CNPostalAddressCityKey];
                             NSString* state = placemark.addressDictionary[(NSString*)CNPostalAddressStateKey];
                             NSString* country = placemark.addressDictionary[(NSString*)CNPostalAddressCountryKey];

                             NSLog(@"city: %@", city);

                         } else {
                             // Lookup Failed
                         }
                     }];
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     UIViewController *dst = [segue destinationViewController];
     if ([dst isKindOfClass:[WeatherVC class]]) {
         WeatherVC *weatherVC = (WeatherVC*)[segue destinationViewController];
         weatherVC.inputLang = _inputLang;
         if(menuButton.tag == SEGMENT_TYPE_SEARCH_BY_ADDRESS) {
             weatherVC.searchResult = _selectedSearchResult;
         } else {
             weatherVC.touchMapCoordinate = _touchMapCoordinate;
         }

     }
 }


@end
