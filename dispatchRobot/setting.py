#!usr/bin/env python
# -*- coding:utf-8 _*-
"""
@author: lixiaofeng
@file: setting.py
@time: 2020/12/08
@desc:
格式化代码 : Ctrl + Alt + L
运行代码 : Ctrl + Shift + F10
"""
def getVariables(env='8047'):
    if env=='8047':
        DICT__variables={
            'ip':"http://10.200.9.183:8074",
            'username':"enler",
            'password':'888888',
            'roadXpath_diagram':'id=mtLocationRunDiagramTree_6_span',   #简图树形菜单线路元素地址，例如：简图树形菜单37路100
            'subid':'200612134458980',
            'roadid':'417768025',
            'belongto':'100003',
            'DeviceLst':[
                {'bus_1':{
                    'internalNo': 'robot1',
                    'bustid': '201126142457482' }},
                {'bus_2':{
                    'internalNo': 'robot2',
                    'bustid': '201128093425842'}},
                {'bus_3':{
                    'internalNo': 'robot3',
                    'bustid': '201128093440756'
                }},
                {'bus_4': {
                    'internalNo': 'robot4',
                    'bustid': '201128111921140'
                }},
                {'bus_5': {
                    'internalNo': 'robot5',
                    'bustid': '201128113217254'
                }}
            ]


        }
    else:
        DICT__variables = {
            'ip': "http://139.9.1.186:8089",
            'username': "huang",
            'password': '888888',
            'roadXpath_diagram': 'id=mtLocationRunDiagramTree_2_span',  # 简图树形菜单线路元素地址，例如：简图树形菜单37路100
            'subid': '191104094314987',
            'roadid': '200415180706666',
            'belongto': '100009',
            'DeviceLst': [
                {'bus_1': {
                    'internalNo': 'robot1',
                    'bustid': '201208150449951'}},
                {'bus_2': {
                    'internalNo': 'robot2',
                    'bustid': '201208150458447'}},
                {'bus_3': {
                    'internalNo': 'robot3',
                    'bustid': '201208150505600'
                }},
                {'bus_4': {
                    'internalNo': 'robot4',
                    'bustid': '201208150513188'
                }},
                {'bus_5': {
                    'internalNo': 'robot5',
                    'bustid': '201208150523825'
                }}
            ]

        }
        # 全局变量，不区分运行环境
    globalvars = {'test1': '3456', 'test2': '6'}
    DICT__variables['globalvars'] = globalvars  # RF中取值用${globalvars['userID']}
    return DICT__variables
if __name__ == '__main__':
   print( type(getVariables()))

