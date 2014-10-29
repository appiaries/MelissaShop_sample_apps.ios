//
//  MELSShopMapViewController.m
//  MelissaShop
//
//  Created by 植田 洋次 on 2014/05/12.
//  Copyright (c) 2014年 Appiaries Corporation. All rights reserved.
//

#import "MELSShopMapViewController.h"
#import <CLLocationManager-blocks/CLLocationManager+blocks.h>
#import "MELSShopListViewController.h"
#import "MELSShopManager.h"
#import "MELSShop.h"

static float const kDefaultZoomSpanDelta = 0.02f;
static NSString *const kPinAnnotationIdentifier = @"PinAnnotationIdentifier";

@interface MELSShopMapViewController ()

@property(nonatomic,weak)IBOutlet MKMapView *mapView;
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)CLLocation *currentlocation;

-(IBAction)searchButtonAction:(id)sender;
-(IBAction)currentLocationButtonAction:(id)sender;

@end

@implementation MELSShopMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.showsUserLocation = YES;
    
    //位置情報を取得
    self.locationManager = [CLLocationManager updateManager];
    if ([CLLocationManager isLocationUpdatesAvailable]) {
        [self currentLocationButtonAction:nil];
    } else {
        //位置情報が有効になってない場合に警告を出す
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ErrorTitle", nil)
                                                        message:NSLocalizedString(@"NotPermitLocationMessage", nil)
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }

    //検索でショップが選択された時の通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedMoveLocation:) name:MELSNotificationSelectedShop object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    //通知削除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MELSNotificationSelectedShop object:nil];
}


#pragma mark - Action

-(IBAction)currentLocationButtonAction:(id)sender
{
    //CLLocationManager-blocksを利用すると、location情報をblocksで受取ができるようになります。
    [self.locationManager startUpdatingLocationWithUpdateBlock:^(CLLocationManager *manager, CLLocation *location, NSError *error, BOOL *stopUpdating) {
        *stopUpdating = YES;
        
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ErrorTitle", nil)
                                                            message:NSLocalizedString(@"NotLocationMessage", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            //位置情報
            self.currentlocation = location;
            
            //現在地のデータを取得
            [self loadMap];
            
            //現在地へ移動
            [self moveLocation:self.currentlocation];
        }
    }];
}

-(IBAction)searchButtonAction:(id)sender
{
    //検索ページへ
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:MELSStoryboardIDShopSearch];
    //現在地を受け渡す
    MELSShopListViewController *viewController = (MELSShopListViewController*)navController.topViewController;
    viewController.currentLocation = self.currentlocation;
    [self.tabBarController presentViewController:navController animated:YES completion:nil];
}

#pragma mark private method

-(void)selectedMoveLocation:(NSNotification*)notification
{
    //選択されたマップへ移動
    if ([self.mapView.annotations count] > 0) {
        MELSShop *shop = [MELSShopManager sharedManager].selectedShop;
        for (id an in self.mapView.annotations) {
            MKPointAnnotation *point = (MKPointAnnotation*)an;
            if (point.coordinate.latitude == shop.shopLocation.coordinate.latitude && point.coordinate.longitude == shop.shopLocation.coordinate.longitude){
                [self.mapView selectAnnotation:point animated:YES];
                break;
            }
        }
    }
    
}

-(void)moveLocation:(CLLocation*)location
{
    //位置へマップを移動
    CLLocationCoordinate2D coordinate = location.coordinate;
    [self.mapView setCenterCoordinate:coordinate];
    
    MKCoordinateRegion zoom = self.mapView.region;
    zoom.span.latitudeDelta = kDefaultZoomSpanDelta;
    zoom.span.longitudeDelta = kDefaultZoomSpanDelta;
    [self.mapView setRegion:zoom animated:YES];
}

-(void)loadMap
{
    //現在地内の店舗を検索する
    __weak typeof(self) weakSelf = self;
    if (self.currentlocation != nil) {
        [[MELSShopManager sharedManager]getShopWithLocation:self.currentlocation completion:^(NSError *error) {
            if (error) {
                [weakSelf displayError:error completion:nil];
            } else {
                [weakSelf addPinsMap];
            }
        }];
    }
}

-(void)addPinsMap
{
    if ([[MELSShopManager sharedManager].collections count] > 0) {
        //まずPinを全消去
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        //複数のPinをさす処理
        for (MELSShop *shop in [MELSShopManager sharedManager].collections) {
            [self addPinWith:shop];
        }
    }
}

-(void)addPinWith:(MELSShop*)shop
{
    //ピンを刺す処理
    MKPointAnnotation *pin = [[MKPointAnnotation alloc]init];
    pin.title = shop.shopName;
    pin.coordinate = shop.shopLocation.coordinate;
    
    [self.mapView addAnnotation:pin];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation
{
    //現在地はピンを刺さずに無視
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView* pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
    if (pinView == nil) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier];
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        return pinView;
    }
    pinView.annotation = annotation;
    return pinView;
}



@end
