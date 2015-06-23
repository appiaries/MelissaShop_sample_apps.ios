//
//  ShopMapViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/12.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "ShopMapViewController.h"
#import <CLLocationManager-blocks/CLLocationManager+blocks.h>
#import "ShopListViewController.h"
#import "Shop.h"
#import "Constants.h"
#import "DataManager.h"


@interface ShopMapViewController ()
#pragma mark - Properties (Private)
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
#pragma mark - Actions (Private)
- (IBAction)searchButtonAction:(id)sender;
- (IBAction)currentLocationButtonAction:(id)sender;
@end


@implementation ShopMapViewController

#pragma mark - Constants
static float const kDefaultZoomSpanDelta = 0.02f;
static NSString *const kPinAnnotationIdentifier = @"PinAnnotationIdentifier";

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.mapView.showsUserLocation = YES;
    
    //位置情報を取得
    self.locationManager = [CLLocationManager updateManager];
    if ([CLLocationManager isLocationUpdatesAvailable]) {
        [self currentLocationButtonAction:nil];
    } else {
        //位置情報が有効になってない場合は警告を表示する
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ErrorTitle", nil)
                                    message:NSLocalizedString(@"NotPermitLocationMessage", nil)
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }

    //検索でショップが選択された時の通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectedMoveLocation:)
                                                 name:MELSNotificationSelectedShop
                                               object:nil];
}

#pragma mark - Memory management
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MELSNotificationSelectedShop object:nil];
}

#pragma mark - Actions
- (IBAction)currentLocationButtonAction:(id)sender
{
    [self.locationManager startUpdatingLocationWithUpdateBlock:^(CLLocationManager *manager, CLLocation *location, NSError *error, BOOL *stopUpdating) {
        *stopUpdating = YES;
        
        if (error) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ErrorTitle", nil)
                                        message:NSLocalizedString(@"NotLocationMessage", nil)
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        } else {
            //現在地情報を保存
            self.currentLocation = location;
            
            //現在地のデータを取得
            [self loadMap];
            
            //現在地へ移動
            [self moveLocation:self.currentLocation];
        }
    }];
}

- (IBAction)searchButtonAction:(id)sender
{
    //検索ページへ遷移
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:MELSStoryboardIDShopSearch];
    ShopListViewController *viewController = (ShopListViewController *)navController.topViewController;
    viewController.currentLocation = self.currentLocation; //@note 現在地を受け渡す
    [self.tabBarController presentViewController:navController animated:YES completion:nil];
}

// ショップ選択時のアクション
- (void)selectedMoveLocation:(NSNotification *)notification
{
    if ([self.mapView.annotations count] > 0) {
        Shop *shop = [DataManager sharedManager].selectedShop;
        for (id an in self.mapView.annotations) {
            MKPointAnnotation *point = (MKPointAnnotation *)an;
            if (point.coordinate.latitude == shop.geoPoint.latitude && point.coordinate.longitude == shop.geoPoint.longitude) {
                [self.mapView selectAnnotation:point animated:YES];
                break;
            }
        }
    }
}

#pragma mark - MKMapView delegates
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation
{
    //現在地はピンを刺さずに無視
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }

    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
    if (pinView == nil) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier];
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        return pinView;
    }
    pinView.annotation = annotation;
    return pinView;
}

#pragma mark Private methods
//マップを移動する
- (void)moveLocation:(CLLocation *)location
{
    CLLocationCoordinate2D coordinate = location.coordinate;
    [self.mapView setCenterCoordinate:coordinate];
    
    MKCoordinateRegion zoom = self.mapView.region;
    zoom.span.latitudeDelta = kDefaultZoomSpanDelta;
    zoom.span.longitudeDelta = kDefaultZoomSpanDelta;
    [self.mapView setRegion:zoom animated:YES];
}

// 現在地から10Km圏内の店舗を検索する
- (void)loadMap
{
    if (self.currentLocation != nil) {
        __weak typeof(self) weakSelf = self;

        ABQuery *query = [[Shop query]
                where:@"_coord" withinCircle:[ABGeoPoint pointWithCLLocation:self.currentLocation] kilometers:10];

        [baas.db findWithQuery:query block:^(ABResult *ret, ABError *err){
            if (err == nil) {
                NSArray *foundArray = ret.data;
                //現在地のからの距離が近い順でソートする
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];

                DataManager *mgr = [DataManager sharedManager];
                [mgr.shopList removeAllObjects];
                [mgr.shopList addObjectsFromArray:[foundArray sortedArrayUsingDescriptors:@[sortDescriptor]]];

                [weakSelf addPinsMap];
            } else {
                [weakSelf displayError:err completion:nil];
            }
        }];
    }
}

// (検索で見つかった)マップ上のすべての店舗にピンを刺す
- (void)addPinsMap
{
    DataManager *mgr = [DataManager sharedManager];
    if ([mgr.shopList count] > 0) {
        [self.mapView removeAnnotations:self.mapView.annotations];
        for (Shop *shop in mgr.shopList) {
            [self addPinWith:shop];
        }
    }
}

// マップ上の店舗にピンを刺す
- (void)addPinWith:(Shop *)shop
{
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    pin.title = shop.shopName;
    pin.coordinate = shop.geoPoint.locationCoordinate2D;
    [self.mapView addAnnotation:pin];
}

@end
