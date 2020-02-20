//
//  AppDelegate.m
//  Cocoa Combo Box Autocomplete
//
//  Created by Nikola Grujic on 20/02/2020.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [self setComboBoxDataSource];
    [self setComboBoxDelegate];
    [self setPopUpMenuItems];
}

#pragma mark - NSComboBoxDataSource

//Returns the number of items that the data source manages for the combo box.
- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox
{
    return [filteredItemsCombo count];
}

//Returns the object that corresponds to the item at the specified index in the combo box.
- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index
{
    return [filteredItemsCombo objectAtIndex:index];
}

//Returns the index of the combo box item matching the specified string.
- (NSUInteger)comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue:(NSString *)string
{
    return [filteredItemsCombo indexOfObject:string];
}

//Returns the first item from the pop-up list that starts with the text the user has typed.
- (NSString *)comboBox:(NSComboBox *)aComboBox completedString:(NSString *)string
{
    [self suggestionsInPopUpForString:string];
    return string;
}

#pragma mark - NSComboBoxDelegate

//Informs the delegate that the pop-up list is about to be displayed.
-(void)comboBoxWillPopUp:(NSNotification *)notification
{
    [self suggestionsInPopUpForString:[((NSComboBox *)[notification object]) stringValue]];
}

#pragma mark - NSControlTextEditingDelegate

//Invoked when users press keys with predefined bindings in a cell of the specified control.
-(BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector
{
    NSComboBox *comboBox = (NSComboBox*) control;

    if (comboBox == _comboBox && (commandSelector == @selector(insertNewline:) ||
                                  commandSelector == @selector(insertBacktab:) ||
                                  commandSelector == @selector(insertTab:)))
    {
        // NOTE: handle choosing of item from pop-up menu
        // Not needed for this example
    }

    return NO;
}

//Sent when the text in the receiving control changes.
- (void)controlTextDidChange:(NSNotification *) aNotification
{
    NSTextField *textField = [aNotification object];
    NSString *value = [textField stringValue];
    [self expandPopUp:value];
}

#pragma mark - Helper methods

- (void)setComboBoxDataSource
{
    [_comboBox setUsesDataSource:YES];
    [_comboBox setCompletes:YES];
    [_comboBox setDataSource:(id)self];
}

- (void)setComboBoxDelegate
{
    [_comboBox setDelegate:(id)self];
}

- (void)setPopUpMenuItems
{
    itemsCombo = [NSMutableArray arrayWithObjects:@"Liverpool",@"Manchester City", @"Manchester United",
                                                  @"Chelsea", @"Everton",@"Watford", @"Wolverhampton",
                                                  @"Leicester City", @"Shefield United", @"Tottenham",@"Arsenal",
                                                  @"Crystal Palace", @"Southampton",@"Norwich", @"Aston Villa"
                                                  @"West Ham United", @"Burnley", @"Newcastle United", nil];
    
    filteredItemsCombo = [[NSMutableArray alloc] initWithArray:itemsCombo];
}

- (NSArray*)suggestionsInPopUpForString:(NSString *)string
{
    [filteredItemsCombo removeAllObjects];

    if ([string length] == 0 || [string isEqualToString:@""] || [string isEqualToString:@" "])
    {
        [filteredItemsCombo addObjectsFromArray:itemsCombo];
    }
    else
    {
        for (int i = 0; i < [itemsCombo count]; i++)
        {
            NSRange searchName  = [itemsCombo[i] rangeOfString:string options:NSCaseInsensitiveSearch];
            
            if (searchName.location != NSNotFound)
            {
                [filteredItemsCombo addObject:itemsCombo[i]];
            }
        }
    }

    [_comboBox reloadData];
    return filteredItemsCombo;
}

- (void)expandPopUp:(NSString*)value
{
    bool isValueEmpty = value == nil || [value length] == 0;
    bool isPopUpExpanded = [[_comboBox cell] isAccessibilityExpanded];
    
    if (isValueEmpty && isPopUpExpanded)
    {
        [[_comboBox cell] setAccessibilityExpanded:NO];
    }
    
    if (!isValueEmpty && !isPopUpExpanded)
    {
        [[_comboBox cell] setAccessibilityExpanded:YES];
    }
}

@end
