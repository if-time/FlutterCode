import 'dart:async';
import 'package:flutter/material.dart';

class DemoStateWidget extends StatefulWidget {
  final String text;

  ////通过构造方法传值
  DemoStateWidget(this.text);

  ///主要是负责创建state
  @override
  _DemoStateWidgetState createState() => _DemoStateWidgetState(text);
}

class _DemoStateWidgetState extends State<DemoStateWidget> {
  String text;

  _DemoStateWidgetState(this.text);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    new Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        text = "这就变了数值";
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ///返回一个居中带图标和文本的Item
    _getBottomItem(IconData icon, String text) {
      ///充满 Row 横向的布局
      return new Expanded(
        flex: 1,

        ///居中显示
        child: new Center(
          ///横向布局
          child: new Row(
            ///主轴居中,即是横向居中
            mainAxisAlignment: MainAxisAlignment.center,

            ///大小按照最大充满
            mainAxisSize: MainAxisSize.max,

            ///竖向也居中
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ///一个图标，大小16.0，灰色
              new Icon(
                icon,
                size: 16.0,
                color: Colors.grey,
              ),

              ///间隔
              new Padding(padding: new EdgeInsets.only(left: 5.0)),

              ///显示文本
              new Text(
                text,
                //设置字体样式：颜色灰色，字体大小14.0
                style: new TextStyle(color: Colors.grey, fontSize: 14.0),
                //超过的省略为...显示
                overflow: TextOverflow.ellipsis,
                //最长一行
                maxLines: 1,
              ),
            ],
          ),
        ),
      );
    }

    // TODO: implement build
    return Container(
      // child: Text(text ?? "这就是有状态"),
      child: new Card(
        child: new FlatButton(
          onPressed: () {
            print("点击");
          },
          child: new Padding(
            padding: new EdgeInsets.only(
                left: 0.0, top: 10.0, right: 10.0, bottom: 10.0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Container(
                    child: new Text(
                      "描述",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
                    alignment: Alignment.topLeft),
                new Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _getBottomItem(Icons.star, "1000"),
                    _getBottomItem(Icons.link, "1000"),
                    _getBottomItem(Icons.subject, "1000"),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
