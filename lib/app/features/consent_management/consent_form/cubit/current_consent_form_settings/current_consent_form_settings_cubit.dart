import 'dart:io';
import 'dart:typed_data';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/data/repositories/general_repository.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/functions.dart';

part 'current_consent_form_settings_state.dart';

class CurrentConsentFormSettingsCubit
    extends Cubit<CurrentConsentFormSettingsState> {
  CurrentConsentFormSettingsCubit({
    required GeneralRepository generalRepository,
  })  : _generalRepository = generalRepository,
        super(CurrentConsentFormSettingsState(
          settingTabs: 0,
          consentForm: ConsentFormModel.empty(),
          consentTheme: ConsentThemeModel.initial(),
          logoImages: const [],
          headerImages: const [],
          bodyImages: const [],
        ));

  final GeneralRepository _generalRepository;

  Future<void> initialSettings(
    ConsentFormModel consentForm,
    ConsentThemeModel consentTheme,
    String companyId,
  ) async {
    emit(
      state.copyWith(
        consentForm: consentForm,
        consentTheme: consentTheme,
      ),
    );

    final logoPath = UtilFunctions.getConsentImagePath(
      companyId,
      consentForm.id,
      ConsentFormImageType.logo,
    );
    final logoResult = await _generalRepository.getImages(logoPath);
    logoResult.fold(
      (_) {},
      (images) => emit(state.copyWith(logoImages: images)),
    );

    final headerPath = UtilFunctions.getConsentImagePath(
      companyId,
      consentForm.id,
      ConsentFormImageType.header,
    );
    final headerResult = await _generalRepository.getImages(headerPath);
    headerResult.fold(
      (_) {},
      (images) => emit(state.copyWith(headerImages: images)),
    );

    final bodyPath = UtilFunctions.getConsentImagePath(
      companyId,
      consentForm.id,
      ConsentFormImageType.body,
    );
    final bodyResult = await _generalRepository.getImages(bodyPath);
    bodyResult.fold(
      (_) {},
      (images) => emit(state.copyWith(bodyImages: images)),
    );
  }

  void setSettingTab(int tabIndex) {
    emit(state.copyWith(settingTabs: tabIndex));
  }

  void setConsentForm(ConsentFormModel consentForm) {
    emit(state.copyWith(consentForm: consentForm));
  }

  void setConsentTheme(ConsentThemeModel consentTheme) {
    emit(state.copyWith(
      consentForm: state.consentForm.copyWith(
        consentThemeId: consentTheme.id,
      ),
      consentTheme: consentTheme,
    ));
  }

  Future<void> generateConsentFormUrl(String longUrl) async {
    final result = await _generalRepository.generateShortUrl(longUrl);

    result.fold(
      (failure) {},
      (shortUrl) {
        final updated = state.consentForm.copyWith(
          consentFormUrl: shortUrl,
        );

        emit(state.copyWith(consentForm: updated));
      },
    );
  }

  Future<void> uploadConsentImage(
    File? file,
    Uint8List? data,
    String fileName,
    String path,
    ConsentFormImageType imageType,
  ) async {
    final result = await _generalRepository.uploadFile(
      file,
      data,
      fileName,
      path,
    );

    result.fold(
      (failure) {},
      (imageUrl) {
        ConsentFormModel consentForm = state.consentForm;

        switch (imageType) {
          case ConsentFormImageType.logo:
            consentForm = consentForm.copyWith(logoImage: imageUrl);
            final logoImages = state.logoImages.map((url) => url).toList()
              ..add(imageUrl);

            emit(
              state.copyWith(
                consentForm: consentForm,
                logoImages: logoImages,
              ),
            );
            break;
          case ConsentFormImageType.header:
            consentForm = consentForm.copyWith(headerBackgroundImage: imageUrl);
            final headerImages = state.headerImages.map((url) => url).toList()
              ..add(imageUrl);

            emit(
              state.copyWith(
                consentForm: consentForm,
                headerImages: headerImages,
              ),
            );
            break;
          case ConsentFormImageType.body:
            consentForm = consentForm.copyWith(bodyBackgroundImage: imageUrl);
            final bodyImages = state.bodyImages.map((url) => url).toList()
              ..add(imageUrl);

            emit(
              state.copyWith(
                consentForm: consentForm,
                bodyImages: bodyImages,
              ),
            );
            break;
        }
      },
    );
  }

  Future<void> setConsentImage(
    String imageUrl,
    ConsentFormImageType imageType,
  ) async {
    ConsentFormModel consentForm = state.consentForm;

    switch (imageType) {
      case ConsentFormImageType.logo:
        consentForm = consentForm.copyWith(logoImage: imageUrl);
        break;
      case ConsentFormImageType.header:
        consentForm = consentForm.copyWith(headerBackgroundImage: imageUrl);
        break;
      case ConsentFormImageType.body:
        consentForm = consentForm.copyWith(bodyBackgroundImage: imageUrl);
        break;
    }

    emit(state.copyWith(consentForm: consentForm));
  }

  Future<void> removeConsentImage(
    ConsentFormImageType imageType,
  ) async {
    ConsentFormModel consentForm = state.consentForm;

    switch (imageType) {
      case ConsentFormImageType.logo:
        consentForm = consentForm.copyWith(logoImage: '');
        break;
      case ConsentFormImageType.header:
        consentForm = consentForm.copyWith(headerBackgroundImage: '');
        break;
      case ConsentFormImageType.body:
        consentForm = consentForm.copyWith(bodyBackgroundImage: '');
        break;
    }

    emit(state.copyWith(consentForm: consentForm));
  }
}
