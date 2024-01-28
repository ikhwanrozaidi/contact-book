import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:ikhwanrozaidi_hoisystem/models/user_model.dart';

class UserRepository {
  final String baseUrl = 'https://reqres.in/api';
  final http.Client httpClient;

  UserRepository({http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

  Future<List<User>> fetchUsers(int page) async {
    final response =
        await http.get(Uri.parse('https://reqres.in/api/users?page=$page'));

    if (response.statusCode == 200) {
      final List<dynamic> userJson = json.decode(response.body)['data'];
      print('Response data: ${response.body}');
      return userJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<User>> fetchAllUsers() async {
    List<User> allUsers = [];
    int currentPage = 1;
    int totalPages = 1;

    while (currentPage <= totalPages) {
      final response =
          await httpClient.get(Uri.parse('$baseUrl/users?page=$currentPage'));

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final List<dynamic> userJson = body['data'];
        allUsers.addAll(userJson.map((json) => User.fromJson(json)).toList());

        totalPages = body['total_pages'];
        currentPage++;
      } else {
        throw Exception('Failed to load users from page $currentPage');
      }
    }

    return allUsers;
  }

  Future<User> createUser(Map<String, dynamic> userData) async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );

    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<void> deleteUser(int userId) async {
    final response =
        await httpClient.delete(Uri.parse('$baseUrl/users/$userId'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }

  Future<User> updateUser(int userId, Map<String, dynamic> updateData) async {
    final response = await httpClient.put(
      Uri.parse('$baseUrl/users/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updateData),
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<User> getUser(int userId) async {
    final response = await httpClient.get(Uri.parse('$baseUrl/users/$userId'));

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to get user');
    }
  }

  Future<dynamic> newRequest() async {
    final response = await httpClient.get(
        Uri.parse('https://mock-rest-api-server.herokuapp.com/api/v1/user'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get new request data');
    }
  }
}
