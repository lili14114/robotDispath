# -*- coding: utf-8 -*-
import re

"""
test robotframe customLibary
creat by Enler 2020-11-18
"""
import time,json
import datetime



class MyTools(object):

    def __init__(self):
        pass

    def base64(self,key):
        '''
        将字符串进行base64加密
        :param key:key
        :return: base_key1
         Examples base64 code.
        | `base64` | key |  # return base64code|
        '''
        import base64
        key = str(key)
        key1 = key.encode(encoding='utf-8')
        base_key = base64.b64encode(key1)
        base_key1 = str(base_key, 'utf-8')
        return base_key1

    def get_Mytool_times(self,flag,hours=1):
        """ 支持将当前系统时间进行特定的转换
        如果flag=%Y-%m-%d %H:%M:%S,则生成当前系统%H:%M格式，例如：2020-12-01 11:35:06
        如果flag=%H:%M，则生成当前系统%H:%M格式，例如：11:37
        如果flag=timedelta,hours默认值为1，则生成前hours个小时的时间，返回格式为'%Y-%m-%d %H:%M:%S
        如果flag=datedelta,hours默认值为1，则生成前hours个小时的时间，返回格式为'%Y-%m-%d
        如果flag=hourdelta，hours默认值为1，则生成前hours个小时的时间，返回格式为%H:%M

         Examples get_Mytool_times code.
          | `get_Mytool_times` | %H:%M | # return  11:37|
          | `get_Mytool_times` | %Y-%m-%d %H:%M:%S | # return  2020-12-01 11:35:06 当前系统时间|
          | `get_Mytool_times` | timedelta | # return  2020-12-01 11:35:06 当前系统时间前一个小时|
          | `get_Mytool_times` | timedelta | 2| # return  2020-12-01 11:35:06 当前系统时间前两个小时|
          | `get_Mytool_times` | hourdelta | # return  11:35 当前系统时间前一个小时
          | `get_Mytool_times` | datedelta | # return  2020-12-01当前系统时间前一个小时

        """
        if '%Y-%m-%d %H:%M:%S' in flag:
            result = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))
        elif '%H:%M' in flag:
            result= time.strftime('%H:%M', time.localtime(time.time()))
        elif  'timedelta' in flag:
            t = datetime.datetime.now()
            # 默认获取1小时前
            result = (t - datetime.timedelta(hours=hours)).strftime("%Y-%m-%d %H:%M:%S")
        elif 'datedelta' in flag:
            t = datetime.datetime.now()
            # 默认获取1小时前
            result = (t - datetime.timedelta(hours=hours)).strftime("%Y-%m-%d")
        elif 'hourdelta' in flag:
            #默认获取1小时前
            t = datetime.datetime.now()
            result = (t - datetime.timedelta(hours=hours)).strftime("%H:%M")
        return result
    def get_caronline_json(self,hostcode):
        '''
               返回调度系统车辆上线的json报文,报文类型为dict
               :param key:hostcode
               :return: requestJson
               Examples base64 code.
              | `get_caronline_json` | hostcode |  # return requestJson|

               '''
        playLoad = {"caronline":
                        {"device_type": "000",
                         "device_id": hostcode,
                         "ip": "1000",
                         "port": "8090"}}
        return playLoad
    def get_caroffline_json(self,hostcode):
        '''
      返回调度系统车辆下线的json报文,报文类型为dict
      :param key:hostcode
      :return: requestJson
       Examples base64 code.
      | `get_caroffline_json` | hostcode |  # return requestJson|
                  '''
        playLoad = {
            "caroffline": {
                "is_all": "xxx",  # 是否全部下线。1：是；0：否
                "device_id": hostcode  # 设备ID。如果is_all=1，则该参数可以不提供
            }
        }
        return playLoad
    def get_gps_json(self,hostcode,logitude,latitude):
        '''
        返回调度系统车辆上报GPS的json报文,报文类型为dict
        :param key:hostcode,logitude,latitude
         cmd_time: %Y-%m-%d %H:%M:%S
        :return: requestJson
         Examples base64 code.
        | `get_gps_json` | hostcode |logitude |latitude| # return requestJson|
                            '''
        dtime = datetime.datetime.now()
        cmd_time = int(time.mktime(dtime.timetuple()))
        cmd_time=str(cmd_time)
        playLoad = {
            "gpsinfo": [
                {
                    "device_id": hostcode,  # 设备ID
                    "longitude": longitude,  # 经度。格式：Edddmm.mmmm
                    "latitude": latitude,  # 纬度。格式：Nddmm.mmmm
                    "azimuth": "50",  # 方向角
                    "altitude": 1000,  # 海拔高度。单位：m
                    "speed": speed,  # 速度。单位：km/h
                    "total_mileage": total_mileage,  # 总里程。单位：m
                    "data_create_time": cmd_time  # 数据生成时间。格式：YYYY-MM-DD hh:mm:ss
                }
            ]
        }
        return playLoad
    def get_dispath_json(self,hostcode,business_request_code):
        '''
        返回调度系统车辆上报指令, 报文类型为dict
        :param
        key: hostcode, logitude, latitude
          cmd_time: %Y-%m-%d %H:%M:%S
        :return: requestJson
         Examples get_dispath_json code.
        | `get_dispath_json` | hostcode | business_request_code| # # return  dispathcodeJson|

        '''
        dtime = datetime.datetime.now()
        cmd_time = int(time.mktime(dtime.timetuple()))
        cmd_time = str(cmd_time)
        extend = {"serial_num": 3, "line_num": "XXX", "employee_num": "XXX",
                  "business_request_code": business_request_code}
        extend=json.dumps(extend)
        playLoad = {
            "cmdinfo": {
                "cmd": "022006",
                "cmd_time": cmd_time,
                "device_id": hostcode,
                "extend": extend
            }
        }
        return playLoad

    def get_dispatchEmployee_json(self,hostcode,employee_num):
        '''
       返回调度系统司机打卡 报文类型为dict
       :param
       key: hostcode, employee_num
       cmd_time: %Y-%m-%d %H:%M:%S
       :return: requestJson
        Examples get_dispatchEmployee_json code.
       | `get_dispatchEmployee_json` | hostcode | employee_num| # # return  requestJson|

       '''
        dtime = datetime.datetime.now()
        cmd_time = int(time.mktime(dtime.timetuple()))
        cmd_time = str(cmd_time)
        check_time = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))
        extend={
                    "line_num": "XXX",
                    "employee_num": employee_num,
                    "check_type": 1,
                    "check_way": 1,
                    "check_time": check_time
                }
        extend=json.dumps(extend)
        playLoad={

            "cmdinfo": {
                "cmd": "022001",
                "cmd_time": cmd_time,
                "device_id": hostcode,
                "extend":extend
        }
        }

        print(playLoad)
        return playLoad
    def get_dispatchPassenger_json(self,hostcode,longitude,latitude,site_number,door_number,get_on_cnt,get_off_cnt):
        '''
          返回调度系统司机打卡 报文类型为dict
          :param
          key: hostcode, employee_num
          :return: requestJson
           The ``site_number`` argument 指站点编号
           The ``door_number`` argument 指门编号，1：前门  2：中门  3：后门
           The ``get_on_cnt`` argument 指上车乘客数
           The ``get_off_cnt`` argument 指下车乘客数

           Examples get_dispatchEmployee_json code.
          | `get_dispatchPassenger_json` | hostcode | longitude| latitude|site_number|door_number|get_on_cnt|get_off_cnt| # return  requestJson|

          '''
        dtime = datetime.datetime.now()
        cmd_time = int(time.mktime(dtime.timetuple()))
        cmd_time = str(cmd_time)

        extend={
                    {
                        "longitude": longitude,
                        "latitude": latitude,
                        "site_number": site_number,  # 定点编号
                        "door_number": door_number,  # 门编号
                        "get_on_cnt": get_on_cnt,  # 上车乘客数
                        "get_off_cnt": get_off_cnt  # 下车乘客数
                    }}
        extend=json.dumps(extend)
        playLoad = {
            "cmdinfo": {
                "cmd": "022011",
                "cmd_time": cmd_time,
                "device_id": hostcode,
                "extend": extend
            }
        }
        return playLoad
    def get_dispathDevice_json(self,hostcode,origin_line_no,target_line_no):
        '''
          返回调度系统切换线路上报 报文类型为dict
          :param
          key: hostcode, rigin_line_no,target_line_no
          :return: requestJson

           The ``origin_line_no`` argument 原线路编号

           The ``target_line_no`` argument 目标线路编号

           Examples get_dispathDevice_json code.
          | `get_dispathDevice_json` | hostcode | origin_line_no| target_line_no|# return  requestJson|

        '''
        dtime = datetime.datetime.now()
        cmd_time = int(time.mktime(dtime.timetuple()))
        cmd_time = str(cmd_time)
        extend= {"origin_line_no": origin_line_no,
                    "target_line_no": target_line_no}
        extend=json.dumps(extend)

        playLoad = {
            "cmdinfo": {
                "cmd": "022015",
                "cmd_time": cmd_time,
                "device_id": hostcode,
                "extend": extend
            }
        }
    def get_time_difference(self,timeLst):
        '''
        将HH:MM时间进行相差，返回发车间隔列表
        :param key:timeLst
        :return: resultLst
         Examples get_time_difference code.
        | `get_time_difference` | timeLst   |  # return resultLst float类型|
        | `get_time_difference` | #['11:00', '11:20', '11:30' ] |  # return [20, 10]|
        '''

        resultLst = []
        for i in range(len(timeLst)):
            timeLst[i] = datetime.datetime.strptime(timeLst[i], '%H:%M')
        timeLst = sorted(timeLst, reverse=False)
        print(timeLst)
        for i in range(0, len(timeLst) - 1):
            diff = (timeLst[i + 1] - timeLst[i]).seconds
            resultLst.append(diff / 60)

        return resultLst
    def str_To_list(self,string,sep=' '):
        '''
        将字符串转换成列表形式，默认通过空格符进行分割
        :param key:string,sep
        :return: resultLst
         Examples str_To_list code.
        | `strTolist` | string   |  # return resultLst |
        | `strTolist` | string | ','  |  # 以逗号进行分割，eturn resultLst |
        '''
        recordLst=string.split(sep)
        recordLst = list(filter(None, recordLst))
        return recordLst
    def should_Contain_multiValue(self,stringLst,targetLst,count=None):
        '''
        增加报表目标值检测功能
        确认多个值是否存在此列表中的某个值中。例如：查询出所有路单记录，验证某台车的路单状态是否存在路单记录中

       :param :
           stringLst--> 查询报表的结果，接收列表格式
           targetLst --> 目标值验证，接收列表格式
           count -->查询结果的数量，默认不验证。如果count！=None时，则需要验证查询出来报表明细数量。
       :return: bool
        Examples get_time_difference code.
       | `should_Contain_multiValue` |  ['运行中，robot1,日班|运营'，‘运行中’]|  ['运行中，robot1' |  # return True |
         | `should_Contain_multiValue` |  ['运行中，robot1,日班|运营'，‘运行中’]|  ['运行中，robot2'] |  # return False |
          | `should_Contain_multiValue` |  ['运行中，robot1,日班|运营'，‘运行中’]|  ['运行中，robot2'] |9 |  # return False |
       '''

        flag=True
        length=len(stringLst)
        if length==0:
            return False
        for i in range(length):
            for target in targetLst:
                if target  not in stringLst[i]:
                    flag = False
            if flag == True:break   # 第一层循环结束后，判断flag_2的值是否为True，如果为True,则直接说明该列表的值都存在此字符串中
            if i!=length-1:flag=True #如果不是最后一次循环则要重置flag初始值
        if count!=None:
            if count!=length:
                flag=False
        return flag
    def main_vice_BusValidation(self,main_record,vice_recordLst):
        '''
        验证行车记录主表车牌号和车辆编号是否与副表明细数据一一对应。
       :param :
       main_record--> 主表的一条数据
       vice_recordLst --> 副表的全部记录，list列表
       :return: bool
        Examples get_time_difference code.
       | `main_vice_BusValidation` |  ${main_record}|  ${vice_recordLst} |  # return bool |
       '''
        main_record = main_record.split(' ')
        flag = True
        if len(vice_recordLst) == 0:
            flag = False
        for j in range(2,4):
            for i in range(len(vice_recordLst)):
                if  main_record[j] not in vice_recordLst[i]:
                    flag = False
                    break
        return  flag
    def main_vice_DriverValidation(self,main_record,vice_recordLst):
        '''
        验证行车记录主表司机和司机趟次是否与副表明细数据一一对应。
        :param main_record: 主表的一条数据
        :param vice_recordLst: 副表的全部记录，list列表
        :return:  | `main_vice_BusValidation` |  ${main_record}|  ${vice_recordLst} |  # return bool |
        '''

        '''1、通过正则表达式抽取司机关键信息'''
        main_record=main_record.split(' ')
        driver=main_record[4]
        pattern_driver=r'\(\d+.\d+\)'
        driverLst=re.split(pattern_driver,driver)

        pattern_tripNo=r'\d+.\d+'
        reg=re.compile(pattern_tripNo)
        tripNoLst=re.findall(reg,driver)

        driver_trip_Lst=zip(driverLst,tripNoLst)

        '''2、对副表的处理办法：
         第一步：将无效趟次数据从列表中去掉，只保留有效的数据。 
         第二步:针对单个司机和多个司机进行分类处理
        '''
        flag = True
        unKownDriverCount=0  #未知司机的初始数量
        length=len(vice_recordLst)
        if length == 0:
            return False
        for i in range(len(vice_recordLst)-1,-1,-1):
            if '有效' not in vice_recordLst[i]:
                vice_recordLst.pop(i)
        #如果司机只有一位，则可以直接等出结果
        if len(driverLst)==1:
            driver_trip_Lst[0][1] != len(vice_recordLst)
            return False
        else:
            #多位司机的处理方法
            for driver, tripNo in driver_trip_Lst:
                tripNo = float(tripNo)
                if driver != '未知司机':
                    '''
                    1、：按照司机姓名，将相同姓名的司机放至一个列表   
                    2、：将第二步生成的列表转换一个字符串 
                    3、：用str.count方法来匹配司机对应的数量的路单数
                    4、处理完已知司机，将已处理的列表进行删除,即么剩下的就是未知司机的路单数了。
                    '''
                    newLst = []
                    vice_Length=len(vice_recordLst)
                    for j in range(vice_Length-1,0,-1):
                        if driver in vice_recordLst[j]:
                            newLst.append(vice_recordLst[j])
                            vice_recordLst.pop(j)
                            # del vice_recordLst[j]
                else:
                    unKownDriverCount = int(tripNo)
            #否则剩下的就是未知司机的单数
            if unKownDriverCount!=len(vice_recordLst):
                return False
        return flag





if __name__ == '__main__':
    mytool=MyTools()
    main_record='37路33 enler f39756 f39756 未知司机(15.0) 15.0 405.00 108.26 -296.74 0.00 0.00 0.00 0.00 0.00 108.26 0.00 110.68'
    vice_recordLst=['f39756\n自动 enler 2020-12-12 运营路单 1.00 0 已完成 无效 上行 02:55:03 四中新校区 霞山总站 2020-12-12 2020-12-12 02:55:03 晚54分钟 03:49:51 54.80 7.90 27.00 日班|营运 2020-12-12 15:41:15 线路完整', 'f39756\n自动 系统 2020-12-12 运营路单 15 1.00 已完成 有效 下行 02:17:36 霞山总站 四中新校区 2020-12-12 2020-12-12 02:17:36 晚34分钟 02:52:18 34.70 6.62 27.00 日班|营运 2020-12-12 02:57:03 线路完整', 'f39756\n自动 系统 2020-12-12 运营路单 14 1.00 已完成 有效 上行 01:15:58 四中新校区 霞山总站 2020-12-12 2020-12-12 01:15:58 晚54分钟 02:10:46 54.80 7.90 27.00 日班|营运 2020-12-12 02:12:37 线路完整', 'f39756\n自动 系统 2020-12-12 运营路单 13 1.00 已完成 有效 下行 00:40:23 霞山总站 四中新校区 2020-12-12 2020-12-12 00:40:23 晚32分钟 01:13:13 32.83 6.62 27.00 日班|营运 2020-12-12 01:17:44 线路完整', 'f39756\n自动 系统 2020-12-11 运营路单 12 1.00 已完成 有效 上行 23:38:45 四中新校区 霞山总站 2020-12-12 2020-12-12 00:23:45 晚9分钟 00:33:33 54.80 7.90 27.00 日班|营运 2020-12-12 00:34:22 线路完整', 'f39756\n自动 系统 2020-12-11 运营路单 11 1.00 已完成 有效 下行 23:01:17 霞山总站 四中新校区 2020-12-11 2020-12-11 23:36:17 准点 23:36:00 34.72 6.62 27.00 日班|营运 2020-12-11 23:36:47 线路完整', 'f39756\n自动 系统 2020-12-11 运营路单 10 1.00 已完成 有效 上行 21:59:39 四中新校区 霞山总站 2020-12-11 2020-12-11 22:44:39 晚9分钟 22:54:27 54.80 7.90 27.00 日班|营运 2020-12-11 22:55:54 线路完整', 'f39756\n自动 系统 2020-12-11 运营路单 9 1.00 已完成 有效 下行 21:24:09 霞山总站 四中新校区 2020-12-11 2020-12-11 21:59:09 早2分钟 21:56:54 32.75 6.62 27.00 日班|营运 2020-12-11 21:58:31 线路完整', 'f39756\n自动 系统 2020-12-11 运营路单 8 1.00 已完成 有效 上行 20:22:26 四中新校区 霞山总站 2020-12-11 2020-12-11 21:07:26 晚9分钟 21:17:14 54.80 7.90 27.00 日班|营运 2020-12-11 21:17:33 线路完整', 'f39756\n自动 系统 2020-12-11 运营路单 7 1.00 已完成 有效 下行 19:44:58 霞山总站 四中新校区 2020-12-11 2020-12-11 20:19:58 准点 20:19:41 34.72 6.62 27.00 日班|营运 2020-12-11 20:20:09 线路完整', 'f39756\n自动 系统 2020-12-11 运营路单 6 1.00 已完成 有效 上行 18:43:20 四中新校区 霞山总站 2020-12-11 2020-12-11 19:28:20 晚9分钟 19:38:08 54.80 7.90 27.00 日班|营运 2020-12-11 19:39:16 线路完整', 'f39756\n自动 系统 2020-12-11 运营路单 5 1.00 已完成 有效 下行 18:07:45 霞山总站 四中新校区 2020-12-11 2020-12-11 18:42:45 早2分钟 18:40:35 32.83 6.62 27.00 日班|营运 2020-12-11 18:41:52 线路完整', 'f39756\n自动 系统 2020-12-11 运营路单 4 1.00 已完成 有效 上行 17:06:07 四中新校区 霞山总站 2020-12-11 2020-12-11 17:51:07 晚7分钟 17:59:02 52.92 7.90 27.00 日班|营运 2020-12-11 18:00:58 线路完整', 'f39756\n自动 系统 2020-12-11 运营路单 3 1.00 已完成 有效 下行 16:28:38 霞山总站 四中新校区 2020-12-11 2020-12-11 17:03:38 准点 17:03:22 34.73 6.62 27.00 日班|营运 2020-12-11 17:03:28 线路完整', 'f39756\n自动 系统 2020-12-11 运营路单 2 1.00 已完成 有效 上行 15:25:00 15:26:24 晚1分钟 四中新校区 霞山总站 2020-12-11 2020-12-11 16:10:00 晚11分钟 16:21:48 55.40 7.90 27.00 日班|营运 2020-12-11 16:22:35 线路完整', 'f39756\n自动 系统 2020-12-11 运营路单 1 1.00 已完成 有效 下行 14:50:00 14:50:49 晚0分钟 霞山总站 四中新校区 2020-12-11 2020-12-11 15:25:00 早1分钟 15:23:39 32.83 6.62 27.00 日班|营运 2020-12-11 15:25:06 线路完整']
    flag=mytool.main_vice_DriverValidation(main_record,vice_recordLst)

    print(flag)






