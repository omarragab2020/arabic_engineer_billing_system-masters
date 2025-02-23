# bin/sh -
result=${PWD##*/}
appName=${result:-/}

./clean.sh
flutter build appbundle --release

if ! [ -d "outputs" ]; then
  mkdir -p outputs
fi

filename="${appName}_$(date +%m-%d_%H-%M).aab"
cp build/app/outputs/bundle/release/app-release.aab "outputs/$filename"

explorer.exe "outputs"
echo " ($filename) is generated. Press any key to continue"
  # shellcheck disable=SC2160
  while [ true ] ; do
    # shellcheck disable=SC2162
    read -t 3 -n 1
    # shellcheck disable=SC2181
    if [ $? = 0 ] ; then
      break ;
    fi
  done
