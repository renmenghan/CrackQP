# CrackQp

#### 介绍
破解趣拍 很久之前的代码 已经不用了 sdk也都已经过时了 qp也被收购了  单独拿出来这个组件（仅代码不能运行）进行分享学习（仅供学习） 持续更新


#### 首先肯定是要根据项目的一些调试  猜测  然后可以通过runtime拿到方法属性配合 Hopper Disassembler进行分析

##权限破解
在QPAuth通过分析猜到权限判断之后会调用success方法 所以我们直接绕过权限验证方法直接调用success
![输入图片说明](https://images.gitee.com/uploads/images/2020/0323/222858_e53d5f7b_1648075.png "屏幕截图.png")
![输入图片说明](https://images.gitee.com/uploads/images/2020/0323/222942_c6bc969d_1648075.png "屏幕截图.png")

视频导出也有权限 在QPMediaRender中也发现了checkAuth 看到他有返回值 直接返回YES
![输入图片说明](https://images.gitee.com/uploads/images/2020/0323/223203_bcfca739_1648075.png "屏幕截图.png")
![输入图片说明](https://images.gitee.com/uploads/images/2020/0323/223221_7dc96383_1648075.png "屏幕截图.png")

##分辨率破解
我在QPConfig文件里看到了videosize相关方法
![输入图片说明](https://images.gitee.com/uploads/images/2020/0323/221421_cffa3df2_1648075.png "qp1.png")

然后对videosize进行方法交换
![输入图片说明](https://images.gitee.com/uploads/images/2020/0323/221635_3ffdd824_1648075.png "qp2.png")

后来导入video视频发现也有size相关方法 所以也进行了相关方法的hook
![输入图片说明](https://images.gitee.com/uploads/images/2020/0323/222050_21c500d5_1648075.png "屏幕截图.png")
![输入图片说明](https://images.gitee.com/uploads/images/2020/0323/222148_ba4e0ff0_1648075.png "屏幕截图.png")



