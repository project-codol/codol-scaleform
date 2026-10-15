package codo.views.persistentView.accountInfo
{
   import fsg.shared.ToolTipItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol924")]
   public dynamic class PrivilegeBlueDiamond extends ToolTipItem
   {
      
      public function PrivilegeBlueDiamond()
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

