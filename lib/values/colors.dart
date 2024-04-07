import 'dart:ui';

class AppColors {
  static const Color primayBackground = Color.fromARGB(255, 255, 255, 255);

  static const Color primaySecondBackground =
      Color.fromARGB(255, 247, 247, 249);

  static Color primaryElement = HexColor("#15113e");
  static Color secondElement = HexColor("#3b75ba");
  static Color brown900 = const Color(0xFF442B2D);
  static Color surfaceWhite = const Color(0xFFFFFBFA);
  static Color errorRed = const Color(0xFFC5032B);
  static const Color primaryText = Color.fromARGB(255, 32, 47, 62);
  static const Color primaryElementText = Color.fromARGB(255, 255, 255, 255);
  static const Color blue = Color.fromARGB(255, 54, 127, 169);
}

class HexColor extends Color {
  static int _getColor(String hex) {
    // ignore: prefer_interpolation_to_compose_strings
    String formattedHex = "FF" + hex.toUpperCase().replaceAll("#", "");
    return int.parse(formattedHex, radix: 16);
  }

  HexColor(final String hex) : super(_getColor(hex));
}
