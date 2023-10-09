import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class EditRejectTypeScreen extends StatelessWidget {
  const EditRejectTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EditRejectTypeView();
  }
}

class EditRejectTypeView extends StatefulWidget {
  const EditRejectTypeView({super.key});

  @override
  State<EditRejectTypeView> createState() => _EditRejectTypeViewState();
}
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
class _EditRejectTypeViewState extends State<EditRejectTypeView> {

void _goBackAndUpdate() {
    context.pop();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(),
        title: Text(
          
              tr('masterData.dsr.rejections.create')
             ,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          _buildSaveButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing),
            CustomContainer(
              child: _buildRejectForm(context),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
         
          ],
        ),
      ),
    );
  }
  CustomIconButton _buildPopButton() {
    return CustomIconButton(
      onPressed: _goBackAndUpdate,
      icon: Ionicons.chevron_back_outline,
      iconColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }
  Builder _buildSaveButton() {
    return Builder(builder: (context) {
      return CustomIconButton(
        icon: Ionicons.save_outline,
        iconColor: Theme.of(context).colorScheme.outlineVariant,
        backgroundColor: Theme.of(context).colorScheme.onBackground,
      );
    });
  }
  Form _buildRejectForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                tr('masterData.dsr.rejections.list'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.dsr.rejections.rejectcode'),
            required: true,
          ),
          CustomTextField(
            hintText: tr('masterData.dsr.rejections.rejectcode'),
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.dsr.rejections.rejectdescription'),
            
          ),
          CustomTextField(
            hintText: tr('masterData.dsr.rejections.rejectdescription'),
            required: true,
          ),
         
          const SizedBox(height: UiConfig.lineSpacing),
        
          
        ],
      ),
    );
  }

}
