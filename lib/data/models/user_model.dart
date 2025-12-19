import '../../domain/entities/entities.dart';

/// Modelo de datos (DTO) para User
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    required super.name,
    required super.address,
    required super.phone,
  });

  /// Constructor desde JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      username: json['username'] as String,
      name: NameModel.fromJson(json['name'] as Map<String, dynamic>),
      address: AddressModel.fromJson(json['address'] as Map<String, dynamic>),
      phone: json['phone'] as String,
    );
  }

  /// Conversión a entidad de dominio
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      username: username,
      name: (name as NameModel).toEntity(),
      address: (address as AddressModel).toEntity(),
      phone: phone,
    );
  }

  /// Conversión a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'name': (name as NameModel).toJson(),
      'address': (address as AddressModel).toJson(),
      'phone': phone,
    };
  }
}

/// Modelo de datos para Name
class NameModel extends NameEntity {
  const NameModel({required super.firstname, required super.lastname});

  factory NameModel.fromJson(Map<String, dynamic> json) {
    return NameModel(
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
    );
  }

  NameEntity toEntity() {
    return NameEntity(firstname: firstname, lastname: lastname);
  }

  Map<String, dynamic> toJson() {
    return {'firstname': firstname, 'lastname': lastname};
  }
}

/// Modelo de datos para Address
class AddressModel extends AddressEntity {
  const AddressModel({
    required super.city,
    required super.street,
    required super.number,
    required super.zipcode,
    required super.geolocation,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      city: json['city'] as String,
      street: json['street'] as String,
      number: json['number'] as int,
      zipcode: json['zipcode'] as String,
      geolocation: GeolocationModel.fromJson(
        json['geolocation'] as Map<String, dynamic>,
      ),
    );
  }

  AddressEntity toEntity() {
    return AddressEntity(
      city: city,
      street: street,
      number: number,
      zipcode: zipcode,
      geolocation: (geolocation as GeolocationModel).toEntity(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'street': street,
      'number': number,
      'zipcode': zipcode,
      'geolocation': (geolocation as GeolocationModel).toJson(),
    };
  }
}

/// Modelo de datos para Geolocation
class GeolocationModel extends GeolocationEntity {
  const GeolocationModel({required super.lat, required super.long});

  factory GeolocationModel.fromJson(Map<String, dynamic> json) {
    return GeolocationModel(
      lat: json['lat'] as String,
      long: json['long'] as String,
    );
  }

  GeolocationEntity toEntity() {
    return GeolocationEntity(lat: lat, long: long);
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'long': long};
  }
}
