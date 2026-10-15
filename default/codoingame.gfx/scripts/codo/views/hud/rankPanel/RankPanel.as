package codo.views.hud.rankPanel
{
   import codo.constants.HUDComponentTypes;
   import codo.localization.DictZHunt;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import codo.views.hud.shared.CollapsibleRankPanel;
   
   public class RankPanel extends CollapsibleRankPanel
   {
      
      private const COLLAPSE_KEYBINDING:String = "+actionslot 5";
      
      private const KEYBINDING_COLOR:uint = 16745472;
      
      public var myRank1:RankBar;
      
      public var myRank2:RankBar;
      
      public var myRank3:RankBar;
      
      public var myRank4:RankBar;
      
      public var myRank5:RankBar;
      
      public var myRank6:RankBar;
      
      public function RankPanel()
      {
         var localizedKey:String = null;
         super();
         mRankBars = [this.myRank1,this.myRank2,this.myRank3,this.myRank4,this.myRank5,this.myRank6];
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
            LocalizeUtil.paramColorized(myCollapseHint["myText"],DictZHunt.PRESS_TO_COLLAPSE_RANK,[localizedKey],[this.KEYBINDING_COLOR]);
            LocalizeUtil.paramColorized(myCollapsedHint["myText"],DictZHunt.PRESS_TO_SHOW_RANK,[localizedKey],[this.KEYBINDING_COLOR]);
         }
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.RANK_PANEL;
      }
   }
}

