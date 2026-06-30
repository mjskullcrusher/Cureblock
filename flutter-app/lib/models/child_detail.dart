class ChildDetail {
 final String id;
 final String name;
 final int age;
 final String gender;
 final String status;
 final String? externalSubjectId;
 final String? enrolmentCenter;
 final bool safe;
 final List<GuardianItem> guardians;
 final List<FingerprintItem> fingerprints;
 final AadhaarItem? aadhaar;
 final BlockchainItem? blockchain;

 ChildDetail({
 required this.id,
 required this.name,
 required this.age,
 required this.gender,
 required this.status,
 this.externalSubjectId,
 this.enrolmentCenter,
 required this.safe,
 required this.guardians,
 required this.fingerprints,
 this.aadhaar,
 this.blockchain,
 });

 factory ChildDetail.fromJson(Map<String, dynamic> json) {
 return ChildDetail(
 id: json['id'] as String,
 name: json['name'] as String? ?? 'Unknown',
 age: json['age'] as int? ?? 0,
 gender: json['gender'] as String? ?? '',
 status: json['status'] as String? ?? '',
 externalSubjectId: json['externalSubjectId'] as String?,
 enrolmentCenter: json['enrolmentCenter'] as String?,
 safe: json['safe'] as bool? ?? true,
 guardians: (json['guardians'] as List<dynamic>? ?? [])
 .map((e) => GuardianItem.fromJson(e as Map<String, dynamic>))
 .toList(),
 fingerprints: (json['fingerprints'] as List<dynamic>? ?? [])
 .map((e) => FingerprintItem.fromJson(e as Map<String, dynamic>))
 .toList(),
 aadhaar: json['aadhaar'] != null
 ? AadhaarItem.fromJson(json['aadhaar'] as Map<String, dynamic>)
 : null,
 blockchain: json['blockchain'] != null
 ? BlockchainItem.fromJson(json['blockchain'] as Map<String, dynamic>)
 : null,
 );
 }
}

class GuardianItem {
 final String name;
 final String relationship;
 final String phone;
 final String accessLevel;
 GuardianItem({required this.name, required this.relationship, required this.phone, required this.accessLevel});
 factory GuardianItem.fromJson(Map<String, dynamic> j) => GuardianItem(
 name: j['name'] as String? ?? '',
 relationship: j['relationship'] as String? ?? '',
 phone: j['phone'] as String? ?? '',
 accessLevel: j['accessLevel'] as String? ?? '',
 );
}

class FingerprintItem {
 final String hand;
 final String finger;
 final String? ipfsCid;
 final String? sha256Hash;
 final int qualityPercent;
 FingerprintItem({required this.hand, required this.finger, this.ipfsCid, this.sha256Hash, required this.qualityPercent});
 factory FingerprintItem.fromJson(Map<String, dynamic> j) => FingerprintItem(
 hand: j['hand'] as String? ?? '',
 finger: j['finger'] as String? ?? '',
 ipfsCid: j['ipfsCid'] as String?,
 sha256Hash: j['sha256Hash'] as String?,
 qualityPercent: j['qualityPercent'] as int? ?? 0,
 );
}

class AadhaarItem {
 final String aadhaarToken;
 final String status;
 AadhaarItem({required this.aadhaarToken, required this.status});
 factory AadhaarItem.fromJson(Map<String, dynamic> j) => AadhaarItem(
 aadhaarToken: j['aadhaarToken'] as String? ?? '',
 status: j['status'] as String? ?? '',
 );
}

class BlockchainItem {
 final String transactionId;
 final String anchoredHash;
 final bool verified;
 BlockchainItem({required this.transactionId, required this.anchoredHash, required this.verified});
 factory BlockchainItem.fromJson(Map<String, dynamic> j) => BlockchainItem(
 transactionId: j['transactionId'] as String? ?? '',
 anchoredHash: j['anchoredHash'] as String? ?? '',
 verified: j['verified'] as bool? ?? false,
 );
}