class ProcessRequestLoadingStatus {
  const ProcessRequestLoadingStatus({
    required this.verifyingForm,
    required this.consideringRequest,
    required this.processingRequest,
  });

  static const initial = ProcessRequestLoadingStatus(
    verifyingForm: false,
    consideringRequest: '',
    processingRequest: '',
  );

  final bool verifyingForm;
  final String consideringRequest;
  final String processingRequest;

  ProcessRequestLoadingStatus copyWith({
    bool? verifyingForm,
    String? consideringRequest,
    String? processingRequest,
  }) {
    return ProcessRequestLoadingStatus(
      verifyingForm: verifyingForm ?? this.verifyingForm,
      consideringRequest: consideringRequest ?? this.consideringRequest,
      processingRequest: processingRequest ?? this.processingRequest,
    );
  }
}
