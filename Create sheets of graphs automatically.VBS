'-------------------------------------------------------------------------------
'-- VBS script file
'-- Created on 06/07/2018 15:35:31
'-- Author: Chris Kingswood
'-- Comment: automatically creates sheets of graphs from existing channels, formats the graphs, displays, positions cursors etc
'-------------------------------------------------------------------------------
Option Explicit  'Forces the explicit declaration of all the variables in a script.
Dim Area, Graph, Curve, Curve2, curve3, curve4, speed, railP, InletP, ReturnP, InletT, rtnT, deltaT, rtnflow, HPflow
Dim WR_Time_X, WR_engine_speed, WR_pump_speed, WR_railP, WR_HPflow, WR_HPflow_mlmin, WR_pump_load, WR_ramp_rate, ChLen
' change the following variable names if they change from rig to rig, Blois may be different names?
'--1HZ DATA  CHANNELS
speed = "MOT_SPEED1"
railP =  "IN_Rail_pressure_feedback1"
InletP = "10cm_PP_IN_P1"
ReturnP = "10cm_PP_BLK_P1"
InletT = "10cm_PP_IN_T1"
deltaT = "PP_DELTA_T1"
rtnT = "10cm_PP_BLK_T1"
rtnflow = "PP_BLK_Q1"
HPflow = "PP_OU_Q1"
ChLen = ChnLength("MOT_SPEED1")
'--DEMAND Work request CHANNELS
WR_Time_X = "Accum.  Test time (S)"
WR_engine_speed = "Engine Speed (Rpm)"
WR_pump_speed = "Pump Speed (Rpm)"
WR_railP =  "Rail Pressure (bar)"
WR_HPflow = "HP Flow (l\hr)"
WR_HPflow_mlmin = "HP Flow (ml\min)"
WR_pump_load = "Pump Load (%)"
WR_ramp_rate = "Ramp Rate"

Call View.Sheets.Add("Speed & RP") '... View.Activesheet.Name
Call View.Sheets.Add("Pressures") '... View.Activesheet.Name
Call View.Sheets.Add("Temps") '... View.Activesheet.Name
Call View.Sheets.Add("Flows") '... View.Activesheet.Name
Call View.Sheets.Add("WR_only1") '... View.Activesheet.Name
Call View.Sheets.Add("WR_only2") '... View.Activesheet.Name
Call View.Sheets.Add("WR_only3") '... View.Activesheet.Name

call View.Sheets("Speed & RP").Areas("Area : 1").SplitTop("TopArea",0.33)
call View.Sheets("Speed & RP").Areas("Area : 1").SplitBottom("BottomArea",0.5)
View.Sheets("Speed & RP").Areas("TopArea").DisplayObjType = "CurveChart2D"
View.Sheets("Speed & RP").Areas("Area : 1").DisplayObjType = "CurveChart2D"
View.Sheets("Speed & RP").Areas("BottomArea").DisplayObjType = "CurveChart2D"
View.Sheets("Speed & RP").Cursor.Type = "Band"
View.Sheets("Speed & RP").Areas("Area : 1").DisplayObj.XScalingMode = "RangeScroll"
View.Sheets("Speed & RP").Areas("BottomArea").DisplayObj.XScalingMode = "RangeScroll"
View.Sheets("Speed & RP").Cursor.X1 =  ChLen*0.1
View.Sheets("Speed & RP").Cursor.X2 =  ChLen*0.9
Set Graph = View.Sheets("Speed & RP").Areas("TopArea").DisplayObj
Set Curve = Graph.Curves.Add("",speed)
Set Curve2 = Graph.Curves.Add("",railP)
Set Curve3 = Graph.Curves.Add(WR_Time_X,WR_engine_speed)
Set Curve4 = Graph.Curves.Add(WR_Time_X,WR_railP)
Set Graph = View.Sheets("Speed & RP").Areas("Area : 1").DisplayObj
Set Curve = Graph.Curves.Add("",speed)
Set Curve2 = Graph.Curves.Add(WR_Time_X,WR_engine_speed)
Set Graph = View.Sheets("Speed & RP").Areas("BottomArea").DisplayObj
Set Curve = Graph.Curves.Add("",railP)
Set Curve2 = Graph.Curves.Add(WR_Time_X,WR_railP)

call View.Sheets("Pressures").Areas("Area : 1").SplitTop("TopArea",0.33)
call View.Sheets("Pressures").Areas("Area : 1").SplitTop("BottomArea",0.5)
View.Sheets("Pressures").Areas("TopArea").DisplayObjType = "CurveChart2D"
View.Sheets("Pressures").Areas("Area : 1").DisplayObjType = "CurveChart2D"
View.Sheets("Pressures").Areas("BottomArea").DisplayObjType = "CurveChart2D"
View.Sheets("Pressures").Cursor.Type = "Band"
View.Sheets("Pressures").Areas("Area : 1").DisplayObj.XScalingMode = "RangeScroll"
View.Sheets("Pressures").Areas("BottomArea").DisplayObj.XScalingMode = "RangeScroll"
View.Sheets("Pressures").Cursor.X1 =  ChLen*0.1
View.Sheets("Pressures").Cursor.X2 =  ChLen*0.9
Set Graph = View.Sheets("Pressures").Areas("TopArea").DisplayObj
Set Curve = Graph.Curves.Add("",speed)
Set Curve2 = Graph.Curves.Add("",railP)
Set Graph = View.Sheets("Pressures").Areas("Area : 1").DisplayObj
Set Curve = Graph.Curves.Add("",InletP)
Set Graph = View.Sheets("Pressures").Areas("BottomArea").DisplayObj
Set Curve = Graph.Curves.Add("",ReturnP)

call View.Sheets("Temps").Areas("Area : 1").SplitTop("TopArea",0.33)
call View.Sheets("Temps").Areas("Area : 1").SplitTop("BottomArea",0.5)
View.Sheets("Temps").Areas("TopArea").DisplayObjType = "CurveChart2D"
View.Sheets("Temps").Areas("Area : 1").DisplayObjType = "CurveChart2D"
View.Sheets("Temps").Areas("BottomArea").DisplayObjType = "CurveChart2D"
View.Sheets("Temps").Cursor.Type = "Band"
View.Sheets("Temps").Areas("Area : 1").DisplayObj.XScalingMode = "RangeScroll"
View.Sheets("Temps").Areas("BottomArea").DisplayObj.XScalingMode = "RangeScroll"
View.Sheets("Temps").Cursor.X1 =  ChLen*0.1
View.Sheets("Temps").Cursor.X2 =  ChLen*0.9
Set Graph = View.Sheets("Temps").Areas("TopArea").DisplayObj
Set Curve = Graph.Curves.Add("",speed)
Set Curve2 = Graph.Curves.Add("",railP)
Set Graph = View.Sheets("Temps").Areas("Area : 1").DisplayObj
Set Curve = Graph.Curves.Add("",InletT)
Set Curve2 = Graph.Curves.Add("",rtnT)
Set Graph = View.Sheets("Temps").Areas("BottomArea").DisplayObj
Set Curve = Graph.Curves.Add("",deltaT)

call View.Sheets("Flows").Areas("Area : 1").SplitTop("TopArea",0.33)
call View.Sheets("Flows").Areas("Area : 1").SplitTop("BottomArea",0.5)
View.Sheets("Flows").Areas("TopArea").DisplayObjType = "CurveChart2D"
View.Sheets("Flows").Areas("Area : 1").DisplayObjType = "CurveChart2D"
View.Sheets("Flows").Areas("BottomArea").DisplayObjType = "CurveChart2D"
View.Sheets("Flows").Cursor.Type = "Band"
View.Sheets("Flows").Areas("Area : 1").DisplayObj.XScalingMode = "RangeScroll"
View.Sheets("Flows").Areas("BottomArea").DisplayObj.XScalingMode = "RangeScroll"
View.Sheets("Flows").Cursor.X1 =  ChLen*0.1
View.Sheets("Flows").Cursor.X2 =  ChLen*0.9
Set Graph = View.Sheets("Flows").Areas("TopArea").DisplayObj
Set Curve = Graph.Curves.Add("",speed)
Set Curve2 = Graph.Curves.Add("",railP)
Set Curve3 = Graph.Curves.Add(WR_Time_X,WR_engine_speed)
Set Curve4 = Graph.Curves.Add(WR_Time_X,WR_railP)
Set Graph = View.Sheets("Flows").Areas("Area : 1").DisplayObj
Set Curve = Graph.Curves.Add("",rtnflow)
Set Graph = View.Sheets("Flows").Areas("BottomArea").DisplayObj
Set Curve = Graph.Curves.Add("",HPflow)
Set Curve2 = Graph.Curves.Add(WR_Time_X,WR_HPflow)

call View.Sheets("WR_only1").Areas("Area : 1").SplitTop("TopArea",0.33)
call View.Sheets("WR_only1").Areas("Area : 1").SplitTop("BottomArea",0.5)
View.Sheets("WR_only1").Areas("TopArea").DisplayObjType = "CurveChart2D"
View.Sheets("WR_only1").Areas("Area : 1").DisplayObjType = "CurveChart2D"
View.Sheets("WR_only1").Areas("BottomArea").DisplayObjType = "CurveChart2D"
View.Sheets("WR_only1").Cursor.Type = "Band"
View.Sheets("WR_only1").Areas("Area : 1").DisplayObj.XScalingMode = "RangeScroll"
View.Sheets("WR_only1").Areas("BottomArea").DisplayObj.XScalingMode = "RangeScroll"
View.Sheets("WR_only1").Cursor.X1 =  ChLen*0.1
View.Sheets("WR_only1").Cursor.X2 =  ChLen*0.9
Set Graph = View.Sheets("WR_only1").Areas("TopArea").DisplayObj
Set Curve = Graph.Curves.Add(WR_Time_X,WR_engine_speed)
Set Curve2 = Graph.Curves.Add(WR_Time_X,WR_railP)
Set Graph = View.Sheets("WR_only1").Areas("Area : 1").DisplayObj
Set Curve = Graph.Curves.Add(WR_Time_X,WR_pump_speed)
Set Curve2 = Graph.Curves.Add(WR_Time_X,WR_railP)
Set Graph = View.Sheets("WR_only1").Areas("BottomArea").DisplayObj
Set Curve = Graph.Curves.Add(WR_Time_X,WR_HPflow)

call View.Sheets("WR_only2").Areas("Area : 1").SplitTop("TopArea",0.33)
call View.Sheets("WR_only2").Areas("Area : 1").SplitTop("BottomArea",0.5)
View.Sheets("WR_only2").Areas("TopArea").DisplayObjType = "CurveChart2D"
View.Sheets("WR_only2").Areas("Area : 1").DisplayObjType = "CurveChart2D"
View.Sheets("WR_only2").Areas("BottomArea").DisplayObjType = "CurveChart2D"
View.Sheets("WR_only2").Cursor.Type = "Band"
View.Sheets("WR_only2").Areas("Area : 1").DisplayObj.XScalingMode = "RangeScroll"
View.Sheets("WR_only2").Areas("BottomArea").DisplayObj.XScalingMode = "RangeScroll"
View.Sheets("WR_only2").Cursor.X1 =  ChLen*0.1
View.Sheets("WR_only2").Cursor.X2 =  ChLen*0.9
Set Graph = View.Sheets("WR_only2").Areas("TopArea").DisplayObj
Set Curve = Graph.Curves.Add(WR_Time_X,WR_engine_speed)
Set Curve2 = Graph.Curves.Add(WR_Time_X,WR_railP)
Set Graph = View.Sheets("WR_only2").Areas("Area : 1").DisplayObj
Set Curve = Graph.Curves.Add(WR_Time_X,WR_pump_load)
Set Graph = View.Sheets("WR_only2").Areas("BottomArea").DisplayObj
Set Curve = Graph.Curves.Add(WR_Time_X,WR_HPflow)

call View.Sheets("WR_only3").Areas("Area : 1").SplitTop("TopArea",0.33)
call View.Sheets("WR_only3").Areas("Area : 1").SplitTop("BottomArea",0.5)
View.Sheets("WR_only3").Areas("TopArea").DisplayObjType = "CurveChart2D"
View.Sheets("WR_only3").Areas("Area : 1").DisplayObjType = "CurveChart2D"
View.Sheets("WR_only3").Areas("BottomArea").DisplayObjType = "CurveChart2D"
View.Sheets("WR_only3").Cursor.Type = "Band"
View.Sheets("WR_only3").Areas("Area : 1").DisplayObj.XScalingMode = "RangeScroll"
View.Sheets("WR_only3").Areas("BottomArea").DisplayObj.XScalingMode = "RangeScroll"
View.Sheets("WR_only3").Cursor.X1 =  ChLen*0.1
View.Sheets("WR_only3").Cursor.X2 =  ChLen*0.9
Set Graph = View.Sheets("WR_only3").Areas("TopArea").DisplayObj
Set Curve = Graph.Curves.Add(WR_Time_X,WR_pump_speed)
Set Curve2 = Graph.Curves.Add(WR_Time_X,WR_railP)
Set Graph = View.Sheets("WR_only3").Areas("Area : 1").DisplayObj
Set Curve = Graph.Curves.Add(WR_Time_X,WR_HPflow)
Set Graph = View.Sheets("WR_only3").Areas("BottomArea").DisplayObj
Set Curve = Graph.Curves.Add(WR_Time_X,WR_ramp_rate)