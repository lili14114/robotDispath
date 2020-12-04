# -*- coding: utf-8 -*-

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
        如果flag=%H:%M，则生成当前系统%H:%M格式，例如：11:37
        如果flag=timedelta,hours默认值为1，则生成前hours个小时的时间，返回格式为'%Y-%m-%d %H:%M:%S

         Examples get_Mytool_times code.
          | `get_Mytool_times` | %H:%M | # return  11:37|
          | `get_Mytool_times` | %Y-%m-%d %H:%M:%S | # return  2020-12-01 11:35:06 当前系统时间|
          | `get_Mytool_times` | timedelta | # return  2020-12-01 11:35:06 当前系统时间前一个小时|
          | `get_Mytool_times` | timedelta | 2| # return  2020-12-01 11:35:06 当前系统时间前两个小时|

        """
        if '%Y-%m-%d %H:%M:%S' in flag:
            result = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))
        elif '%H:%M' in flag:
            result= time.strftime('%H:%M', time.localtime(time.time()))
        elif  'timedelta' in flag:
            t = datetime.datetime.now()
            # 默认获取1小时前
            result = (t - datetime.timedelta(hours=hours)).strftime("%Y-%m-%d %H:%M:%S")

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



if __name__ == '__main__':
   # mytool=MyTools()
   # print(mytool.get_concrete_times('%H:%M'))

   t1='11:20'
   t2='11:05'
   t3='11:17'
   timeLst=[t1, t2, t3]
   resultLst=[]
   for i in range(len(timeLst)):
       timeLst[i] = datetime.datetime.strptime(timeLst[i], '%H:%M')
   timeLst=sorted(timeLst,reverse=False)
   print(timeLst)
   for i in range(0,len(timeLst)-1):
        diff=int((timeLst[i+1]-timeLst[i]).seconds)
        resultLst.append(int(diff/60))

   print(resultLst)