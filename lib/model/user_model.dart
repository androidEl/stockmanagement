class UserDetail {
  final String username;
  final String photoUrl;
  final String email;
  final String providerDetail;
  final List<ProviderDetails> providerData;

  UserDetail(this.username, this.photoUrl, this.email, this.providerDetail,
      this.providerData);
}

class ProviderDetails {
  ProviderDetails(this.providerDetails);
  final String providerDetails;
}
