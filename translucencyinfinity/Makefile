ARCHS = armv7 arm64 armv7s
DEBUG = 0
GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TranslucencyInfinity
TranslucencyInfinity_FILES = Tweak.xm Common/DDTMColours.m

include $(THEOS_MAKE_PATH)/tweak.mk
$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation
$(TWEAK_NAME)_LDFLAGS += -F./ -F./Common/
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -F./Common/

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += Settings
SUBPROJECTS += infinitypatcher
SUBPROJECTS += infinipatch
include $(THEOS_MAKE_PATH)/aggregate.mk
