class Node:
	def __init__(self, data = ''):
		self.data = data  # data为含2个元素的列表,data[0]为属性,data[1]为标签
		self.children = []

	def is_empty(self):
		return self.data is None

	def set_data(self, data):
		self.data = data

	def get_data(self):
		return self.data

	def add_child(self, child):
		self.children.append(child)

	def get_children(self):
		return self.children

	def get_a_child(self, index):
		return self.children[index]
		
	def __repr__(self, level=0):
		representation = "\t" * level + "|" + "-" * level + repr(self.data) + "\n"
		for child in self.children:
			representation += child.__repr__(level + 1)
		return representation

