ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

TWEAK_NAME = SubtleKoDate
SubtleKoDate_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

FW_DEVICE_IP = 192.168.1.4

ri:: remoteinstall
remoteinstall:: all internal-remoteinstall after-remoteinstall
internal-remoteinstall::
	scp -P 22 "$(FW_PROJECT_DIR)/$(THEOS_OBJ_DIR_NAME)/$(TWEAK_NAME).dylib" root@$(FW_DEVICE_IP):
	scp -P 22 "$(FW_PROJECT_DIR)/$(TWEAK_NAME).plist" root@$(FW_DEVICE_IP):
	ssh root@$(FW_DEVICE_IP) "mv $(TWEAK_NAME).* /Library/MobileSubstrate/DynamicLibraries/"
after-remoteinstall::
	ssh root@$(FW_DEVICE_IP) "killall -9 SpringBoard"
