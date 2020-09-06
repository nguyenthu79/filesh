#!/bin/bash
APK_PATH=$1
DEVICE_FILE="adroid-devices.txt"

runTest() {
    DEVICE=$1;
    echo $DEVICE;
    echo "Install in device: $DEVICE with apk url: $APK_PATH";
    adb -s $DEVICE install $APK_PATH;
    echo "Run automation test on device: $DEVICE";
    clean verify allure:report -P fastCompilation -Dbrowser=Android -DdeviceName=${DEVICE}
}

declare -a A_DEVICES
let i=0
adb devices > $DEVICE_FILE
while read line #get devices list
  do
    if [ -n "$line" ] && [ "`echo $line | awk '{print $2}'`" == "device" ]
    then
      device="`echo $line | awk '{print $1}'`"
      echo "Add $device"
      A_DEVICES[i]="$device" # $ is optional
      let i=$i+1
    fi
  done < $DEVICE_FILE


echo "List of devices: ${A_DEVICES[*]}";
runTest "${A_DEVICES[0]}"
rm -rf DEVICE_FILE
