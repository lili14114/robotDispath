# robotDispath
[dropdown_menuDict]

	mapGPS=xpath=//a[contains(text(),"定位") and @tabindex='-1']  #定位
	roadGPS=xpath=//a[contains(text(),"线路") and @tabindex='-1'] #线路和切换线路
	GPS_history=xpath=//a[contains(text(),"轨迹") and @tabindex='-1']#轨迹，取最后一个
	video=xpath=//a[contains(text(),"视频") and @tabindex='-1']#视频
	IPconnect=xpath=//a[contains(text(),"IP通话") and @tabindex='-1']#IP通话
	alarm=xpath=//a[contains(text(),"报警") and @tabindex='-1']#报警
	busReport=xpath=//a[contains(text(),"路单") and @tabindex='-1']#路单，取最后一个
	notify=xpath=//a[contains(text(),"通知") and @tabindex='-1']#通知
	hand_assigh=xpath=//a[contains(text(),"代发") and @tabindex='-1']#代发
	short_dispath=xpath=//a[contains(text(),"临时调度") and @tabindex='-1']#临时调度
	annular_dispath=xpath=//a[contains(text(),"环形调度") and @tabindex='-1']#环形调度
	adjust_plantime=xpath=//a[contains(text(),"计划调整") and @tabindex='-1']#计划调整 
	cancle_plantime=xpath=//a[contains(text(),"取消计划") and @tabindex='-1']#取消计划
	stop_plantime=xpath=//a[contains(text(),"停用排班") and @tabindex='-1']#停用排班 
	goToSite= xpath=//a[contains(text(),"进站") and @tabindex='-1']#进站
	outSite=xpath=//a[contains(text(),"出站") and @tabindex='-1']#出站 
	driver=xpath=//a[contains(text(),"司机") and @tabindex='-1']#司机 ，取最后一个
[]

