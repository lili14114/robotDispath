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
def getVariables(env='183_8074'):
    if env=='183_8074':
        DICT__variables={
            'ip':"http://10.200.9.183:8074",
            'username':"enler",
            'password':'888888',
            'roadXpath_diagram':'id=mtLocationRunDiagramTree_2_span',   #简图树形菜单线路元素地址，例如：简图树形菜单37路100
            'roadname':'31路100',
            'drivername':'张五',
            'subid':'200612134458980',
            'roadid':'417768025',
            'belongto':'100003',
             'iframe_tab': 'id=iframe_tab_BsBusdiagarm-Maplist-417768025',  #简图37路100的主frame
            'iframe_line':'css=#line_417768025',#简图37路100副frame
            'myDB':{
                'host':'10.200.9.183',
                'port':3306,
                'user':'root',
                'password':'jgx7e32cv'
            },
            'bus_1': {
                'internalNo': 'robot1',
                'hostcode': 'robot1',
                'bustid': '201126142457482'},
            'bus_2': {
                'internalNo': 'robot2',
                'hostcode': 'robot2',
                'bustid': '201128093425842'},
            'bus_3': {
                'internalNo': 'robot3',
                'hostcode': 'robot3',
                'bustid': '201128093440756' },
            'bus_4': {
                'internalNo': 'robot4',
                'hostcode': 'robot4',
                'bustid': '201128111921140' },
            'bus_5': {
                'internalNo': 'robot5',
                'bustid': '201128113217254' }
        }

    elif env == '186_8089':
        DICT__variables = {
            'ip': "http://139.9.1.186:8089",
            'username': "huang",
            'password': '888888',
            'roadXpath_diagram': 'id=mtLocationRunDiagramTree_2_span',  # 简图树形菜单线路元素地址，例如：简图树形菜单37路100
            'roadname': '101路',
            'drivername': '周某人',
            'subid': '191104094314987',
            'roadid': '200415180706666',
            'belongto': '100009',
            'iframe_tab': 'id=iframe_tab_BsBusdiagarm-Maplist-200415180706666',  #章丘公交测试环境8089，简图101路主frame
            'iframe_line':'css=#line_200415180706666',#简图101路副frame
            'myDB': {
                'host': '10.200.9.183',
                'port': 3306,
                'user': 'root',
                'password': 'jgx7e32cv'
            },
            'bus_1': {
                'internalNo': 'robot1',
                'bustid': '201208150449951',
                'hostcode':'robot1'
            },

            'bus_2': {
                'internalNo': 'robot2',
                'hostcode': 'robot2',
                'bustid': '201208150458447'},
            'bus_3': {
                'internalNo': 'robot3',
                'hostcode': 'robot3',
                'bustid': '201208150505600'},
            'bus_4': {
                'internalNo': 'robot4',
                'hostcode': 'robot4',
                'bustid': '201208150513188'},
            'bus_5': {
                'internalNo': 'robot5',
                'hostcode': 'robot5',
                'bustid': '201208150523825'}

        }
        # 全局变量，不区分运行环境
    # globalvars = {'test1': '3456', 'test2': '6'}
    # DICT__variables['globalvars'] = globalvars  # RF中取值用${globalvars['userID']}
    else:
        DICT__variables = {
            'ip': "www.baidu.com",
            'username': "huang",
            'password': '888888',
            'roadXpath_diagram': 'id=mtLocationRunDiagramTree_2_span',  # 简图树形菜单线路元素地址，例如：简图树形菜单37路100
            'subid': '191104094314987',
            'roadid': '200415180706666',
            'belongto': '100009',
            'iframe_tab': 'id=iframe_tab_BsBusdiagarm-Maplist-200415180706666',  # 章丘公交测试环境8089，简图101路主frame
            'iframe_line': 'css=#line_200415180706666',  # 简图101路副frame
            'bus_1': {
                'internalNo': 'weiyan',
                'bustid': '201208150449951',
                'hostcode': 'robot1'
            },

            'bus_2': {
                'internalNo': 'robot2',
                'hostcode': 'robot2',
                'bustid': '201208150458447'},
            'bus_3': {
                'internalNo': 'robot3',
                'hostcode': 'robot3',
                'bustid': '201208150505600'},
            'bus_4': {
                'internalNo': 'robot4',
                'hostcode': 'robot4',
                'bustid': '201208150513188'},
            'bus_5': {
                'internalNo': 'robot5',
                'hostcode': 'robot5',
                'bustid': '201208150523825'}

        }
    return DICT__variables
if __name__ == '__main__':
   print( type(getVariables()))


