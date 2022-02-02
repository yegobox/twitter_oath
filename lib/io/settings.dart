import 'package:isar/isar.dart';
part 'settings.g.dart';

@Collection()
class Settings {
  int id = Isar.autoIncrement;

  late String token;

  late DateTime date;
}
