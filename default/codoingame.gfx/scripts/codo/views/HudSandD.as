package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.DataInGameID;
   import codo.constants.GameInfo;
   import codo.utils.LocalizeUtil;
   import codo.utils.SDPlusPvpUtil;
   import codo.utils.ShoutcastUtil;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class HudSandD extends BaseView
   {
      
      public var myLeftContainer:MovieClip;
      
      public var myPurchaseHint:TextField;
      
      private var _attacking:Boolean;
      
      public function HudSandD()
      {
         super();
         this.myPurchaseHint.htmlText = "@SDP_BUY_MENU_HINT";
         this.myPurchaseHint.visible = false;
         addDP(DataInGameID.SD_ATTACKING,this.getAttacking);
      }
      
      override public function init() : void
      {
         super.init();
         var header:TextField = this.myLeftContainer["myScoreboard"]["myHeader"] as TextField;
         header.text = LocalizeUtil.localize("UI_HUD_SDPLUS_SCOREBOARD_LABEL");
      }
      
      override protected function showView() : void
      {
         super.showView();
         var stagePosition:Point = GameInfo.stagePosition;
         this.myLeftContainer.x = stagePosition.x;
         CFunctionInGameContainer.AS_RegisterHUDView(CFunctionInGameContainer.HVT_SAD,this);
         ShoutcastUtil.getInstance().registerView(this);
         this.myLeftContainer.alpha = 1;
      }
      
      public function cppSDPSetCanPurchase(value:Boolean) : void
      {
         SDPlusPvpUtil.instance.canPurchase = value;
         this.myPurchaseHint.visible = value;
      }
      
      public function cppSetAttacking(value:Boolean) : void
      {
         this._attacking = value;
         setBindData(DataInGameID.SD_ATTACKING,this._attacking);
      }
      
      public function cppSetPrematchTimer(value:int) : void
      {
         setBindData(DataInGameID.SD_PREMATCH_TIMER,value);
      }
      
      public function cppSetChampionSelections(value:Array) : void
      {
         setBindData(DataInGameID.CHAMPION_SELECTIONS,value);
      }
      
      private function getAttacking() : Boolean
      {
         return this._attacking;
      }
   }
}

