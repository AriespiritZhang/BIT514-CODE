# -*- coding: utf-8 -*-     支持文件中出现中文字符
#########################################################################

"""
Created on Wed Oct 23 13:45:42 2019

@author: yangmengyao

代码功能描述：  （1）分割信号，时间窗为150个采样点，每个文件300个样本点，2个文件共计600个样本点
              （2）计算六个属性
              （3）分析数据，实现自动标label
              （4）用csv格式输出结果

"""
#####################################################################

import numpy as np
import pandas as pd
from scipy import signal
import math
import matplotlib
import matplotlib.pylab as plt                       #绘图
#from numpy import *
import os
import gc                                            #gc模块提供一个接口给开发者设置垃圾回收的选项
import time
import xlwt
import openpyxl
import csv

#读取文件第一列，保存在s1列表中
###########################################################################################################
start = 113                                         #设立变量start，作为循环读取文件的起始
N = 2                                               #设立变量N，作为循环读取文件的增量
csv_list = []
for e in range(start, start+N):                      #循环2次，读取113&114两个文件
    d = e - start
    data = open(r'/Users/yangmengyao/PycharmProjects/FeatureExtraction/20151026_%d'% (e)).read()     #设立data列表变量，python 文件流，%d处，十进制替换为e值，.read读文件
    data = data.split( )                            #以空格为分隔符，返回数值列表data
    data = [float(s) for s in data]                 #将列表data中的数值强制转换为float类型

    s1 = data[0:45000*4:4]                          #list切片L[n1:n2:n3]  n1代表开始元素下标；n2代表结束元素下标
                                                    #n3代表切片步长，可以不提供，默认值是1，步长值不能为0
####################################################################################################################

#滤波
##################################################################################################################
    fs = 3000                                       #设立频率变量fs
    lowcut = 1
    highcut = 30
    order = 2                                       #设立滤波器阶次变量
    nyq = 0.5*fs                                    #设立采样频率变量nyq，采样频率=fs/2。
    low = lowcut/nyq
    high = highcut/nyq
    b, a = signal.butter(order, [low, high], btype='band') #设计巴特沃斯带通滤波器 “band”
    s1_filter1 = signal.lfilter(b, a, s1)           #将s1带入滤波器，滤波结果保存在s1_filter1中
###################################################################################################################
    # 计算每一帧的过零率
    # def ZCR(s):
    #     frameNum = 15
    #     frameSize = 3000
    #     zcr = np.zeros((frameNum, 1))
    #     dataFrame = np.reshape(s, (45000, 1))
    #     for i in range(frameNum):
    #         singleFrame = dataFrame[:, i]
    #         temp = singleFrame[:frameSize - 1] * singleFrame[1:frameSize]
    #         temp = np.sign(temp)
    #         zcr[i] = np.sum(temp < 0)
    #     return zcr
#计算6个属性
##################################################################################################################
   # a = [[0 for i in range(15)] for j in range(6)]  #初始化数组
    # i_mean = []
    # i_std = []
    # i_var = []
    # i_med = []
    # i_sc = []
    # i_ku = []
    csv_line = []
    slice_len = 150                                                       # 设置滑动窗口大小
    slice_num = (45000 / slice_len).__int__()
    for i in range(0, slice_num):
        i_list = s1_filter1[i * slice_len:(i + 1) * slice_len]
        i_arr = np.array(i_list)
        i_std = np.std(i_arr)                                             # 计算标准差 0.01
        i_mean = np.mean(i_arr)                                           # 计算平均值
        i_var = np.var(i_arr)  # 计算方差
        i_ku = np.mean((i_list - i_mean) ** 4) / pow(i_var, 2)            # 计算峰度 3
        i_max = np.max(i_arr)                                             # 计算最大值
        i_min = np.min(i_arr)                                             # 计算最小值
        # i_med = np.median(i_arr)                                        # 计算中值
        # i_sc = np.mean((i_list - i_mean) ** 3)                          # 计算偏斜度
                                                                          #sharp_waves简写为SW
                                                                          # label0表示不是SW，label1表示半SW，label2表示完整SW
        if i_std < 0.01:                                                  #通过分析数据，发现标准差和峰度能有效判断。
            i_label = 0                                                   #标准差较小就不是SW，0.01的选取依据数据
        elif i_ku < 3:                                                    #峰度越大，分布就有更多的极端值，分布更加陡峭，一般取3为分界点
            i_label = 1                                                   #半SW由于极端值分布分布不如完整SW多，所以峰度小于3为半SW
        else:
            i_label = 2
        csv_line = [i_std, i_ku, i_max, i_min, i_mean, i_var, i_label]
        csv_list.append(csv_line)
    # print(csv_list)
        #print(a[0][0])
    #i_zcr = ZCR(s1_filter1)
    #print(a)
    #print(a[0][1][1])
        #print(i_mean)
        #print(i_sc)
        #print(i_std)
        #print(i_var)
        #print(i_arr[0])
##################################################################################################################

#保存为CSV
##################################################################################################################
    #name = ['one', 'two', 'three']
    test = pd.DataFrame(data=csv_list)                                     #6个属性和标签的记录存储为csv格式
    print(test)
    test.to_csv('./testcsv.csv', encoding='utf-8')