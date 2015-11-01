FW_DEVICE_IP = 192.168.1.9
ARCHS = armv7 arm64

include theos/makefiles/common.mk

TWEAK_NAME = SubtleKoDate
SubtleKoDate_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"

ri:: remoteinstall
remoteinstall:: all internal-remoteinstall after-remoteinstall
internal-remoteinstall::
	ssh root@$(FW_DEVICE_IP) "rm -f /Library/MobileSubstrate/DynamicLibraries/$(TWEAK_NAME).*"
	scp -P 22 "$(FW_PROJECT_DIR)/$(THEOS_OBJ_DIR_NAME)/$(TWEAK_NAME).dylib" root@$(FW_DEVICE_IP):/Library/MobileSubstrate/DynamicLibraries/
	scp -P 22 "$(FW_PROJECT_DIR)/$(TWEAK_NAME).plist" root@$(FW_DEVICE_IP):/Library/MobileSubstrate/DynamicLibraries/
after-remoteinstall::
	ssh root@$(FW_DEVICE_IP) "killall -9 backboardd"
