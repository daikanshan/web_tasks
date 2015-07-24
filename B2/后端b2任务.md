# 后端B2任务
----

B2任务中，开始让大家涉及有关数据库的一些知识，并使用这个知识增强上一个应用的体验，另外再加入一些其他的小功能。

## 任务要求
1. 安装active_record插件(安装Rails时会自带)，并了解其用法

2. 了解cookie和session，并使用sinatra提供的session功能。

3. 了解Mysql的使用，学会使用sql语句建立数据库、数据表以及增删改查操作

4. 完善你的留言板应用，添加注册登录系统。数据格式与B1任务的要求相同，其逻辑也大致类似。但因为加入了注册登录系统，所以需要增加一个用户表，其定义如下：

users:

	字段名称		字段类型		字段描述
	id  		int			用户id
	username	string		用户名
	password	string		密码

  另外，留言表的表名为messages，需要增加一个int类型的字段user_id，用来标识是哪个作者编写的留言。
  
5. 需要在留言板上添加上作者的用户名，也需要提供对作者的筛选功能。	
6. 用户可以通过提交用户名和密码注册，用户名必须是一个唯一的值，如果重复需要返回错误信息。注册后可以登录，只有登录后才可以查看留言信息。用户登录的时候可以在其session中保留一个用户id用来标识其已经登录。

## 检查点
1. 使用active_record重构应用
2. 启用sinatra的session功能，并在应用中充分利用这一功能。（例如发表留言时系统会自动填写user_id字段）
3. 建立一个注册和登录页面，并可以完成正常的注册和登录流程
4. 在除了注册页面和登录页面的其他地方设置权限判断，没有登录的用户会跳转回登录页面。登录页面下，已登录的用户会跳转到留言列表页面。
4. 留言显示页面可以看到发表留言的用户名
5. 提供按照用户名筛选留言的功能


## 加分项
1. 提供对密码的单向加密功能，使用例如SHA算法（Ruby已自带），单向加密密码，防止密码的明文泄露
2. 提供密码修改功能
3. 提供用户个人页面，可以查看到当前的用户信息以及提交的留言列表

## 任务期限
本次任务要求在7月29日20点前提交任务，可以提前提交。
赵兴海、蒲家训由于进度较慢，不设置截止期限，每两天向我汇报进度。

## 资源以及提示

### cookie和session介绍
http://blog.51yip.com/php/938.html

### mysql入门书籍
电子书在群共享里

安装mysql可以使用sudo apt-get update && sudo apt-get install mysql-server mysql-client libmysqlclient-dev

之后，使用sudo gem install mysql2来安装mysql的ruby驱动

最后只需要在你的文件中require 'mysql2'就可以引入mysql驱动了。

active_record建立与mysql的连接需要使用以下代码：

	ActiveRecord::Base.establish_connection(
		:adapter => "mysql2",
		:host => "127.0.0.1",
		:username => "",  # mysql用户名
		:password => "",  # mysql密码
		:database => "")  # mysql数据库名

### 密码Hash的介绍

http://drops.wooyun.org/papers/1066

