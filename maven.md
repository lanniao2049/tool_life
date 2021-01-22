# maven使用 #
## 常用命令 ##
## 其他 ##
- 生命周期(clean lifecycle,default lifecycle,site lifecycle)
	- clean lifecycle
		- pre-clean,清理前准备工作
		- clean，清理上一次结构文件target
		- post-clean，清理后收尾
	- default lifecycle
		- validate，验证构建过程需要信息的正确性
		- compile，编译
		- test，测试
		- package，打jar或者war等包
		- verify,检查打的包
		- install,安装到本地库
		- deploy,发布版本到远程库
	- site lifecycle 
		- pre-site，发布站点前工作
		- site，生成站点阶段
		- post-site，发布站的后工作
		- deploy site，将站点信息发布到远程库
	
- dependency的scope依赖范围(compile默认,test,provided,runtime,system)

## maven私服nexus搭建 ##
## maven如何创建archtype ##