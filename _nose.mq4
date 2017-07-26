#property strict
#property indicator_chart_window

extern int        ZZdepth = 4;
extern int    ZZdeviation = 5;
extern int     ZZbackStep = 3;
extern double  multiplier = 1.5;
extern int        History = 500;    
extern int    rightOffset = 25;
extern color     lineColor1 = clrLavender;
extern color     lineColor2 = clrPeachPuff;
   
int init()                         
{

   return(0);              
}

int deinit()
{
   int k=0;
   while ( k < ObjectsTotal() )
   {
      string objname = ObjectName(k);
      if (StringSubstr(objname,0,5) == "nose-") 
         ObjectDelete(objname);
      else
         k++;
   } 
   return(0);   
}
  

int start()   
{
   int i,j, Counted_bars;
   double zig,A,B,C,D = 0.0;
   int Bi,Ci = 0;
 
   Counted_bars=IndicatorCounted(); 
   i=Bars-Counted_bars-1;
   if (i>History-1)
   {                 
      i=History-1;                  
   }
   
   while (i>=0)
   {
      j=i;
      while (A==0.0 && j<=History){
         zig=iCustom(NULL, 0, "ZigZag", ZZdepth, ZZdeviation, ZZbackStep, 0, j);
         if ( zig > 0.0 )
         {
            if ( D == 0.0 ) 
            {
               D=zig;
            }
            else if ( C == 0.0 ) 
            {
               C=zig;
               Ci=j;
            }
            else if ( B == 0.0 ) 
            {
               B=zig;
               Bi=j;
            }
            else if ( A == 0.0 ) 
            {
               A=zig;
            }
         }   
         j++;
      }
      if ( A != 0.0 )
      {
         if ( MathAbs(A - C) <= 1.5*iATR(NULL,0,12,Ci) )
         {
            double nose=multiplier*MathAbs(A-B);
            double neck=MathAbs(B-D);
            if ( nose <= neck ) 
            {
               color lineColor;
               if ( A < B ) lineColor=lineColor1;
               else lineColor=lineColor2;
               TrendCreate(0,"nose-"+TimeToStr(Time[Bi]),0,Time[Bi],B,Time[0]+rightOffset*500,B,lineColor,STYLE_SOLID,1,true,false,false,false,false,0);
            }
         }
      }
      
      zig = 0.0;
      A = 0.0;
      B = 0.0;
      C = 0.0;
      D = 0.0;
      
      i--;
   }
   return(0);
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
