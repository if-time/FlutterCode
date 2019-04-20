import 'package:flutter/material.dart';
import '../utils/timeline_util.dart';
import '../model/SystemTreeModel.dart';
import '../model/SystemTreeContentModel.dart';
import '../utils/route_util.dart';
import '../api/common_service.dart';

/// 知识体系详情
class SystemTreeContentPageUI extends StatefulWidget {
  SystemTreeData data;

  SystemTreeContentPageUI(ValueKey<SystemTreeData> key) : super(key: key) {
    this.data = key.value;
  }

  @override
  State<StatefulWidget> createState() {
    return SystemTreeContentPageUIState();
  }
}

class SystemTreeContentPageUIState extends State<SystemTreeContentPageUI>
    with TickerProviderStateMixin {
  SystemTreeData _datas;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _datas = widget.data;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController =
        new TabController(vsync: this, length: _datas.children.length);
    return new Scaffold(
      appBar: new AppBar(
        title: Text(_datas.name),
        elevation: 0.4,
        bottom: new TabBar(
          controller: _tabController,
          tabs: _datas.children.map((SystemTreeChild item) {
            return Tab(
              text: item.name,
            );
          }).toList(),
          isScrollable:
              true, //水平滚动的开关，开启后Tab标签可自适应宽度并可横向拉动，关闭后每个Tab自动压缩为总长符合屏幕宽度的等宽，默认关闭
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: _datas.children.map((item) {
          return NewsList(
            id: item.id,
          );
        }).toList(),
      ),
    );
  }
}

//知识体系文章列表
class NewsList extends StatefulWidget {
  final int id; //知识体系id
  @override
  NewsList({Key key, this.id}) : super(key: key);

  _NewsListState createState() => new _NewsListState();
}

class _NewsListState extends State<NewsList> {
  List<SystemTreeContentChild> _datas = new List();
  ScrollController _scrollController = ScrollController(); //listview的控制器
  int _page = 0; //加载的页数

  @override
  void initState() {
    super.initState();
    getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMore();
      }
    });
  }

  Future<Null> getData() async {
    _page = 0;
    int _id = widget.id;
    CommonService().getSystemTreeContent((SystemTreeContentModel _systemTreeContentModel){
      setState(() {
        _datas = _systemTreeContentModel.data.datas;
      });
    }, _page, _id);
  }

  Future<Null> _getMore() async {
    _page++;
    int _id = widget.id;

    CommonService().getSystemTreeContent((SystemTreeContentModel _systemTreeContentModel){
      setState(() {
        _datas.addAll(_systemTreeContentModel.data.datas);
      });
    }, _page, _id);
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: RefreshIndicator(
        onRefresh: getData,
        child: ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemBuilder: _renderRow,
          itemCount: _datas.length + 1,
          controller: _scrollController,
          separatorBuilder: _separatorView,
        ),
      ),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
    if (index < _datas.length) {
      return _itemView(context, index);
    }
    return _getMoreWidget();
  }

  Widget _itemView(BuildContext context, int index) {
    return InkWell(
      child: _newsRow(_datas[index]),
      onTap: () {
        RouteUtil.toWebView(context, _datas[index].title, _datas[index].link);
      },
    );
  }

  Widget _separatorView(BuildContext context, int index) {
    return Container(
      height: 0.5,
      color: Colors.black26,
    );
  }

  //新闻列表单个item
  Widget _newsRow(SystemTreeContentChild item) {
    return new Column(
      children: <Widget>[
        new Container(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  item.author,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                new Expanded(
                  child: new Text(
                    TimelineUtil.format(item.publishTime),
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            )),
        Container(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  item.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ))
              ],
            )),
        Container(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              children: <Widget>[
                Text(
                  item.superChapterName,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                new Text(
                  "/" + item.chapterName,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.right,
                ),
              ],
            )),
      ],
    );
  }

  

  // 加载更多时显示的组件,给用户提示
  Widget _getMoreWidget() {
    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
