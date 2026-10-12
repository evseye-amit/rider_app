import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as img;

const int baseArtColour = 0xFFF475D0;

double hueOf(int argb) => _toHsv(((argb >> 16) & 0xFF) / 255, ((argb >> 8) & 0xFF) / 255, (argb & 0xFF) / 255).h;

bool sameHue(int a, int b) => (_wrap(hueOf(a) - hueOf(b)) * 360).abs() < 1;

Uint8List recolourPng(Uint8List png, {required double fromHue, required double toHue}) {
  final img.Image? decoded = img.decodePng(png);
  if (decoded == null) throw const FormatException('Not a PNG image.');
  final img.Image rgba = decoded.convert(format: img.Format.uint8, numChannels: 4);
  final Uint8List bytes = Uint8List.fromList(rgba.getBytes(order: img.ChannelOrder.rgba));
  final int count = bytes.length ~/ 4;

  final Float64List hues = Float64List(count);
  final Float64List saturations = Float64List(count);
  final Float64List values = Float64List(count);
  final Float64List weights = Float64List(count);
  double sumCos = 0;
  double sumSin = 0;
  bool found = false;

  for (int i = 0; i < count; i++) {
    final int o = i * 4;
    final ({double h, double s, double v}) hsv = _toHsv(bytes[o] / 255, bytes[o + 1] / 255, bytes[o + 2] / 255);
    hues[i] = hsv.h;
    saturations[i] = hsv.s;
    values[i] = hsv.v;
    final double offset = ((hsv.h - fromHue) * 360 + 180) % 360 - 180;
    final double weight = _unit((offset + 49) / 20) * _unit((41 - offset) / 10) * _unit((hsv.s - 0.04) / 0.12);
    weights[i] = weight;
    if (bytes[o + 3] > 51 && weight > 0.5) {
      sumCos += math.cos(2 * math.pi * hsv.h);
      sumSin += math.sin(2 * math.pi * hsv.h);
      found = true;
    }
  }

  final double centre = found ? (math.atan2(sumSin, sumCos) / (2 * math.pi)) % 1.0 : fromHue;
  final double shift = _wrap(toHue - centre);

  for (int i = 0; i < count; i++) {
    final double weight = weights[i];
    if (weight == 0) continue;
    final int o = i * 4;
    final ({double r, double g, double b}) rgb = _toRgb(
      (hues[i] + weight * shift) % 1.0,
      math.min(1, saturations[i] * (1 + 0.12 * weight)),
      values[i],
    );
    bytes[o] = (rgb.r * 255).round();
    bytes[o + 1] = (rgb.g * 255).round();
    bytes[o + 2] = (rgb.b * 255).round();
  }

  return img.encodePng(
    img.Image.fromBytes(
      width: rgba.width,
      height: rgba.height,
      bytes: bytes.buffer,
      numChannels: 4,
      order: img.ChannelOrder.rgba,
    ),
  );
}

double _unit(double value) => value < 0 ? 0 : (value > 1 ? 1 : value);

double _wrap(double turns) => (turns + 0.5) % 1.0 - 0.5;

({double h, double s, double v}) _toHsv(double r, double g, double b) {
  final double top = math.max(r, math.max(g, b));
  final double spread = top - math.min(r, math.min(g, b));
  double h = 0;
  if (spread > 1e-9) {
    final double rc = (top - r) / spread;
    final double gc = (top - g) / spread;
    final double bc = (top - b) / spread;
    h = r == top ? bc - gc : (g == top ? 2 + rc - bc : 4 + gc - rc);
    h = (h / 6) % 1.0;
  }
  return (h: h, s: top > 1e-9 ? spread / top : 0, v: top);
}

({double r, double g, double b}) _toRgb(double h, double s, double v) {
  final int sector = (h * 6).floor() % 6;
  final double f = h * 6 - (h * 6).floor();
  final double p = v * (1 - s);
  final double q = v * (1 - s * f);
  final double t = v * (1 - s * (1 - f));
  return switch (sector) {
    0 => (r: v, g: t, b: p),
    1 => (r: q, g: v, b: p),
    2 => (r: p, g: v, b: t),
    3 => (r: p, g: q, b: v),
    4 => (r: t, g: p, b: v),
    _ => (r: v, g: p, b: q),
  };
}
