#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


void OnStart()
{
  string sData;
  string fileName="TemplateToCopy.tpl";
  
  ResetLastError();
  
  // read in file content
  int FileHandle=FileOpen(fileName,FILE_BIN|FILE_READ|FILE_COMMON);
  if(FileHandle!=INVALID_HANDLE)
  {
    ulong size=FileSize(FileHandle);
    while(!FileIsEnding(FileHandle))
      sData=FileReadString(FileHandle,(int)size);
    FileClose(FileHandle);
  }
  else PrintFormat("Failed to open %s file, Error code = %d",fileName,GetLastError());

  // extract symbol from template
  int index=StringFind(sData,"symbol=",0);
  if(index == -1)
  {
    MessageBox("'symbol=' not found in template, something is wrong");
    return;
  }
  string symbol=StringSubstr(sData,index+7,6);

  // open new chart
  long new_chart=ChartOpen(symbol,PERIOD_H1);
  if(new_chart!=0)
  {
    //--- Apply template to a chart
    ChartApplyTemplate(new_chart,fileName);
    ChartSetInteger(new_chart,CHART_COLOR_BACKGROUND,clrLightGray);
  }

}

