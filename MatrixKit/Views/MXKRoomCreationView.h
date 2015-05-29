/*
 Copyright 2015 OpenMarket Ltd
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <MatrixSDK/MatrixSDK.h>

#import "MXKAlert.h"

@class MXKRoomCreationView;
@protocol MXKRoomCreationViewDelegate <NSObject>

/**
 Tells the delegate that a MXKAlert must be presented.
 
 @param creationView the view.
 @param alert the alert to present.
 */
- (void)roomCreationView:(MXKRoomCreationView*)creationView presentMXKAlert:(MXKAlert*)alert;

/**
 Tells the delegate to open the room with the provided identifier in a specific matrix session.
 
 @param creationView the view.
 @param roomId the room identifier.
 @param mxSession the matrix session in which the room should be available.
 */
- (void)roomCreationView:(MXKRoomCreationView*)creationView showRoom:(NSString*)roomId withMatrixSession:(MXSession*)mxSession;
@end

/**
 MXKRoomCreationView instance is a cell dedicated to room creation.
 Add this view in your app to offer room creation option.
 */
@interface MXKRoomCreationView : UIView <UITextFieldDelegate>

/**
 *  Returns the `UINib` object initialized for the tool bar view.
 *
 *  @return The initialized `UINib` object or `nil` if there were errors during
 *  initialization or the nib file could not be located.
 */
+ (UINib *)nib;

/**
 Creates and returns a new `MXKRoomCreationView-inherited` object.
 
 @discussion This is the designated initializer for programmatic instantiation.
 @return An initialized `MXKRoomCreationView-inherited` object if successful, `nil` otherwise.
 */
+ (instancetype)roomCreationView;

/**
 The delegate.
 */
@property (nonatomic) id<MXKRoomCreationViewDelegate> delegate;

/**
 */
@property (nonatomic) NSArray* mxSessions;

/**
 UI items
 */
@property (weak, nonatomic) IBOutlet UILabel *roomNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomAliasLabel;
@property (weak, nonatomic) IBOutlet UILabel *participantsLabel;
@property (weak, nonatomic) IBOutlet UITextField *roomNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *roomAliasTextField;
@property (weak, nonatomic) IBOutlet UITextField *participantsTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *roomVisibilityControl;
@property (weak, nonatomic) IBOutlet UIButton *createRoomBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldLeftConstraint;

/**
 Action registered to handle text field editing change (UIControlEventEditingChanged).
 */
- (IBAction)textFieldEditingChanged:(id)sender;

/**
 Force dismiss keyboard.
 */
- (void)dismissKeyboard;

/**
 Dispose any resources and listener.
 */
- (void)destroy;

@end
