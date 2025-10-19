// import 'dart:collection';
import 'package:flutter/foundation.dart';
// import 'package:note_taking_app/models/folder.dart';

class FolderProvider with ChangeNotifier {

  // final List<Folder> _folders = [
  //   Folder(id: '0', name: "Tất cả ghi chú"),
  //   Folder(id: '1', name: 'Ý tưởng dự án'),
  //   Folder(id: '2', name: 'Việc cần làm'),
  // ];

  // // Getter public để UI có thể đọc (nhưng không thể sửa đổi)
  // UnmodifiableListView<Folder> get folders => UnmodifiableListView(_folders);

  // void createFolder(String name) {
  //   final newFolder = Folder(
  //     id: "${_folders.length}",
  //     name: name,
  //   );
  //   _folders.add(newFolder);
  //   notifyListeners();
  // }

  // void deleteFolder(String folderId) {
  //   _folders.removeWhere((folder) => folder.id == folderId);
  //   notifyListeners();
  // }

  // void updateFolder(String folderId, String newName) {
  //   try {
  //     final folder = _folders.firstWhere((f) => f.id == folderId);
      
  //     folder.name = newName;
      
  //     notifyListeners();
  //   } catch (e) {
      
  //     print('Không tìm thấy thư mục');
  //   }
  // }
}