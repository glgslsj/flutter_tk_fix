import 'area_data.dart';
import 'package:collection/collection.dart';
bool contains(String str, List list) {
  return list.firstWhere((element) => str.contains(element), orElse: () => null) != null;
}

class TkRegions {
  static List<AreaItem> get provinces {
    return AreaData.where((element) => element.type == AreaType.province).toList();
  }

  static List<AreaItem> get cities {
    return AreaData.where((element) => element.type == AreaType.city).toList();
  }

  static List<AreaItem> get areas {
    return AreaData.where((element) => element.type == AreaType.area).toList();
  }

  /// 获取城市列表，指独立的行政区域，包括地级市，县，县级市
  static List<AreaItem> get cityList {
    List<AreaItem> list = AreaData.where((element) => element.type != AreaType.province).toList();
    list.removeWhere((element) => contains(element.name , ['区', '街道', '直辖']));
    TkRegions.cities.where((element) => element.name.contains('直辖')).forEach((element) {
      list.addAll(TkRegions.getChildren(element.id)!);
    });
    list = list.toSet().toList();
    return list.sortedBy<String>((element) => element.pinyin);
  }

  static String getName (String id) {
    return AreaData.firstWhere((element) => element.id == id).name;
  }

  /// 获取短名称，如 石家庄市 => 石家庄
  static String getShortName (String id) {
    var area = AreaData.firstWhere((element) => element.id == id);
    var name = area.name;
    if (name.contains('辖')) name = TkRegions.parse(id)[AreaType.province]!.name;
    name = name.replaceAll(RegExp(r'[市省县]|(地区)'), '');
    var ethnicGroup = ['朝鲜族', '蒙古族', '蒙古', '土家族', '藏族', '彝族', '布依族', '苗族', '傣族', '维吾尔族', '羌族', '侗族', '哈尼族', '壮族', '白族', '傈僳族', '哈萨克', '回族', '景颇族', '柯尔克孜', '维吾尔'];
    if (RegExp(r'自治').hasMatch(name)) {
      ethnicGroup.forEach((element) {
        name = name.replaceAll(element, '');
      });
    }
    name = name.replaceAll(RegExp(r'(蒙古)?自治.'), '');
    return name;
  }

  static String getFullName (String id) {
    var parseMap = TkRegions.parse(id);
    var parseList = [parseMap[AreaType.province], parseMap[AreaType.city], parseMap[AreaType.area]];
    parseList.removeWhere((element) => element == null);
    return parseList.map((e) => e!.name).join(' ');
  }

  static AreaType getType (String id) {
    return AreaData.firstWhere((element) => element.id == id).type;
  }

  static List<AreaItem>? getChildren (String id) {
    var type = TkRegions.getType(id);
    if (type == AreaType.province) {
      return TkRegions.cities.where((element) => element.id.substring(0, 1) == id.substring(0, 1)).toList();
    }
    if (type == AreaType.city) {
      return TkRegions.areas.where((element) => element.id.substring(0, 3) == id.substring(0, 3)).toList();
    }
    return null;
  }

  static Map<AreaType, AreaItem> parse (String id) {
    Map<AreaType, AreaItem> rt = {};
    var item = AreaData.firstWhere((element) => element.id == id);
    if (item.type != AreaType.province) {
      var provinceId = id.replaceRange(2, 6, '0000');
      rt[AreaType.province] = AreaData.firstWhere((element) => element.id == provinceId);
    }
    if (item.type == AreaType.area) {
      var cityId = id.replaceRange(4, 6, '00');
      rt[AreaType.city] = AreaData.firstWhere((element) => element.id == cityId);
    }
    rt[item.type] = item;
    return rt;
  }
}