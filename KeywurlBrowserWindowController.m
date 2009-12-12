#include "KeywurlBrowserWindowController.h"
#include "KeywurlPlugin.h"

@implementation NSObject(Keywurr_BrowserWindowController)

// We override this method to intercept addresses at an early stage without 
// invoking Safari's fallback system. This is quicker as it avoids unnecessary 
// DNS lookups
- (void) keywurl_goToToolbarLocation: (id) sender {
    KeywurlPlugin* plugin = [KeywurlPlugin sharedInstance];
    KeywordMapper* mapper = [plugin keywordMapper];
    NSString* input = [[[self keywurl_locationFieldEditor] textStorage] string];
    if (input) {
        BOOL useDefault = NO;
        if ([input rangeOfString: @" "].location != NSNotFound ||
			[input rangeOfString: @"."].location == NSNotFound) {
            // URL contains spaces and is not a single word that contains dots, 
            // so it's pretty much guaranteed to not be a URL
            useDefault = YES;
        }
        NSString* newUrl = [mapper mapKeywordInput: input withDefault: useDefault];
        if (![input isEqualToString: newUrl]) {
			void *field;
			object_getInstanceVariable([self keywurl_locationFieldEditor], "field", &field);
            [(id)field setObjectValue: newUrl];
        }
    }
    return [self keywurl_goToToolbarLocation: sender];
}

- (id) keywurl_locationFieldEditor {
	void *ptr;
	object_getInstanceVariable(self, "_locationFieldEditor", &ptr);
	return (id) ptr;
	//return _locationFieldEditor;
}

@end
