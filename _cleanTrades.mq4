// Clean chart from trade history
#include <stdlib.mqh>
#include <WinUser32.mqh>

int start()
{

  int k=0;
  while (k<ObjectsTotal())
  {
    string objname = ObjectName(k);
    if ( StringSubstr(objname,0,1) == "#" )  
      ObjectDelete(objname);
    else
      k++;
  }
  return(0);
}
