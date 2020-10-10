
#import <CoreLocation/CoreLocation.h>
%hook AMapLocationManager

- (void)locationManager:(id)arg1 didUpdateLocations:(id)arg2 {

    NSArray *locationArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"hsz_locations"];
    double lat = [locationArr[0] doubleValue] + arc4random_uniform(10)/1000000.0;
    double lon = [locationArr[1] doubleValue] + arc4random_uniform(10)/1000000.0;

    CLLocation *l = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    NSArray *arr = @[l];
    
    %orig(arg1, arr);
}

%end


%hook DTConversationListController

- (void)viewWillAppear:(_Bool)arg1 {
    %orig;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 200, 30, 30);
    [btn setTitle:@"📱" forState: UIControlStateNormal];
    [[UIApplication sharedApplication].keyWindow addSubview:btn];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
}

%new
- (void)btnAction {
    NSArray *locationArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"hsz_locations"];
    NSString *latS = nil;
    NSString *lonS = nil;
    if (locationArr && [locationArr count] == 2) {
        latS = locationArr[0];
        lonS = locationArr[1];
    }

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入经纬度" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入纬度";
        if (latS) textField.text = latS;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入经度";
        if (lonS) textField.text = lonS;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *lat = alertController.textFields.firstObject;
        UITextField *lon = alertController.textFields[1];

        if (!lat.text || !lon.text) return;
        NSArray *arr = @[lat.text, lon.text];
        [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"hsz_locations"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }]];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

%end