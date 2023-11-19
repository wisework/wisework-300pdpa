import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/form_data_subject_right/form_data_subject_right_cubit.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';

class ReserveTheRightPage extends StatefulWidget {
  const ReserveTheRightPage({
    super.key,
    required this.controller,
    required this.currentPage,
  });

  final PageController controller;
  final int currentPage;

  @override
  State<ReserveTheRightPage> createState() => _ReserveTheRightPageState();
}

class _ReserveTheRightPageState extends State<ReserveTheRightPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: CustomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: UiConfig.lineSpacing),
                  Text(
                    'ข้อสงวนสิทธิของผู้ควบคุมข้อมูล', //!
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "บริษัทขอเรียนแจ้งให้ท่านทราบว่า เพื่อให้เป็นไปตามกฎหมายที่"
                          "เกี่ยวข้องบริษัทอาจจำเป็นต้องปฏิเสธคำร้องขอของท่าน "
                          "ในบางกรณี ซึ่งรวมถึงแต่ไม่จำกัดเพียงกรณีดังต่อไปนี้", //!
                          textAlign: TextAlign.left,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "1. ท่านไม่สามารถแสดงให้เห็นอย่างชัดเจนได้ว่าผู้ยื่นคำร้อง"
                          "เป็นเจ้าของข้อมูลส่วนบุคคลหรือมีอำนาจในการยื่นคำร้องขอดังกล่าว\n"
                          "2. คำร้องขอดังกล่าวไม่สมเหตุสมผล เช่น กรณีที่ผู้ร้อง\n"
                          "ขอไม่มีสิทธิในการขอเข้าถึงข้อมูลส่วนบุคคลหรือไม่มีข้อมูลส่วนบุคคลนั้นอยู่ที่บริษัท เป็นต้น\n"
                          "3. คำร้องขอดังกล่าวเป็นคำร้องขอฟุ่มเฟือย เช่น เป็นคำร้อง"
                          "ขอที่มีลักษณะเดียวกัน หรือ มีเนื้อหาเดียวกันซ้ำ ๆ กันโดยไม่มีเหตุอันสมควร\n"
                          "4. การเก็บรักษาข้อมูลส่วนบุคคลนั้นเป็นไปเพื่อการก่อตั้งสิทธิเรียกร้องตามกฎหมาย "
                          "การปฏิบัติตามกฎหมายการใช้สิทธิเรียกร้องตามกฎหมาย หรือการยกขึ้นต่อสู้"
                          "สิทธิเรียกร้องตามกฎหมาย\n", //!
                          textAlign: TextAlign.left,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        ContentWrapper(
          child: Container(
            padding: const EdgeInsets.all(
              UiConfig.defaultPaddingSpacing,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.outline,
                  blurRadius: 1.0,
                  offset: const Offset(0, -2.0),
                ),
              ],
            ),
            child: _buildPageViewController(
              context,
              widget.controller,
              widget.currentPage,
            ),
          ),
        ),
      ],
    );
  }

  Row _buildPageViewController(
    BuildContext context,
    PageController controller,
    int currentpage,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          onPressed: previousPage,
          child: Text(
            tr("app.previous"),
          ),
        ),
        Text("$currentpage/7"),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          onPressed: nextPage,
          child: Text(
            tr("app.next"),
          ),
        ),
      ],
    );
  }

  void nextPage() {
    widget.controller.animateToPage(widget.currentPage + 1,
        duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
    context.read<FormDataSubjectRightCubit>().nextPage(widget.currentPage + 1);
  }

  void previousPage() {
    widget.controller.animateToPage(widget.currentPage - 1,
        duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
    context.read<FormDataSubjectRightCubit>().nextPage(widget.currentPage - 1);
  }
}
