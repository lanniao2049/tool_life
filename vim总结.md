### vim总结

___

* linux查看vim是否安装和安装命令
  * rpm qa|grep vim 查看是否安装vim命令
  * yum install vim 安装命令
  
* vim有四种模式：normal,insert,command,visual
  * normal,普通模式，默认进入模式
    
    * vim a.txt  默认进入normal模式
    
    * gi 快递跳转到最后一场编辑的地方并插入
    
    * 左右上下移动
    
      * h 向左移动
      * j 向下移动
      * k 向上移动
      * l 向右移动
      * 2+j 向下移动两行
      * 5+h 向左移动五个字符
    
    * 在单词之间跳转
    
      * w/W 跳转到下一个单词word/Word的开始(word是非空白符分割的单词/Word是空白符分割的单词)
      * e/E 跳转到下一个单词word/Word的结尾
      * b/B 跳转到上一个单词word/Word的开始(backword)
    
    * 行间搜索移动
    
      * 使用f{char}可以移动到char字符上，例如 fi
      * 使用t{char}可以移动到char的前一个字符上，例如 ts
    
      > 以上如果第一次没有搜到可以使用分号(;)/逗号(,)是继续下一个搜索/上一个搜索
    
    * 水平移动
    
      * ^(Sfit+6)/0 移动到行开头
      * $(Shift+4) 移动到行结尾
    
    * 页面移动
    
      * gg 移动到文章开头
      * GG 移动到文章结尾
      * Ctrl+u 移动到上半页(upword)
      * Ctrl+b 移动到上一页(backpace)
      * Ctrl+f 移动到下一页(forword)
      * zz 把屏幕至于中间
      * H/M/L 跳转到当前屏幕的开始/中间/结尾  H(Head开头),M(Middle中间),L(Low结尾)
    
    * 快速修改(r-replace,c-change,s-substitute)
    
      * ra/rb 修改为a/b
      * R 直接替换
      * s 删除当前字符并进入插入
      * 4s 删除当前四个字符并进入插入
      * S 删除当前行并进入插入模式
      * cw(change word)
      * ct"(change to ")
      * ci",ci{,ci(
    
    * 搜索
    
      * /或者？ 单词搜索，其中n/N 向下或者向上搜索  例如： /good +n  向下搜索good
      * :set hls 设置高亮
      * :set incsearch 设置增量搜索
      * /m\c 大小写不敏感搜索
      * /m\C 大小写敏感搜索
    
    * 其他操作
    
      * d(delete) 删除，剪切选定文本内容
      * y(yank) 复制选定文本内容
      * yy 复制一行
      * yiw 复制一个单词
      * u(undone) 撤销上一步操作
      * p/P(put) 粘贴到光标后/前
      * d+p,dw+p删除一个单词然后粘贴,yiw+p复制一个单词然后粘贴
      * Ctrl+r 恢复之前撤销操作
      * x 删除字符
      * 2x 删除两个字符
      * dd 删除行
      * 5dd 删除5行
      * dw 删除单词,3dw删除3个单词
      * dG 删除光标之后所有行
      * daw(delete around word) 删除单词
      * diw(delete inner word)
      * dt"(delete to ")  删除到"
      * dt)  删除到)
      * d0 删除到行开头
      * d$ 删除到行结尾
    
  * insert模式，插入模式
    * i (insert) ,在字符之前插入
    * a(append),在字符之后插入
    * o(open a line below),在当前字符下一行插入
    * I(insert before line),在所在行最前插入
    * A(append after line),在所在行最后插入
    * O(open a line above),在所在行上一行插入
    * Esc(Ctrl+c或者Ctrl+[) 退出当前模式回到normal模式
    * 快捷的命令(注意必须是insert模式下)，以下命令也使用与linux终端使用，例如：ps -ef|grep java
      * Ctrl+h 删除上一个字符
      * Ctrl+w 删除上一个单词
      * Ctrl+u 删除当前行
    * Ctrl+n 补全
    * Ctrl+b
    * Ctrl+p
    * Ctrl+x+f 文件路径补全
    
  * command命令模式
    * :q(quite)退出 
    * :q! 强制退出
    * :wq(write quite) 保存退出
    * :wq!
    * :%s/good/tool/g  全文替换
    * :1,6 s/self/my/g 1到6行直接替换
    * :1,20 s/night//n 1到20行night的个数
    * `:% s/\<quck\>/selft/g` 精确匹配quck单词并替换
    * `:[range] s/{pattern}/{String}/[flag]` ，其中flag(g表示全局，n表示数量，i表示忽略大小写,I表示区分大小写,c表示每次替换前需要确认)，range选项(% 表示全局执行范围，m,n表示m到n行，/$最后一行)
    * :vs  竖着分屏
    * :sp  横着分屏
    * :set nu 设置行号
    * :set hls 设置高亮
    * :set incsearcha 设置增量搜索
    * vim多文件切换，分为buffer,window,tab
      * buffer 缓存区
        * :e 1.txt
        * :ls 列出所有的编辑文件
        * :b 1.txt 切换到1.txt编辑文件
        * :b 2 切换到排序是2的文件
        * :bpre/bnext/blast/bfirst
      * window 窗口
        * Ctrl+w+w 循环切换窗口
        * Ctrl+w+h 切换到向左边窗口
        * Ctrl+w+l 切换到向右边窗口
        * Ctrl+w+j 切换到向下边窗口
        * Ctrl+w+k 切换到向上边窗口
    
  * visual可视化模式
  
    * 在normal模式下按下如下字符进入visual模式
      * v 选中字符
      * viw(v inner word) 选中单词
      * vaw(v arround word) 选中单词，包含两边空格
      * V 选中行 
      * VG 选中行到文章结束
      * Ctrl+v 选中块(visual block)
      * Shift+v 选中行(visual line)
      * v/V 选中块+d  删除
      * u (undone) 恢复
  
* vim 寄存器，默认存储在无名寄存器上，寄存器分为多个种类

  * 复制粘贴到不同的寄存器中，例如： "a+ yy,"b+yy, "a+p,"b+p
  * 查看寄存器`:reg`或者`:reg a`,`:reg b`
  * "+系统剪切板，使用`:echo has('clipboard')`是否支持,1表示支持，0表示不支持，如果支持，则使用`"+`yy,`"+`p
  * vim宏的使用，例如：在 `https://www.xxx.com`等等批量添加前后双引号
    * q(第一个表示宏开始录制)，第二个q表示宏录制结束
    * `qa`(其中a表示录制到a的寄存器上)，执行 `I"`（第一行开头） ,在执行 `A"`(第一行) ，再按`q`退出宏，再选中要操作的文本`VG`(全选)，最后执行`:normal @a`(全选录放宏)
    * 还有另一种方案是，首先执行`VG`,然后执行`:normal I"`(开头添加)，在执行：Ctrl+p切换上一个命令，最后执行`:normal A"` 结尾添加

* linux终端执行命令：

  * Ctrl+a 移动到行开头
  * Ctrl+e 移动到行结尾
  * Ctrl+h 删除上一个字符
  * Ctrl+w 删除上一个单词
  * Ctrl+u 删除当前行
  * Ctrl+b 前移
  * Ctrl+f  后移



> 需要大量的肌肉记忆

##### vim配置和插件，需要再次学习

参考资料：

+ 慕课网视频课程(https://www.imooc.com/learn/1129)
+ 慕课网教程(http://www.imooc.com/wiki/vimlesson)