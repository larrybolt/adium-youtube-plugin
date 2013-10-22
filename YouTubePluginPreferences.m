//
//  YouTubePluginPreferences.m
//  YouTube Plugin
//
//  Created by Vincenzo Luca Mantova on 31/05/09.
//  Copyright 2009 Vincenzo Luca Mantova.
//
//  This file is part of YouTube Plugin.
//
//  YouTube Plugin is free software: you can redistribute it and/or modify
//  it undel the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  YouTube Plugin is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with YouTube Plugin.  If not, see <http://www.gnu.org/licenses/>.
//

#import "YouTubePluginPreferences.h"
#import "YouTubePlugin.h"
#import <AIUtilities/AIDictionaryAdditions.h>
#import <Adium/AIPreferenceControllerProtocol.h>
#import <Adium/AIServiceIcons.h>
#import <Adium/ESDebugAILog.h>

@implementation YouTubePluginPreferences

- (NSString *)label
{
	return @"YouTube";
}

- (NSString *)nibName
{
    return @"YouTubePluginPrefs";
}

- (NSImage *)image
{
	NSString* imageName = [[NSBundle bundleForClass:[self class]] pathForResource:@"youtube_logo" ofType:@"png"];
	NSImage* imageObj = [[NSImage alloc] initWithContentsOfFile:imageName];
	[imageObj autorelease];
	return imageObj;
}

- (AIPreferenceCategory)category
{
    return AIPref_Advanced;
}

- (void)viewDidLoad
{
	[checkBox_enableYouTubePlugin setState:[[[adium preferenceController] preferenceForKey:KEY_YOUTUBE_ENABLED
																					 group:PREF_GROUP_YOUTUBE] boolValue]];
	[checkBox_enableYouTubePlugin setLocalizedString:@"Enable YouTube plugin"];
	NSUInteger border = [[[adium preferenceController] preferenceForKey:KEY_DISPLAY_BORDER
																  group:PREF_GROUP_YOUTUBE] integerValue];
	[checkBox_displayBorder setState:border];
	[checkBox_displayBorder setLocalizedString:@"Display border"];
	NSUInteger width = [[[adium preferenceController] preferenceForKey:KEY_WIDTH
																 group:PREF_GROUP_YOUTUBE] intValue];
	[slider_size setIntValue:width];
	[label_size setStringValue:[NSString stringWithFormat:@"%lux%lu", width + border * 20, width * 3 / 4 + border * 20]];
	
}


- (IBAction)changePreference:(id)sender {
	if (sender == checkBox_enableYouTubePlugin) {
		[[adium preferenceController] setPreference:[NSNumber numberWithBool:[sender state]] 
											 forKey:KEY_YOUTUBE_ENABLED
											  group:PREF_GROUP_YOUTUBE];
		[checkBox_displayBorder setEnabled:[sender state]];
		[label_sizeLabel setEnabled:[sender state]];
		[slider_size setEnabled:[sender state]];
		[label_size setEnabled:[sender state]];
	} else if (sender == checkBox_displayBorder) {
		NSUInteger border = [sender state];
		NSUInteger width = [slider_size intValue];
		[[adium preferenceController] setPreference:[NSNumber numberWithBool:[sender state]] 
											 forKey:KEY_DISPLAY_BORDER
											  group:PREF_GROUP_YOUTUBE];
		[label_size setStringValue:[NSString stringWithFormat:@"%lux%lu", width + border * 20, width * 3 / 4 + border * 20]];
	} else if (sender == slider_size) {
		NSUInteger width = [sender intValue];
		NSUInteger border = [checkBox_displayBorder state];
		[[adium preferenceController] setPreference:[NSNumber numberWithInteger:width]
											 forKey:KEY_WIDTH
											  group:PREF_GROUP_YOUTUBE];
		[label_size setStringValue:[NSString stringWithFormat:@"%lux%lu", width + border * 20, width * 3 / 4 + border * 20]];
	}
}

@end
