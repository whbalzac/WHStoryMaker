# WHStoryMaker
> #### 开门见山，先看效果图：

![StoryMaker.gif](http://upload-images.jianshu.io/upload_images/2963444-2a97f0c44bca6e77.gif?imageMogr2/auto-orient/strip)

小姐姐有没有很好看！是不是该点一波Star！（无耻，滚粗。。）(￣ε(#￣)☆╰╮o(￣皿￣///)

目前美图有四个功能，“贴纸 | 涂鸦 | 文字 | 滤镜”。

![贴纸 | 涂鸦 | 文字 | 滤镜.png](http://upload-images.jianshu.io/upload_images/2963444-b889f45c7a2311db.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)





> #### WHStoryMaker接入说明：
1. 在你需要用到 **WHStoryMaker** 的时候引用 **WHStoryMakerHeader.h** 头文件，**StoryMakeImageEditorViewController** 就是你需要的VC。
2. **StoryMakeImageEditorViewController** 只提供一种初始化方法
   ````- (instancetype)initWithImage:(UIImage *)image;````
   在初始化的时候传入 **Image**。
3. **WHStoryMaker** 依赖了 **Masonry**，写的时候习惯性就用了，受“毒害”太深，哈哈。。￣▽￣
