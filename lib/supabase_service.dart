import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> query(String table, {Map<String, dynamic>? filters}) async {
    var query = _client.from(table).select();

    if (filters != null) {
      filters.forEach((key, value) {
        query = query.eq(key, value);
      });
    }

    final response = await query;

    if (response.isEmpty) {
      print('No data found.');
    }

    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> update(String table, String id, Map<String, dynamic> data) async {
    final response = await _client
        .from(table)
        .update(data)
        .eq('id', id)
        .select()
        .single();

    if (response.isEmpty) {
      throw Exception('Error updating data.');
    }

    return response;
  }

  Future<Map<String, dynamic>> insert(String table, Map<String, dynamic> data) async {
    final response = await _client
        .from(table)
        .insert(data)
        .select()
        .single();

    if (response.isEmpty) {
      throw Exception('Error inserting data.');
    }

    return response;
  }

  Future<void> delete(String table, {Map<String, dynamic>? filters}) async {
    var query = _client.from(table).delete();

    if (filters != null) {
      filters.forEach((key, value) {
        query = query.eq(key, value);
      });
    }

    final response = await query;

    if (response.isEmpty) {
      print('Error deleting data.');
    }
  }
}
