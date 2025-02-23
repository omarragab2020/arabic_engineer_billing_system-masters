

if [ -d "build" ]; then
  rm -rf build
fi

flutter clean


cd ios || exit
#xcodebuild clean
rm -rf Pods
rm -rf .symlinks
rm -rf Flutter/Flutter.framework
rm -rf Flutter/Flutter.podspec
rm -rf Podfile.lock

flutter pub get
flutter pub upgrade
pod install

# Navigate back to the root project directory
cd ..