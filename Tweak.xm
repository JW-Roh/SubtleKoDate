
@interface SLTopView : UIView
+ (id)sharedInstance;
- (UILabel *)dateLabel;
- (void)getDate;
@end


%group SubtleHook

%hook SLTopView

- (void)getDate {
	NSLocale *systemLocale = [NSLocale currentLocale];
	
	if ([systemLocale.localeIdentifier hasPrefix:@"ko"]) {
		NSDate *today = [NSDate date];
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"MMMM d일\nEEEE"];
		[dateFormat setLocale:systemLocale];
		
		NSString *dateString = [dateFormat stringFromDate:today];
		
		[dateFormat release];
		
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
	%init(SubtleHook);
	
	%orig;
}

%end


%ctor
{
	%init;
}

