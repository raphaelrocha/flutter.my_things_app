class User {
  final String photoURL;
  final String displayName;
  final String firestoreUid;
  final String userName;
  final String plan;
  final int updatedAt;
  final List<int> products;
  final String firebaseUid;

  User({
    required this.photoURL,
    required this.displayName,
    required this.firestoreUid,
    required this.userName,
    required this.plan,
    required this.updatedAt,
    required this.products,
    required this.firebaseUid,
  });

  // Converte um Map<String, dynamic> (JSON) em uma instância de User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      photoURL: json['photoURL'] ?? '',
      displayName: json['displayName'] ?? '',
      firestoreUid: json['firestoreUid'] ?? '',
      userName: json['userName'] ?? '',
      plan: json['plan'] ?? '',
      updatedAt: json['updatedAt'] ?? 0,
      products: List<int>.from(json['products'] ?? []),
      firebaseUid: json['firebaseUid'] ?? '',
    );
  }

  // Converte uma instância de User para um Map<String, dynamic> (JSON)
  Map<String, dynamic> toJson() {
    return {
      'photoURL': photoURL,
      'displayName': displayName,
      'firestoreUid': firestoreUid,
      'userName': userName,
      'plan': plan,
      'updatedAt': updatedAt,
      'products': products,
      'firebaseUid': firebaseUid,
    };
  }
}