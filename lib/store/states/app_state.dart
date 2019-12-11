
/// APP state
class AppState{
  final int count;
  final bool showNavConfig;
  final List<String> navList;
  final List<String> restnavList;
  final Object user;


  AppState({
    this.count,
    this.showNavConfig,
    this.navList,
    this.restnavList,
    this.user
  });

  factory AppState.init() => AppState(
    count: 0, 
    showNavConfig: false,
    navList: ['关注', '推荐', '直播','影视','游戏','社会','历史','NBA','国外'],
    restnavList: ['小说', '测一测', '动物','钓鱼','精品课','音乐','影视','音频','微头条',
    '传媒', '健身', '圈子','综艺','图片','数码','手机','游戏','时尚',
    '历史', '育儿', '搞笑','美食','养生','电影','旅游','宠物','情感',
    '家具', '教育', '三农','文化','股票','科学','动漫','故事','收藏',
    '精选', '星座', '辟谣','正能量','生活','彩票','公益',],
    user: null,
  );

  @override
  String toString() {
    return 'AppState{count: $count,showNavConfig: $showNavConfig, navList: $navList';
  }
}