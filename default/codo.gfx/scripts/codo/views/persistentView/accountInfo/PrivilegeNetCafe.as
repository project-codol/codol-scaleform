package codo.views.persistentView.accountInfo
{
   import fsg.shared.ToolTipItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1047")]
   public dynamic class PrivilegeNetCafe extends ToolTipItem
   {
      
      public function PrivilegeNetCafe()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

