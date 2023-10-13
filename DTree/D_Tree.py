# -*- coding: utf-8 -*-     支持文件中出现中文字符
#########################################################################
#########################################################################

"""
Created on Wed Oct 23 13:45:42 2019

@author: yangmengyao

代码功能描述：  （1）计算候选点gini值
              （2）选择最小gini值对应的划分点为最佳划分点
              （3）根据最佳划分点对数据进行划分
              （4）建立决策树
              （5）...

"""
#####################################################################
from Node import Node
from collections import Counter


def calc_gini(leseq_list, large_list):                              #计算gini值
    leseq_result = Counter(leseq_list)                              #用于计算n1,n2比例
    large_result = Counter(large_list)
    n1 = list(leseq_result.values())
    n2 = list(large_result.values())
    #print(large_result.values())
    try:
        gini_n1 = 1-(n1[0]/(n1[0]+n2[0]))**2-(n1[1]/(n1[1]+n2[1]))**2-(n1[2]/(n1[2]+n2[2]))**2
        gini_n2 = 1 - (n2[0] / (n1[0] + n2[0])) ** 2 - (n2[1] / (n1[1] + n2[1])) ** 2 - (n2[2] / (n1[2] + n2[2])) ** 2
        gini = gini_n1 * (len(leseq_list)/(len(leseq_list)+len(large_list))) + gini_n2 * (len(large_list)/(len(leseq_list)+len(large_list)))
    except IndexError:
        gini = 100
    return gini


def select_partition_value(using_al_column):                       #选择最小gini值对应的划分点为最佳划分点
    attr_sort_list = sorted(using_al_column[0])                    #对属性值进行排序
    two_ave_list = []
    gini_list = []
    for i in range(len(attr_sort_list)-1):                         #从两个相邻排过序的属性值之间选择中间值，作为划分候选点
        two_ave_list.append((attr_sort_list[i]+attr_sort_list[i+1])/2.0)
    #print(two_ave_list)
    for i in two_ave_list:
        leseq_list = []
        large_list = []
        for j in using_al_column:
            if j[0] <= i:
                leseq_list.append(j[1])
            else:
                large_list.append(j[1])
        gini_list.append(calc_gini(leseq_list, large_list))        #计算每个候选点的gini值
    min_index = gini_list.index(min(gini_list))                    #输出最小gini值的索引
    partition_value = two_ave_list[min_index]                      #通过索引查找出最佳划分值
    # print(partition_value)
    return partition_value


def best_split(attr_label_column, attr_index):                     #根据最佳划分点对数据进行划分
    using_al_column = [[attr_label_column[i][attr_index], attr_label_column[i][-1]] for i in range(len(attr_label_column))]
    #print(len(using_al_column))
    partition_value = select_partition_value(using_al_column)
    bs_list_l = [item for item in attr_label_column if item[attr_index] <= partition_value]
    bs_list_r = [item for item in attr_label_column if item[attr_index] > partition_value]
    bs_list = [bs_list_l, bs_list_r]
    return bs_list, partition_value


def build_tree(root, attr_index):                                 #建立决策树
    node_data_list = root.get_data()
    # print(len(node_data_list))
    node_data_list_label = Counter(node_data_list[i][-1] for i in range(len(node_data_list)))
    label_values = list(node_data_list_label.values())
    if len(node_data_list_label) == 1:                            #结束条件1：所有数据属于同一类，停止分裂
        return
    bs_list, partition_value = best_split(node_data_list, attr_index)
    attr_index += 1
    if not root.children and attr_index < len(node_data_list[0]): #结束条件2：所有属性值都用完
        root.children.append(Node())
        root.children.append(Node())
        root.children[0].set_data(bs_list[0])
        #print('第'+str(attr_index)+'层')
        #print(root.children[0])
        root.children[1].set_data(bs_list[1])
        build_tree(root.children[0], attr_index)
        build_tree(root.children[1], attr_index)
    attr_index -= 1
    # 把节点的data值改为partition_value
    if root.children:
        root.set_data(partition_value)
    return
