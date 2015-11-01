
@interface SLLockScreenDateView : UIView
+ (id)sharedInstance;
- (id)dateText;
- (void)setDateString:(id)arg1;
- (id)timeFont;
@end



static NSLocale *systemLocale = nil;
static NSDateFormatter *dateFormat = nil;
static BOOL isKO = NO;


%group SubtleHook

%hook SLLockScreenDateView

- (void)updateLabels {
	%orig;
	
	if (isKO) {
		NSDate *today = [NSDate date];
		
		[dateFormat setLocale:systemLocale];
		
		NSString *dateString = [dateFormat stringFromDate:today];
		
		if (![self.dateText isEqualToString:dateString])
			[self setDateString:dateString];
		
		UILabel *_timeLabel = MSHookIvar<UILabel *>(self, "_timeLabel");
		CGRect frame = _timeLabel.frame;
		frame.size.width += 20.0f;
		_timeLabel.frame = frame;
	}
}

%end

%end


%hook SpringBoard

- (void)appleIconViewRemoved {
	systemLocale = [NSLocale currentLocale];
	
	dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"MMMM d일\nEEEE"];
	[dateFormat setLocale:systemLocale];
	
	isKO = [systemLocale.localeIdentifier hasPrefix:@"ko"];
	
	%init(SubtleHook);
	
	%orig;
}

%end


%ctor
{
	%init;
}


