#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator Parameters                                      |
//+------------------------------------------------------------------+
extern ENUM_BASE_CORNER InpCorner   =  CORNER_LEFT_UPPER;   
extern color            panl_0_cl   =  clrGainsboro;        
extern bool             panl_0_st   =  true;                
extern color            rect_1_cl   =  clrSteelBlue;        
extern ENUM_LINE_STYLE  rect_1_st   =  STYLE_SOLID;         
extern int              rect_1_wd   =  1;                   
extern color            rect_2_cl   =  clrFireBrick;        
extern ENUM_LINE_STYLE  rect_2_st   =  STYLE_SOLID;         
extern int              rect_2_wd   =  1;                   
extern color            rect_3_cl   =  clrLightSteelBlue;   
extern color            rect_4_cl   =  clrLightSalmon;      
extern color            rect_5_cl   =  clrYellow;           
extern color            line_1_cl   =  clrBlue;             
extern ENUM_LINE_STYLE  line_1_st   =  STYLE_SOLID;         
extern int              line_1_wd   =  1;                   
extern color            line_2_cl   =  clrCrimson;          
extern ENUM_LINE_STYLE  line_2_st   =  STYLE_SOLID;         
extern int              line_2_wd   =  1;                   
extern color            line_3_cl   =  clrMediumSeaGreen;   
extern ENUM_LINE_STYLE  line_3_st   =  STYLE_DASH;          
extern int              line_3_wd   =  1;                   
extern color            line_4_cl   =  clrRed;              
extern ENUM_LINE_STYLE  line_4_st   =  STYLE_SOLID;         
extern int              line_4_wd   =  1;
extern string           Soundfile   =  "alert.wav";                   
extern bool             PopupAlert  =  TRUE;
extern bool             SendtoPhone =  TRUE;

bool              InpSelection      =  false;               
bool              InpHidden         =  true;                
bool              InpHidden_OBJ     =  false;               
bool              InpBackRect       =  false;               

extern int x_coor = 10;
extern int y_coor = 20;
int x_size = 180;
int y_size = 30;
int x_step = 5;
int y_panl = 20;
int x_rect = 20;
int y_rect = 20;
int y_line = 6;

string obj_name[8] = {"name_1","name_2","name_3","name_4","name_5","name_6","name_7","name_8","name_9","name_10"};

int g_newBarTime = 0;
int rightOffset = 25;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   Comment("");
   RectLabelDelete(0,obj_name[0]);
   RectLabelDelete(0,obj_name[1]);
   RectLabelDelete(0,obj_name[2]);
   RectLabelDelete(0,obj_name[3]);
   RectLabelDelete(0,obj_name[4]);
   RectLabelDelete(0,obj_name[5]);
   RectLabelDelete(0,obj_name[6]);
   RectLabelDelete(0,obj_name[7]);
   RectLabelDelete(0,obj_name[8]);
   RectLabelDelete(0,obj_name[9]);
   ObjectDelete("SpreadObject");
   ObjectDelete("ProfitObject");
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   CreatePanel();
   CreateRect();

   ExtendAndStraighten();
   HandleAlarms();
   ShowSpread("SpreadObject");
   ShowProfit("ProfitObject");

   return(rates_total);
}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   datetime dt_1     = 0;
   double   price_1  = 0;
   datetime dt_2     = 0;
   double   price_2  = 0;
   int      window   = 0;
   int      x        = 0;
   int      y        = 0;
   
   if (id == CHARTEVENT_OBJECT_CLICK) {
      string clickedChartObject = sparam;
      if (clickedChartObject == obj_name[1]) {
         string name = "name_" + IntegerToString(MathRand() + 100,0,' ');
         
         y = y_coor + y_rect + 2*x_step;
         ChartXYToTimePrice(0, x_coor + x_step, y, window, dt_1, price_1);
         
         y = y_coor + 2*y_rect + 3*x_step;
         ChartXYToTimePrice(0, x_coor + x_size, y, window, dt_2, price_2);
         
         RectangleCreate(0,name,0,dt_1,price_1,dt_2,price_2,rect_1_cl,rect_1_st,rect_1_wd,false,false,true,InpHidden_OBJ,0);
      }
   }
   if (id == CHARTEVENT_OBJECT_CLICK) {
      string clickedChartObject = sparam;
      if (clickedChartObject == obj_name[2]) {
         string name = "name_" + IntegerToString(MathRand() + 100,0,' ');
         
         y = y_coor + 2*y_rect + 3*x_step;
         ChartXYToTimePrice(0, x_coor + x_step, y, window, dt_1, price_1);
         
         y = y_coor + 3*y_rect + 4*x_step;
         ChartXYToTimePrice(0, x_coor + x_size, y, window, dt_2, price_2);         
         
         RectangleCreate(0,name,0,dt_1,price_1,dt_2,price_2,rect_2_cl,rect_2_st,rect_2_wd,false,false,true,InpHidden_OBJ,0);
      }
   }   
   if (id == CHARTEVENT_OBJECT_CLICK) {
      string clickedChartObject = sparam;
      if (clickedChartObject == obj_name[3]) {
         string name = "name_" + IntegerToString(MathRand() + 100,0,' ');

         y = y_coor + 3*y_rect + 4*x_step;
         ChartXYToTimePrice(0, x_coor + x_step, y, window, dt_1, price_1);
         
         y = y_coor + 4*y_rect + 5*x_step;
         ChartXYToTimePrice(0, x_coor + x_size, y, window, dt_2, price_2);   
         
         RectangleCreate(0,name,0,dt_1,price_1,dt_2,price_2,rect_3_cl,STYLE_SOLID,0,false,true,true,InpHidden_OBJ,0);
      }
   }
   if (id == CHARTEVENT_OBJECT_CLICK) {
      string clickedChartObject = sparam;
      if (clickedChartObject == obj_name[4]) {
         string name = "name_" + IntegerToString(MathRand() + 100,0,' ');

         y = y_coor + 4*y_rect + 5*x_step;
         ChartXYToTimePrice(0, x_coor + x_step, y, window, dt_1, price_1);
         
         y = y_coor + 5*y_rect + 6*x_step;
         ChartXYToTimePrice(0, x_coor + x_size, y, window, dt_2, price_2);
         
         RectangleCreate(0,name,0,dt_1,price_1,dt_2,price_2,rect_4_cl,STYLE_SOLID,0,false,true,true,InpHidden_OBJ,0);
      }
   }
   if (id == CHARTEVENT_OBJECT_CLICK) {
      string clickedChartObject = sparam;
      if (clickedChartObject == obj_name[5]) {
         string name = "name_" + IntegerToString(MathRand() + 100,0,' ');

         y = y_coor + 5*y_rect + 6*x_step;
         ChartXYToTimePrice(0, x_coor + x_step, y, window, dt_1, price_1);
         
         y = y_coor + 6*y_rect + 7*x_step;
         ChartXYToTimePrice(0, x_coor + x_size, y, window, dt_2, price_2);
         
         RectangleCreate(0,name,0,dt_1,price_1,dt_2,price_2,rect_5_cl,STYLE_SOLID,0,false,true,true,InpHidden_OBJ,0);
      }
   }
   if (id == CHARTEVENT_OBJECT_CLICK) {
      string clickedChartObject = sparam;
      if (clickedChartObject == obj_name[6]) {
         string name = "name_" + IntegerToString(MathRand() + 100,0,' ');
         
         y = y_coor + 6*y_rect + 8*x_step;
         ChartXYToTimePrice(0, x_coor + x_step, y, window, dt_1, price_1);
         ChartXYToTimePrice(0, x_coor + x_size, y, window, dt_2, price_2);         
         
         TrendCreate(0,name,0,dt_1,price_1,dt_2,price_2,line_1_cl,line_1_st,line_1_wd,InpBackRect,true,false,false,InpHidden_OBJ,0);
      }
   }
   if (id == CHARTEVENT_OBJECT_CLICK) {
      string clickedChartObject = sparam;
      if (clickedChartObject == obj_name[7]) {
         string name = "name_" + IntegerToString(MathRand() + 100,0,' ');
         
         y = y_coor + 6*y_rect + 10*x_step;
         ChartXYToTimePrice(0, x_coor + x_step, y, window, dt_1, price_1);
         ChartXYToTimePrice(0, x_coor + x_size, y, window, dt_2, price_2);         
         
         TrendCreate(0,name,0,dt_1,price_1,dt_2,price_2,line_2_cl,line_2_st,line_2_wd,InpBackRect,true,false,false,InpHidden_OBJ,0);
      }
   }
   if (id == CHARTEVENT_OBJECT_CLICK) {
      string clickedChartObject = sparam;
      if (clickedChartObject == obj_name[8]) {
         string name = "name_" + IntegerToString(MathRand() + 100,0,' ');
         
         y = y_coor + 6*y_rect + 12*x_step;
         ChartXYToTimePrice(0, x_coor + x_step, y, window, dt_1, price_1);
         ChartXYToTimePrice(0, x_coor + x_size, y, window, dt_2, price_2);         
         
         TrendCreate(0,name,0,dt_1,price_1,dt_2,price_2,line_3_cl,line_3_st,line_3_wd,InpBackRect,true,false,false,InpHidden_OBJ,0);
      }
   }
   if (id == CHARTEVENT_OBJECT_CLICK) {
      string clickedChartObject = sparam;
      if (clickedChartObject == obj_name[9]) {
         string name = "name_" + IntegerToString(MathRand() + 100,0,' ');
         
         y = y_coor + 6*y_rect + 14*x_step;
         ChartXYToTimePrice(0, x_coor + x_step, y, window, dt_1, price_1);
         ChartXYToTimePrice(0, x_coor + x_size, y, window, dt_2, price_2);         
         
         TrendCreate(0,name,0,dt_1,price_1,dt_2,price_2,line_4_cl,line_4_st,line_4_wd,InpBackRect,true,false,true,InpHidden_OBJ,0);
      }
   }
}

//+------------------------------------------------------------------+
void CreatePanel()
{   
   if (panl_0_st) {
   
      int x_pn = x_coor, y_pn = y_coor;
      if (InpCorner == 1)  x_pn = x_coor + x_size + x_step;
      if (InpCorner == 2)  y_pn = y_coor + y_rect + x_step;
      if (InpCorner == 3) {x_pn = x_coor + x_size + x_step; y_pn = y_coor + y_rect + x_step;}
   
      if (!RectLabelCreate(0,obj_name[0],0,x_pn,y_pn,x_size,y_size,panl_0_cl,BORDER_SUNKEN,InpCorner,
           clrBlack,STYLE_SOLID,2,true,InpSelection,true,0)) {
         return;
      }   
   } else {
      panl_0_cl = ChartBackColorGet(0);
   }
}
//+------------------------------------------------------------------+
void CreateRect()
{
   int x_pn = x_coor + x_step, y_pn = y_coor + x_step;
   if (InpCorner == 1)  x_pn = x_coor + x_size;
   if (InpCorner == 2)  y_pn = y_coor + y_rect;
   if (InpCorner == 3) {x_pn = x_coor + x_size; y_pn = y_coor + y_rect;}
   
   if (!RectLabelCreate(0,obj_name[1],0,x_pn,y_pn,x_rect,y_rect,panl_0_cl,BORDER_FLAT,InpCorner,
        rect_1_cl,rect_1_st,rect_1_wd,InpBackRect,InpSelection,InpHidden,0)) {
      return;
   }   

   x_pn = x_coor + x_rect + 2*x_step; y_pn = y_coor + x_step;
   if (InpCorner == 1)  x_pn = x_coor + x_size - x_step - x_rect;
   if (InpCorner == 2)  y_pn = y_coor + y_rect;
   if (InpCorner == 3) {x_pn = x_coor + x_size - x_step - x_rect; y_pn = y_coor + y_rect;}
   
   if (!RectLabelCreate(0,obj_name[2],0,x_pn,y_pn,x_rect,y_rect,panl_0_cl,BORDER_FLAT,InpCorner,
        rect_2_cl,rect_2_st,rect_2_wd,InpBackRect,InpSelection,InpHidden,0)) {
      return;
   }  

   x_pn = x_coor + 2*x_rect + 3*x_step; y_pn = y_coor + x_step;
   if (InpCorner == 1)  x_pn = x_coor + x_size - 2*x_step - 2*x_rect;
   if (InpCorner == 2)  y_pn = y_coor + y_rect;
   if (InpCorner == 3) {x_pn = x_coor + x_size - 2*x_step - 2*x_rect; y_pn = y_coor + y_rect;}
   
   if (!RectLabelCreate(0,obj_name[3],0,x_pn,y_pn,x_rect,y_rect,rect_3_cl,BORDER_FLAT,InpCorner,
        rect_3_cl,STYLE_SOLID,0,InpBackRect,InpSelection,InpHidden,0)) {
      return;
   }  

   x_pn = x_coor + 3*x_rect + 4*x_step; y_pn = y_coor + x_step;
   if (InpCorner == 1)  x_pn = x_coor + x_size - 3*x_step - 3*x_rect;
   if (InpCorner == 2)  y_pn = y_coor + y_rect;
   if (InpCorner == 3) {x_pn = x_coor + x_size - 3*x_step - 3*x_rect; y_pn = y_coor + y_rect;}
   
   if (!RectLabelCreate(0,obj_name[4],0,x_pn,y_pn,x_rect,y_rect,rect_4_cl,BORDER_FLAT,InpCorner,
        rect_4_cl,STYLE_SOLID,0,InpBackRect,InpSelection,InpHidden,0)) {
      return;
   }

   x_pn = x_coor + 4*x_rect + 5*x_step; y_pn = y_coor + x_step;
   if (InpCorner == 1)  x_pn = x_coor + x_size - 4*x_step - 4*x_rect;
   if (InpCorner == 2)  y_pn = y_coor + y_rect;
   if (InpCorner == 3) {x_pn = x_coor + x_size - 4*x_step - 4*x_rect; y_pn = y_coor + y_rect;}
   
   if (!RectLabelCreate(0,obj_name[5],0,x_pn,y_pn,x_rect,y_rect,rect_5_cl,BORDER_FLAT,InpCorner,
        rect_5_cl,STYLE_SOLID,0,InpBackRect,InpSelection,InpHidden,0)) {
      return;
   }
   
   x_pn = x_coor + 5*x_rect + 6*x_step; y_pn = y_coor + x_step;
   if (InpCorner == 1)  x_pn = x_coor + x_size - 5*x_step - 5*x_rect;
   if (InpCorner == 2)  y_pn = y_coor + y_rect;
   if (InpCorner == 3) {x_pn = x_coor + x_size - 5*x_step - 5*x_rect; y_pn = y_coor + y_rect;}
   
   if (!RectLabelCreate(0,obj_name[6],0,x_pn,y_pn,x_rect,y_line,line_1_cl,BORDER_FLAT,InpCorner,
        line_1_cl,STYLE_SOLID,0,InpBackRect,InpSelection,InpHidden,0)) {
      return;
   }

   x_pn = x_coor + 5*x_rect + 6*x_step; y_pn = y_coor + y_rect;
   if (InpCorner == 1)  x_pn = x_coor + x_size - 5*x_step - 5*x_rect;
   if (InpCorner == 2)  y_pn = y_coor + x_step;
   if (InpCorner == 3) {x_pn = x_coor + x_size - 5*x_step - 5*x_rect; y_pn = y_coor + x_step;}
   
   if (!RectLabelCreate(0,obj_name[7],0,x_pn,y_pn,x_rect,y_line,line_2_cl,BORDER_FLAT,InpCorner,
        line_2_cl,STYLE_SOLID,0,InpBackRect,InpSelection,InpHidden,0)) {
      return;
   }

   x_pn = x_coor + 6*x_rect + 7*x_step; y_pn = y_coor + x_step;
   if (InpCorner == 1)  x_pn = x_coor + x_size - 6*x_step - 6*x_rect;
   if (InpCorner == 2)  y_pn = y_coor + y_rect;
   if (InpCorner == 3) {x_pn = x_coor + x_size - 6*x_step - 6*x_rect; y_pn = y_coor + y_rect;}
   
   if (!RectLabelCreate(0,obj_name[8],0,x_pn,y_pn,x_rect,y_line,line_3_cl,BORDER_FLAT,InpCorner,
        line_3_cl,STYLE_SOLID,0,InpBackRect,InpSelection,InpHidden,0)) {
      return;
   }
   
   x_pn = x_coor + 6*x_rect + 7*x_step; y_pn = y_coor + y_rect;
   if (InpCorner == 1)  x_pn = x_coor + x_size - 6*x_step - 6*x_rect;
   if (InpCorner == 2)  y_pn = y_coor + x_step;
   if (InpCorner == 3) {x_pn = x_coor + x_size - 6*x_step - 6*x_rect; y_pn = y_coor + x_step;}
   
   if (!RectLabelCreate(0,obj_name[9],0,x_pn,y_pn,x_rect,y_line,line_4_cl,BORDER_FLAT,InpCorner,
        line_4_cl,STYLE_SOLID,0,InpBackRect,InpSelection,InpHidden,0)) {
      return;
   }
}


bool RectLabelCreate(const long             chart_ID=0,               
                     const string           name="RectLabel",         
                     const int              sub_window=0,             
                     const int              x=0,                      
                     const int              y=0,                      
                     const int              width=50,                 
                     const int              height=18,                
                     const color            back_clr=C'236,233,216',  
                     const ENUM_BORDER_TYPE border=BORDER_SUNKEN,     
                     const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, 
                     const color            clr=clrRed,               
                     const ENUM_LINE_STYLE  style=STYLE_SOLID,        
                     const int              line_width=1,             
                     const bool             back=false,               
                     const bool             selection=false,          
                     const bool             hidden=true,              
                     const long             z_order=0)                
{

   ResetLastError();

   if (ObjectFind(name) == -1)
      ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,sub_window,0,0);

   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);              
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);              
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);         
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,border);       
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);            
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);                
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);              
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,line_width);         
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);                
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);     
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);            
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);           
   
   return(true);
}


bool RectLabelDelete(const long   chart_ID=0,       
                     const string name="RectLabel") 
{
   
   ResetLastError();
   
   if (ObjectFind(chart_ID,name) >= 0) 
      ObjectDelete(chart_ID,name);
   
   return(true);
}


color ChartBackColorGet(const long chart_ID=0)
{

   long result=clrNONE;

   ResetLastError();

   if(!ChartGetInteger(chart_ID,CHART_COLOR_BACKGROUND,0,result))
     {
      Print(__FUNCTION__+", Error Code = ",GetLastError());
     }

   return((color)result);
}
  
  
bool RectangleCreate(const long            chart_ID=0,        
                     const string          name="Rectangle",  
                     const int             sub_window=0,      
                     datetime              time1=0,           
                     double                price1=0,          
                     datetime              time2=0,           
                     double                price2=0,          
                     const color           clr=clrRed,        
                     const ENUM_LINE_STYLE style=STYLE_SOLID, 
                     const int             width=1,           
                     const bool            fill=false,        
                     const bool            back=false,        
                     const bool            selection=true,    
                     const bool            hidden=true,       
                     const long            z_order=0)         
{
   
   ResetLastError();
   
   if (ObjectFind(name) == -1)
      ObjectCreate(chart_ID,name,OBJ_RECTANGLE,sub_window,time1,price1,time2,price2);

   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);             
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);           
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);           
   ObjectSetInteger(chart_ID,name,OBJPROP_FILL,fill);             
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);             
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);  
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);    
                                                                  
                                                                  
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);         
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);        

   return(true);
}

bool TrendCreate(const long            chart_ID=0,        
                 const string          name="TrendLine",  
                 const int             sub_window=0,      
                 datetime              time1=0,           
                 double                price1=0,          
                 datetime              time2=0,           
                 double                price2=0,          
                 const color           clr=clrRed,        
                 const ENUM_LINE_STYLE style=STYLE_SOLID, 
                 const int             width=1,           
                 const bool            back=false,        
                 const bool            selection=true,    
                 const bool            ray_left=false,    
                 const bool            ray_right=false,   
                 const bool            hidden=true,       
                 const long            z_order=0)         
{
   
   ResetLastError();
   
   if (ObjectFind(name) == -1)
      ObjectCreate(chart_ID,name,OBJ_TREND,sub_window,time1,price1,time2,price2);
   
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);             
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);           
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);           
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);             
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);  
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);    
                                                                  
                                                                  
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_LEFT,ray_left);     
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,ray_right);   
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);         
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);        

   return(true);
}

int NewBar() {
   if (Time[0] != g_newBarTime) {
      g_newBarTime = Time[0];
      return (1);
   }
   return (0);
}

void ExtendAndStraighten()
{
   for (int i = ObjectsTotal()-1; i >= 0; i--)
   {
      string objName=ObjectName(i);
      if ( (ObjectType(objName) == OBJ_RECTANGLE) && (ObjectGet(objName, OBJPROP_BACK) == true) && ( ObjectGet(objName, OBJPROP_COLOR) == rect_3_cl  || ObjectGet(objName, OBJPROP_COLOR) == rect_4_cl))
      {
         ObjectSet(objName, OBJPROP_TIME2, Time[0]+rightOffset*500);
      }
       
      if ( ObjectType(objName) == OBJ_TREND )
      {
         color lineC = ObjectGet(objName, OBJPROP_COLOR);
         if ( lineC == line_1_cl || lineC == line_2_cl ) 
         {
            if ( ObjectGet(objName, OBJPROP_STYLE) == STYLE_SOLID )
            {
               ObjectSet(objName, OBJPROP_PRICE2, ObjectGet(objName, OBJPROP_PRICE1));
            }
         }
      }
   }
}

void HandleAlarms()
{
   bool   newBar;
   string objName;
   double objPrice;
   int    alertDist;
   int    distToPrice;
   string alertText;
   
   if (NewBar()) newBar = TRUE;
    else newBar = FALSE;
   
   for (int i = ObjectsTotal() - 1; i >= 0; i--) 
   {
      objName = ObjectName(i);
      
      if ( StringSubstr(ObjectDescription(objName), 0, 6) != "Alert_" ) continue; 
      
      objPrice = getObjectPrice(objName);
      if (objPrice != -1.0) 
      {
         alertDist = getObjectAlertDist(objName);
         if (alertDist != -1) 
         {
            distToPrice = MathAbs(Bid - objPrice) / Point;
            if (distToPrice <= alertDist) 
            {
               alertText = "Alert triggered: " + Symbol() + "@" + DoubleToStr(Bid, Digits) + "." + "  " + IntegerToString(distToPrice) + " pips from " + objName + ".";
               if (PopupAlert) Alert(alertText);
               else Print(alertText);              
               if (SendtoPhone) SendNotification(alertText);
               clearObjectAlert(objName);
            }
         }
      }
   }
}

void clearObjectAlert(string objName) 
{
   ObjectSetText(objName, "");
   return;
}

double getObjectPrice(string objName) {
   double price1;
   double price2;
   int time1;
   int time2;
   int objType = ObjectType(objName);
   if (objType == OBJ_TREND) return (ObjectGetValueByShift(objName, 0));
   if (objType == OBJ_RECTANGLE)
   {
      time1 = ObjectGet(objName, OBJPROP_TIME1);
      time2 = ObjectGet(objName, OBJPROP_TIME2);
      price1 = ObjectGet(objName, OBJPROP_PRICE1);
      price2 = ObjectGet(objName, OBJPROP_PRICE2);

      if (Time[0] >= time1 && Time[0] <= time2)
      {
         if ( StringSubstr(ObjectDescription(objName), 6, 1) == "H" ) 
         {
            if ( price1 > price2 ) return price1;
            else return price2; 
         }
         if ( StringSubstr(ObjectDescription(objName), 6, 1) == "L" ) 
         {
            if ( price1 < price2 ) return price1;
            else return price2; 
         } 
      }
   }
   
   return (-1);
}

int getObjectAlertDist(string objName) {
   string objDescr = ObjectDescription(objName);
   string result[];
   ushort u_sep = StringGetCharacter("_",0);
   int k = StringSplit(objDescr,u_sep,result); 
   
   if ( k == 3 )   return (StrToInteger(result[2]));
   if ( k == 2 )   return (StrToInteger(result[1]));
   return (-1);
}

void ShowSpread(string spreadObj)
{
   double point = Point;
   if (Point == 0.00001) point = 0.0001;
   else if (Point == 0.001) point = 0.01;
   
   string spread = DoubleToStr(NormalizeDouble((Ask - Bid) / point, 2), 1);
   
   ObjectCreate(spreadObj, OBJ_LABEL, 0, 0, 0);
   ObjectSetText(spreadObj, "Spread: "+spread, 8, "Arial", Black);
   ObjectSet(spreadObj, OBJPROP_XDISTANCE, 5);
   ObjectSet(spreadObj, OBJPROP_YDISTANCE, 5);
   ObjectSet(spreadObj, OBJPROP_CORNER, 1);
}

void ShowProfit(string profitObj)
{

   double pl = 0.0;
   for (int i=OrdersTotal()-1; i>=0; i--)
   {
      if ( !OrderSelect(i, SELECT_BY_POS, MODE_TRADES) ) continue;
      if ( OrderSymbol() != Symbol() )  
         continue;
      if ( OrderType() == OP_BUY )
         pl += (((OrderOpenPrice() - OrderStopLoss())*-1)*MarketInfo(Symbol(), MODE_TICKVALUE)/Point*OrderLots())-OrderCommission()-OrderSwap(); 
      else if ( OrderType() == OP_SELL )
         pl += (((OrderStopLoss()-OrderOpenPrice())*-1)*MarketInfo(Symbol(), MODE_TICKVALUE)/Point*OrderLots())-OrderCommission()-OrderSwap();       
   }

   ObjectCreate(profitObj, OBJ_LABEL, 0, 0, 0);
   ObjectSetText(profitObj, "Secured Profit: " + DoubleToStr(pl, 2), 8, "Arial", Black);
   ObjectSet(profitObj, OBJPROP_XDISTANCE, 5);
   ObjectSet(profitObj, OBJPROP_YDISTANCE, 17);
   ObjectSet(profitObj, OBJPROP_CORNER, 1);
}
