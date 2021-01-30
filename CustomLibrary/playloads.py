# -*- coding: utf-8 -*-
import re
import random

"""
test robotframe customLibary
creat by Enler 2020-11-18
"""
import time,json
import datetime

class PlayLoads(object):
    def __init__(self):
        pass

    def add_BsOrganization(self,organname,organid='100000000000000'):
        '''
        添加机构信息
        :param organname:
        :param organid='100000000000000:
        :return: urlplay,playLoad
        '''
        urlplay='/BsOrganization/add.koala'
        playLoad={
            '?': '',
            'organname': organname,
            'organshortname': '',
            'linkman': '',
            'fax': '',
            'phone': '',
            'mailcode': '',
            'email': '',
            'adress': '',
            'memo': '',
            'organtype': '1',
            'uporgan': organid

        }

        return urlplay,playLoad

    def search_BsOrganization(self,organname):
        '''
        查询机构信息
         post请求
        :param organname:
        :return: urlplay, playLoad
        '''
        urlplay =  '/BsOrganization/pageJson.koala'
        playLoad = {
            'page': 0,
            'pagesize': 50,
            'organname': organname
        }
        return urlplay, playLoad
    def search_auth_role_pagingQuery(self,rolename,organname):
        '''
        查询角色
         post请求
        :param rolename:
        :param organname:
        :return:
        '''
        urlplay =  '/auth/role/pagingQuery.koala'
        playLoad = {
            "name": rolename,
            "description": "",
            "organName": organname,
            "pagesize": 50,
            "page": 0
        }
        return urlplay, playLoad

    def add_auth_role(self, organname, ogranId):
        '''
        添加角色
         post请求
        :param organname:
        :param ogranId:
        :return: urlplay, playLoad
        '''
        urlplay = '/auth/role/add.koala'
        playLoad = {
            "name": organname,
            "description": "",
            "organid": ogranId
        }
        return urlplay, playLoad

    def api_auth_menu_findAllMenusTreeByConditions(self, roleid):
        '''
        授权全部菜单资源
        post请求
        :param :roleid
        :param :
        :return:urlplay, playLoad
        '''
        Ids = [1,2,3,5,6,8,672,673,674,675,676,677,678,679,680,681,682,683,684,685,686,687,688,689,690,
               691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,
               713,714,715,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,731,732,733,734,
               735,736,737,738,739,740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,756,
               757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,
               779,780,781,782,783,784,790,791,792,793,795,796,797,799,800,801,802,803,804,805,806,807,
               808,809,810,811,818,819,820,824,825,832,833,835,836,838,839,842,844,845,846,850,854,858,859,860,861,862,863]
        playStr = []
        for id in Ids:
            playStr.append('''menuResourceIds':''' + str(id))
        playLoad = json.dumps(str(playStr))
        urlplay =  '/auth/role/grantMenuResourcesToRole.koala?roleId=' + str(roleid)
        return urlplay, playLoad

    def api_auth_role_grantPageElementResourcesToRole(self, roleid):
        '''
        授权全部页面元素
        post请求
        :param roleid:
        :param pageElementResourceId:
        :return:urlplay, playLoadLst
        '''
        pageElementResourceIds = [9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,
                                  30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,
                                  51,52,53,54,55,56,57,58,59,60,61,252,253,254,255,256,257,259,260,
                                  262,263,265,266,268,269,271,272,273,274,275,276,277,279,280,282,
                                  283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,
                                  299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,
                                  315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,335,
                                  336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,
                                  353,354,355,356,357,358,360,361,362,366,367,368,369,380,381,382,383,
                                  384,385,386,387,388,395,396,397,398,399,400,401,402,403,404,405,406,
                                  407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,
                                  424,425,475,476,477,478,479,493,494,574,575,576,577,578,579,580,581,582,
                                  583,585,586,587,588,589,591,592,593,594,595,596,597,598,603,604,605,606,
                                  607,608,609,610,611,612,613,614,615,616,617,618,619,620,622,639,640,646,
                                  661,662,663,664,665,666,667,668,669,670,671,785,786,787,812,813,814,815,
                                  816,817,821,822,823,826,827,828,829,830,831,841,843,847,848,849,851,852,855]
        urlplay = self.url+ '/auth/role/grantPageElementResourcesToRole.koala'
        playLoadLst=[]
        playLoad = {
            'roleId': roleid,
            "pageElementResourceIds": ''
        }
        for id in pageElementResourceIds:
            playLoad['pageElementResourceIds']=id
            playLoadLst.append(playLoad)

        return  urlplay,playLoadLst

    def add_auth_user(self, organname, ogranId):
        '''
        添加用户
         post请求
        :param organname:
        :param ogranId:
        :return: urlplay, playLoad
        '''
        urlplay = '/auth/user/add.koala'
        playLoad = {
            "name": organname,
            "userAccount": organname,
            "description": "",
            "subid": ogranId,
            "adminuser": ""
        }
        return urlplay, playLoad

    def search_auth_user_pagingQuery(self, username):
        '''
        查询用户
        post请求
        :param username:
        :return: urlplay, playLoad
        '''
        urlplay =  '/auth/user/pagingQuery.koala'
        playLoad = {
            "userid": "",
            "disabled": '',
            "subName": '',
            "pagesize": 50,
            "page": 0,
            "name": username
        }
        return urlplay, playLoad

    def api_DhBlineassignOrgan_BlineassignOrgan(self, userid, organid):
        '''
        分配机构
        post请求
        :param userid:
        :param organid:
        :return: urlplay, playLoad
        '''
        urlplay = '/DhBlineassignOrgan/BlineassignOrgan.koala?operId=' + str(userid)
        playLoad = {
            'roadids': organid

        }
        return urlplay, playLoad

    def api_auth_user_grantRolesToUser(self, userId,roleid):
        '''
        分配角色
        post请求
        :param userId,roleid:
        :return:  urlplay, playLoad
        '''
        urlplay = '/auth/user/grantRolesToUser.koala'
        playLoad = {
            "userId": userId,
            "roleIds": str(roleid)
        }
        return urlplay, playLoad
    def add_DhCommanddeploy(self,ogranid):
        '''
        添加指令配置
        post请求
        :param：ogranid
        :return:  urlplay,playLoadLst
        '''
        commandDictLst=[
            {
                'commandname': '恢复营运',
                'commandid': 106
            },
            {
                'commandname': '停运',
                'commandid': 6

            },
            {
                'commandname': '包车',
                'commandid': 7

            }
        ]
        urlplay='/DhCommanddeploy/add.koala'
        playLoad={
                "commandname": '',
                "commandtype": '非营运',
                'commandid': '',
                'belongto': ogranid,
                'autoAgreePeriodStart':'00:00',
                'autoAgreePeriodEnd':'23:59',
                'instructionExtension':''
        }
        playLoadLst=[]
        for commandDict in commandDictLst:
            playLoad['commandname']=commandDict['commandname']
            playLoad['commandid']=commandDict['commandid']
            playLoadLst.append(playLoad)
        return urlplay,playLoadLst
    def update_DhCommanddeploy(self,id):
        '''
        指令勾选自动同意
       post请求
       :param：id
       :return:  urlplay
       '''
        urlplay='/DhCommanddeploy/update.koala?id={0}&num={1}'.format(str(id),str(4))
        return urlplay

    def search_DhCommanddeploy(self,commandname=''):
        '''
        查询指令
        post请求
        :param：id
        :return:  urlplay, playload
        '''
        urlplay='/DhCommanddeploy/pageJson.koala'
        playload={
            'pagesize': 50,
            'commandname': commandname,
            'commandtype':'',
             'page': 0
        }
        return urlplay, playload
    def get_commandIdLst(self,response):
        idLst = []
        dataLst = response['data']
        for d in dataLst:
            id = d['id']
            idLst.append(id)
        return idLst

if __name__ == '__main__':
    p=PlayLoads()
    #print(p.get_commandIdLst())





