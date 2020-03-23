# CrackQp

#### 介绍
破解趣拍 很久之前的代码 已经不用了 sdk也都已经过时了 qp也被收购了  单独拿出来这个组件（仅代码不能运行）进行分享学习（仅供学习） 持续更新


#### 首先肯定是要根据项目的一些调试  猜测  然后可以通过runtime拿到方法属性配合 Hopper Disassembler进行分析

##分辨率破解
我在QPConfig文件里看到了videosize相关方法
![输入图片说明](https://images.gitee.com/uploads/images/2020/0323/221421_cffa3df2_1648075.png "qp1.png")

然后对videosize进行方法交换
![输入图片说明](https://images.gitee.com/uploads/images/2020/0323/221635_3ffdd824_1648075.png "qp2.png")

后来导入video视频发现也有size相关方法 所以也进行了相关方法的hook
![输入图片说明](https://images.gitee.com/uploads/images/2020/0323/222050_21c500d5_1648075.png "屏幕截图.png")



