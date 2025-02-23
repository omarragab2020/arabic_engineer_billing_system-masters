# bin/sh -

result=${PWD##*/}
appName=${result:-/}

#./clean.sh
flutter build apk --release --split-per-abi

# shellcheck disable=SC2154
curDate=$(date +%m-%d_%H-%M)
if ! [ -d "outputs" ]; then
  mkdir -p outputs
fi


if [ -f "build/app/outputs/apk/release/app-armeabi-v7a-release.apk" ]; then
  if ! [ -d "outputs/$curDate" ]; then
    mkdir -p "outputs/$curDate"
  fi

#  filename1="${appName}_${curDate}_armeabi-v7a.apk"
  filename2="${appName}_${curDate}_arm64-v8a.apk"
#  filename3="${appName}_${curDate}_x86_64.apk"

#  cp build/app/outputs/apk/release/app-armeabi-v7a-release.apk "outputs/$curDate/$filename1"
  cp build/app/outputs/apk/release/app-arm64-v8a-release.apk "outputs/$curDate/$filename2"
#  cp build/app/outputs/apk/release/app-x86_64-release.apk "outputs/$curDate/$filename3"

  explorer.exe "outputs\\$curDate"
  echo " (Files) are generated. Press any key to continue"
else
  echo "Not generated. Press any key to continue"
fi
# shellcheck disable=SC2160
while [ true ] ; do
    # shellcheck disable=SC2162
    read -t 3 -n 1
    # shellcheck disable=SC2181
    if [ $? = 0 ] ; then
      break ;
    fi
  done
