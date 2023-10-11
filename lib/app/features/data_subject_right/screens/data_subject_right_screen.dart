import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdpa/app/features/data_subject_right/routes/data_subject_right_route.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class DSRScreen extends StatefulWidget {
  const DSRScreen({super.key});

  @override
  State<DSRScreen> createState() => _DSRScreenState();
}

class _DSRScreenState extends State<DSRScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PdpaAppBar(
        title: Text('DSR'),
      ),
      body: const CustomContainer(
        child: Text('TEST'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(DataSubjectRightRouter.start.path);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
