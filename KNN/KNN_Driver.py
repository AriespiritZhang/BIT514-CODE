# -*- coding: utf-8 -*-     支持文件中出现中文字符
#########################################################################
#########################################################################

"""
Created on Sun Oct 27 13:45:42 2019

@author: yangmengyao

代码功能描述：  （1）读取数据
              （2）调用数据划分，KNN分类，得出分类结果
              （3）根据测试集实际类别与预测类别得出混淆矩阵
              （4）根据混淆矩阵获得一系列参数
              （5）...

"""
#####################################################################
import KNN
import csv
import codecs
from numpy import *
input_file = 'testcsv.csv'                                                          # 读取数据
records = []
with codecs.open(input_file, 'r', "utf-8-sig") as f:
    f = csv.reader(f, delimiter=',')
    for line in f:
        r = [float(i) for i in line]
        records.append(r)
n_records = len(records)
group_train, labels_train, group_test, labels_act = KNN.createDataSet(records)      # 调用函数数据划分
K = int(input("请输入k值："))
output = KNN.classify(group_test, group_train, labels_train, K)                     # 调用函数KNN分类
print("分类结果为：", output)
confusion_matrix = [[0 for i in range(3)]for j in range(3)]                         # 根据结果得出混淆矩阵
for k in range(len(output)):
    for i in range(3):
        for j in range(3):
            if(labels_act[k] == i and output[k] == j):
                confusion_matrix[i][j] = confusion_matrix[i][j] + 1
print("confusion_matrix = " + confusion_matrix.__str__())
acc = sum([confusion_matrix[i][i] for i in range(3)]) / len(output)         # 计算准确度
tr = [confusion_matrix[i][i] / sum(confusion_matrix[i]) for i in range(3)]  # 计算真0率，真1率，真2率
fr = [1 - tr[i] for i in range(3)]  # 计算假非0率，假非1率，假非2率
p = confusion_matrix[0][0] / (confusion_matrix[0][0] + confusion_matrix[1][0] + confusion_matrix[2][0])  # 计算精度
r = confusion_matrix[0][0] / (confusion_matrix[0][0] + confusion_matrix[0][1] + confusion_matrix[0][2])  # 计算召回率
F_measure = 2 * confusion_matrix[0][0] / (3 * confusion_matrix[0][0] + confusion_matrix[0][1] + confusion_matrix[0][2])  # 计算F1度量
print("Accuracy = " + acc.__str__())
print("tr = " + tr.__str__())
print("fr = " + fr.__str__())
print("Precision = " + p.__str__())
print("Recall = " + r.__str__())
print("F_measure = " + F_measure.__str__())
