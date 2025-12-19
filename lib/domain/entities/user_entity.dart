/// Entidad de dominio para Usuario
class UserEntity {
  final int id;
  final String email;
  final String username;
  final NameEntity name;
  final AddressEntity address;
  final String phone;

  const UserEntity({
    required this.id,
    required this.email,
    required this.username,
    required this.name,
    required this.address,
    required this.phone,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity &&
        other.id == id &&
        other.email == email &&
        other.username == username &&
        other.name == name &&
        other.address == address &&
        other.phone == phone;
  }

  @override
  int get hashCode {
    return Object.hash(id, email, username, name, address, phone);
  }
}

/// Entidad de dominio para Name
class NameEntity {
  final String firstname;
  final String lastname;

  const NameEntity({required this.firstname, required this.lastname});

  String get fullName => '$firstname $lastname';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NameEntity &&
        other.firstname == firstname &&
        other.lastname == lastname;
  }

  @override
  int get hashCode => Object.hash(firstname, lastname);
}

/// Entidad de dominio para Address
class AddressEntity {
  final String city;
  final String street;
  final int number;
  final String zipcode;
  final GeolocationEntity geolocation;

  const AddressEntity({
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
    required this.geolocation,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddressEntity &&
        other.city == city &&
        other.street == street &&
        other.number == number &&
        other.zipcode == zipcode &&
        other.geolocation == geolocation;
  }

  @override
  int get hashCode {
    return Object.hash(city, street, number, zipcode, geolocation);
  }
}

/// Entidad de dominio para Geolocation
class GeolocationEntity {
  final String lat;
  final String long;

  const GeolocationEntity({required this.lat, required this.long});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GeolocationEntity && other.lat == lat && other.long == long;
  }

  @override
  int get hashCode => Object.hash(lat, long);
}
