# robotDispath
[menuDict]

	operative_monitor=xpath=//a[@href='#menuMark181']   #运营监控
	diagram_disapth=css=li[data-mark='menuMark214']   #简图调度
	busrecordPage=css=li[data-mark='menuMark228']  #行车记录

[ImplementtingRecord_menuDict]

	  xchangeCar对调车位,
	  insertCar车辆插队,
	  finishRoadPlan完成路单,
	  replaceCar替换车辆,
	  replaceDriver替换司机,
	  changePlantime更改计划时间,
	  supplementaryDriver补录司机,
	  addPlan增加计划,
	  abandonPlan计划烂班,
	  deletePlan删除计划,
	  deletePlan删除计划,
	  addMemo修改备注,
	  trackplayback轨迹回放
		

[dropdown_menuDict]

	mapGPS=xpath=//a[contains(text(),'定位') and @tabindex='-1']  #定位
	roadGPS=xpath=//a[contains(text(),'线路') and @tabindex='-1'] #线路和切换线路
	GPS_history=xpath=//a[contains(text(),'轨迹') and @tabindex='-1']#轨迹，取最后一个
	video=xpath=//a[contains(text(),'视频') and @tabindex='-1']#视频
	IPconnect=xpath=//a[contains(text(),'IP通话') and @tabindex='-1']#IP通话
	alarm=xpath=//a[contains(text(),'报警') and @tabindex='-1']#报警
	busReport=xpath=//a[contains(text(),'路单') and @tabindex='-1']#路单，取最后一个
	notify=xpath=//a[contains(text(),'通知') and @tabindex='-1']#通知
	hand_assigh=xpath=//a[contains(text(),'代发') and @tabindex='-1']#代发
	short_dispath=xpath=//a[contains(text(),'临时调度') and @tabindex='-1']#临时调度
	annular_dispath=xpath=//a[contains(text(),'环形调度') and @tabindex='-1']#环形调度
	adjust_plantime=xpath=//a[contains(text(),'计划调整') and @tabindex='-1']#计划调整 
	cancle_plantime=xpath=//a[contains(text(),'取消计划') and @tabindex='-1']#取消计划
	stop_plantime=xpath=//a[contains(text(),'停用排班') and @tabindex='-1']#停用排班 
	goToSite= xpath=//a[contains(text(),'进站') and @tabindex='-1']#进站
	outSite=xpath=//a[contains(text(),'出站') and @tabindex='-1']#出站 
	driver=xpath=//a[contains(text(),'司机') and @tabindex='-1']#司机 ，取最后一个
	quick_input=xpath=//a[contains(text(),'快速补录') and @tabindex='-1']#快速补录
	
[report_XpathDict]
	roadRecord_1=css=#road_order_detail_grid1_417768025>div>table>tbody>tr>td>div[class='grid-body']>div[class='grid-table-body']>table>tbody>tr  #简图调度下方路单
	roadRecord_2=xpath=//div[@class='grid-table-body' and @style='width: 1170px; height: 320px; position: relative;']/table/tbody/tr    #简图-车辆-路单
[TestCase]
    create bsRecord_bsBusdiagrame_bus #简图-车辆路单-运营路单补录
	


