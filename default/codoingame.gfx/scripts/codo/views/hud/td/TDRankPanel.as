package codo.views.hud.td
{
   import codo.constants.HUDComponentTypes;
   import codo.localization.DictTD;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import codo.views.hud.shared.CollapsibleRankPanel;
   import flash.display.MovieClip;
   
   public class TDRankPanel extends CollapsibleRankPanel
   {
      
      private const COLLAPSE_KEYBINDING:String = "togglecamo";
      
      private const KEYBINDING_COLOR:uint = 41727;
      
      private const TD_RANK_HEIGHT:Number = 67;
      
      public var myRank0:MovieClip;
      
      public var myRank1:MovieClip;
      
      public var myRank2:MovieClip;
      
      public var myRank3:MovieClip;
      
      public function TDRankPanel()
      {
         var localizedKey:String = null;
         super();
         mRankBars = [this.myRank0,this.myRank1,this.myRank2,this.myRank3];
         mRankBarHeight = this.TD_RANK_HEIGHT;
         mCollapsed = false;
         mEnabledRankBar = 0;
         for(var i:int = 0; i < mRankBars.length; i++)
         {
            mRankBars[i].visible = false;
         }
         myCollapsedHint.visible = false;
         myCollapsedHint.scaleX = 0;
         if(ScaleformUtil.isScaleform)
         {
            localizedKey = LocalizeUtil.localizeFirstKeyBindingForCommand(this.COLLAPSE_KEYBINDING).toUpperCase();
            LocalizeUtil.paramColorized(myCollapseHint["myText"],DictTD.PRESS_TO_COLLAPSE_RANK,[localizedKey],[this.KEYBINDING_COLOR]);
            LocalizeUtil.paramColorized(myCollapsedHint["myText"],DictTD.PRESS_TO_SHOW_RANK,[localizedKey],[this.KEYBINDING_COLOR]);
         }
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.TD_RANK_PANEL;
      }
   }
}

