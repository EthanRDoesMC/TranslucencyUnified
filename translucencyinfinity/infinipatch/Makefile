include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = infinipatch
infinipatch_FILES = ifpRootListController.m
infinipatch_INSTALL_PATH = /Library/PreferenceBundles
infinipatch_FRAMEWORKS = UIKit
infinipatch_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/infinipatch.plist$(ECHO_END)
