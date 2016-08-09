//
//  ViewController.m
//  DudeWheresMyCar
//
//  Created by Ross Gottschalk on 8/9/16.
//  Copyright © 2016 The Iron Yard. All rights reserved.
//

#import "CarMapViewController.h"
#import <MapKit/MapKit.h>

@interface CarMapViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSMutableArray *annotations;
@property (strong, nonatomic) CLLocationManager *locationManager;



@end

@implementation CarMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.annotations = [[NSMutableArray alloc] init];
    [self configureLocationManager];
    

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocation related methods
-(void)configureLocationManager
{
    if ([CLLocationManager authorizationStatus] !=kCLAuthorizationStatusDenied && [CLLocationManager authorizationStatus] !=kCLAuthorizationStatusRestricted)
        //if clLocManag is not denied and also not restricted...keep going
    {
        if (!self.locationManager)
            //if locationManager doesnt point at an object
        {
            self.locationManager = [[CLLocationManager alloc] init];
            //init locationManager to ask permission
            self.locationManager.delegate = self;
            //this view is the delegate since its set to self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
            {
                //dont forget to add the reason to the info.plist
                [self.locationManager requestWhenInUseAuthorization];
            }
        }
    }
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse)
        //if location status is authorized, then we're good
    {
        [self enableLocationManager:YES];
    }
    else
    {
        [self enableLocationManager:NO];
    }
}

-(void)enableLocationManager:(BOOL)enable;
//this creates the boolean value for the above "enableLocationManager"
{
    if (self.locationManager)
    {
        [self.locationManager stopUpdatingLocation];
        if (enable)
        {
            [self.locationManager startUpdatingLocation];
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error != kCLErrorLocationUnknown)
    {
        [self enableLocationManager:NO];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    [self enableLocationManager:NO];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = location.coordinate;
    annotation.title = @"The Iron Yard";
    [self.annotations addObject:annotation];
    //configure annotations method is now dependent on finding our location first
}


- (IBAction)addPinPressed:(UIBarButtonItem *)sender
{
    
}

@end
