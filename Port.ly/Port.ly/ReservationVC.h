//
//  ReservationVC.h
//  Port.ly
//
//  Created by Matt Cooper on 2/6/16.
//  Copyright © 2016 Matthew Cooper. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Flight;
@class Ride;

@interface ReservationVC : UIViewController

@property Flight *flight;

- (void)setupWithFlight:(Flight *)flight;
- (void)setupToRide:(Ride *)ride;
- (void)setupFromRide:(Ride *)ride;

@property (weak, nonatomic) IBOutlet UIView *flightView;

@property (weak, nonatomic) IBOutlet UILabel *airlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromAirportFull;
@property (weak, nonatomic) IBOutlet UILabel *fromAirportCode;
@property (weak, nonatomic) IBOutlet UILabel *toAirportFull;
@property (weak, nonatomic) IBOutlet UILabel *toAirportCode;
@property (weak, nonatomic) IBOutlet UILabel *takeoffTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIView *rideView;
@property (weak, nonatomic) IBOutlet UIView *ride1View;
@property (weak, nonatomic) IBOutlet UIView *ride2View;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@property (weak, nonatomic) IBOutlet UILabel *toRideAirportLabel;
@property (weak, nonatomic) IBOutlet UIImageView *toRideDriverImageView;
@property (weak, nonatomic) IBOutlet UILabel *toRideDriverNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *toRideLicenseLabel;
@property (weak, nonatomic) IBOutlet UILabel *toRidePickupTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *toRideStaticDriver;
@property (weak, nonatomic) IBOutlet UILabel *toRideStaticLicense;
@property (weak, nonatomic) IBOutlet UILabel *toRideStaticPickup;

@property (weak, nonatomic) IBOutlet UILabel *fromRideAirportLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fromRideDriverImageView;
@property (weak, nonatomic) IBOutlet UILabel *fromRideDriverNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromRideLicenseLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromRidePickupTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromRideStaticDriver;
@property (weak, nonatomic) IBOutlet UILabel *fromRideStaticLicense;
@property (weak, nonatomic) IBOutlet UILabel *fromRideStaticPickup;

@property BOOL confirmed;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
- (IBAction)confirm:(id)sender;

- (IBAction)cancel:(id)sender;

@end