//
//  TUIMapViewController.m
//  decarta
//
//  Created by Diego Lafuente on 22/08/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TUIMapViewController.h"
#import "TUILocationManager.h"

#pragma mark - Private interface
@interface TUIMapViewController () <TUILocationManagerDelegate>

@property (strong, nonatomic) IBOutlet deCartaMapView *mapView;



@end

#pragma mark - Implementation
@implementation TUIMapViewController

#pragma mark - UIViewController Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[TUILocationManager sharedInstance] addDelegate:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //Get the user location.
    [[TUILocationManager sharedInstance] getUserLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TUILocationManagerDelegate Methods
-(void)locationReady:(CLLocation *)location {
    deCartaPosition *position = [[deCartaPosition alloc] initWithLat:location.coordinate.latitude andLon:location.coordinate.longitude];
    [_mapView centerOnPosition:position];
    _mapView.zoomLevel=13;
    [_mapView refreshMap];
    [_mapView startAnimation];
}

@end
