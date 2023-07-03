import 'package:floor/floor.dart';

@Entity(tableName: 'HREntity')
class HREntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String date;

  final double time;

  final int value;

  HREntity(this.id, this.date, this.time, this.value);
}
