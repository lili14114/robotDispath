# -*- coding: utf-8 -*-
import re
import random

"""
test robotframe customLibary
creat by Enler 2020-11-18
"""
import time,json
import pandas as pd
import csv


class FileTools(object):
    def __init__(self):
        pass

    def read_file_pd(self,filepath):
        '''
        通过pandas读取文件
         :param filePath: 文件地址
        :return: dataframe文件
        '''
        data=pd.read_csv(filepath)
        # data.columns=['A','B','C','D','E']
        print(data)

    # 读文件内容
    def read_file(self,file):
        with open(file, encoding='UTF-8') as f:
            read_all = f.read()
            f.close()
        return read_all
    #传入文件，将旧内容替换为新内容（new_content)
    def replace(self,file, new_file,old_content, new_content):
        content = self.read_file(file)
        content = content.replace(old_content, new_content)
        self.rewrite_file(new_file, content)

    # 写内容到文件
    def rewrite_file(self,file, data):
        with open(file, 'w', encoding='UTF-8') as f:
            f.write(data)
            f.close()
        content=self.read_file(file)
        print('new',content)
    #批量更改sql文件
    def replace_sql_dispath(self,filePath,belongto,subid,organname):
        '''
        批量修改sql文件，用于快速插入压测数据
        执行前，确保所有的sql中的belongto=100003，subid=210120134316294， empbusActual和empbusplan_index中的日期为2021-01-29。否则建议手动修改
        执行完毕后，修改后sql文件存在filepath目录下
        将修改的文件如下:
         roadinfo=r'\bs_roadinfo.sql'
        roadsite=r'\bs_roadsite.sql.'
        bussite=r'\bs_bussite.sql'
        empinfo=r'\bs_empinfo.sql'
        empbusplan=r'\dh_empbusplan_index.sql'
        empbusActual=r'\dh_empbusActual_detail.sql'

        :param filePath: sql文件所在的目录地址
        :param belongto:
        :param subid:
        :return:

        例如：
         filepath=r'D:\test_tools\Bus_Server_5871_37路_基本资料'
         belongto='100001059'
         subid='210201164056412'
         organname='robottest'
         replace_sql_dispath(filepath,belongto,subid,organname)
        '''
        # file=r'D:\test_tools\Bus_Server_5871_37路_基本资料'
        #线路信息，将'100003'，替换成目标belongto.; '210120134316294'，替换成目标subid ;  VALUES (  替换成VALUES (99 ;  2021-01-29 替换成当前系统时间
        t = time.strftime('%Y-%m-%d', time.localtime(time.time()))
        roadinfo=r'\bs_roadinfo.sql'
        roadsite=r'\bs_roadsite.sql.'
        bussite=r'\bs_bussite.sql'
        empinfo=r'\bs_empinfo.sql'
        empbusplan=r'\dh_empbusplan_index.sql'
        empbusActual=r'\dh_empbusActual_detail.sql'
        pathLst=[roadinfo,roadsite,bussite,empinfo,empbusplan,empbusActual]
        contentLst=[("'100003'","'{0}'".format(belongto)),("'210120134316294'","'{0}'".format(subid)),("VALUES ( ","VALUES (99"),("2021-01-29",t),("stress",organname)]

        for path in pathLst:
            resouce_path = filePath + path
            goal_path = filePath + path + t
            data = self.read_file(resouce_path)
            for content in contentLst:
                data=data.replace(content[0],content[1])
            self.rewrite_file(goal_path,data)
    def read_csv_file(self,start=0):
        '''
        读取businfo，csv表数据。
        length为csv的行数
        :param filepath: csv表数据所在的目录
        :param start:  开始的行数
        :return:  截止的行数，internalno,hostcode,busplate,length
        '''
        filepath=r'D:\test_tools\dispath\dispath\db\bs_businfo_zj37_zj_term_5871_gps.db.csv'
        rows = [row for row in filepath]
        length=rows.__len__()
        internalno = rows[start][3]
        hostcode = rows[start][2]
        busplate = rows[start][4]
        return internalno,hostcode,busplate,length






if __name__ == '__main__':
    F=FileTools()
    filepath=r'D:\test_tools\Bus_Server_5871_37路_基本资料'
    belongto='100001059'
    subid='210201164056412'
    organname='robottest'
    F.replace_sql_dispath(filepath,belongto,subid,organname)






