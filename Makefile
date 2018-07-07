#
# Copyright (C) 2006-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=gdut-drcom
PKG_VERSION:=1.6.8
PKG_RELEASE:=4

PKG_SOURCE:=$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/chenhaowen01/$(PKG_NAME)/archive
PKG_MD5SUM:=86586eacd0540c994c0f194197d6000e
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_LICENSE:=GPL-3.0+

#PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
MAKE_PATH:=src

define Package/gdut-drcom
  SECTION:=net
  CATEGORY:=Network
  TITLE:=A third party drcom client openwrt.
  MAINTAINER:=chw
endef

define Package/gdut-drcom/description
	gdut-drcom for openwrt is a third party drcom client openwrt.
endef

define Package/gdut-drcom/postinst
#!/bin/sh
echo "post install: patching ppp.sh"
sed -i '/#added by gdut-drcom/d' /lib/netifd/proto/ppp.sh
sed -i '/proto_run_command/i username=$$(echo -e "\\r\\n$$username")    #added by gdut-drcom!' /lib/netifd/proto/ppp.sh
echo "patched!"
endef

define Package/gdut-drcom/prerm
#!/bin/sh
echo "pre remove: unpatching ppp.sh!"
sed -i '/#added by gdut-drcom/d' /lib/netifd/proto/ppp.sh
echo "unpatched!"
endef

define Package/gdut-drcom/install
	$(INSTALL_DIR)  $(1)/usr/bin
	$(INSTALL_BIN)  $(PKG_BUILD_DIR)/src/gdut-drcom $(1)/usr/bin
	$(INSTALL_BIN)  ./files/usr/bin/gdut-drcom-patch $(1)/usr/bin
	$(INSTALL_BIN)  ./files/usr/bin/gdut-drcom-unpatch $(1)/usr/bin
	$(INSTALL_DIR)  $(1)/etc
	$(INSTALL_DATA) ./files/etc/gdut-drcom.conf $(1)/etc
	$(INSTALL_DIR)  $(1)/etc/init.d
	$(INSTALL_BIN)  ./files/etc/init.d/gdut-drcom $(1)/etc/init.d

	$(INSTALL_DIR)   $(1)/etc/config
	$(INSTALL_DATA)  ./files/etc/config/gdut_drcom $(1)/etc/config
	$(INSTALL_DIR)   $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA)  ./files/usr/lib/lua/luci/controller/gdut-drcom.lua $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DIR)   $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA)  ./files/usr/lib/lua/luci/model/cbi/gdut-drcom.lua $(1)/usr/lib/lua/luci/model/cbi
endef

$(eval $(call BuildPackage,gdut-drcom))

