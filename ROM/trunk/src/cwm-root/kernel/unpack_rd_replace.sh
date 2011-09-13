#!/tmp/busybox sh
/tmp/busybox sh -c ">>EOF
cd /tmp
mkdir ramdisk
cd ramdisk
/tmp/busybox gzip -dc ../boot.img-ramdisk.gz | /tmp/busybox cpio -i
cd lib/modules
cp /tmp/modules/dhd.ko ./
cp /tmp/modules/scsi_wait_scan.ko ./
/tmp/busybox chmod 644 dhd.ko
/tmp/busybox chmod 644 scsi_wait_scan.ko
cd ../../
/tmp/busybox cat default.prop | /tmp/busybox sed s:'ro.secure=1':'ro.secure=0':g > default.prop.new
mv default.prop.new default.prop
/tmp/busybox cat init.p3.rc | /tmp/busybox sed s:'# Power management settings':'':g | /tmp/busybox sed s:'write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor interactive':'':g | /tmp/busybox sed s:'write /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor interactive':'':g | /tmp/busybox sed s:'write /sys/devices/system/cpu/cpufreq/interactive/go_maxspeed_load 80':'':g | /tmp/busybox sed s:'write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 216000':'':g | /tmp/busybox sed s:'write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1000000':'':g | /tmp/busybox sed s:'write /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq 216000':'':g | /tmp/busybox sed s:'write /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq 1000000':'':g | /tmp/busybox sed s:'chmod 664 /sys/class/sensors/accelerometer_sensor/calibration':'':g | /tmp/busybox sed s:'chown system system /sys/class/sensors/accelerometer_sensor/calibration':'':g > init.p3.rc.new
mv init.p3.rc.new init.p3.rc
/tmp/busybox find . | /tmp/busybox cpio -o -H newc | /tmp/busybox gzip > ../ramdisk.gz
cd ../
rm -r ramdisk modules
"
