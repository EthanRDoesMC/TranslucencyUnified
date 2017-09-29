// Endless. 
// Welcome to Translucency Infinity. Works everywhere, most of the time. 
// Because code is linear, each method is organized in order of least likely to work to most likely to work.
// When a method works in an app, it marks a bool as yes. 
// This bool is checked later on, and if no previous method has worked, the next one runs.
// Thus, a rather quick bypass of all remaining code happens, preventing too much of a slowdown.
// Used methods: Translucency by EthanRDoesMC, TranslucentMessages by AppleBetas, 

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "Common/DDTMCommon.h"
#import "Headers/UIBackgroundStyle.h"

static BOOL isEnabled = YES;
static BOOL shouldBlur = YES;
static BOOL hasPromptedAboutReduceTransparency = NO;
static BOOL tcethanr = YES;
CFStringRef kPrefsAppID = CFSTR("tk.ethanrdoesmc.translucency");

@interface UIWebBrowserView : UIView
- (NSURL *)_documentUrl;
@end

@interface _UIWebViewScrollView : UIView
@end

@interface UIApplication (Private)
- (void)_setBackgroundStyle:(long long)style;
- (void)terminateWithSuccess;
@end

@interface UIBehavior : NSObject
+(id)sharedBehaviors;
+(BOOL)hasDarkTheme;
@end

static void loadSettings() {
    NSDictionary *settings = nil;
    CFPreferencesAppSynchronize(kPrefsAppID);
    CFArrayRef keyList = CFPreferencesCopyKeyList(kPrefsAppID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    if (keyList) {
        settings = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, kPrefsAppID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));
        CFRelease(keyList);
    }
    if (settings && settings[@"Enabled"]) {
        isEnabled = [settings[@"Enabled"] boolValue];
    }
    if (settings && settings[@"BlurWallpaper"]) {
        shouldBlur = [settings[@"BlurWallpaper"] boolValue];
    }
    if (settings && settings[@"ReduceTransparencyPrompted"]) {
        hasPromptedAboutReduceTransparency = [settings[@"ReduceTransparencyPrompted"] boolValue];
    }
	if (settings && settings[@"tcethanr"]) {
        tcethanr = [settings[@"tcethanr"] boolValue];
    }
}

static void settingsChanged(CFNotificationCenterRef center,
                            void *observer,
                            CFStringRef name,
                            const void *object,
                            CFDictionaryRef userInfo) {
    [[UIApplication sharedApplication] terminateWithSuccess];
}

%hook UIWebBrowserView

- (void)loadRequest:(NSURLRequest *)request {
    %orig;
    if(tcethanr)
			{
        [[UIApplication sharedApplication] _setBackgroundStyle:3];
        [UIView animateWithDuration:0.3
                              delay:0.6
                            options:0
                         animations:^{
                             self.alpha = 1;
                             self.superview.backgroundColor = [UIColor clearColor];
							 self.superview.opaque = 0;
                             }
                         completion:nil];
//static BOOL TranslucencyWorked = YES;
    }
//	else {
//static BOOL TranslucencyWorked = NO;
//}
}
%end
static BOOL TranslucencyWorked = YES;
//lazy late nite assumption :P

%hook _UIWebViewScrollView
- (void)setBackgroundColor:(UIColor *)color {
    for (UIWebBrowserView *view in self.subviews) {
        if ([view isKindOfClass:%c(UIWebBrowserView)]) {
			if (TranslucencyWorked)
			{
            %orig([UIColor clearColor]);
            return;
        }
		}
		}
    %orig;
}
%end



%hook UIApplication

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = %orig;
    [application _setBackgroundStyle:UIBackgroundStyleDefault];
    UIWindow *window = MSHookIvar<UIWindow *>(application, "_window");
    [window setBackgroundColor:[UIColor clearColor]];
    [window setOpaque:NO];
    return result;
}

-(void)_setBackgroundStyle:(UIBackgroundStyle)style {
    if(shouldBlur) {
        %orig([NSClassFromString(@"UIBehavior") hasDarkTheme] ? [DDTMColours darkBlurStyle] : [DDTMColours blurStyle]);
    } else {
        %orig([DDTMColours transparentStyle]);
    }
}

%end

@interface UIViewController (Z)
@property(readonly, nonatomic) UITableView *tableView;
@property(readonly, nonatomic) UITableView *collectionView;
@property(readonly, nonatomic) UITableView *table;
@property(readonly, nonatomic) UISearchController *searchController;
-(void)blurSearchBar;
-(void)fixMyNumber;
-(void)quickFix;
@property (assign) BOOL editMode;
@end

@interface UIView (Z)
@property(nonatomic) UIColor *textColor;
@property(nonatomic) UILabel *textLabel;
@property(nonatomic) UILabel *nameLabel;
@property(nonatomic) UILabel *detailTextLabel;
-(void)clearBackgroundForView:(UIView *)view withForceWhite:(BOOL)force;
- (void)whiteTextForCell:(id)cell withForceWhite:(BOOL)force;
@end

@interface UITableViewCell (Z)
-(long long)tableViewStyle;
-(UITableView *)_tableView;
- (UILabel *)titleLabel;
- (UILabel *)valueLabel;
@end
@interface CNContactContentViewController
@property (assign) BOOL editMode;
@property(readonly, nonatomic) UITableView *tableView;
@end




static void createBlurView(UIView *view, CGRect bound, int effect)  {
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:effect]];
    visualEffectView.frame = bound;
    visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view addSubview:visualEffectView];
    [view sendSubviewToBack:visualEffectView];
}

static BOOL nero10Enabled() {
	// return YES;
	NSDictionary *list = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/tk.ethanrdoesmc.infinity.applist.plist"];
	NSString *id = [[NSBundle mainBundle] bundleIdentifier];
	// NSLog(@">>>>> %@", list);

	if (list != nil && list[id] != nil && [list[id] boolValue] == YES) {
		return YES;
	}

	return NO;
}

%hook CNContactContentViewController
%property (assign) BOOL editMode;
- (void)didChangeToEditMode:(bool)arg1 {
	// NSLog(@">>> didChangeToEditMode >>> %@", arg1 ? @"Y" : @"N");
	self.editMode = arg1;
	self.tableView.tag = arg1 ? 30052014 : 0;
	[self.tableView reloadData];

	%orig;
}
%end;

%hook UIViewController
%new
- (void)fixMyNumber {
	// NSLog(@">>> fixMyNumber >>> %@", self);


		if ([self respondsToSelector:@selector(meContactBanner)]) {
			id me = [self performSelector:@selector(meContactBanner)];
			if ([me respondsToSelector:@selector(footnoteLabel)]) {
				UILabel *label = [me performSelector:@selector(footnoteLabel)];


				label.textColor = [UIColor whiteColor];
				label.alpha = 0.6;
			}

			if ([me respondsToSelector:@selector(footnoteValueLabel)]) {
				UILabel *valueLabel = [me performSelector:@selector(footnoteValueLabel)];

				valueLabel.textColor = [UIColor whiteColor];
				valueLabel.alpha = 0.8;
			}
		}
}
%new
- (void)quickFix {
	// NSLog(@">>> quickFix >>> %@", self);

		// if ([self respondsToSelector:@selector(meContactBanner)]) {
		// 	id me = [self performSelector:@selector(meContactBanner)];
		// 	UILabel *label = [me performSelector:@selector(footnoteLabel)];
		// 	UILabel *valueLabel = [me performSelector:@selector(footnoteValueLabel)];

		// 	label.textColor = [UIColor whiteColor];
		// 	label.alpha = 0.8;
		// 	valueLabel.textColor = [UIColor whiteColor];
		// 	valueLabel.alpha = 0.9;
		// }

		if ([self respondsToSelector:@selector(contactHeaderView)]) {
			UIView *header = [self performSelector:@selector(contactHeaderView)];
			if (header.tag != 181188) {
				header.tag = 181188;
				header.backgroundColor = [UIColor clearColor];
				// NSLog(@">>> quickFix >>> %@", header.nameLabel);
				// header.nameLabel.textColor = [UIColor whiteColor];
				createBlurView(header, header.bounds, UIBlurEffectStyleExtraLight);
				
				// header.nameLabel.textColor = [UIColor whiteColor];
			}
			

		}

		if ([self respondsToSelector:@selector(actionsWrapperView)]) {	
			UIView *action = [self performSelector:@selector(actionsWrapperView)];
			if (action.tag != 181188) {
				action.tag = 181188;
				action.backgroundColor = [UIColor clearColor];
				createBlurView(action, action.bounds, UIBlurEffectStyleExtraLight);
			}
		}	
}


- (void)viewDidLoad {
    %orig;

	// NSLog(@">>> viewDidLoad >>> %@", self);
	
	if (nero10Enabled()) {
		// temporary disable
		// if (

		// 	// [[[self class] description] isEqualToString:(@"CNContactContentViewController")]
		// 	// || [[[self class] description] isEqualToString:(@"CNContactViewController")]
		// 	// || [[[self class] description] isEqualToString:(@"CNContactInlineActionsViewController")]
		// 	) {
		// 		return;
		// }
		

		if ([ [[self class] description] isEqualToString:(@"CNContactContentViewController")]) {
			if ([self editMode]) {
				return;
			}
		}

		[[UIApplication sharedApplication] _setBackgroundStyle:3];


		UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"/var/mobile/bg.jpg"]];
		iv.frame = [UIScreen mainScreen].bounds;


		// for(UIWindow *window in [UIApplication sharedApplication].windows) {
				// [window addSubview:iv];
				// [window sendSubviewToBack:iv];
			// window.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"/var/mobile/bg.jpg"]];
		// }




		createBlurView(iv, iv.frame, UIBlurEffectStyleLight);

		if ([ [[self class] description] isEqualToString:(@"ALApplicationPreferenceViewController")]) {
			[((UITableView *)MSHookIvar<UITableView *>(self, "_tableView")) setBackgroundView:iv];
		}else if ([self respondsToSelector:@selector(table)]) {
			[self.table setBackgroundView:iv];
		}else if ([self respondsToSelector:@selector(tableView)]) {
			[self.tableView setBackgroundView:iv];
		}else if ([self respondsToSelector:@selector(collectionView)]) {
			[self.collectionView setBackgroundView:iv];
		}else {
			// self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"/var/mobile/bg.jpg"]];
			// [self.view addSubview:iv];
			// [self.view sendSubviewToBack:iv];

			// NSLog(@">>> viewDidLoad >>> %@ %@", self, self.view);


			for(UITableView *v in [self.view subviews]) {
				if ([v isKindOfClass:[UITableView class]]) {
					// [v setBackgroundView:iv];
					v.backgroundColor = [UIColor clearColor];
				}
			}

			for(UICollectionView *v in [self.view subviews]) {
				if ([v isKindOfClass:[UICollectionView class]]) {
					// [v setBackgroundView:iv];
					v.backgroundColor = [UIColor clearColor];
				}
			}

			// if([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.calculator"]) {
			// 	[self.view addSubview:iv];
			// 	[self.view sendSubviewToBack:iv];
			// }


		}
		
		@try {
			self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
			self.tabBarController.tabBar.barStyle = UIBarStyleBlack;
		}
		@catch(NSException *e){}
		
		
		@try {
			if([[UIApplication sharedApplication].windows count] == 1)
			{
				UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
				[window addSubview:iv];
				[window sendSubviewToBack:iv];
			}
		}
		@catch(NSException *e){}

		
		
		UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
		
		if ([ [[self class] description] isEqualToString:(@"ALApplicationPreferenceViewController")]) {
			((UITableView *)MSHookIvar<UITableView *>(self, "_tableView")).separatorEffect = vibrancyEffect;
			((UITableView *)MSHookIvar<UITableView *>(self, "_tableView")).sectionIndexBackgroundColor = [UIColor clearColor];
			// [((UITableView *)MSHookIvar<UITableView *>(self, "_tableView")) setSectionIndexColor:[UIColor clearColor]];
			[((UITableView *)MSHookIvar<UITableView *>(self, "_tableView")) setSectionIndexTrackingBackgroundColor:[UIColor clearColor]];
		}else if ([self respondsToSelector:@selector(table)]) {
			self.table.separatorEffect = vibrancyEffect;
			self.table.sectionIndexBackgroundColor = [UIColor clearColor];
			// [self.table setSectionIndexColor:[UIColor clearColor]];
			[self.table setSectionIndexTrackingBackgroundColor:[UIColor clearColor]];
		}else if ([self respondsToSelector:@selector(tableView)]) {
			self.tableView.separatorEffect = vibrancyEffect;
			self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
			// [self.tableView setSectionIndexColor:[UIColor clearColor]];
			[self.tableView setSectionIndexTrackingBackgroundColor:[UIColor clearColor]];
		}else{

			for(UITableView *v in [self.view subviews]) {
				if ([v isKindOfClass:[UITableView class]]) {
					v.separatorEffect = vibrancyEffect;
					v.sectionIndexBackgroundColor = [UIColor clearColor];
					// [v setSectionIndexColor:[UIColor clearColor]];
					[v setSectionIndexTrackingBackgroundColor:[UIColor clearColor]];
				}
			}
		}
		

		
		self.view.backgroundColor = [UIColor clearColor];
	}


}

%new
- (void)blurSearchBar {
	if (self.searchController.searchBar.tag != 181188) {
		self.searchController.searchBar.tag = 181188;
		// self.searchController.searchBar.barStyle = UIBarStyleBlackTranslucent;
		self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
		self.searchController.searchBar.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.25];
		UITextField *searchField = [self.searchController.searchBar valueForKey:@"searchField"];
		searchField.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8];
		
		
		// self.searchController.searchBar.subviews[0].subviews[0].alpha = 0;
		
		// createBlurView(self.searchController.searchBar, self.searchController.searchBar.bounds, UIBlurEffectStyleLight);
	}
}

- (void)viewWillAppear:(bool)arg1 {
	%orig;

	// NSLog(@">>> viewWillAppear >>> %@", self);

	if (nero10Enabled()) {
		if ([ [[self class] description] isEqualToString:(@"CNContactContentViewController")]) {
			if ([self editMode]) {
				return;
			}
		}

		if ([self respondsToSelector:@selector(searchController)]) {
			[self blurSearchBar];

			[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(blurSearchBar) userInfo:nil repeats:NO];
			

		}
		if ([ [[self class] description] isEqualToString:(@"CNContactListViewController")]) {
			[NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(fixMyNumber) userInfo:nil repeats:NO];
		} else if ([ [[self class] description] isEqualToString:(@"CNContactContentViewController")]) {
			[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(quickFix) userInfo:nil repeats:NO];
		}  

		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];


		
		/*
		// temporary disable
		if ([self respondsToSelector:@selector(meContactBanner)]) {
			id me = [self performSelector:@selector(meContactBanner)];
			UILabel *label = [me performSelector:@selector(footnoteLabel)];
			UILabel *valueLabel = [me performSelector:@selector(footnoteValueLabel)];

			label.textColor = [UIColor whiteColor];
			label.alpha = 0.8;
			valueLabel.textColor = [UIColor whiteColor];
			valueLabel.alpha = 0.9;
		}else if ([self respondsToSelector:@selector(contactHeaderView)]) {
			UIView *header = [self performSelector:@selector(contactHeaderView)];
			header.backgroundColor = [UIColor clearColor];
		}else if ([self respondsToSelector:@selector(actionsWrapperView)]) {	
			UIView *action = [self performSelector:@selector(actionsWrapperView)];
			action.backgroundColor = [UIColor clearColor];
		}
		*/

	}
}


- (void)viewDidAppear:(bool)arg1 {
	%orig;


	// NSLog(@">>> viewDidAppear >>> %@", self);

	if (nero10Enabled()) {
		if ([ [[self class] description] isEqualToString:(@"CNContactContentViewController")]) {
			if ([self editMode]) {
				self.tableView.tag = 30052014;
				return;
			}
		}

		if ([self respondsToSelector:@selector(searchController)]) {
			[self blurSearchBar];

			[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(blurSearchBar) userInfo:nil repeats:NO];

		}

		
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	}
}



// - (id)tableView:(UITableView *)arg1 cellForRowAtIndexPath:(id)arg2 {
// 	UITableViewCell *cell = %orig;
// 	if (nero10Enabled()) {
// 		[arg1 whiteTextForCell:cell withForceWhite:NO];
// 	}
// 	return cell;
// }
%end

%hook CNContactListViewController
- (void)tableView:(UITableView *)arg1 didSelectRowAtIndexPath:(NSIndexPath *)arg2 {
	%orig;


	if (nero10Enabled()) {
		// UITableViewCell *cell = [arg1 cellForRowAtIndexPath:arg2];
		// [arg1 whiteTextForCell:cell withForceWhite:NO];

		[arg1 reloadRowsAtIndexPaths:@[arg2] withRowAnimation:UITableViewRowAnimationFade];
	}
}
%end

%hook UICollectionView 
%new
- (void)clearBackgroundForView:(UIView *)view withForceWhite:(BOOL)force {
	if(view.tag == 181188) return;

	view.backgroundColor = [UIColor clearColor];
	for(UIView *v in [view subviews]) {
		if(v.tag == 181188) continue;
		v.backgroundColor = [UIColor clearColor];

		if ([v respondsToSelector:@selector(textColor)]) {
			if(v.textColor == [UIColor blackColor] || force) { 
				if (v.textColor != [UIColor whiteColor]) {
					v.alpha = 0.8;
				}
				v.textColor = [UIColor whiteColor];
			}
		}

		[self clearBackgroundForView:v withForceWhite:force];
	}
}
%new
- (void)whiteTextForCell:(UICollectionViewCell *)cell withForceWhite:(BOOL)force {		
		cell.backgroundColor = [UIColor clearColor];


		UIView *selectionColor = [[UIView alloc] init];
		selectionColor.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3];
		cell.selectedBackgroundView = selectionColor;


		[self clearBackgroundForView:cell withForceWhite:force];
		// [self clearBackgroundForView:cell.contentView withForceWhite:force];
}

-(id)_createPreparedCellForItemAtIndexPath:(id)arg1 withLayoutAttributes:(id)arg2 applyAttributes:(BOOL)arg3 isFocused:(BOOL)arg4 notify:(BOOL)arg5 {
	UICollectionViewCell *cell = %orig;


	if (nero10Enabled()) {
		if (self.tag == 30052014) return cell;
		[self whiteTextForCell:cell withForceWhite:NO];
	}

	return cell;
}
%end


@interface PHHandsetDialerNameLabelView : UIControl
@property (retain) UILabel * nameAndLabelLabel;
@end

@interface PHHandsetDialerLCDView : UIView
@property (retain) PHHandsetDialerNameLabelView * nameAndLabelView; 
@property (nonatomic,retain) UITextField * numberTextField;
@end


@interface PHHandsetDialerView {
	UIView* _lcdView;
	UIView* _phonePadView;
}
@property(retain) UIView* topBlankView;
@property(retain) UIView* bottomBlankView;
@property(retain) UIView* rightBlankView;
@property(retain) UIView* leftBlankView;
@end

@interface TPRevealingRingView : UIView
@property (nonatomic, retain) UIColor *colorInsideRing;
@property (nonatomic, retain) UIColor *colorOutsideRing;
@property (nonatomic) double alphaInsideRing;
@property (nonatomic) double alphaOutsideRing;
@property (nonatomic) double gammaBoost;
@property (nonatomic) bool gammaBoostInside;
@property (nonatomic) bool gammaBoostOuterRing;
@end

@interface PHHandsetDialerNumberPadButton
@property (nonatomic, readonly) TPRevealingRingView *revealingRingView;
- (void)setHighlighted:(bool)arg1;
- (void)setUsesColorDodgeBlending;
- (void)backToHighlighted;
@end

%hook MPKeypadViewController
-(void)viewDidLoad {
	%orig;

	PHHandsetDialerView *_dialerView = (PHHandsetDialerView *)MSHookIvar<PHHandsetDialerView *>(self, "_dialerView");
	_dialerView.topBlankView.hidden = YES;
	_dialerView.bottomBlankView.hidden = YES;
	_dialerView.rightBlankView.hidden = YES;
	_dialerView.leftBlankView.hidden = YES;

	PHHandsetDialerLCDView* _lcdView =  (PHHandsetDialerLCDView *)MSHookIvar<PHHandsetDialerLCDView *>(_dialerView, "_lcdView");
	UIView* _phonePadView =  (UIView *)MSHookIvar<UIView *>(_dialerView, "_phonePadView");
	
	_lcdView.backgroundColor = [UIColor clearColor];
	_lcdView.numberTextField.textColor = [UIColor whiteColor];
	_lcdView.nameAndLabelView.nameAndLabelLabel.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8];

	for(PHHandsetDialerNumberPadButton *v in [_phonePadView subviews]){
		// NSLog(@">>> _phonePadView subviews >>> %@", v);
		// if([[v description] isEqualToString:(@"PHHandsetDialerNumberPadButton")]) {

			[v setUsesColorDodgeBlending];
			[v setHighlighted:YES];
			TPRevealingRingView *rv = v.revealingRingView;//[v performSelector:@selector(revealingRingView)];
		// NSLog(@">>> _phonePadView subviews rv >>> %@", rv);
			rv.colorOutsideRing = [UIColor clearColor];
			rv.colorInsideRing = [UIColor clearColor];
			// rv.colorInsideRing = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.1];
			// rv.alphaInsideRing = 0.5;
			// createBlurView(rv, rv.bounds, UIBlurEffectStyleLight);
			// rv.alphaInsideRing = 0;

			// UIView *vv = [[UIView alloc] init];
			// vv.alpha = 0.6;
			// vv.frame = CGRectMake((rv.bounds.size.width - rv.bounds.size.height + 18)/2,(rv.bounds.size.height - rv.bounds.size.height + 18)/2,rv.bounds.size.height - 18,rv.bounds.size.height - 18);
			// vv.backgroundColor = [UIColor clearColor];
			// vv.layer.cornerRadius = vv.frame.size.height/2;
			// vv.clipsToBounds = YES;
			// createBlurView(vv, vv.bounds, UIBlurEffectStyleLight);
			// vv.layer.borderWidth = 1;
			// vv.layer.borderColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8].CGColor;
			// [rv addSubview:vv];



		// }
	}
}
%end


%hook PHHandsetDialerNumberPadButton 
// - (id)glyphLayer {
// 	// NSLog(@">>> glyphLayer >>>");
// 	// return [self performSelector:@selector(highlightedGlyphLayer)];
// 	return nil;
// }
// - (void)setGlyphLayer:(id)arg1 {
// 	// NSLog(@">>> setGlyphLayer >>>");
// 	// [self performSelector:@selector(setHighlightedGlyphLayer:) withObject:[self performSelector:@selector(highlightedGlyphLayer)]];
// }
- (void)setHighlighted:(bool)arg1 {
	%orig;
	[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(backToHighlighted) userInfo:nil repeats:NO];
			
}

%new
- (void)backToHighlighted {
	[self setHighlighted:YES];
}
%end

%hook UITableView
%new
- (void)clearBackgroundForView:(UIView *)view withForceWhite:(BOOL)force {
	if(view.tag == 181188) return;
		if ([view respondsToSelector:@selector(textLabel)]) {
			if(view.textLabel.textColor == [UIColor blackColor] || force) { 
				if (view.textLabel.textColor != [UIColor whiteColor]) {
					view.textLabel.alpha = 0.8;
				}
				view.textLabel.textColor = [UIColor whiteColor];
				
			}
		}
		if ([view respondsToSelector:@selector(detailTextLabel)]) {
			if(view.detailTextLabel.textColor == [UIColor blackColor] || force) { 
				if (view.detailTextLabel.textColor != [UIColor whiteColor]) {
					view.detailTextLabel.alpha = 0.8;
				}
				view.detailTextLabel.textColor = [UIColor whiteColor];
			}
		}

	view.backgroundColor = [UIColor clearColor];
	for(UIView *v in [view subviews]) {
		if(v.tag == 181188) continue;
		v.backgroundColor = [UIColor clearColor];

		if ([v respondsToSelector:@selector(textColor)]) {
			if(v.textColor == [UIColor blackColor] || force) { 
				if (v.textColor != [UIColor whiteColor]) {
					v.alpha = 0.8;
				}
				v.textColor = [UIColor whiteColor];
			}
		}

		[self clearBackgroundForView:v withForceWhite:force];
	}
}
%new
- (void)whiteTextForCell:(UITableViewCell *)cell withForceWhite:(BOOL)force {
	UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
		[cell _tableView].separatorEffect = vibrancyEffect;
		
		cell.backgroundColor = [UIColor clearColor];
		cell.textLabel.textColor = [UIColor whiteColor];

		if ([cell respondsToSelector:@selector(titleLabel)]) {
			// if(cell.titleTextLabel.textColor == [UIColor blackColor]e) { 
				// if (view.textLabel.textColor != [UIColor whiteColor]) {
					// view.textLabel.alpha = 0.8;
				// }
				cell.titleLabel.textColor = [UIColor whiteColor];
				
			// }
		}
		// NSLog(@">>> whiteTextForCell >>> %@", [[cell class] superclass]);
		BOOL contactCell = NO;
		if (
			[[[[cell class] superclass] description] isEqualToString:(@"CNPropertySimpleTransportCell")]
			|| [[[[cell class] superclass] description] isEqualToString:(@"CNPropertyCell")]
			|| [[[[cell class] superclass] description] isEqualToString:(@"CNPropertyAlertCell")]
			|| [[[[cell class] superclass] description] isEqualToString:(@"CNLabeledCell")]
			|| [[[[cell class] superclass] description] isEqualToString:(@"CNPropertySimpleEditingCell")]
			) {
			((UIView *)[cell subviews][0]).hidden = YES;
			contactCell = YES;
		}

		UIView *selectionColor = [[UIView alloc] init];
		selectionColor.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3];
		cell.selectedBackgroundView = selectionColor;

		[self clearBackgroundForView:cell withForceWhite:force];
		// [self clearBackgroundForView:cell.contentView withForceWhite:force];

		if (cell.tableViewStyle == UITableViewStyleGrouped) {
			if ([cell viewWithTag:181188] == nil && !contactCell) {
				UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, cell.frame.size.height)];
				whiteView.tag = 181188;
				whiteView.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.09];

				[cell addSubview:whiteView];
				[cell sendSubviewToBack:whiteView];

			}
		}
}


// -(UIColor *)sectionIndexTrackingBackgroundColor {
// 	return [UIColor clearColor];
// }

// -(id)_sectionIndexTrackingBackgroundColor {
// 	return [UIColor clearColor];
// }

// -(BOOL)_shouldSetIndexBackgroundColorToTableBackgroundColor {
// 	return YES;
// }
// -(UIColor *)sectionIndexTrackingBackgroundColor {
// 	return [UIColor clearColor];
// }
// -(UIColor *)sectionIndexColor {
// 	return [UIColor clearColor];
// }
// -(UIColor *)sectionIndexBackgroundColor {
// 	return [UIColor clearColor];
// }

// - (id)_createPreparedCellForGlobalRow:(long long)arg1 withIndexPath:(id)arg2 {
// 	UITableViewCell *cell = %orig;

// 	if (nero10Enabled()) {
// 		[self whiteTextForCell:cell withForceWhite:NO];

// 	}
// 	return cell;
// }

// -(id)cellForRowAtIndexPath:(id)arg1 {
// 	UITableViewCell *cell = %orig;


// 	if (nero10Enabled()) {
// 		[self whiteTextForCell:cell withForceWhite:NO];

// 	}
// 	return cell;	
// }
// -(id)dequeueReusableCellWithIdentifier:(id)arg1 {
// 	UITableViewCell *cell = %orig;


// 	if (nero10Enabled()) {
// 		[self whiteTextForCell:cell withForceWhite:NO];

// 	}
// 	return cell;	
// }
// -(id)_createPreparedCellForRowAtIndexPath:(id)arg1 willDisplay:(BOOL)arg2  {
// 		UITableViewCell *cell = %orig;


// 	if (nero10Enabled()) {
// 		[self whiteTextForCell:cell withForceWhite:NO];

// 	}
// 	return cell;
// }
- (id)_createPreparedCellForGlobalRow:(long long)arg1 withIndexPath:(id)arg2 willDisplay:(bool)arg3 {
	UITableViewCell *cell = %orig;


	if (nero10Enabled()) {
		if (self.tag == 30052014) return cell;
		[self whiteTextForCell:cell withForceWhite:NO];
	}

	return cell;
}
// -(void)_configureCellForDisplay:(UITableViewCell*)cell forIndexPath:(id)arg2 {

// 	%orig;
	


// 	if (nero10Enabled()) {

// 		[self whiteTextForCell:cell withForceWhite:NO];
// 	}

// }
-(id)_sectionHeaderView:(BOOL)arg1 withFrame:(CGRect)arg2 forSection:(long long)arg3 floating:(BOOL)arg4 reuseViewIfPossible:(BOOL)arg5 willDisplay:(BOOL)arg6 {
	UIView *view = %orig;
	if (nero10Enabled()) {	
		if (self.tag == 30052014) return view;
		[self clearBackgroundForView:view withForceWhite:YES];
		
		// if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.mobilephone"])
		// {
		// 	createBlurView(view, view.bounds, UIBlurEffectStyleLight);
		// 	// view.alpha = 0.7;
		// }

		

		if ([view respondsToSelector:@selector(contentView)]) {
			[self clearBackgroundForView:[view performSelector:@selector(contentView)] withForceWhite:YES]; 
		}
	}
	return view;
}

-(id)_sectionFooterViewWithFrame:(CGRect)arg1 forSection:(long long)arg2 floating:(BOOL)arg3 reuseViewIfPossible:(BOOL)arg4 willDisplay:(BOOL)arg5 {
	UIView *view = %orig;
	if (nero10Enabled()) {	
		if (self.tag == 30052014) return view;
		[self clearBackgroundForView:view withForceWhite:YES];

		if ([view respondsToSelector:@selector(contentView)]) {
			[self clearBackgroundForView:[view performSelector:@selector(contentView)] withForceWhite:YES]; 
		}
	}
	return view;
}

// -(void)setTableHeaderView:(UIView *)view {
// 	// NSLog(@"333");
// 	if (nero10Enabled()) {	
// 		[self clearBackgroundForView:view withForceWhite:YES];

// 		if ([view respondsToSelector:@selector(contentView)]) {
// 			[self clearBackgroundForView:[view performSelector:@selector(contentView)] withForceWhite:YES]; 
// 		}
// 	}
// 	%orig(view);
// }
// -(void)setTableFooterView:(UIView *)view {
// 	// NSLog(@"444");
// 	if (nero10Enabled()) {	
// 		[self clearBackgroundForView:view withForceWhite:YES];

// 		if ([view respondsToSelector:@selector(contentView)]) {
// 			[self clearBackgroundForView:[view performSelector:@selector(contentView)] withForceWhite:YES]; 
// 		}
// 	}
// 	%orig(view);
// }
%end


%hook SpringBoard
- (void)applicationDidFinishLaunching: (id) application {
    %orig;

	UIImage *i = [[[%c(SBWallpaperController) performSelector:@selector(sharedInstance)] performSelector:@selector(_activeWallpaperView)] performSelector:@selector(_displayedImage)];
	
	[UIImageJPEGRepresentation(i, 1) writeToFile:@"/var/mobile/bg.jpg" atomically:YES];
}
%end

// More coming soon.