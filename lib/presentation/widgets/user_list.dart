import 'package:flutter/material.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';

class UserList extends StatefulWidget {
  final GetUsers getUsers;

  const UserList({super.key, required this.getUsers});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<UserEntity>? users;
  String? errorMessage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final result = await widget.getUsers();
    result.fold(
      (failure) {
        setState(() {
          errorMessage = failure.message;
          isLoading = false;
        });
      },
      (usersList) {
        setState(() {
          users = usersList;
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $errorMessage'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadUsers,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (users == null || users!.isEmpty) {
      return const Center(child: Text('No hay usuarios disponibles'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: users!.length,
      itemBuilder: (context, index) {
        final user = users![index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purple,
              child: Text(user.username[0].toUpperCase()),
            ),
            title: Text(
              user.name.fullName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(user.email),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('ID', '${user.id}'),
                    _buildInfoRow('Username', user.username),
                    _buildInfoRow('Teléfono', user.phone),
                    _buildInfoRow(
                      'Dirección',
                      '${user.address.street} #${user.address.number}',
                    ),
                    _buildInfoRow('Ciudad', user.address.city),
                    _buildInfoRow('Código Postal', user.address.zipcode),
                    _buildInfoRow(
                      'Ubicación',
                      'Lat: ${user.address.geolocation.lat}, Long: ${user.address.geolocation.long}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
