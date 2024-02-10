import "package:shared_preferences/shared_preferences.dart";

class HelperFunction {
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";
  static String sharedPreferenceUserUIDKey = "USERUIDKEY";
  static String sharedPreferenceUserPhoneKey = "USERPHONEKEY";

  // saving data to sharedpreference
  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSharedPreference(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveUserEmailSharedPreference(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  // getting data from sharedpreference
  static Future<bool?> getUserLoggedInSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String?> getUserNameSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserNameKey);
  }

  static Future<String?> getUserEmailSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserEmailKey);
  }

  static Future<String?> getUserUIDSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserUIDKey);
  }

  static Future<String?> getUserPhoneSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserPhoneKey);
  }

  static Future<bool> saveUserUIDSharedPreference(String userUID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserUIDKey, userUID);
  }

  static Future<bool> saveUserPhoneSharedPreference(String userPhone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserPhoneKey, userPhone);
  }

  static Future<bool> clearUserLoggedInSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }

  static Future<bool> clearUserUIDSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(sharedPreferenceUserUIDKey);
  }

  static Future<bool> clearUserPhoneSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(sharedPreferenceUserPhoneKey);
  }

  static Future<bool> clearUserEmailSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(sharedPreferenceUserEmailKey);
  }

  static Future<bool> clearUserNameSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(sharedPreferenceUserNameKey);
  }

  static Future<bool> saveUserTypeSharedPreference(String userType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString("USERTYPE", userType);
  }

  static Future<void> setUserSharedPreference(credential) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("USER", credential);
  }

  static Future getUserSharedPreferenceCredential() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("USER");
  }
}
// Compare this snippet from lib/screens/ProductDetails.dart:
// import 'package:flutter/material.dart';
