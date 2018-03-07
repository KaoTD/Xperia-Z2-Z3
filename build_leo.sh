### GCC 4.9.x
### I'm using UBERTC https://bitbucket.org/UBERTC/arm-eabi-4.9
export ARCH=arm
export PATH=~/arm-eabi-4.9/bin/:$PATH
### See prefix of file names in the toolchain's bin directory
export CROSS_COMPILE=arm-eabi-

if [ ! -e ./arch/arm/boot/msm8974pro-ac-shinano_leo.dtb ]; then
rm ./arch/arm/boot/*.dtb
fi

### get defconfig
make leo_defconfig

### compile kernel
make -j16

echo "checking for compiled kernel..."
if [ -f arch/arm/boot/zImage ]
then

echo "generating device tree..."
./dtbToolCM --force-v2 -o ./final_files/dt.img -s 2048 -p ./scripts/dtc/ ./arch/arm/boot/

### copy zImage
mkdir -p ./final_files
cp -f ./arch/arm/boot/zImage ./final_files

echo "DONE"

fi

### D6603
./mkbootimg --cmdline "androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x3b7 ehci-hcd.park=3 androidboot.bootdevice=msm_sdcc.1 vmalloc=400M dwc3.maximum_speed=high dwc3_msm.prop_chg_detect=Y androidboot.selinux=permissive" --base 0x00000000 --kernel ./final_files/zImage --ramdisk ./final_files/ramdisk.cpio.gz --ramdisk_offset 0x02000000 -o ./final_files/boot.img --dt ./final_files/dt.img --tags_offset 0x01E00000

