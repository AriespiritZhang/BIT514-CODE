# -*- coding: utf-8 -*-     支持文件中出现中文字符
#########################################################################
#########################################################################

"""
Created on Sun Oct 27 13:45:42 2019

@author: yangmengyao

代码功能描述：  （1）划分训练集，测试集。训练集：测试集=7：3
              （2）通过KNN进行分类
              （3）...

"""
#####################################################################
from numpy import *
import numpy as np
import operator


#根据原始数据给出：训练数据以及对应的类别，测试数据以及对应的类别，训练集：测试集=7：3
def createDataSet(records):
    group_train = np.array([[records[i][0:6]] for i in range(int(0.7 * len(records)))])             #训练集数据
    labels_train = [records[i][-1] for i in range(int(0.7 * len(records)))]                         #训练集类别
    group_test = np.array([[records[i][0:6]] for i in range(int(0.7 * len(records)), len(records))])#测试集数据
    labels_act = [records[i][-1] for i in range(int(0.7 * len(records)), len(records))]             #测试集类别（实际）
    return group_train, labels_train, group_test, labels_act


#通过KNN进行分类
def classify(group_test, group_train, labels_train, k):
    output = []
    trainSize = group_train.shape[0]
    testSize = group_test.shape[0]
    for i in range(testSize):                                                                       #计算欧式距离
        diff = tile(group_test[i], (trainSize, 1, 1)) - group_train
        sqdiff = diff ** 2
        squareDist = sum(sqdiff, axis=2)
        dist = squareDist ** 0.5
        sortedDistIndex = np.argsort(dist, axis = 0)                                                #欧式距离从小到大排序，返回下标
        classCount = {}
        for i in range(k):
            voteLabel = labels_train[sortedDistIndex[i][0]]                                         #对选取的K个样本所属的类别个数进行统计
            classCount[voteLabel] = classCount.get(voteLabel, 0) + 1
        maxCount = 0
        for key, value in classCount.items():                                                       #选取出现的类别次数最多的类别
            if value > maxCount:
                maxCount = value
                classes = key
        output.append(classes)
    return output