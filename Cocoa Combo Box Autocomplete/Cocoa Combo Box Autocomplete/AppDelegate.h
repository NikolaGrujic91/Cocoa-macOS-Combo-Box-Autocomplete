//
//  AppDelegate.h
//  Cocoa Combo Box Autocomplete
//
//  Created by Nikola Grujic on 20/02/2020.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSComboBoxDelegate, NSComboBoxDataSource, NSControlTextEditingDelegate>
{
    NSMutableArray *itemsCombo;
    NSMutableArray *filteredItemsCombo;
}

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSComboBox *comboBox;

- (void)setComboBoxDataSource;
- (void)setComboBoxDelegate;
- (void)setPopUpMenuItems;
- (NSArray*)suggestionsInPopUpForString:(NSString *)string;
- (void)expandPopUp:(NSString*)value;

@end

