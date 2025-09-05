import 'package:ammerha_management/config/theme/app_theme.dart';
import 'package:ammerha_management/core/models/event.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;
  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  //bool isRegistered = false;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () {},
            ),
          ],
          backgroundColor: AppColors.primary,
          centerTitle: true,
          title: Text(
            widget.event.name,
            style: GoogleFonts.almarai(
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
        body: ListView(
          children: [
            Image(
              image: AssetImage(widget.event.coverImage!.file),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                widget.event.name,
                style: GoogleFonts.almarai(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  fontSize: 25,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                widget.event.description,
                style: GoogleFonts.almarai(
                  fontWeight: FontWeight.normal,
                  color: AppColors.secondaryBlack,
                  fontSize: 20,
                ),
              ),
            ),
            Divider(
              color: Colors.grey.shade200,
              thickness: 0.7,
              height: 20,
              indent: 15,
              endIndent: 15,
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'زمان الفعالية:',
                style: GoogleFonts.almarai(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Row(
                children: [
                  Text(
                    'التاريخ:  ${widget.event.date!.year}/${widget.event.date!.month}/${widget.event.date!.day}',
                    style: TextStyle(
                      color: AppColors.secondaryBlack,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 40),
                  Text(
                    'الوقت:  ${widget.event.date!.hour}:${widget.event.date!.minute}',
                    style: TextStyle(
                      color: AppColors.secondaryBlack,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey.shade200,
              thickness: 0.7,
              height: 20,
              indent: 15,
              endIndent: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Text(
                'عدد المتطوعين',
                style: GoogleFonts.almarai(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
              child: Row(
                children: [
                  Text(
                    'المطلوب:  ',
                    style: GoogleFonts.almarai(
                      fontSize: 16,
                      color: AppColors.secondaryBlack,
                    ),
                  ),
                  Text(
                    '${widget.event.volunteersCount}',
                    style: GoogleFonts.almarai(
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    'عدد المقبولين:  ',
                    style: GoogleFonts.almarai(
                      fontSize: 16,
                      color: AppColors.secondaryBlack,
                    ),
                  ),
                  Text(
                    '${widget.event.acceptedCount}',
                    style: GoogleFonts.almarai(fontSize: 16, color: Colors.red),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey.shade200,
              thickness: 0.7,
              height: 20,
              indent: 15,
              endIndent: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'مكان الفعالية:',
                style: GoogleFonts.almarai(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Text(
                widget.event.location!,
                style: TextStyle(color: AppColors.secondaryBlack, fontSize: 16),
              ),
            ),
            Divider(
              color: Colors.grey.shade200,
              thickness: 0.7,
              height: 20,
              indent: 15,
              endIndent: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),

              child: Text(
                'عدد الساعات التطوعية:',
                style: GoogleFonts.almarai(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Row(
                children: [
                  Text(
                    'عدد الساعات الأعلى: ${widget.event.maxHours}',
                    style: GoogleFonts.almarai(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: AppColors.secondaryBlack,
                    ),
                  ),
                  SizedBox(width: 40),
                  Text(
                    'عدد الساعات الأدنى: ${widget.event.minHours}',
                    style: GoogleFonts.almarai(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: AppColors.secondaryBlack,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey.shade200,
              thickness: 0.7,
              height: 20,
              indent: 15,
              endIndent: 15,
            ),
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: Center(
            //     child: Text(
            //       'المشرف على الفعالية:${widget.event.leader}',
            //       style: GoogleFonts.almarai(
            //         fontWeight: FontWeight.bold,
            //         fontSize: 15,
            //         color: AppColors.primary,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
