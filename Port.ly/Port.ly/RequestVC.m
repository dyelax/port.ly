//
//  RequestVC.m
//  Port.ly
//
//  Created by Matt Cooper on 2/6/16.
//  Copyright © 2016 Matthew Cooper. All rights reserved.
//

#import "RequestVC.h"
#import "ReservationVC.h"
#import "LoadingView.h"
#import "Flight.h"
#import "AppDelegate.h"

@interface RequestVC ()

@end

@implementation RequestVC {
    CLLocation *currentLocation;
	LoadingView *loadingView;
	Flight *tempFlight;
}

@synthesize mapView = _mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  //  locationManager = [CLLocationManager new];
  //  if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
  //      [locationManager requestWhenInUseAuthorization];
  //  }
	tempFlight = [[Flight alloc]init];

//    self.mapView = [[MKMapView alloc]
//               initWithFrame:CGRectMake(0,
//                                        0,
//                                        self.view.bounds.size.width,
//                                        self.view.bounds.size.height)
//               ];
    self.mapView.showsUserLocation = YES;
    self.mapView.showsBuildings = YES;
    self.mapView.delegate = self;
//[self.mapView setDelegate:self];
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    [self.view addSubview:mapView];
	
	[self.reservationTypeControl.layer setCornerRadius:5];
	[self.goButton.layer setCornerRadius:3];
	[self.goButton setClipsToBounds:YES];
	
	loadingView = [[LoadingView alloc]initWithFrame:self.view.bounds];
	[self.view addSubview:loadingView];
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter]addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note){
		[self slideViewForKeyboard:note];
	}];
	[[NSNotificationCenter defaultCenter]addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note){
		[self slideViewForKeyboard:note];
	}];
}
- (void)slideViewForKeyboard:(NSNotification *)note {
	NSDictionary* userInfo = [note userInfo];
	
	// Get animation info from userInfo
	NSTimeInterval animationDuration;
	UIViewAnimationCurve animationCurve;
	CGRect keyboardEndFrame;
	
	[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
	[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
	[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
	
	CGRect newFrame = CGRectMake(self.view.frame.origin.x,
								 self.view.frame.origin.y,
								 self.view.frame.size.width,
								 keyboardEndFrame.origin.y);
	
	if (animationDuration == 0) {
		animationDuration = 0.12;
	}
	
	[UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		[self.view setFrame:newFrame];
		[self.view layoutIfNeeded];
	} completion:NULL];
}

//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
  //  [mapView setRegion:MKCoordinateRegionMake(currentLocation.coordinate,MKCoordinateSpanMake(0.02, 0.02)) animated:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    currentLocation = locations.lastObject;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"currentLocationUpdated" object:self userInfo:@{@"currentLocation" : currentLocation}];
    NSLog(@"location");
}*/

- (IBAction)mapTapped:(id)sender {
	[self.flightNumTextField resignFirstResponder];
}

- (IBAction)go:(id)sender {
	[loadingView show];
	[loadingView setState:LoadingStateLoading];
	[loadingView setMessage:@"Finding flight..."];
	
	//send flight number to server
	AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	BOOL to, from;
	switch (self.reservationTypeControl.selectedSegmentIndex) {
		case 0:
			to = YES;
			break;
		case 1:
			from = YES;
			break;
		case 2:
			to = YES;
			from = YES;
			break;
		default:
			break;
	}
	
	NSString *flightNo = self.flightNumTextField.text;
	
	MSClient *client = [ad client];
	NSDictionary *item = @{ @"userID" : [[[UIDevice currentDevice] identifierForVendor] UUIDString], @"startLat" : [NSString stringWithFormat:@"%f",ad.locationManager.location.coordinate.latitude], @"startLon" : [NSString stringWithFormat:@"%f",ad.locationManager.location.coordinate.longitude], @"flightNo" : flightNo, @"to" : @(to), @"from" : @(from)};
	MSTable *itemTable = [client tableWithName:@"Flight"];
	[itemTable insert:item completion:^(NSDictionary *insertedItem, NSError *error) {
		if (error) {
			NSLog(@"Error: %@", error);
		} else {
			NSLog(@"Item inserted, id: %@", [insertedItem objectForKey:@"id"]);
			
			[itemTable readWithCompletion:^(MSQueryResult *result, NSError *err){
				NSDictionary *flightData;

				if (result.items.count > 0) {
					flightData = result.items[0];
				}
				
				//setup tempFlight with flight Data
				[tempFlight setAirline:flightData[@"airline"]];
				[tempFlight setFromAirport:flightData[@"fromAPname"]];
				[tempFlight setToAirport:flightData[@"toAPname"]];
				[tempFlight setFromAirportCode:flightData[@"fromAPcode"]];
				[tempFlight setToAirportCode:flightData[@"toAPcode"]];
				[tempFlight setTakeoffTimeScheduled:flightData[@"schedDdate"]];
				[tempFlight setTakeoffTimeReal:flightData[@"estDdate"]];
				[tempFlight setArrivalTimeScheduled:flightData[@"schedAdate"]];
				[tempFlight setArrivalTimeReal:flightData[@"estAdate"]];
				[tempFlight setToRidePickupTime:flightData[@"toRideDate"]];
				[tempFlight setFromRidePickupTime:flightData[@"fromRideDate"]];
				
				[loadingView hide];
				[self performSegueWithIdentifier:@"modalReservationVC" sender:self];
			}];
		}
	}];

	[self performSegueWithIdentifier:@"modalReservationVC" sender:self];//TEST
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	ReservationVC *reservationVC = segue.destinationViewController;
	[reservationVC setupWithFlight:tempFlight];
}

@end
