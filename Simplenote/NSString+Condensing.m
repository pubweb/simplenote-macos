#import "NSString+Condensing.h"

#define kMaxPreviewLength 500

@implementation NSString (Condensing)

- (NSString *)stringByGeneratingPreview
{
    NSString *aString = [NSString stringWithString:self];
    NSString *titlePreview;
    NSString *contentPreview;

    // Optimize to make sure a bunch of text doesn't get rendered but clipped in the previews
    if (aString.length > kMaxPreviewLength) {
        aString = [aString substringToIndex:kMaxPreviewLength];
    }
    
	NSString *contentTest = [aString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	
	NSRange firstNewline = [contentTest rangeOfString: @"\n"];
	if (firstNewline.location == NSNotFound) {
		titlePreview = contentTest;
		contentPreview = nil;
	} else {
		titlePreview = [contentTest substringToIndex:firstNewline.location];
		contentPreview = [[contentTest substringFromIndex: firstNewline.location+1] stringByReplacingOccurrencesOfString:@"\n\n" withString:@" \n"];
		
		// Remove leading newline if applicable
		NSRange nextNewline = [contentPreview rangeOfString: @"\n"];
        if (nextNewline.location == 0) {
			contentPreview = [contentPreview substringFromIndex:1];
        }
	}

    // Remove Markdown #'s
    if ([titlePreview hasPrefix:@"#"]) {
        NSRange cutRange = [titlePreview rangeOfString:@"# "];
        if (cutRange.location != NSNotFound) {
            titlePreview = [titlePreview substringFromIndex:cutRange.location + cutRange.length];
        }
    }
    
    if (contentPreview) {
        return [NSString stringWithFormat:@"%@\n%@", titlePreview, contentPreview];
    }
    
    return titlePreview;
}

@end
