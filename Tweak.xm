
@interface SLTopView : UIView
+ (id)sharedInstance;
- (UILabel *)dateLabel;
- (void)getDate;
@end



NSLocale *systemLocale = nil;
NSDateFormatter *dateFormat = nil;


%group SubtleHook

%hook SLTopView

- (void)getDate {
	systemLocale = [NSLocale currentLocale];
	
	if ([systemLocale.localeIdentifier hasPrefix:@"ko"]) {
		NSDate *today = [NSDate date];
		
		[dateFormat setLocale:systemLocale];
		
		NSString *dateString = [dateFormat stringFromDate:today];
		
		UILabel *dateLabel = [self dateLabel];
		
		if (![dateLabel.text isEqualToString:dateString])
			dateLabel.text = dateString;
	}
	else
		%orig;
}

%end

%end


%hook SpringBoard

- (void)appleIconViewRemoved {
	systemLocale = [NSLocale currentLocale];
	
	dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"MMMM d일\nEEEE"];
	[dateFormat setLocale:systemLocale];
	
	%init(SubtleHook);
	
	%orig;
}

%end


%ctor
{
	%init;
}

