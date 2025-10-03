import 'dart:convert';
import 'dart:io';
import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class RateEventSheet extends StatefulWidget {
  final int eventId;
  final String eventName;

  // ⬅️ مهم: الآن ترجع String (مسار الملف)
  final Future<String> Function(int eventId) onDownloadTemplate;
  final Future<String?> Function() onPickFile;
  final Future<void> Function(int eventId, String filePath) onUploadFile;

  final BuildContext rootContext;

  const RateEventSheet({
    super.key,
    required this.eventId,
    required this.eventName,
    required this.onDownloadTemplate,
    required this.onPickFile,
    required this.onUploadFile,
    required this.rootContext,
  });

  @override
  State<RateEventSheet> createState() => _RateEventSheetState();
}

class _RateEventSheetState extends State<RateEventSheet> {
  bool _downloading = false;
  bool _uploading = false;
  String? _pickedFilePath;
  String? _error;

  Future<void> _handleDownload() async {
    setState(() {
      _error = null;
      _downloading = true;
    });

    try {
      // 1) نزّل الملف واحصل على مساره
      final String filePath = await widget.onDownloadTemplate(widget.eventId);

      // 2) افتحه مباشرة
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        throw Exception('تعذّر فتح الملف: ${result.message}');
      }

      // 3) أغلق الشيت بعد الفتح
      if (mounted) Navigator.of(context).pop();

      // (اختياري) رسالة نجاح
      ScaffoldMessenger.of(widget.rootContext).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primary,
          content: Text(
            'تم تنزيل وفتح الملف',
            textDirection: TextDirection.rtl,
            style: GoogleFonts.almarai(),
          ),
        ),
      );
    } catch (e) {
      setState(() => _error = 'فشل تحميل أو فتح الملف.');
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  Future<String> _bytesToTempFile(String suggestedName, List<int> bytes) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$suggestedName');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  Future<void> _handlePick() async {
    setState(() => _error = null);
    try {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        withData: true,
        allowMultiple: false,
        dialogTitle: 'اختر ملف التقييم',
      );

      if (!mounted) return;
      if (res == null || res.files.isEmpty) return;

      final f = res.files.single;
      String? path = f.path;

      if (path == null && f.bytes != null) {
        path = await _bytesToTempFile(
          f.name.isNotEmpty ? f.name : 'report.xlsx',
          f.bytes!,
        );
      }

      setState(() => _pickedFilePath = path);

      if (path != null) {
        ScaffoldMessenger.of(widget.rootContext).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.primary,
            content: Text(
              'تم اختيار: ${path.split('/').last}',
              textDirection: TextDirection.rtl,
              style: GoogleFonts.almarai(),
            ),
          ),
        );
      } else {
        setState(() => _error = 'تعذّر الوصول لمسار الملف. حاول مجددًا.');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _handleUpload() async {
    if (_pickedFilePath == null || _pickedFilePath!.isEmpty) {
      ScaffoldMessenger.of(widget.rootContext).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primary,
          content: Text(
            'اختر ملف التقييم أولًا',
            textDirection: TextDirection.rtl,
            style: GoogleFonts.almarai(),
          ),
        ),
      );
      return;
    }
    setState(() {
      _error = null;
      _uploading = true;
    });
    try {
      await widget.onUploadFile(widget.eventId, _pickedFilePath!);

      ScaffoldMessenger.of(widget.rootContext).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primary,
          content: Text(
            'تم رفع الملف وتقييم الفعالية',
            textDirection: TextDirection.rtl,
            style: GoogleFonts.almarai(),
          ),
        ),
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      final msg = _extractServerMessage(e);
      // حالة "تم التقييم مسبقاً" من السيرفر
      if (msg.contains('تم التقييم') || msg.contains('مسبق')) {
        ScaffoldMessenger.of(widget.rootContext).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.primary,
            content: Text(
              msg, // مثال: "لقد تم التقييم مسبقاً"
              textDirection: TextDirection.rtl,
              style: GoogleFonts.almarai(),
            ),
          ),
        );
        if (mounted) Navigator.pop(context); // نقفل الشيت بلطف
      } else {
        // أخطاء أخرى: نعرضها داخل الشيت
        setState(() => _error = msg);
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 12,
          left: 16,
          right: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'تقييم الفعالية',
              style: GoogleFonts.almarai(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.eventName,
              style: GoogleFonts.almarai(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _downloading ? null : _handleDownload,
                icon: _downloading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.download_rounded),
                label: Text(
                  'تحميل ملف التقييم (Excel)',
                  style: GoogleFonts.almarai(),
                ),
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _handlePick,
                icon: const Icon(Icons.attach_file),
                label: Text(
                  _pickedFilePath == null
                      ? 'اختر ملفًا من جهازك'
                      : _pickedFilePath!.split('/').last,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.almarai(),
                ),
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _uploading ? null : _handleUpload,
                icon: _uploading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.upload_rounded),
                label: Text('رفع الملف', style: GoogleFonts.almarai()),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ),

            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: GoogleFonts.almarai(color: Colors.red)),
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  String _extractServerMessage(Object e) {
    try {
      final s = e
          .toString(); // مثال: POST multipart failed [400]: {"message":"...","errors":["..."]}
      final i = s.indexOf('{');
      if (i != -1) {
        final Map<String, dynamic> m = jsonDecode(s.substring(i));
        final msg =
            (m['message'] as String?) ??
            (m['errors'] is List ? (m['errors'] as List).join('\n') : null);
        if (msg != null && msg.isNotEmpty) return msg;
      }
      return s;
    } catch (_) {
      return e.toString();
    }
  }
}

Future<void> showRateEventSheet({
  required BuildContext context,
  required int eventId,
  required String eventName,
  required Future<String> Function(int eventId)
  onDownloadTemplate, // ⬅️ هنا أيضًا String
  required Future<String?> Function() onPickFile,
  required Future<void> Function(int eventId, String filePath) onUploadFile,
}) {
  final rootContext = context;

  return showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.secondaryWhite,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => RateEventSheet(
      eventId: eventId,
      eventName: eventName,
      onDownloadTemplate: onDownloadTemplate,
      onPickFile: onPickFile,
      onUploadFile: onUploadFile,
      rootContext: rootContext,
    ),
  );
}
