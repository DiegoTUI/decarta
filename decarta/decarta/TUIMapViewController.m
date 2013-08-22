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
@property (strong, nonatomic) deCartaOverlay *routePins;

-(void)addMapEventListeners;

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
    [self addMapEventListeners];
    _routePins = [[deCartaOverlay alloc] initWithName:@"route_pins"];
    [_mapView addOverlay:_routePins];
    [_mapView showOverlays];
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

#pragma mark - Private Methods
-(void)addMapEventListeners {
    //Capture MOVEEND
    [_mapView addEventListener:[deCartaEventListener eventListenerWithCallback:^(id<deCartaEventSource> es, deCartaPosition *position) {
        NSLog(@"Moved!! - Lat: %f - Lon: %f", position.lat, position.lon);
        CLLocation *location = [[CLLocation alloc] initWithLatitude:position.lat longitude:position.lon];
        [[TUILocationManager sharedInstance] setUserLocation:location];
    }] forEventType:MOVEEND];
    //Capture LONGTOUCH
    [_mapView addEventListener:[deCartaEventListener eventListenerWithCallback:^(id<deCartaEventSource> es, deCartaPosition *position) {
        NSLog(@"LongTouch!! - Lat: %f - Lon: %f", position.lat, position.lon);
        UIImage *pinImage = [UIImage imageNamed:@"pin.png"];
        int width = pinImage.size.width;
        int height = pinImage.size.height;
        deCartaXYInteger *size = [deCartaXYInteger XYWithX:width andY:height];
        deCartaXYInteger *offset = [deCartaXYInteger XYWithX:width/2 andY:height];
        deCartaIcon *pinicon = [[deCartaIcon alloc] initWithImage:pinImage size:size offset:offset];
        deCartaRotationTilt *pinrt=[[deCartaRotationTilt alloc] initWithRotateRelative:ROTATE_RELATIVE_TO_SCREEN tiltRelative:TILT_RELATIVE_TO_SCREEN];
        pinrt.rotation = 0.0; //No rotation
        pinrt.tilt = 0.0; //No tilt
        deCartaPin * pin=[[deCartaPin alloc] initWithPosition:position icon:pinicon message:@"You fuck my mother" rotationTilt:pinrt];
        [_routePins addPin:pin];
        [_mapView refreshMap];
    }] forEventType:LONGTOUCH];
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
