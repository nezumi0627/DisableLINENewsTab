TARGET := iphone:clang:latest:18.0

# インストール時に終了させるアプリケーションを指定
INSTALL_TARGET_PROCESSES = LINE

ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DisableLINENewsTab

$(TWEAK_NAME)_FILES = $(shell find Tweak -name '*.x')
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -Wno-module-import-in-extern-c
$(TWEAK_NAME)_FRAMEWORKS = UIKit MapKit

ifeq ($(JAILED), 1)
$(TWEAK_NAME)_FILES += fishhook/fishhook.c SideloadFix/SideloadFix.xm
$(TWEAK_NAME)_CFLAGS += -D JAILED=1
endif

include $(THEOS_MAKE_PATH)/tweak.mk
