//
//  YouTubePlugin.h
//  YouTube Plugin
//
//  Created by Vincenzo Luca Mantova on 23/04/09.
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

#import <Cocoa/Cocoa.h>
#import <Adium/AIPlugin.h>
#import <Adium/AIContentControllerProtocol.h>
#import <Adium/AIPreferencePane.h>

#define PREF_GROUP_YOUTUBE	@"YouTube Plugin"
#define KEY_YOUTUBE_ENABLED	@"Enable YouTube plugin"
#define KEY_DISPLAY_BORDER	@"Display border"
#define KEY_WIDTH			@"Width"

@interface YouTubePlugin : AIPlugin <AIHTMLContentFilter> {
	AIPreferencePane *YouTubePluginPrefs;
@private
	NSUInteger blockId;
	NSCharacterSet *videoIdChars;
	
	NSString *blockHTML;
	NSString *ytThumbHTML;
}

@end
