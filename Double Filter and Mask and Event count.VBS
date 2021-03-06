'-------------------------------------------------------------------------------
'--This VBS script filters the data set based on the values of one or two channels there is an option to filter out values or mask in values using <,< and <>
'--hence with the <> there is a maximum of 4 filters applied to 2 different channels 
'--filtered data can then be re-filtered
'--also a count of times <,> a certain condition is included as part of the filter --> so can look for number of events during a test

'----CHANNEL SELECT5.SUD IS THE FORM USED WITH THIS File

'-- Created on 06/29/2018 11:21:34
'-- Author: Chris Kingswood
'-- Comment: '--Stage 1.) Dialog box appears for user to select which channel to filter, 
'----------- value to filer on and sign(i.e. >,<,>-,<=)
'--Stage 2.) User entered values are then entered into variables
'--Stage 3.) Ask user if they want to filter selected (default) channel group
'----------  or create a copy of the selected channel group and filter that copy
'--Stage 3b.) create a list using 'ChnEventResultLIst' from channel events to identify
'----------- rows to remove
'--Stage 4.) Filter the channel group using ChnEventCreateFilteredTrueChn & ChnNovHandle
'---------NOTE IF YOU WANT TO FILTER CHANNELS THAT HAVE ALREADY BEEN FILTERD THAN 
'---------MOVE THE EVENT COUNT CHANNELS OUT OF THAT GROUP 1ST (ALSO NOTE NEW EVENT CHANNELS
'---------ARE FROM THAT ALREADY FILTERD CHANNEL)
'-------------------------------------------------------------------------------
Option Explicit  'Forces the explicit declaration of all the variables in a script.
Dim sSUDName, oPara, l1, sel_X, sel_X2, filtervalue, filtervalue2, sign2, oMyChns, chancounts',sign3
Dim L4, oMyChnGrp, copygroupname, overwrite, iCount, a, b, filmask, actgrp
Dim filtervalue_2, filtervalue2_2, sign2_2, copygroupname_2, multi, ChnEventList_T1, ChnEventList_T2
dim ChnEventList3, ChnEventList4, a_2, b_2, size_events, Myevents, MyChannels(3), filter_name
'----------------------------------------------------------------------------
'User to select which channel to filter, value to filter on 
'and sign (>,<,>-,<=)--> using a Dialog box
'---------------------------------------------------------------------------
SSUDName = CurrentScriptPath & "channel select5.SUD" 'make sure to save SUD dialog box in same place as script
set oPara = new cPara
Call SUDDlgShow("Dlg1", sSUDName, oPara)

class cPara
  dim sX_ChnReference,  sX2_ChnReference, sText1, sText2, sText3, sText4, sText1_2, sText2_2, sText3_2, sText5
  
sub class_initialize
'sText1    = "1000"
'sText2 = "< > ="
  if (Data.Root.ChannelGroups.Count > 0) then
    if (Data.Root.ChannelGroups(1).Channels.Count > 1) then
    sX_ChnReference = Data.GetChannel("[1]/[1]").GetReference(ExtendChnName)', "OnlyName") 'eRefTypeOnlyName
    sX2_ChnReference = Data.GetChannel("[1]/[1]").GetReference(ExtendChnName)', "OnlyName") 'eRefTypeOnlyName
    else
    sX_ChnReference = ""
    sX2_ChnReference = ""
    end if 
  else
    sX_ChnReference = ""
    sX2_ChnReference = ""
  end if
end sub
end class

'putting the user entered inputs into variables ready for filtering
sel_X = oPara.sX_ChnReference 'string: "[1]/Pump Speed (Rpm)"
sel_X2= oPara.sX2_ChnReference 
filterValue = oPara.sText1 'greater than value
filterValue_2 = oPara.sText1_2 
filtervalue2 = oPara.sText2 'less than value
filtervalue2_2 = oPara.sText2_2 
sign2 = oPara.sText3 
sign2_2 = oPara.sText3_2 
filmask = oPara.sText4 
multi = oPara.SText5 'user wants 1 or 2 filters applied

'----------------------------------------------------------------------------
'----------------------------------------------------------------------------
'Select active gropup for editing, user to decide to overwrite active or copy
'channel group and filter the copied version
'---------------------------------------------------------------------------
overwrite = MsgBox("Overwrite existing selected channel Group?", vbYesNo)
  if overwrite = vbNo then
  Set oMyChnGrp = Data.Root.ActiveChannelGroup
  Call Data.Root.ChannelGroups.AddChannelGroup(oMyChnGrp).Activate()
  Data.Root.ActiveChannelGroup.Name = "copyGroup"
  end if
Set oMyChnGrp = Data.Root.ActiveChannelGroup
chancounts = oMyChnGrp.Channels.Count 'how many channels are there (needed so can be removed after)
copygroupname = Data.Root.ActiveChannelGroup.Name & "/" &  sel_X 'was before --> & "/Pump Speed (Rpm)"
copygroupname_2 = Data.Root.ActiveChannelGroup.Name & "/" &  sel_X2 
actgrp = Data.Root.ActiveChannelGroup.Name


if multi = "No" then 
'----------------------------------------------------------------------------
'----------------- 1 FILTER/MASK ------------------------------------
'CREATE A ChnEventResultLIst, that has an array of all the events linked
'to the filter, with first column showing starting row and 2nd column shows end row
'---------------------------------------------------------------------------
ChnEventList1 = Null 
ChnEventList2 = Null 
ChnEventResultList= Null 

if filmask = "Filter Out" then
  if sign2 = ">" then
  b = val(filtervalue)  'lower limit i.e for more than this value delete
  a = NULL
  elseif sign2 = "<" then
  b = NULL
  a = val(filtervalue2)  'upper limit i.e for lower than this value delete
  elseif sign2 = "<>" then
  a = val(filtervalue)  'lower limit i.e for more than this value delete
  b = val(filtervalue2)  'upper limit i.e for lower than this value delete
  end if
elseif filmask = "Mask In" then
  if sign2 = ">" then
  a = val(filtervalue)  'lower limit i.e for more than this value delete
  b = NULL
  elseif sign2 = "<" then
  a = NULL
  b = val(filtervalue2)  'upper limit i.e for lower than this value delete
  elseif sign2 = "<>" then
  a = val(filtervalue)  'lower limit i.e for more than this value delete
  b = val(filtervalue2)  'upper limit i.e for lower than this value delete
  end if
end if

if sign2 = "<>" and filmask = "Filter Out" then
ChnEventList1 = ChnEventDetectionWindow(, copygroupname, a, NULL, 0, 0)
ChnEventList2 = ChnEventDetectionWindow(, copygroupname, NULL, b, 0, 0)
ChnEventResultList = ChnEventOperationAND(ChnEventList1, ChnEventList2)
ChnEventResultList = ChnEventOperationNOT(ChnEventResultList,copygroupname)
else
ChnEventResultList = ChnEventDetectionWindow(, copygroupname, a, b, 0, 0)
end if

'ChnEventResultList = ChnEventDetectionWindow(, "[2]/[2]", 1600, , 0, 0)
'1st value empty, 2nd value is the lower limit, 3rd is upper limit --> anything between the 2 values
'will then be deleted in following DataBlDel routine --> can specify no upper limit
'i.e i want to delete all values above 4000rpm --> ....,4000, ,0,0)
'i.e i want to delete all values below 4000rpm --> ...., ,4000 ,0,0)
'---------------------------------------------------------------------------
Call ChnEventCreateFilteredTrueChn("Event/EventStatusTrue", ChnEventResultList, copygroupname, NULL)
Call ChnNovHandle("Event/EventStatusTrue",oMyChnGrp,"Delete","X",False,False)
'----------------------------------------------------------------------------
else 
'----------------------------------------------------------------------------
'----------------- 2 FILTERS/MASKS ------------------------------------
'---CREATE A ChnEventResultLIst, that has an array of all the events linked
'to the filter, with first column showing starting row and 2nd column shows end row
'---------------------------------------------------------------------------
  ChnEventList1 = Null 
  ChnEventList2 = Null 
  ChnEventResultList= Null 
  ChnEventList3 = Null
  ChnEventList4 = Null
  ChnEventList_T1= Null
  ChnEventList_T2= Null
  
  'filtervalue2 = Val(filterValue) 
  'filtervalue > value, filtervalue2 <
  if filmask = "Filter Out" then
    if sign2 = ">" then
    b = val(filtervalue)  'lower limit i.e for more than this value delete
    a = NULL
    elseif sign2 = "<" then
    b = NULL
    a = val(filtervalue2)  'upper limit i.e for lower than this value delete
    elseif sign2 = "<>" then
    a = val(filtervalue)  'lower limit i.e for more than this value delete
    b = val(filtervalue2)  'upper limit i.e for lower than this value delete
    end if
  elseif filmask = "Mask In" then
    if sign2 = ">" then
    a = val(filtervalue)  'lower limit i.e for more than this value delete
    b = NULL
    elseif sign2 = "<" then
    a = NULL
    b = val(filtervalue2)  'upper limit i.e for lower than this value delete
    elseif sign2 = "<>" then
    a = val(filtervalue)  'lower limit i.e for more than this value delete
    b = val(filtervalue2)  'upper limit i.e for lower than this value delete
    end if
  end if
  
  if filmask = "Filter Out" then
    if sign2_2 = ">" then
    b_2 = val(filtervalue_2)  'lower limit i.e for more than this value delete
    a_2 = NULL
    elseif sign2_2 = "<" then
    b_2 = NULL
    a_2 = val(filtervalue2_2)  'upper limit i.e for lower than this value delete
    elseif sign2_2 = "<>" then
    a_2 = val(filtervalue_2)  'lower limit i.e for more than this value delete
    b_2 = val(filtervalue2_2)  'upper limit i.e for lower than this value delete
    end if
  elseif filmask = "Mask In" then
    if sign2_2 = ">" then
    a_2 = val(filtervalue_2)  'lower limit i.e for more than this value delete
    b_2 = NULL
    elseif sign2_2 = "<" then
    a_2 = NULL
    b_2 = val(filtervalue2_2)  'upper limit i.e for lower than this value delete
    elseif sign2_2 = "<>" then
    a_2 = val(filtervalue_2)  'lower limit i.e for more than this value delete
    b_2 = val(filtervalue2_2)  'upper limit i.e for lower than this value delete
    end if
  end if
  
  if sign2 = "<>" and filmask = "Filter Out" then
    ChnEventList1 = ChnEventDetectionWindow(, copygroupname, a, NULL, 0, 0)
    ChnEventList2 = ChnEventDetectionWindow(, copygroupname, NULL, b, 0, 0)
    ChnEventList_T1 = ChnEventOperationAND(ChnEventList1, ChnEventList2)
    ChnEventList_T1 = ChnEventOperationNOT(ChnEventList_T1,copygroupname)
  else
    ChnEventList_T1 = ChnEventDetectionWindow(, copygroupname, a, b, 0, 0)
  end if
  
  if sign2_2 = "<>" and filmask = "Filter Out" then
    ChnEventList3 = ChnEventDetectionWindow(, copygroupname_2, a_2, NULL, 0, 0)
    ChnEventList4 = ChnEventDetectionWindow(, copygroupname_2, NULL, b_2, 0, 0)
    ChnEventList_T2 = ChnEventOperationAND(ChnEventList3, ChnEventList4)
    ChnEventList_T2 = ChnEventOperationNOT(ChnEventList_T2,copygroupname_2)
  else
    ChnEventList_T2 = ChnEventDetectionWindow(, copygroupname_2, a_2, b_2, 0, 0)
  end if
  
  ChnEventResultList = ChnEventOperationAND(ChnEventList_T1, ChnEventList_T2)
  
  Call ChnEventCreateFilteredTrueChn("Event/EventStatusTrue", ChnEventResultList, copygroupname, NULL)
  Call ChnNovHandle("Event/EventStatusTrue",oMyChnGrp,"Delete","X",False,False)
'----------------------------------------------------------------------------

end if

'----------------------------------------------------------------------------
'---Remove original channels
'---------------------------------------------------------------------------
Set oMyChns = Data.GetChannels("'" & actgrp & "/[1]' - '" & actgrp & "/[" & chancounts + 1 & "]'")
Data.Remove(oMyChns)

'----------------------------------------------------------------------------
'---Record events --> number of and put to array etc ONLY FOR MASK IN SELECTION
'---------------------------------------------------------------------------
if filmask = "Mask In" then

  Redim Myevents(3,ChnEventCount(ChnEventResultList)-1)
  
  for iCount = 0 to ChnEventCount(ChnEventResultList)-1 
  Myevents(0, iCount) = iCount + 1
  Myevents(1, iCount) = ChnEventResultList(iCount,0) 'start row 'was istart =...
  Myevents(2, iCount) = ChnEventResultList(iCount,1) 'end row 'was iend = ...
  Myevents(3, iCount) = 1 +  Myevents(2, iCount) -  Myevents(1, iCount)  'was iLen
  next
  
  if multi = "No" then 
  filter_name = "  " & sel_X & ": " & sign2 & filtervalue & " - " & filtervalue2   
  else
  filter_name = "  " & sel_X & ": " & sign2 & filtervalue & " - " & filtervalue2 & "  " & sel_X2 & ": " & sign2 & filtervalue_2 & " - " & filtervalue2_2    
  end if
  
  MyChannels(0) = "event_count" & filter_name
  MyChannels(1) = "event_start row" & filter_name
  MyChannels(2) = "event_end row" & filter_name
  MyChannels(3) = "event_length" & filter_name
  
  Call ArrayToChannels(Myevents, MyChannels)
Msgbox ("Number of Events = : " & ChnEventCount(ChnEventResultList))  
end if