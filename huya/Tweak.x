// @interface AboutHuyaViewController : UIViewController
// @property (nonatomic, retain) UILabel *copyrightTitleLabel;
// @end

%hook ChannelInteractiveEntranceViewController
+ (id)viewController {
	return nil;
}
- (id)init {
	return nil;
}
%end

%hook HuyaAdvViewController
- (id)init {
	return nil;
}
- (id)advViewFromBundle {
	return nil;
}
%end

%hook HYFloatBallView
- (id)init {
	return nil;
}
- (id)initWithFrame:(struct CGRect)arg1 {
	return nil;
}
%end

%hook ActivityButtonView
- (id)init {
	return nil;
}
- (id)initWithFrame:(struct CGRect)arg1 {
	return nil;
}
%end

%hook BannerAnimationViewController
- (id)init {
	return nil;
}
- (id)bannerDispatchDelegateCreateAnimationViewWithInfo:(id)arg1 {
	return nil;
}
+ (id)embedSegue {
	return nil;
}
- (id)marqueeDispatchDelegateCreateMarqueeViewWithInfo:(id)arg1 {
	return nil;
}
%end

// %hook AboutHuyaViewController
// - (void)viewWillAppear:(id)arg1 {
// 	self.copyrightTitleLabel.text = @"虎牙公司@hsz";
// }
// %end