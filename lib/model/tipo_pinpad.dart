library clisitef;

enum TipoPinPad {
  auto('ANDROID_AUTO'),
  usb('ANDROID_USB'),
  bluetooth('ANDROID_BT');

  const TipoPinPad(this.value);
  final String value;
}
