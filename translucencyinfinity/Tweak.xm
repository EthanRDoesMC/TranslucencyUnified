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
    if (tcethanr)
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

// More coming soon.