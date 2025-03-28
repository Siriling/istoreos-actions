#!/bin/bash

echo -e "添加额外设备"

# 加入nsy_g68-plus初始化网络配置脚本
cp -f $GITHUB_WORKSPACE/configs/swconfig_install package/base-files/files/etc/init.d/swconfig_install
chmod 755 package/base-files/files/etc/init.d/swconfig_install

# 集成 nsy_g68-plus WiFi驱动
mkdir -p package/base-files/files/lib/firmware/mediatek
cp -f $GITHUB_WORKSPACE/configs/mt7915_eeprom.bin package/base-files/files/lib/firmware/mediatek/mt7915_eeprom.bin
cp -f $GITHUB_WORKSPACE/configs/mt7916_eeprom.bin package/base-files/files/lib/firmware/mediatek/mt7916_eeprom.bin

# 删除会导致编译失败的补丁
rm -f target/linux/generic/hack-5.10/747-1-rtl8367b-support-rtl8367s.patch
rm -f target/linux/generic/hack-5.10/747-2-rtl8366_smi-phy-id.patch
rm -f target/linux/generic/hack-5.10/744-rtl8366_smi-fix-ce-debugfs.patch

# 电工大佬的rtl8367b驱动资源包，暂时使用这样替换
wget https://github.com/xiaomeng9597/files/releases/download/files/rtl8367b.tar.gz
tar -xvf rtl8367b.tar.gz

# openwrt主线rtl8367b驱动资源包，暂时使用这样替换
# wget https://github.com/xiaomeng9597/files/releases/download/files/rtl8367b-openwrt.tar.gz
# tar -xvf rtl8367b-openwrt.tar.gz

# rm -f target/linux/rockchip/rk35xx/base-files/lib/board/init.sh
# cp -f $GITHUB_WORKSPACE/configs/init.sh target/linux/rockchip/rk35xx/base-files/lib/board/init.sh

rm -f target/linux/rockchip/rk35xx/base-files/etc/board.d/02_network
cp -f $GITHUB_WORKSPACE/configs/02_network target/linux/rockchip/rk35xx/base-files/etc/board.d/02_network

# 增加nsy_g68-plus
echo -e "\\ndefine Device/nsy_g68-plus
\$(call Device/rk3568)
  DEVICE_VENDOR := NSY
  DEVICE_MODEL := G68
  DEVICE_DTS := rk3568-nsy-g68-plus
  SUPPORTED_DEVICES += nsy,g68-plus
  DEVICE_PACKAGES := kmod-nvme kmod-scsi-core kmod-thermal kmod-switch-rtl8306 kmod-switch-rtl8366-smi kmod-switch-rtl8366rb kmod-switch-rtl8366s kmod-hwmon-pwmfan kmod-leds-pwm kmod-r8125 kmod-r8168 kmod-switch-rtl8367b swconfig kmod-swconfig
endef
TARGET_DEVICES += nsy_g68-plus" >> target/linux/rockchip/image/rk35xx.mk

# 增加nsy_g16-plus
echo -e "\\ndefine Device/nsy_g16-plus
\$(call Device/rk3568)
  DEVICE_VENDOR := NSY
  DEVICE_MODEL := G16
  DEVICE_DTS := rk3568-nsy-g16-plus
  SUPPORTED_DEVICES += nsy,g16-plus
  DEVICE_PACKAGES := kmod-nvme kmod-scsi-core kmod-thermal kmod-switch-rtl8306 kmod-switch-rtl8366-smi kmod-switch-rtl8366rb kmod-switch-rtl8366s kmod-hwmon-pwmfan kmod-leds-pwm kmod-r8125 kmod-r8168 kmod-switch-rtl8367b swconfig kmod-swconfig
endef
TARGET_DEVICES += nsy_g16-plus" >> target/linux/rockchip/image/rk35xx.mk

# 增加bdy_g18-pro
echo -e "\\ndefine Device/bdy_g18-pro
\$(call Device/rk3568)
  DEVICE_VENDOR := BDY
  DEVICE_MODEL := G18
  DEVICE_DTS := rk3568-bdy-g18-pro
  SUPPORTED_DEVICES += bdy,g18-pro
  DEVICE_PACKAGES := kmod-nvme kmod-scsi-core kmod-thermal kmod-switch-rtl8306 kmod-switch-rtl8366-smi kmod-switch-rtl8366rb kmod-switch-rtl8366s kmod-hwmon-pwmfan kmod-leds-pwm kmod-r8125 kmod-r8168 kmod-switch-rtl8367b swconfig kmod-swconfig
endef
TARGET_DEVICES += bdy_g18-pro" >> target/linux/rockchip/image/rk35xx.mk

# 添加dts
cp -f $GITHUB_WORKSPACE/configs/rk3568-nsy-g68-plus.dts target/linux/rockchip/dts/rk3568/rk3568-nsy-g68-plus.dts
cp -f $GITHUB_WORKSPACE/configs/rk3568-nsy-g16-plus.dts target/linux/rockchip/dts/rk3568/rk3568-nsy-g16-plus.dts
cp -f $GITHUB_WORKSPACE/configs/rk3568-bdy-g18-pro.dts target/linux/rockchip/dts/rk3568/rk3568-bdy-g18-pro.dts
