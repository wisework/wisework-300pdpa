class ProcessRequestLoadingStatus {
  const ProcessRequestLoadingStatus({
    required this.verifyingForm,
    required this.consideringRequest,
    required this.processingRequest,
    required this.sendingEmail,
  });

  static const initial = ProcessRequestLoadingStatus(
    verifyingForm: false,
    consideringRequest: '',
    processingRequest: '',
    sendingEmail: false,
  );

  final bool verifyingForm;
  final String consideringRequest;
  final String processingRequest;
  final bool sendingEmail;

  ProcessRequestLoadingStatus copyWith({
    bool? verifyingForm,
    String? consideringRequest,
    String? processingRequest,
    bool? sendingEmail,
  }) {
    return ProcessRequestLoadingStatus(
      verifyingForm: verifyingForm ?? this.verifyingForm,
      consideringRequest: consideringRequest ?? this.consideringRequest,
      processingRequest: processingRequest ?? this.processingRequest,
      sendingEmail: sendingEmail ?? this.sendingEmail,
    );
  }
}
