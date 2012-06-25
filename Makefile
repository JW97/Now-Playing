include theos/makefiles/common.mk

BUNDLE_NAME = NowPlaying
NowPlaying_FILES = NowPlayingController.m NPControlsPage.m NPInfoPage.m NPScrollView.m WidgetHelper.m AutoScrollLabel.m
NowPlaying_INSTALL_PATH = /System/Library/WeeAppPlugins/
NowPlaying_FRAMEWORKS = UIKit CoreGraphics Twitter
NowPlaying_LDFLAGS = -lapplist

include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
