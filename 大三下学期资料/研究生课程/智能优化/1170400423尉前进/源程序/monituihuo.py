# -*- coding: UTF-8 -*-
'''*******************************
@ 开发人员：Mr.Zs
@ 开发时间：2020/5/24-14:27
@ 开发环境：PyCharm
@ 项目名称：算法类总工程->模拟退火算法路径规划V1.0.py
******************************'''
import numpy as np
import random as rd
import time
from pylab import *
import math

#这个对象专门滤除路径中的回头路
class Fiter:
    def __init__(self):
        self.b = 1  # 标志位

    def function(self, a):  # 定义一个函数
        for i in a:  # 遍历列表中的内容
            a = a[a.index(i) + 1:]  # 把当前内容索引的后面的内容剪切下来  因为前面的已经比对过了
            if i in a:  # 如果当前内容与后面有重复
                return i, 1  # 返回当前重复的内容 以及标志位1
            else:  # 没有重复就不用管  继续for循环
                pass
        return 0, 0  # 全部遍历完  没有重复的就返回0 这里返回两个0 是因为返回的数量要保持一致

    def fiter(self, a):
        if a == []: #判断传进来的列表是否为空，空的话会报错 也没有必要进行下一步
            return a
        while (self.b == 1):  # 标志位一直是 1  则说明有重复的内容
            (i, self.b) = self.function(a)  # 此时接受函数接收 返回值 i是重复的内容 b是标志位
            c = [j for j, x in enumerate(a) if x == i]  # 将重复内容的索引全部添加进c列表中
            a = a[0:c[0]] + a[c[-1]:]  # a列表切片在重组
        return a
fiter = Fiter()#实例化对象
#step1
#生成的地图为指定大小的随机障碍地图
# class Map():
#     '''
#     :param:地图类
#     :param:使用时需要传入行列两个参数 再实例化
#     '''
#
#     def __init__(self,row,col):
#         '''
#         :param:row::行
#         :param:col::列
#         '''
#         self.data = []
#         self.row = row
#         self.col = col
#     def map_init(self):
#         '''
#         :param:创建栅格地图row行*col列 的矩阵
#         '''
#         self.data = [[10 for i in range(self.col)] for j in range(self.row)]
#         # for i in range(self.row):
#         #     for j in range(self.col):
#         #         print(self.data[i][j],end=' ')
#         #     print('')
#     def map_Obstacle(self,num):
#         '''
#         :param:num:地图障碍物数量
#         :return：返回包含障碍物的地图数据
#         '''
#         self.num = num
#         for i in range(self.num):#生成小于等于num个障碍
#             self.data[random.randint(0,self.row-1)][random.randint(0,self.col-1)] = 0
#         if self.data[0][0] == 1:        #判断顶点位置是否是障碍  若是 修改成可通行
#             self.data[0][0] = 0
#
#         if self.data[self.row-1][0] == 1:
#             self.data[self.row-1][0] = 0
#
#         if self.data[0][self.col-1] == 1:
#             self.data[0][self.col - 1] = 0
#
#         if self.data[self.row-1][self.col - 1] == 1:
#             self.data[self.row - 1][self.col - 1] = 0
#         for i in range(self.row):       #显示出来
#             for j in range(self.col):
#                 print(self.data[i][j],end=' ')
#             print('')
#         return self.data
#step1 路径规划地图创建
class Map():
    def __init__(self):
        #10 是可行 白色
        # 0 是障碍 黑色
        # 8 是起点 颜色浅
        # 2 是终点 颜色深
        self.data = [[ 8,10,10,10,10,10,10,10,10,10],
                     [10,10, 0, 0,10,10,10, 0,10,10],
                     [10,10, 0, 0,10,10,10, 0,10,10],
                     [10,10,10,10,10, 0, 0, 0,10,10],
                     [10,10,10,10,10,10,10,10,10,10],
                     [10,10, 0,10,10,10,10,10,10,10],
                     [10, 0, 0, 0,10,10, 0, 0, 0,10],
                     [10,10, 0,10,10,10, 0,10,10,10],
                     [10,10, 0,10,10,10, 0,10,10,10],
                     [10,10,10,10,10,10,10,10,10, 2]]

        # for i in range(10):       #显示出来
        #     for j in range(10):
        #         print(self.data[i][j],end=' ')
        #     print('')

#step2 随机选取一个初始可行解
class FeasibleSolution():
    def __init__(self):
        self.p_start = 0  # 起始点序号0  10进制编码
        self.p_end = 99  # 终点序号99 10进制编码
        # self.xs = (self.p_start) // (self.col)  # 行
        # self.ys = (self.p_start) % (self.col)  # 列
        # self.xe = (self.p_end) // (self.col)  # 终点所在的行
        # self.ye = (self.p_end) % (self.col)
        self.map = Map()  # Map的实例化 主函数中可以不再初始化地图
        # for i in range(10):       #显示出来
        #     for j in range(10):
        #         print(self.map.data[i][j],end=' ')
        #     print('')
        self.can = []  # 这个列表存放整个地图中不是障碍物的点的坐标 按行搜索
        self.popu = []#缓存一下
        self.end_popu = []#最终的

    def feasiblesolution_init(self):
        '''
        :return:无返回值，随机选出一条初始可行解
        '''
        temp = []
        while (temp == []):
            self.end_popu = []
            for xk in range(0,10):  #遍历0-10行
                self.can = []             #清空can列表   用来缓存当前行的可行点
                for yk in range(0,10):   #遍历所有的列
                    num = (yk) + (xk) * 10  #编码当前的坐标
                    if self.map.data[xk][yk] == 10: #可行点
                        self.can.append(num)        #添加进can列表
                # print(self.can,'自由点')
                length = len(self.can)     #此行的长度  随机生成指针取出坐标
                # print(length)
                a = (self.can[rd.randint(0, length - 1)])
                self.end_popu.append(a) #在当前行的可行点中随机选一个给end_popu
            self.end_popu[0] = self.p_start  # 每一行的第一个元素设置为起点序号
            self.end_popu[-1] = self.p_end  #最后一个元素设为终点编号
            # print('间段路径',self.end_popu)
            temp = self.Generate_Continuous_Path(self.end_popu)#将返回的一条路经 添加进end中
        # print('当前的路径',temp)
        self.end_popu = fiter.fiter(temp)    #滤除重复节点路径
            # print(self.end_popu, end='\n')
        # print('测试1',self.popu,end='\n')
        return self.end_popu
    # @staticmethod
    def Generate_Continuous_Path(self,old_popu):#生成连续的路径个体
        '''
        :param old_popu: 未进行连续化的一条路径
        :return:        无返回                   # 已经连续化的一条路径
        '''
        num_insert = 0
        self.new_popu = old_popu    #传进来的参数就是一行的数组  一条路径
        self.flag = 0
        self.lengh = len(self.new_popu)  #先将第一条路经的长度取出来
        i = 0
        # print("lengh =",self.lengh )
        while i!= self.lengh-1:       #i 不等于 当前行的长度减去1  从0计数  这里有问题 待修改
            x_now = (self.new_popu[i]) // (10)  # 行 解码  算出此条路经的第i个元素的直角坐标
            y_now = (self.new_popu[i]) % (10)  # 列
            x_next =  (self.new_popu[i+1]) // (10) #计算此条路经中下一个点的坐标
            y_next =  (self.new_popu[i+1]) % (10)
            #最大迭代次数
            max_iteration = 0

            #判断下一个点与当前点的坐标是否连续 等于1 为连续
            while max(abs(x_next - x_now), abs(y_next - y_now)) != 1:
                x_insert = ((x_next + x_now) // 2)      #行
                y_insert = ((y_next + y_now) // 2) #ceil向上取整数     #列
                # print("x_insert = ",x_insert,"\ty_insert = ",y_insert)
                flag1 = 0

                if self.map.data[x_insert][y_insert] == 10:  #插入的这个坐标为10 可走
                    num_insert = (y_insert) + (x_insert) * 10 #计算出插入坐标的编码
                    self.new_popu.insert(i+1,num_insert)
                    # print(self.new_popu)
                    # print('插入编号',num_insert)
                else:#插入的栅格为障碍  判断插入的栅格上下左右是否为障碍，以及是否在路径中，若不是障碍且不在路径中，就插入
                    #判断下方
                    if (x_insert + 1 < 10)and flag1 == 0:       #保证坐标是在地图上的
                        if ((self.map.data[x_insert+1][y_insert] == 10)#下方不是障碍物
                            and (((y_insert) + (x_insert+1) * 10) not in self.new_popu)):#编号不在已知路径中
                            num_insert = (y_insert) + (x_insert+1) * 10  #计算下方的编号
                            self.new_popu.insert(i + 1, num_insert) #插入编号
                            flag1 = 1       #设置标志位 避免下面重复插入

                            # print('下方插入',num_insert)
                    #判断右下方
                    if (x_insert + 1 < 10)and (y_insert+1<10)and flag1 == 0:       #保证坐标是在地图上的
                        if ((self.map.data[x_insert+1][y_insert+1] == 10)#下方不是障碍物
                            and (((y_insert+1) + (x_insert+1) * 10) not in self.new_popu)):#编号不在已知路径中
                            num_insert = (y_insert+1) + (x_insert+1) * 10  #计算下方的编号
                            self.new_popu.insert(i + 1, num_insert) #插入编号
                            flag1 = 1       #设置标志位 避免下面重复插入

                            # print('右下方插入',num_insert)
                    #判断右方
                    if (y_insert + 1 < 10)and flag1 == 0:  # 保证坐标是在地图上的 并且前面没有插入
                        if ((self.map.data[x_insert][y_insert+1] == 10)#右方不是障碍物
                            and (((y_insert+1) + (x_insert) * 10) not in self.new_popu)):#编号不在已知路径中
                            num_insert = (y_insert+1) + (x_insert) * 10  #计算右方的编号
                            self.new_popu.insert(i + 1, num_insert) #插入编号
                            flag1 = 1  # 设置标志位 避免下面重复插入
                            # print('右方插入',num_insert)
                    #判断右上方
                    if (y_insert + 1 < 10)and (x_insert - 1 >= 0)and flag1 == 0:  # 保证坐标是在地图上的 并且前面没有插入
                        if ((self.map.data[x_insert-1][y_insert+1] == 10)#右方不是障碍物
                            and (((y_insert+1) + (x_insert-1) * 10) not in self.new_popu)):#编号不在已知路径中
                            num_insert = (y_insert+1) + (x_insert-1) * 10  #计算右方的编号
                            self.new_popu.insert(i + 1, num_insert) #插入编号
                            flag1 = 1  # 设置标志位 避免下面重复插入
                            # print('右上方插入',num_insert)
                    #判断上方
                    if (x_insert - 1 >= 0) and flag1 == 0:  # 保证坐标是在地图上的
                        if ((self.map.data[x_insert-1][y_insert] == 10)#右方不是障碍物
                            and (((y_insert) + (x_insert-1) * 10) not in self.new_popu)):#编号不在已知路径中
                            num_insert = (y_insert) + (x_insert-1) * 10  #计算右方的编号
                            self.new_popu.insert(i + 1, num_insert) #插入编号
                            flag1 = 1  # 设置标志位 避免下面重复插入
                            # print('上方插入',num_insert)
                    #判断左上方
                    if (x_insert - 1 >=0) and(y_insert - 1 >= 0)and flag1 == 0:  # 保证坐标是在地图上的
                        if ((self.map.data[x_insert-1][y_insert-1] == 10)#右方不是障碍物
                            and (((y_insert-1) + (x_insert-1) * 10) not in self.new_popu)):#编号不在已知路径中
                            num_insert = (y_insert-1) + (x_insert-1) * 10  #计算右方的编号
                            self.new_popu.insert(i + 1, num_insert) #插入编号
                            flag1 = 1  # 设置标志位 避免下面重复插入
                            # print('左上方插入',num_insert)
                    #判断左方
                    if (y_insert - 1 >=0)and flag1 == 0:  # 保证坐标是在地图上的
                        if ((self.map.data[x_insert][y_insert-1] == 10)#右方不是障碍物
                            and (((y_insert-1) + (x_insert) * 10) not in self.new_popu)):#编号不在已知路径中
                            num_insert = (y_insert-1) + (x_insert) * 10  #计算右方的编号
                            self.new_popu.insert(i + 1, num_insert) #插入编号
                            flag1 = 1  # 设置标志位 避免下面重复插入
                            # print('左方插入',num_insert)
                    #判断左下方
                    if (y_insert - 1 >= 0)and(x_insert+1<10)and flag1 == 0:  # 保证坐标是在地图上的
                        if ((self.map.data[x_insert+1][y_insert-1] == 10)#右方不是障碍物
                            and (((y_insert-1) + (x_insert+1) * 10) not in self.new_popu)):#编号不在已知路径中
                            num_insert = (y_insert-1) + (x_insert+1) * 10  #计算右方的编号
                            self.new_popu.insert(i + 1, num_insert) #插入编号
                            flag1 = 1  # 设置标志位 避免下面重复插入
                            # print('左下方插入',num_insert)
                    if flag1 == 0:  #如果前面没有插入新点  说明这条路径不对 删除
                        pass
                        # self.new_popu = []
                        # print(x_insert,y_insert,'没有可行点')
                x_next = num_insert//10
                y_next = num_insert%10
                # x_next = x_insert
                # y_next = y_insert
                max_iteration += 1#迭代次数+1
                if max_iteration > 20:
                    self.new_popu = []  #超出迭代次数 说明此条路经可能无法进行连续   删除路径
                    break
            if self.new_popu == []:
                # print('运行到这里2')
                break

            self.lengh = len(self.new_popu)
            # print(self.new_popu, '连续,长度为:',self.lengh)
            i = i+1
        # print(self.new_popu,'连续')
        return  self.new_popu#返回的是一条路径
#step2 计算适应度函数
def calvalue(popu,col):
    '''
    :param popu: 传入单条路径信息
    :param col: 这个参数是地图的列数 ，因为要解码用到
    :return:    返回的是一个路径长度值
    '''
    value = 0 #存放计算出来的路径长度值
    single_popu = popu
    single_lengh = len(single_popu)#将当前行的长度拿出来
    # print(single_lengh)
    for j in range(single_lengh-1):#从第一个元素计算到倒数第一个元素
        x_now = (single_popu[j]) // (col)  # 行 解码  算出此条路经的第i个元素的直角坐标
        y_now = (single_popu[j]) % (col)  # 列
        x_next = (single_popu[j + 1]) // (col)  # 计算此条路经中下一个点的坐标
        y_next = (single_popu[j + 1]) % (col)
        if abs(x_now - x_next) + abs(y_now - y_next) == 1:#路径上下左右连续 不是对角的 则路径长度为1
            value = value+1
        elif max(abs(x_now - x_next),abs(y_now - y_next))>=2:#惩罚函数 若跳跃或者穿过障碍
            value = value + 100
        else:
            value = value+1.4  #对角长度为根号2  即1.4
    return value
#step3 生成新的路径   采用遗传算法中变异的方法
def get_newsolution(oldsolution):
    temp = []  # 定义一个缓存路径的空列表
    while (temp == []):
        single_popu = oldsolution
        col = len(single_popu)  # 长度 即列数  也就是这条路径有多少节点
        first = rd.randint(1, col - 2)  # 随机选取两个指针
        second = rd.randint(1, col - 2)
        if first != second:  # 判断两个指针是否相同  不相同的话把两个指针中间的部分删除 在进行连续化
            # 判断一下指针大小  便于切片
            if (first < second):
                single_popu = single_popu[0:first] + single_popu[second + 1:]
            else:
                single_popu = single_popu[0:second] + single_popu[first + 1:]
        temp = feasiblesolution.Generate_Continuous_Path(single_popu)  # 连续化
    new_popu = (temp)
    return new_popu
if __name__ == '__main__':
    #参数初始化
    T0 = 10 # 初始温度
    T = T0 # 迭代中温度会发生改变，第一次迭代时温度就是T0
    maxgen = 100 # 最大迭代次数
    Lk = 100 # 每个温度下的迭代次数
    alfa = 0.95 # 温度衰减系数
    starttime = time.time()
    print('开始时间：',starttime)
    feasiblesolution = FeasibleSolution()
    #step1随机产生一条路径信息
    oldsolution = feasiblesolution.feasiblesolution_init()
    print('初始路径',oldsolution)
    old_value = calvalue(oldsolution, 10)
    print('初始路径距离',old_value)
    for i in range(maxgen): #外循环 迭代次数
        for j in range(Lk):  #内循环 每个温度下迭代的次数
            #step2计算当前路径的适应度值
            old_value = calvalue(oldsolution,10)
            # print('当前适应度值',value)
            #step3根据初始路径,生成新的路径
            newsolution = get_newsolution(oldsolution)
            # print('新的路径',newsolution)
            new_value = calvalue(newsolution,10)
            # print('新路径适应度值',new_value)
            if new_value<=old_value: #新可行解的适应度值小于旧的  替换掉旧的
                oldsolution = newsolution       #更新路径
            else:
                p = np.exp(-(new_value-old_value)/T) #计算概率
                if rd.random()<p:
                    oldsolution = newsolution #更新路径
        T = T*alfa  #温度下降
    print('最终路径', oldsolution)
    old_value = calvalue(oldsolution, 10)
    print('最终路径距离',old_value)
    stoptime = time.time()  # 结束时间
    print('结束时间：', stoptime)
    print('共用时', stoptime - starttime, '秒')
    for i in oldsolution:
        if i == 0 or i ==99:
            pass
        else:
            x = (i) // 10  # 行 解码  算出此条路经的第i个元素的直角坐标
            y = (i) % 10  # 列
            feasiblesolution.map.data[x][y] = 5  # 将路径用3表示

    plt.imshow(feasiblesolution.map.data, cmap=plt.cm.hot, interpolation='nearest', vmin=0, vmax=10)
    # plt.colorbar()
    xlim(-1, 10)  # 设置x轴范围
    ylim(-1, 10)  # 设置y轴范围
    my_x_ticks = np.arange(0, 10, 1)
    my_y_ticks = np.arange(0, 10, 1)
    plt.xticks(my_x_ticks)
    plt.yticks(my_y_ticks)
    plt.grid(True)
    plt.show()
