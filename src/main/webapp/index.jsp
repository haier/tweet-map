<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html ng-app="tweetMapApp">
<head>
    <style>
        #map #iCenter {
            width:75%;
            height:800px;
            float: left;

        }
        #map #tweet {
            width:20%;
            float: left;
        }

        /*给repeat中的enter和leave事件添加基础动画*/
        #map #tweet .repeat.ng-enter,
        #map #tweet  .repeat.ng-leave {
            -webkit-transition: 0.5s linear all;
            transition: 0.5s linear all;
        }

        #map #tweet  .repeat.ng-enter,
        #map #tweet  .repeat.ng-leave.ng-leave-active {
            opacity: 0;
        }

        #map #tweet  .repeat.ng-leave,
        #map #tweet  .repeat.ng-enter.ng-enter-active {
            opacity: 1;
        }
    </style>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>tweet-map</title>
    <!-- 页面布局样式 -->
    <link rel="stylesheet" type="text/css" href="http://developer.amap.com/Public/css/demo.Default.css" />
    <script language="javascript"  src="lib/jquery/jquery.min.js"></script>
    <script language="javascript"  src="lib/angular/angular.js"></script>
    <script language="javascript"  src="lib/angular/angular-animate.js"></script>
    <script language="javascript" src="script/app.js"></script>
    <script language="JavaScript" src="script/controler.js"></script>
    <script language="javascript" src="http://webapi.amap.com/maps?v=1.3&key=9cc7f355fb07c8dbfc017e7178245b10"></script>
    <script language="javascript">
        var mapObj,toolBar,locationInfo;

        //初始化地图对象，加载地图
        function mapInit(){
            mapObj = new AMap.Map("iCenter",{
                zoom:5 //地图显示的缩放级别
            });
            //地图中添加地图操作ToolBar插件
            mapObj.plugin(["AMap.ToolBar"],function(){
                toolBar = new AMap.ToolBar(); //设置地位标记为自定义标记
                mapObj.addControl(toolBar);
                AMap.event.addListener(toolBar,'location',function callback(e){
                    locationInfo = e.lnglat;
                });
            });


            inforWindow = new AMap.InfoWindow({
                autoMove:true,
                content:"我是系统默认的信息窗体，可以任意修改我的内容！"

            });
            //inforWindow.open(mapObj,new AMap.LngLat(116.373881,39.907409));

            addMarker();
            addMarker2();
            addMarker3();
        }

        //更新信息窗体的内容
        function updateInfo(){
            var info = [];
            info.push("<div><div><img style=\"float:left;\" src=\" http://webapi.amap.com/images/autonavi.png \"/></div> ");
            info.push("<div style=\"padding:0px 0px 0px 4px;\"><b>成熟的毛毛虫</b>");
            info.push("动弹地图demo </div></div>");
            inforWindow = new AMap.InfoWindow();
            inforWindow.setContent(info.join("<br/>") );  //在信息窗体中显示新的信息内容
            inforWindow.open(mapObj,new AMap.LngLat(116.480983,39.989628));
            mapObj.setCenter(new AMap.LngLat(116.480983,39.989628));
        }
        //获取定位位置信息
        function showLocationInfo()
        {
            var locationX = locationInfo.lng; //定位坐标经度值
            var locationY = locationInfo.lat; //定位坐标纬度值
            document.getElementById('info').innerHTML = "定位点坐标：("+locationX+","+locationY+")";
            var info = [];
            info.push("<div><div><img style=\"float:left;\" src=\" http://webapi.amap.com/images/autonavi.png \"/>成熟的毛毛虫</div> ");
            info.push("动弹地图demo </div></div>");
            inforWindow.setContent(info.join("<br/>") );  //在信息窗体中显示新的信息内容
            inforWindow.open(mapObj,new AMap.LngLat(locationX,locationY));
           // mapObj.setCenter(new AMap.LngLat(locationX,locationY));
        }
        //在地图上添加点标记函数
        function addMarker(){
            marker=new AMap.Marker({
                icon:new AMap.Icon({    //复杂图标
                    size:new AMap.Size(50,50),//图标大小
                    image:"http://static.oschina.net/uploads/user/292/584425_50.png?t=1384915933000" //大图地址

                }),
                position:new AMap.LngLat(115.405467,39.907761)
            });
            marker.setContent("sdsdsdsd");
            marker.setMap(mapObj);  //在地图上添加点
        }

        //在地图上添加点标记函数
        function addMarker2(){
            marker=new AMap.Marker({
                icon:new AMap.Icon({    //复杂图标
                    size:new AMap.Size(50,50),//图标大小
                    image:"http://static.oschina.net/uploads/user/292/584425_50.png?t=1384915933000" //大图地址

                }),
                position:new AMap.LngLat(112.405467,39.907761)
            });
            marker.setMap(mapObj);  //在地图上添加点
        }

        //添加带文本的点标记覆盖物
        function addMarker3(){
            //自定义点标记内容
            var markerContent = document.createElement("div");
            markerContent.className = "markerContentStyle";

            //点标记中的图标
            var markerImg= document.createElement("img");
            markerImg.className="markerlnglat";
            markerImg.src="http://static.oschina.net/uploads/user/292/584425_50.png?t=1384915933000";
            markerContent.appendChild(markerImg);

            //点标记中的文本
            var markerSpan = document.createElement("span");
            markerSpan.innerHTML = "我是自定义样式的点2222222222222222222222222222222222222222222222222222标记哦！";
            markerContent.appendChild(markerSpan);
            marker = new AMap.Marker({
                map:mapObj,
                position:new AMap.LngLat(116.397428,39.90923), //基点位置
                offset:new AMap.Pixel(-1,-36), //相对于基点的偏移位置
                draggable:false,  //是否可拖动
                content:markerContent   //自定义点标记覆盖物内容
            });
            marker.setMap(mapObj);  //在地图上添加点
        }


    </script>
</head>
<body onLoad="mapInit()" >
<div id="map">
<div id="iCenter"></div>
<div style="padding:2px 0px 0px 5px;font-size:12px">
    <input type="button" value="开始定位" onClick="javascript:toolBar.doLocation()"/>
    <input type="button" value="显示位置信息" onClick="javascript:showLocationInfo()"/>
    <input type="button" value="更新信息窗体内容" onClick="javascript:updateInfo()"/>
    <div id="info" style="margin-top:10px;margin-left:10px;height:30px"></div>
    <div style="color: #C0C0C0">不支持IE9以下版本</div>
</div>


<div id="tweet" ng-controller="tweetCtrl">
    <div class="user-info">
        <span class="login">请先使用 OSCHINA 帐号</span><a class="login"
                                                     href="javascript:Api.login();">登录</a> <a class="logout"
                                                                                              href="javascript:Api.logout();"
                                                                                              style="display: none; margin-left: 10px;">退出登录</a>
    </div>
<textarea ></textarea>
    <ul class="list-group">
        <li class="list-group-item repeat" ng-repeat="item in vm.items">
            <img ng-src="{{item.userImg}}">{{item.userName}} {{item.tweet}}


        </li>
    </ul>
    <button class="btn btn-default mmm" ng-click="vm.addItem()">添加一条</button>
</div>
</div>
</body>
</html> 
