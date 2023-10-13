# -*- coding: utf-8 -*-     支持文件中出现中文字符
#########################################################################
#########################################################################

"""
Created on Wed Oct 23 13:45:42 2019

@author: yangmengyao

代码功能描述：  （1）执行build_tree函数
              （2）计算出混淆矩阵
              （3）计算出一系列度量结果
              （4）...

"""
#####################################################################
from D_Tree import *
import sys
import csv
import codecs

# Use processed version of dataset where labels are mapped to integer values


def main():

	# if len(sys.argv) < 3:
	# 	print("\nError - Not enough arguments supplied")
	# 	print("\nUsage: > DTree_Driver.py <input_processed_csv_file> <output_txt_file>")
	# 	print("\nExample: > DTree_Driver.py golf_processed.csv golf_output.txt")
	# 	sys.exit()

	input_file = 'testcsv.csv'
	#output_file = 'output.txt'
	records = []
	
	with codecs.open(input_file, 'r', "utf-8-sig") as f:
		f = csv.reader(f, delimiter=',')
		for line in f:
			r = [float(i) for i in line]
			records.append(r)
			
	n_records = len(records)
	n_attributes = len(records[0]) - 1
	# print("\n")
	# print("------Input Configuration------")
	# print("\nNumber of records: ", n_records)
	# print("\nNumber of attributes: ", n_attributes)
	# #print("\nCheck output in ", output_file)
	# print("\n")
	# print("-------------------------------\n")
	attr_list = [0 for i in range(n_attributes)]
	root = Node()
	input_records = [[records[i][0], records[i][1], records[i][-1]] for i in range(len(records))]
	root.set_data(input_records)
	build_tree(root, 0)
	# outfile = open(output_file, 'w')
	print(root)
	# print(root.get_children()[0])
	# print(tree, outfile)
	# outfile.close()
	confusion_matrix = [[0 for i in range(3)]for j in range(3)]					#计算混淆矩阵
	clf_0_list = root.get_a_child(0).get_data()
	clf_1_list = root.get_a_child(1).get_a_child(0).get_data()
	clf_2_list = root.get_a_child(1).get_a_child(1).get_data()
	clf_list = [clf_0_list, clf_1_list, clf_2_list]
	for i in range(3):
		clf_list_label = [clf_list[i][k][-1] for k in range(len(clf_list[i]))]
		for j in range(3):
			confusion_matrix[j][i] = clf_list_label.count(j)
	print("confusion_matrix = " + confusion_matrix.__str__())
	acc = sum([confusion_matrix[i][i] for i in range(3)]) / n_records			#计算准确度
	tr = [confusion_matrix[i][i]/sum(confusion_matrix[i]) for i in range(3)]	#计算真0率，真1率，真2率
	fr = [1 - tr[i] for i in range(3)]											#计算假非0率，假非1率，假非2率
	p = confusion_matrix[0][0] / (confusion_matrix[0][0] + confusion_matrix[1][0] + confusion_matrix[2][0])#计算精度
	r = confusion_matrix[0][0] / (confusion_matrix[0][0] + confusion_matrix[0][1] + confusion_matrix[0][2])#计算召回率
	F_measure = 2 * confusion_matrix[0][0] / (3 * confusion_matrix[0][0] + confusion_matrix[0][1] + confusion_matrix[0][2])#计算F1度量
	print("Accuracy = " + acc.__str__())
	print("tr = " + tr.__str__())
	print("fr = " + fr.__str__())
	print("Precision = " + p.__str__())
	print("Recall = " + r.__str__())
	print("F_measure = " + F_measure.__str__())
if __name__ == '__main__':
	main()


