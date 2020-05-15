
class ListUtils {

  static bool getBool(List<bool> list, int index) {
    return list.length > index ? list[index] : false;
  }
}