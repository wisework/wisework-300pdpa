import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ConsentForm extends StatelessWidget {
  const ConsentForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ConsentListView extends StatelessWidget {
  const ConsentListView({
    Key? key,
    required this.consents,
  }) : super(key: key);

  final List<ConsentForm> consents;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RefreshIndicator(
          onRefresh: () async {
            const Duration(seconds: 1);
            print("Refresh Successfully");
          },
          child: consents.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: consents.length,
                    itemBuilder: (_, index) {
                      return ConsentFormCard(context: context);
                    },
                  ),
                )
              : const ConsentFormExample(),
        ),
      ],
    );
  }
}

class ConsentFormCard extends StatelessWidget {
  const ConsentFormCard({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  // if (consent.consentId.isNotEmpty &&
                  //     consent.companyId != null) {
                  //   await Navigator.pushNamed(
                  //     context,
                  //     AppRoutes
                  //         .consentManagement.generalConsent
                  //         .detail(
                  //       consent.consentId,
                  //     ),
                  //   ).then((result) {
                  //     if (result != null) {
                  //       final isCreated = result as bool;
                  //       if (isCreated) {
                  //         context.read<GeneralConsentBloc>().add(
                  //             const GeneralConsentInitialized());
                  //       }
                  //     }
                  //   });
                  // }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "example test",
                            //consent.title.toString(),
                            style: Theme.of(context).textTheme.button?.copyWith(
                                height: 1.6,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: Text(
                            "11/11/1111",
                            // Convert.toDate(
                            //   consent.updatedDate,
                            //   "dd.MM.yy",
                            // ),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 1,
                      // consent.purposeCategories.length,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            top: 2.0,
                          ),
                          // consent.purposeCategories
                          //             .first ==
                          //         consent.purposeCategories[
                          //             index]
                          //     ? 2.0
                          //     : 8.0),
                          child: Text(
                            "test categories",
                            // consent.purposeCategories[index]
                            //     .title
                            //     .toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(
                                    height: 1.6,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 5.0),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                child: Divider(
                  color: Theme.of(context).colorScheme.outline,
                  thickness: 0.3,
                ),
              ),
            ],
          )),
    );
  }
}

class ConsentFormExample extends StatelessWidget {
  const ConsentFormExample({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "General consent form",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              Text(
                "A consent to collect user’s data",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Image.asset(
                      "assets/images/general-consent-example.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Text(
                "According to the act 23 and 26 of the PDPA law suit, if you collect customer/user’s data, you need to defind the following",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              const SizedBox(height: 25.0),
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () async {
                    // await Navigator.pushNamed(
                    //   context,
                    //   AppRoutes.consentManagement.generalConsent
                    //       .create(),
                    // ).then((result) {
                    //   if (result != null) {
                    //     final isCreated = result as bool;
                    //     if (isCreated) {
                    //       context
                    //           .read<GeneralConsentBloc>()
                    //           .add(const GeneralConsentInitialized());
                    //     }
                    //   }
                    // });
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<
                          RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  )),
                  child: Text("Create general consent",
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .button
                          ?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondary)),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
