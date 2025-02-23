# bin/sh -

result=${PWD##*/}
appName=${result:-/}

./clean.sh
flutter build apk --release

if ! [ -d "outputs" ]; then
  mkdir -p outputs
fi

if [ -f "build/app/outputs/apk/release/app-release.apk" ]; then
  filename="${appName}_$(date +%m-%d_%H-%M).apk"
  cp build/app/outputs/apk/release/app-release.apk "outputs/$filename"
  explorer.exe "outputs"
  echo " ($filename) is generated. Press any key to continue"1
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
