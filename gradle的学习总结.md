### gradle的学习总结

##### 安装

* 设置环境变量
  * win平台新建环境变量  GRADLE_HOME=D:\software\gradle-6.5
  * 在path环境变量中添加**==；%GRADLE_HOME%\bin==;**
* 验证安装服务
  * cmd命令中输入 ==gradle -v==验证

##### groovy的特性

+ 基本区别

  + 完全兼容java,底层使用JVM
  + 语句结尾==;==可以省略
  + 对象的==getter/setter==默认添加
  + 类和方法默认使用public修饰
  + 方法返回==return==可以省略
  + 对象属性可以使用使用==.==调出

+ 高级特性

  + 类型可选，一般使用def修饰

    ```groovy
    def name = 'jack'
    def age = 20
    ```

  + 方法可选

    ```groovy
    println('good')
    println 'good'
    ```

  + 字符串

    ``` groovy
    def name ='jack'
    def hello = "hello $name"
    def test ='''hello 
    everyon
    ! '''
    ```

    

  + 集合API

    ```groovy
    // list集合
    def gj =['ant','maven']
    gj << 'gradle'
    println(gi.get[0])
    
    // map 集合
    def map =['ant':2004,'maven':2008]
    map.gradle=2012
    ```

    

  + 闭包使用

    ```groovy
    def createDir={
    	path ->
        File dir = new File(path)
        if(!dir.exists()){
            dir.makedirs()
        }
    }
    ```

    

##### task脚本


```groovy
//闭包
	def makedir={
		path->
		File dir = new File(path)
		if(!dir.exists()){
			dir.mkdirs()
		}
	}
	
	// 任务
	task createJavaDir(){
		def paths=['src/main/java','src/main/resources']
		doFirst{
			paths.foreach(makedir);
		}
	}
	// 任务
	task createTestDir(){
		dependsOn 'createJavaDir'
		def paths=['src/test/java','src/test/resources']
		doLast{
			paths.foreach(makedir);
		}
	}
```



##### 生命周期

	+ 初始化
	+ 配置阶段
	+ 执行任务阶段

##### 依赖仓库

```groovy
// 注意仓库顺序
repositories{
    maven{
        url '……'
    }
    mavenLoacl()
    mavenCentral()
}
```



##### 单个项目多个module

```
		// 单个module的依赖其他的module
		dependencies{
			compile project ':first'
		}

		//全局配置 build.gradle
		allprojects{
			applugin id 'java'
			sourceCompitibility=1.8
		}
		subprojects{
			repositories{
				mavenCentral()
			}
			
			dependencies{
			……
			}
		}
		
		// 全局配置 setting.gradle
		rootProject.name='todo'
		include 'web'
		include 'model'
```



