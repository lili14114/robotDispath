# -*- coding: utf-8 -*-
import pandas as  pd

import os

BASE_DIR = os.path.split(os.path.realpath(__file__))[0]
db_dirs = os.path.join(BASE_DIR, 'db')

class MyPandas:
    def __init__(self):
        pass
    def read_csv_data(self,filename):

        """
        read csv_file,return self.data,self.rows,self.columns
        返回list--> [self.data,self.rows,self.columns]
        self.data  #所有数据
        self.rows  #总行数
        self.columns  #总列数
        示例：

        """
        file_dirs = os.path.join(db_dirs, filename)
        # file_dirs=os.path.join(db_dirs, 'bs_businfo_zj37_zj_term_5871_gps.db.csv')

        self.data=pd.read_csv(file_dirs,encoding='utf-8')
        self.rows=self.data.shape[0]  #总行数
        self.columns=self.data.shape[1]  #总列数
        return [self.data,self.rows,self.columns]

    def read_line(self,row):
        """
        按行读取数据，返回list
        """

        return list(self.data.loc[row].values[0:-1])
        
        

if __name__ == '__main__':
    # myPandas=MyPandas()
    # filename="bs_businfo_zj37_zj_term_5871_gps.db.csv"
    # res=myPandas.read_csv_data(filename)
    #
    # for i in range(res[1]):
    #     line=myPandas.read_line(i)
    #     print(line)
    BASE_DIR = os.path.split(os.path.realpath(__file__))[0]
    db_dirs = os.path.join(BASE_DIR, 'db')
    print(db_dirs)










