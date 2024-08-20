# loongarch
this is a simple CPU us loonarch fram

## 项目简介

本次提交的设计为五段流水线CPU。实现的指令包括addi.w、add.w、sub.w、lu12i.w、pcaddu12i、or、ori、andi、and、xor、srli.w、slli.w、jirl、b、beq、bne、bl、st.w、ld.w、st.b、ld.b、mul.w、slti、srai_w和bge。 流水线CPU包括取指(IF)、译码(ID)、执行(EXE)、访存(MEM)和写回(WB)五个流水段，以及bridgesCtrl用于调度外设控制器。 
不同流水段之间采用握手信号进行连接，同时采用了数据旁路、指令cache以及分支预测等技术，并且使用Chisel3来设计BridgesCtrl。 时钟频率为 82MHz 。本地布局布线后建立时间余量为 0.282ns，保持时间余量为 0.127ns，LUT 使用量为2919，FF使用量2508，Block RAM Tile使用量1，DSP使用量3，MMCM2_ADV使用量1。

### 框架图

![image-20240820221644564](C:\Users\Lenovo\AppData\Roaming\Typora\typora-user-images\image-20240820221644564.png)

## 软件下载

该项目使用的是软件是vivado，版本是2019.2
下载地址为：https://china.xilinx.com/support/download/index.html/content/xilinx/zh/downloadNav/vivado-design-tools/archive.html

百度网盘：链接: https://pan.baidu.com/s/1kXoAVR9RAE962mGZwwPv9A?pwd=ikni 提取码: ikni 

安装教程：解压缩安装包到*非中文路径下*，双击运行安装程序 `xsetup.exe`：

![image-20240820220614665](C:\Users\Lenovo\AppData\Roaming\Typora\typora-user-images\image-20240820220614665.png)

## 项目运行

点击thinpad_top.xpr即可打开软件运行

## 编译环境

汇编的环境需要使用Ubuntu系统，loongarch需要的交叉编译器在文件夹（loongarch32r-linux-gnusf-2022-05-20.zip）中。
交叉编译环境配置：

1. 把文件夹解压到Ubuntu系统下的文件夹中
2. 在命令行输入vim ~/.bashrc
3. 在文件最后添加export PATH=.../loongarch32r-linux-gnusf-2022-05-20/bin/:$PATH
4. 在命令行输入loongarch32r-linux-gnusf-gcc -v查看版本。

