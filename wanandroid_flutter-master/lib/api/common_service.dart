import 'Api.dart';
import 'package:dio/dio.dart';
import '../net/dio_manager.dart';
import '../model/BannerModel.dart';
import '../model/ArticleModel.dart';
import '../model/SystemTreeModel.dart';
import '../model/SystemTreeContentModel.dart';
import '../model/WxArticleTitleModel.dart';
import '../model/WxArticleContentModel.dart';
import '../model/NaviModel.dart';
import '../model/ProjectListModel.dart';
import '../model/ProjectTreeModel.dart';
import '../model/HotWordModel.dart';
import '../model/UserModel.dart';
import '../model/CollectionModel.dart';
import '../model/BaseModel.dart';
import '../model/WebsiteCollectionModel.dart';
import '../model/TodoListModel.dart';
import '../common/User.dart';

class CommonService{
  void getBanner(Function callback) async {
    DioManager.singleton.dio.get(Api.HOME_BANNER, options: _getOptions()).then((response) {
      callback(BannerModel(response.data));
    });
  }
  void getArticleList(Function callback,int _page) async {
    DioManager.singleton.dio.get(Api.HOME_ARTICLE_LIST+"$_page/json", options: _getOptions()).then((response) {
      callback(ArticleModel(response.data));
    });
  }

  void getArticleList2(Function callback,int _page) async {
    DioManager.singleton.dio.get("http://www.wanandroid.com/lg/collect/list/0/json", options: _getOptions()).then((response) {
      callback(ArticleModel(response.data));
    });
  }
  
  /// 获取知识体系列表
  void getSystemTree(Function callback) async {
    DioManager.singleton.dio.get(Api.SYSTEM_TREE, options: _getOptions()).then((response) {
      callback(SystemTreeModel(response.data));
    });
  }
  /// 获取知识体系列表详情
  void getSystemTreeContent(Function callback,int _page,int _id) async {
    DioManager.singleton.dio.get(Api.SYSTEM_TREE_CONTENT+"$_page/json?cid=$_id", options: _getOptions()).then((response) {
      callback(SystemTreeContentModel(response.data));
    });
  }
  /// 获取公众号名称
  void getWxList(Function callback) async {
    DioManager.singleton.dio.get(Api.WX_LIST, options: _getOptions()).then((response) {
      callback(WxArticleTitleModel(response.data));
    });
  }
  /// 获取公众号文章
  void getWxArticleList(Function callback,int _id,int _page) async {
    DioManager.singleton.dio.get(Api.WX_ARTICLE_LIST+"$_id/$_page/json", options: _getOptions()).then((response) {
      callback(WxArticleContentModel(response.data));
    });
  }
  /// 获取导航列表数据
  void getNaviList(Function callback) async {
    DioManager.singleton.dio.get(Api.NAVI_LIST, options: _getOptions()).then((response) {
      callback(NaviModel(response.data));
    });
  }
  /// 获取项目分类
  void getProjectTree(Function callback) async {
    DioManager.singleton.dio.get(Api.PROJECT_TREE, options: _getOptions()).then((response) {
      callback(ProjectTreeModel(response.data));
    });
  }
  /// 获取项目列表
  void getProjectList(Function callback,int _page,int _id) async {
    DioManager.singleton.dio.get(Api.PROJECT_LIST+"$_page/json?cid=$_id", options: _getOptions()).then((response) {
      callback(ProjectTreeListModel(response.data));
    });
  }
  /// 获取搜索热词
  void getSearchHotWord(Function callback) async {
    DioManager.singleton.dio.get(Api.SEARCH_HOT_WORD, options: _getOptions()).then((response) {
      callback(HotWordModel(response.data));
    });
  }
  /// 获取搜索结果
  void getSearchResult(Function callback,int _page,String _id) async {
    FormData formData = new FormData.from({
      "k": _id,
    });
    DioManager.singleton.dio.post(Api.SEARCH_RESULT+"$_page/json", data: formData, options: _getOptions()).then((response) {
      callback(ArticleModel(response.data));
    });
  }

  /// 登录
  void login(Function callback,String _username,String _password) async {
    FormData formData = new FormData.from({
      "username": _username,
      "password":_password
    });
    DioManager.singleton.dio.post(Api.USER_LOGIN, data: formData, options: _getOptions()).then((response) {
      callback(UserModel(response.data),response);
    });
  }

  /// 注册
  void register(Function callback,String _username,String _password) async {
    FormData formData = new FormData.from({
      "username": _username,
      "password":_password,
      "repassword":_password
    });
    DioManager.singleton.dio.post(Api.USER_REGISTER, data: formData, options: null).then((response) {
      callback(UserModel(response.data));
    });
  }

  /// 获取收藏列表
  void getCollectionList(Function callback,int _page) async {
    DioManager.singleton.dio.get(Api.COLLECTION_LIST+"$_page/json", options: _getOptions()).then((response) {
      callback(CollectionModel(response.data));
    });
  }

  /// 我的收藏-取消收藏
  void cancelCollection(Function callback,int _id,int _originId) async {
     FormData formData = new FormData.from({
      "originId": _originId
    });
    DioManager.singleton.dio.post(Api.CANCEL_COLLECTION+"$_id/json", data: formData,options: _getOptions()).then((response) {
      callback(BaseModel(response.data));
    });
  }
  /// 我的收藏-新增收藏
  void addCollection(Function callback,String _title,String _author,String _link) async {
     FormData formData = new FormData.from({
      "title": _title,
      "author":_author,
      "link":_link
    });
    DioManager.singleton.dio.post(Api.ADD_COLLECTION, data: formData,options: _getOptions()).then((response) {
      callback(BaseModel(response.data));
    });
  }

  /// 网站收藏列表
  void getWebsiteCollectionList(Function callback) async {
    DioManager.singleton.dio.get(Api.WEBSITE_COLLECTION_LIST, options: _getOptions()).then((response) {
      callback(WebsiteCollectionModel(response.data));
    });
  }
  /// 取消网站收藏
  void cancelWebsiteCollectionList(Function callback,int _id) async {
    FormData formData = new FormData.from({
      "id": _id,
    });
    DioManager.singleton.dio.post(Api.CANCEL_WEBSITE_COLLECTION, data: formData, options: _getOptions()).then((response) {
      callback(BaseModel(response.data));
    });
  }
  /// 新增网站收藏
  void addWebsiteCollectionList(Function callback,String _name,String _link) async {
    FormData formData = new FormData.from({
      "name": _name,
      "link":_link
    });
    DioManager.singleton.dio.post(Api.ADD_WEBSITE_COLLECTION, data: formData, options: _getOptions()).then((response) {
      callback(BaseModel(response.data));
    });
  }
  /// 编辑网站收藏
  void editWebsiteCollectionList(Function callback,int _id,String _name,String _link) async {
    FormData formData = new FormData.from({
      "id": _id,
      "name": _name,
      "link":_link
    });
    DioManager.singleton.dio.post(Api.EDIT_WEBSITE_COLLECTION, data: formData, options: _getOptions()).then((response) {
      callback(BaseModel(response.data));
    });
  }

  /// todo列表
  void getTodoList(Function callback,int _type) async {
    DioManager.singleton.dio.get(Api.TODO_LIST+"$_type/json", options: _getOptions()).then((response) {
      callback(TodoListModel(response.data));
    });
  }
  
  /// 新增todo数据
  void addTodoData(Function callback,String _title,String _content,String _date,int _type) async {
    FormData formData = new FormData.from({
      "title": _title,
      "content": _content,
      "date":_date,
      "type":_type
    });
    DioManager.singleton.dio.post(Api.ADD_TODO, data: formData, options: _getOptions()).then((response) {
      callback(BaseModel(response.data));
    });
  }

  /// 更新todo数据
  void updateTodoData(Function callback,int _id,String _title,String _content,String _date,int _status,int _type) async {
    FormData formData = new FormData.from({
      "title": _title,
      "content": _content,
      "date":_date,
      "status":_status,
      "type":_type
    });
    DioManager.singleton.dio.post(Api.UPDATE_TODO+"$_id/json", data: formData, options: _getOptions()).then((response) {
      callback(BaseModel(response.data));
    });
  }


  /// 删除todo数据
  void deleteTodoData(Function callback,int _id) async {
    DioManager.singleton.dio.post(Api.DELETE_TODO+"$_id/json", data: null, options: _getOptions()).then((response) {
      callback(BaseModel(response.data));
    });
  }
  
  /// 仅更新todo完成状态
  void doneTodoData(Function callback,int _id,int _status) async {
    FormData formData = new FormData.from({
      "status":_status
    });
    DioManager.singleton.dio.post(Api.DONE_TODO+"$_id/json", data: formData, options: _getOptions()).then((response) {
      callback(BaseModel(response.data));
    });
  }

  Options _getOptions() {
    Map<String,String> map = new Map();
    List<String> cookies = User().cookie;
    map["Cookie"] = cookies.toString();
    return Options(headers: map);
  }
}