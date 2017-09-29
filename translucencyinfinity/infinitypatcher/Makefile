include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = infinitypatcher
infinitypatcher_FILES = XXXRootListController.m
infinitypatcher_INSTALL_PATH = /Library/PreferenceBundles
infinitypatcher_FRAMEWORKS = UIKit
infinitypatcher_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/infinitypatcher.plist$(ECHO_END)
