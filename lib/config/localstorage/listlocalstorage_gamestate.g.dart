part of 'localstorage_gamestate.dart';

class ListLocalStorageGameStateAdapter extends TypeAdapter<List<LocalStorageGameState>> {
  @override
  final int typeId = 2;

  @override
  List<LocalStorageGameState> read(BinaryReader reader) {
    final int length = reader.readByte();
    return List.generate(
      length,
          (index) => LocalStorageGameStateAdapter().read(reader),
    );
  }

  @override
  void write(BinaryWriter writer, List<LocalStorageGameState> list) {
    writer.writeByte(list.length);
    for (final objeto in list) {
      LocalStorageGameStateAdapter().write(writer, objeto);
    }
  }
}