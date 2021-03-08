### vim总结

___

* linux查看vim是否安装和安装命令
  * rpm qa|grep vim 查看是否安装vim命令
  * yum install vim 安装命令
* vim有四种模式：normal,insert,command,visual
  * normal,普通模式，默认进入模式
    * vim a.txt  默认进入normal模式
  * insert模式，插入模式
    * i (insert) ,在字符之前插入
    * a(append),在字符之后插入
    * o(open a line below),在当前字符下一行插入
    * I(insert before line),在所在行最前插入
    * A(append after line),在所在行最后插入
    * O(open a line above),在所在行上一行插入
    * Esc 退出当前模式回到normal模式
  * command命令模式
    * :q(quite)退出 
    * :q! 强制退出
    * :wq(write quite) 保存退出
    * :wq!
    * :%s/good/tool/g  全文替换
    * :vs  竖着分屏
    * :sp  横着分屏
    * :set nu 设置行号
  * visual可视化模式