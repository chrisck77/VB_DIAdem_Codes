'-------------------------------------------------------------------------------
'-- VBS script file
'-- Created on 06/07/2018 14:49:52
'-- Author: ck
'-- Comment: simple time saving routine to offset graphs --> when comparing 2 graphs this routine can overlay the graphs on the fly 
'--offset is applied to the time of one group of channels
'--------------------------------------------------------------------------
Option Explicit  'Forces the explicit declaration of all the variables in a script.
dim d
d = InputBox("Please input a whole number.")

Set ChnResult = ChnOffset("Accum.  Test time (S)","/Accum.  Test time (S)",d,"free offset")