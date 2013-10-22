//
//  YouTubePluginPreferences.h
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

#import <Cocoa/Cocoa.h>

#import <Adium/AIAdvancedPreferencePane.h>
#import <Adium/AILocalizationButton.h>

@interface YouTubePluginPreferences : AIAdvancedPreferencePane {
	IBOutlet		AILocalizationButton		*checkBox_enableYouTubePlugin;
	IBOutlet		AILocalizationButton		*checkBox_displayBorder;
	IBOutlet		NSTextField					*label_sizeLabel;
	IBOutlet		NSSlider					*slider_size;
	IBOutlet		NSTextField					*label_size;
}

@end
