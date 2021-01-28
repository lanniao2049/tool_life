
### 相关快捷键和命令

- 触发快速搜索框  Ctrl+P
- 在目标文件唤起搜索面板，输入:10即可跳转到第10行，如果不够就会跳转最后一行。
- 在目标文件唤起搜索面板，可以使用@xxx，上下箭头和鼠标选定即可跳转到对应的行。
- 在目标文件唤起搜索面板，可以使用#xxxx，模糊搜索匹配内容，回车跳转到目标位置。
- 混合使用，base.js@xx，就可以跳转到base.js的一个函数里。
- 在调用的方法出按下F12可以跳转到函数定义的地方。
- 多重选择，同时编辑多处  Ctrl+D
- 撤回多选的最后一个 Ctrl+U
- 跳过选择  Ctrl+K,Ctrl+D
- 选中鼠标所在行 Ctrl+L
- 增加缩进 Ctrl +]
- 减少缩进 Ctrl+[
- 换出命令面板  Ctrlt +Shitf + P

___

### 插件安装
- 插件安装
  
  - 唤出命令面板，模糊搜索：install package 或者 remove package 即可安装，卸载相关插件
  
- 一键保存
  
  - 当我们打开了很多tab，并进行了修改，但是一个一个保存就有点麻烦。这个时候可以唤出命令面板使用一键保存。搜索：`Save All`，点击或者回车即可，可以看到非常方便。 
  
- 汉化编译器
  
  - 打开包管理器，准备安装插件啦！**Preferences > Package Control**，点击下拉框里的`Package Control: Install Package` 或者快捷键 **Ctrl+Shift+p**，模糊搜索`install`，点击，等待片刻，出现一个包管理列表。我们模糊搜索`chinese`，点击`ChineseLocalizations`，等待安装。
  
- DocBlockr 插件

  - 一个专注于快速生成代码注释的插件。

    **Preferences > Package Control > Install Packages**，支持模糊搜索 `docb`， 点击 `DocBlockr` 下载即可。

- Dartlight 插件

  - `flutter`代码高亮显示的插件。

- 自动补全

___

### 其他
- 设置国内源：
  - **Preferences > Package Settings > Package Control > Settings User**，添加如下代码并保存，搞定。
   ```
    "channels": [ "http://packagecontrol.cn/channel_v3.json"]
   ```
   
  - 通过 **Preferences > Package Settings > Package Control > Settings User**，查看全部配置信息(包含插件安装)
 ```
 {
	"bootstrapped": true,
	"channels":
	[
		"http://packagecontrol.cn/channel_v3.json"
	],
	"in_process_packages":
	[
	],
	"installed_packages":
	[
		"ChineseLocalizations",
		"Dartlight",
		"DocBlockr",
		"DocBlockr_Python",
		"Emmet",
		"Markdown Extended",
		"Package Control"
	]
}
 ```


#### 参考资料：
   慕课网教程(http://www.imooc.com/wiki/sublime)      
   官网教程(http://www.sublimetext.cn/docs/3/index.html)    
   Github资料(https://github.com/jikeytang/sublime-text)  
