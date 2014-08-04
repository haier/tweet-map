/**
 * Created by oschina on 2014/8/3.
 */
'use strict';
angular.module('tweetMapApp').controller('tweetCtrl', function ($scope) {
    var vm = $scope.vm = {};
    vm.items = [
        {
            userId:1,
            userName:'小苹果',
            userImg:'http://static.oschina.net/uploads/user/292/584425_50.png?t=1384915933000',
            tweet:'动弹地图',
            locationX:114.138372,
            locationY:22.530595
        },
        {
            userId:2,
            userName:'小苹果2',
            userImg:'http://static.oschina.net/uploads/user/292/584425_50.png?t=1384915933000',
            tweet:'动弹地图2',
            locationX:113.138372,
            locationY:20.530595
        }
    ];
    vm.itemId = 3;

    vm.addItem = function() {
        vm.items.push('item' + vm.itemId);
        vm.itemId++;
    };

    vm.delItem = function(index) {
        vm.items.splice(index, 1);
    };


});
