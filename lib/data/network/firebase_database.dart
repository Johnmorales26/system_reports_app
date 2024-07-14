import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:system_reports_app/data/local/task_entity.dart';
import 'package:system_reports_app/data/local/user_database.dart';
import 'dart:io';

import '../../utils/constants.dart';

class FirebaseDatabase {
  final db = FirebaseFirestore.instance;

  Future<bool> createNewUser(UserDatabase user) async {
    try {
      await db.collection(Constants.COLLECTION_USERS).doc(user.uid).set(user.toJson());
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> createTask(TaskEntity taskEntity) async {
    try {
      await db.collection(Constants.COLLECTION_TASKS).doc(taskEntity.id.toString()).set(taskEntity.toJson());
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getTask() async {
    return db.collection(Constants.COLLECTION_TASKS).snapshots();
  }

  Future<void> deleteTask(String taskId) async {
    await db.collection(Constants.COLLECTION_TASKS).doc(taskId).delete();
  }

  Future<void> updateTaskStatus(String taskId, bool isChecked) async {
    await db.collection(Constants.COLLECTION_TASKS).doc(taskId).update({
      Constants.PROPERTY_STATUS: isChecked,
    });
  }

  Future<bool> downloadFile(BuildContext context, String url, String selectedDirectory) async {
    bool downloadSuccess = false;
    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
      final fileName = ref.name;
      final filePath = '$selectedDirectory/$fileName${Constants.EXTENSION_PDF}';
      final file = File(filePath);
      final downloadTask = ref.writeToFile(file);
      downloadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes.toDouble();
      });
      await downloadTask.whenComplete(() async {
        downloadSuccess = true;
      });
    } catch (e) {
      downloadSuccess = false;
    }
    return downloadSuccess;
  }
}