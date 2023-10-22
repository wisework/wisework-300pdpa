import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/data/models/consent_management/user_consent_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class ConsentApi {
  const ConsentApi(this._firestore);

  final FirebaseFirestore _firestore;

  //? Consenst Form
  Future<List<ConsentFormModel>> getConsentForms(String companyId) async {
    final result =
        await _firestore.collection('Companies/$companyId/ConsentForms').get();

    List<ConsentFormModel> consentForms = [];
    for (var document in result.docs) {
      DataMap response = document.data();
      response['id'] = document.id;

      final purposeCategories = (response['purposeCategories'] as DataMap)
          .entries
          .map(
            (entry) => {
              'id': entry.key,
              ...PurposeCategoryModel.empty()
                  .copyWith(priority: entry.value)
                  .toMap(),
            },
          )
          .toList();
      response['purposeCategories'] = purposeCategories;

      consentForms.add(ConsentFormModel.fromMap(response));
    }

    return consentForms;
  }

  Future<ConsentFormModel?> getConsentFormById(
    String consentFormId,
    String companyId,
  ) async {
    final result = await _firestore
        .collection('Companies/$companyId/ConsentForms')
        .doc(consentFormId)
        .get();

    if (!result.exists) return null;

    DataMap response = result.data()!;
    response['id'] = result.id;

    final purposeCategories = (response['purposeCategories'] as DataMap)
        .entries
        .map(
          (entry) => {
            'id': entry.key,
            ...PurposeCategoryModel.empty()
                .copyWith(priority: entry.value)
                .toMap(),
          },
        )
        .toList();
    response['purposeCategories'] = purposeCategories;

    return ConsentFormModel.fromMap(response);
  }

  Future<ConsentFormModel> createConsentForm(
    ConsentFormModel consentForm,
    String companyId,
  ) async {
    final ref =
        _firestore.collection('Companies/$companyId/ConsentForms').doc();
    final created = consentForm.copyWith(id: ref.id);

    await ref.set(created.toMap());

    return created;
  }

  Future<void> updateConsentForm(
    ConsentFormModel consentForm,
    String companyId,
  ) async {
    await _firestore
        .collection('Companies/$companyId/ConsentForms')
        .doc(consentForm.id)
        .set(consentForm.toMap());
  }

  //? Consenst Theme
  Future<List<ConsentThemeModel>> getConsentThemes(String companyId) async {
    final result =
        await _firestore.collection('Companies/$companyId/ConsentThemes').get();

    List<ConsentThemeModel> consentThemes = [];
    for (var document in result.docs) {
      consentThemes.add(ConsentThemeModel.fromDocument(document));
    }

    return consentThemes;
  }

  Future<ConsentThemeModel?> getConsentThemeById(
    String consentThemeId,
    String companyId,
  ) async {
    final result = await _firestore
        .collection('Companies/$companyId/ConsentThemes')
        .doc(consentThemeId)
        .get();

    if (!result.exists) return null;
    return ConsentThemeModel.fromDocument(result);
  }

  Future<ConsentThemeModel> createConsentTheme(
    ConsentThemeModel consentTheme,
    String companyId,
  ) async {
    final ref =
        _firestore.collection('Companies/$companyId/ConsentThemes').doc();
    final created = consentTheme.copyWith(id: ref.id);

    await ref.set(created.toMap());

    return created;
  }

  Future<void> updateConsentTheme(
    ConsentThemeModel consentTheme,
    String companyId,
  ) async {
    await _firestore
        .collection('Companies/$companyId/ConsentThemes')
        .doc(consentTheme.id)
        .set(consentTheme.toMap());
  }

  Future<void> deleteConsentTheme(
    String consentThemeId,
    String companyId,
  ) async {
    if (consentThemeId.isNotEmpty) {
      await _firestore
          .collection('Companies/$companyId/ConsentThemes')
          .doc(consentThemeId)
          .delete();
    }
  }

  //? User consent
  Future<List<UserConsentModel>> getUserConsents(String companyId) async {
    final result =
        await _firestore.collection('Companies/$companyId/UserConsents').get();

    List<UserConsentModel> userConsents = [];
    for (var document in result.docs) {
      userConsents.add(UserConsentModel.fromDocument(document));
    }

    return userConsents;
  }

  Future<UserConsentModel?> getUserConsentById(
    String userConsentId,
    String companyId,
  ) async {
    final result = await _firestore
        .collection('Companies/$companyId/UserConsents')
        .doc(userConsentId)
        .get();

    if (!result.exists) return null;
    return UserConsentModel.fromDocument(result);
  }

  Future<UserConsentModel> createUserConsent(
    UserConsentModel userConsent,
    String companyId,
  ) async {
    final ref =
        _firestore.collection('Companies/$companyId/UserConsents').doc();
    final created = userConsent.copyWith(id: ref.id);

    await ref.set(created.toMap());

    return created;
  }

  Future<void> updateUserConsent(
    UserConsentModel userConsent,
    String companyId,
  ) async {
    await _firestore
        .collection('Companies/$companyId/UserConsents')
        .doc(userConsent.consentFormId)
        .set(userConsent.toMap());
  }
}
