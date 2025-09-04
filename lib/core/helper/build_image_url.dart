class BuildImageUrl {
  /// يبني رابط صالح للصورة، ويقصّ أي بادئة قبل /storage/
  static String normalize(String? raw, String baseUrl) {
    if (raw == null) return '';
    var s = raw.trim();
    if (s.isEmpty || s.toLowerCase() == 'null') return '';

    // إن وجدنا /storage/ في أي مكان، نقصّ كل ما قبله
    final i = s.indexOf('/storage/');
    if (i >= 0) {
      s = s.substring(i); // يبدأ بـ /storage/attachments/...
    }

    // استخرج origin من baseUrl (schema + host + port)
    final base = Uri.parse(baseUrl);
    final origin =
        '${base.scheme}://${base.host}${base.hasPort ? ':${base.port}' : ''}';

    // لو s نسبي (ما فيه http/https) أضيف origin
    final hasProto = s.startsWith('http://') || s.startsWith('https://');
    if (!hasProto) {
      if (!s.startsWith('/')) s = '/$s';
      s = '$origin$s';
    }

    // نظّف السلاشات المكررة بدون لمس البروتوكول
    final m = RegExp(r'^(https?:\/\/)').firstMatch(s);
    final proto = m?.group(0) ?? '';
    var rest = s.substring(proto.length).replaceAll(RegExp(r'\/{2,}'), '/');

    return '$proto$rest';
  }
}
