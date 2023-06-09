import 'package:flutter/material.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/src/topics/webservices/report_service.dart';

class ReportAlert extends StatefulWidget {
  const ReportAlert(
      {Key? key,
      required this.reported,
      required this.reporter,
      required this.collection})
      : super(key: key);
  final String? reporter;
  final String? reported;
  final String collection;

  @override
  State<ReportAlert> createState() => _ReportAlertState();
}

class _ReportAlertState extends State<ReportAlert> {
  List<dynamic>? dataList;
  List<dynamic> isSelectedList = [];
  List reasons = [];

  bool dataLoaded = false;
  ReportService service = ReportService();

  @override
  void initState() {
    super.initState();
    waitForData();
  }

  Future<void> waitForData() async {
    if (!dataLoaded) {
      Map<String, List>? myData = await service.getReportReasons(
        dataList,
        isSelectedList,
      );
      dataList = myData!['data'];
      isSelectedList = myData['isSelected']!;

      if (mounted) {
        setState(() {
          dataLoaded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Report this topic',
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        height: 300,
        width: 300,
        child: dataLoaded
            ? ListView.separated(
                shrinkWrap: true,
                itemCount: dataList!.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final isSelected = isSelectedList[index];
                  final myColor = isSelected ? myBlue1 : Colors.black87;
                  final myBorderColor =
                      isSelected ? myBlue1 : Colors.transparent;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        isSelectedList[index] = !isSelected;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: myBorderColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          dataList![index],
                          style: TextStyle(color: myColor),
                        ),
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () async {
              for (int i = 0; i < isSelectedList.length; i++) {
                if (isSelectedList[i]) {
                  reasons.add(dataList![i]);
                }
              }
              await service.sendReport(
                  context: context,
                  reasons: reasons,
                  reported: widget.reported,
                  reporter: widget.reporter,
                  collection: widget.collection);
            },
            style: ElevatedButton.styleFrom(backgroundColor: myBlue2),
            child: const Text('Send report'),
          ),
        ),
      ],
    );
  }
}
