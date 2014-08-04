/**
 * Created by oschina on 2014/8/3.
 */
angular.module('tweetMapApp', []);

var Conf = {
    'host' : 'http://www.oschina.net',
    'auth_uri' : '/action/oauth2/authorize',
    'response_type' : 'code',
    'client_id' : '9offZrPebB75IH24dpFH',
    'redirect_uri' : 'http://localhost:8080/Oauth2Action'
};

var Api = (function(conf, $) {

    var api = {};

    var uri = {
        'user' : '/action/user',
        'login' : conf.auth_uri + '?response_type=' + conf.response_type
            + '&client_id=' + conf.client_id + '&redirect_uri='
            + encodeURIComponent(conf.redirect_uri),
        'blog_list' : '/action/spider',
        'blog_type' : '/action/syscatalog',
        'import_list' : '/action/moveblog'
    };
    var blog_tpl = [
        '<li>',
        '<span class="article_title">',
        '<input type="checkbox" id="blog_{id}" data-url="{link}"/>',
        '<img class="import_loading" src="img/loading2.gif">',
        '<img class="import_ok" src="img/ok.png" >',

        '<label for="blog_{id}">',
        '<a href="{link}" title="按住Ctrl点击在新页查看《{title}》" target="_blank">{title}</a>',
        '</label>',
        '</span>',
        '<span class="select_type">',
        '<select class="select_box" name="classification" id="sys_catalog">',
        '</select>',
        '<select class="person_select_box" name="classification" id="user_catalog">',
        '</select>',
        '</span>',
        '</li>'].join('\n');

    var getCookie = function(name, value) {
        var arr, reg = new RegExp("(^| )" + name + "=([^;]*)(;|$)");
        if (arr = document.cookie.match(reg))
            return unescape(arr[2]);
        else
            return null;
    };

    var delCookie = function(name) {
        var exp = new Date();
        exp.setTime(exp.getTime() - 1);
        var cval = getCookie(name);
        if (cval != null)
            document.cookie = name + "=" + cval + ";expires="
                + exp.toGMTString();
    };

    var ajax = function(url, callback, data, async) {
        return $.ajax({
            url : url,
            type : 'POST',
            dataType : 'json',
            async : typeof async === 'undefined' ? true : async,
            data : data,
            success : function(response) {
                if (response == null)
                    return;
                ajaxErrorHandler(response, callback);
            },
            error : callback
        }).responseText;
    };

    var ajaxErrorHandler = function(response, callback, onError) {
        var data = typeof response === "object" ? response : eval('('
            + response + ')');

        if (data == null) {
            location.reload();
            return;
        }

        if (data.status == 500) {
            alert('500 服务器内部错误');
            location.reload();
            return;
        }
        if (data.error) {
            if (onError) {
                return onError(data);
            }
            if (data.code == 0) {
                alert(data.error);
                return;
            } else if (data.code == 1) {
                delCookie('user');
                location.reload();
                return;
            }
        }
        callback && callback(data);
    };

    var getUserInfo = function(callback) {
        var user_id = getCookie('user');
        return ajax(uri.user, callback, {
            user_id : user_id
        });
    };

    var doLogin = function() {
        location.href = conf.host + uri.login;
    };

    var checkLogin = function() {
        return getCookie('user') != null;
    };

    var doLogout = function() {
        delCookie('user');
        location.reload();
    };

    var getBlogList = function(url, callback) {
        return ajax(uri.blog_list, callback, {
            url : url
        });
    };

    var getBlogType = function(){
        $.getJSON('http://www.moveblog.com:8080/action/syscatalog',function(data){
            var options="";
            $.each(data.blog_sys_catalog_list,function(optionindex,option){
                options = options+ "<option value="+option.id+">"+option.name+"</option>";
            });
            return options;
        },false);
        return Options;
    };

    var detectBlogType = function(url) {
        var blog_types = [ 'csdn', 'cnblogs', '51cto', 'iteye' ];
        return $.map(blog_types, function(type) {
            return url.indexOf(type) > -1 ? type : '';
        }).join('');
    };

    var generateBlogList = function(arr) {
        var ul = $('<ul>');
        for ( var i = 0; i < arr.length; i++) {
            var blog = arr[i];
            var li = blog_tpl.replace(/\{link\}/ig, blog.link).replace(
                /\{id\}/ig, i).replace(/\{title\}/ig, blog.title);
            ul.append(li);
        }
        return ul;
    };

    var importBlog = function(arr, len, before, callback) {
        var length = arr.length;
        if (length == 0)
            return;
        var obj = arr.shift();
        var url = obj.url;
        before && before(url, len - length);
        return ajax(uri.import_list, function(data) {
            callback && callback(data, url, len - length);
            importBlog(arr, len, before, callback);
        }, {
            link : url,
            user_catalog:obj.user_catalog,
            sys_catalog:obj.sys_catalog,
            reprint:obj.reprint,
            priva:obj.priva
        });
    };

    api.ajax = ajax;
    api.cookie = getCookie;
    api.rcookie = delCookie;

    api.user = getUserInfo;
    api.login = doLogin;
    api.logout = doLogout;
    api.logined = checkLogin;
    api.blog_select_type = getBlogType;
    api.blog_list = getBlogList;
    api.blog_type = detectBlogType;
    api.blog_list_tpl = generateBlogList;
    api.importBlog = importBlog;
    api.on_error = ajaxErrorHandler;

    return api;

})(Conf, jQuery);

$(function() {

    var $user_info = $('.user-info')

    // 查询 login user 信息
    Api.user(function(user) {
        if (!user) {
            Api.rcookie('user');
            return;
        }
        var login = $user_info.find('a.login');
        var logout = $user_info.find('a.logout');
        var tmplogin = $user_info.find('span.login');
        tmplogin.hide();
        login.attr('href', user.url + '/blog').attr('target', '_blank').text(
                user.name + ' ');
        logout.show().removeAttr('disabled');
    });

});