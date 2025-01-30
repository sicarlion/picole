import 'dart:io';
import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:picole/solution/shared.dart';
import 'package:picole/solution/storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum Rating { general, sensitive, explicit }

enum Categories { normal, art }

final supabase = Supabase.instance.client;

class Database {
  static Future<void> init() async {
    await dotenv.load(fileName: ".env");
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
  }
}

class Client {
  /// Authenticate the user with the Database
  static Future<User?> auth(String name, String password) async {
    final account = await supabase
        .from('accounts')
        .select('id, avatar, name, display, email')
        .eq('name', name)
        .single();

    if (account.isEmpty) {
      return null;
    }

    final email = account['email'];
    AuthResponse auth;
    try {
      auth = await supabase.auth
          .signInWithPassword(email: email, password: password);
    } catch (e) {
      return null;
    }

    final user = auth.user!;

    return User(
      id: user.id,
      email: user.email ?? '',
      avatar: account['avatar'],
      name: account['name'],
      display: account['display'],
    );
  }

  static Future<void> sign(File file, String email, String name, String display,
      String password) async {
    final account =
        await supabase.from('accounts').select('id, name').eq('name', name);

    if (account.isNotEmpty) {
      return;
    }

    final avatar = await Storage(id: name, image: file).stamp();

    final signedAccount =
        await supabase.auth.signUp(email: email, password: password);

    await supabase.auth.signInWithPassword(email: email, password: password);
    await supabase.from('accounts').insert({
      'id': signedAccount.user!.id,
      'email': email,
      'name': name,
      'display': display,
      'avatar': avatar.url
    });

    final postList = await supabase.from('posts').select('id');
    final featured = postList[Random().nextInt(postList.length)];

    await supabase.from('featured').insert({
      'user_id': signedAccount.user!.id,
      'post': featured['id'],
    });
  }

  /// Authenticate the user with the session saved to SharedPreferences before application closes
  static Future<User?> restore() async {
    final creds = await loadCredentials();
    PostgrestMap account;

    try {
      account = await supabase
          .from('accounts')
          .select('id, avatar, name, display, email')
          .eq('name', creds[0])
          .single();
    } catch (e) {
      return null;
    }

    final email = account['email'];
    final auth = await supabase.auth
        .signInWithPassword(email: email, password: creds[1]);

    if (auth.user == null) {
      return null;
    }

    final user = auth.user!;

    return User(
      id: user.id,
      email: user.email ?? '',
      avatar: account['avatar'],
      name: account['name'],
      display: account['display'],
    );
  }

  /// Retrieve current session user data
  static Future<User?> session() async {
    final auth = await supabase.auth.getUser();

    if (auth.user == null) {
      return null;
    }
    final user = auth.user!;

    final account = await supabase
        .from('accounts')
        .select('id, avatar, name, display, email')
        .eq('id', user.id)
        .single();

    return User(
      id: user.id,
      email: user.email ?? '',
      avatar: account['avatar'],
      name: account['name'],
      display: account['display'],
    );
  }

  static Future<Post> getFeatured() async {
    final client = await Client.session();

    final featured = await supabase
        .from('featured')
        .select(
            'user_id, post (id, title, user_id (id, email, name, display, avatar), image, description, rating, categories, tags , dimension, score)')
        .eq('user_id', client!.id)
        .single();

    Post post = Post.convert(featured['post']);
    return post;
  }
}

class Post {
  String id;
  User artist;
  Asset image;
  String title;
  String description;
  Rating rating;
  Categories categories;
  String tags;

  Post({
    required this.id,
    required this.artist,
    required this.image,
    required this.title,
    this.rating = Rating.general,
    this.categories = Categories.normal,
    this.description = '',
    this.tags = '',
  });

  static Post convert(PostgrestMap raw) {
    double x = raw['dimension'][0].toDouble();
    double y = raw['dimension'][1].toDouble();
    List<double> dimension = [x, y];

    final artist = User(
      id: raw['user_id']['id'],
      name: raw['user_id']['name'],
      display: raw['user_id']['display'],
      avatar: raw['user_id']['avatar'],
    );

    return Post(
      id: raw['id'],
      artist: artist,
      image: Asset(
        url: raw['image'],
        dimension: dimension,
      ),
      title: raw['title'],
      description: raw['description'],
      rating: Rating.values.byName(raw['rating']),
      categories: Categories.values.byName(raw['categories']),
      tags: raw['tags'],
    );
  }

  static Future<Post> find(String id) async {
    PostgrestMap raw = await supabase
        .from('posts')
        .select(
            'id, user_id, image, dimension, title, description, rating, categories, tags')
        .eq('id', id)
        .single();
    double x = raw['dimension'][0].toDouble();
    double y = raw['dimension'][1].toDouble();
    List<double> dimension = [x, y];

    final artist = await Users.getId(raw['user_id']);

    return Post(
      id: raw['id'],
      artist: artist,
      image: Asset(
        url: raw['image'],
        dimension: dimension,
      ),
      title: raw['title'],
      description: raw['description'],
      rating: Rating.values.byName(raw['rating']),
      categories: Categories.values.byName(raw['categories']),
      tags: raw['tags'],
    );
  }

  static Future<List<Post>> bulk() async {
    List<Post> posts = [];
    PostgrestList raw = await supabase.from('posts').select(
        'id, title, user_id (id, email, name, display, avatar), image, description, rating, categories, tags , dimension, score');

    for (var item in raw) {
      final post = Post.convert(item);
      posts.add(post);
    }

    return posts.reversed.toList();
  }

  Future<void> assign() async {
    await supabase.from('posts').insert({
      'id': id,
      'user_id': artist.id,
      'image': image.url,
      'title': title,
      'description': description,
      'rating': rating.name,
      'categories': categories.name,
      'tags': tags,
      'dimension': image.dimension
    });
  }

  Asset get thumb => image.toThumb();
}

class User {
  String id;
  String email;
  String avatar;
  String name;
  String display;

  User({
    required this.id,
    this.email = '',
    this.avatar = '',
    this.name = '',
    this.display = '',
  });
}

class Users {
  static Future<User> getId(String id) async {
    PostgrestMap account;

    if (id != '') {
      account = await supabase
          .from('accounts')
          .select('id, avatar, name, display, email')
          .eq('id', id)
          .single();
    } else {
      throw 'You did not search anything.';
    }

    return User(
      id: account['id'],
      email: account['email'],
      avatar: account['avatar'],
      name: account['name'],
      display: account['display'],
    );
  }

  static Future<User> getName(String name) async {
    PostgrestMap account;

    if (name != '') {
      account = await supabase
          .from('accounts')
          .select('id, avatar, name, display, email')
          .eq('name', name)
          .limit(1)
          .single();
    } else {
      throw 'You did not search anything.';
    }

    return User(
      id: account['id'],
      email: account['email'],
      avatar: account['avatar'],
      name: account['name'],
      display: account['display'],
    );
  }
}

class Asset {
  /// The URL of the Image
  String url;
  List<double> dimension;

  Asset({required this.url, required this.dimension});

  Asset toThumb() {
    // Find the position to insert the new string
    String insertion = "c_thumb,q_10,f_auto/";
    String updatedUrl = url.replaceFirst("/v", "/${insertion}v");

    return Asset(url: updatedUrl, dimension: dimension);
  }

  /// Drop the value of asset and remove the image from database.
  void drop() {}
}
