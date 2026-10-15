package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.BCInGameEvent;
   import codo.constants.GameInfo;
   import codo.event.ParaEvent;
   import codo.utils.ClashPvpUtil;
   import codo.utils.Logger;
   import codo.utils.ShoutcastUtil;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   
   public class HudClash extends BaseView
   {
      
      public var healthBar:MovieClip;
      
      public var enduranceBar:MovieClip;
      
      public var myLeftContainer:MovieClip;
      
      public var myRightContainer:MovieClip;
      
      public var buffIcon:MovieClip;
      
      public var notifications:MovieClip;
      
      private var INTV_BLOCK:int = 5;
      
      public var enduranceBarBlockArray:Array = new Array();
      
      public var enduranceBarBlockScaleX:Number = 1;
      
      private var INVT_BUFFICON:int = 10;
      
      public var buffArray:Array = new Array();
      
      private var healthBarY:Number;
      
      public function HudClash()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         super.init();
         this.healthBarY = this.healthBar.y;
         this.listen(BCInGameEvent.EVT_PLAYERCARD_OPENED,this.onPlayerCardOpened);
         this.listen(BCInGameEvent.EVT_PLAYERCARD_ClOSED,this.onPlayerCardClosed);
      }
      
      private function onPlayerCardOpened(cEvt:ParaEvent) : void
      {
         this.healthBar.y = cEvt.myPara - 30;
      }
      
      private function onPlayerCardClosed(cEvt:ParaEvent) : void
      {
         this.healthBar.y = this.healthBarY;
      }
      
      override protected function showView() : void
      {
         CFunctionInGameContainer.AS_RegisterHUDView(CFunctionInGameContainer.HVT_Clash,this);
         var stageSize:Point = GameInfo.stageSize;
         var stagePosition:Point = GameInfo.stagePosition;
         this.enduranceBar.bar.alpha = 0;
         this.myLeftContainer.x = stagePosition.x;
         if(ClashPvpUtil.isClashTDM())
         {
            this.myLeftContainer.y = stagePosition.y + (stageSize.y - 400);
         }
         else
         {
            this.myLeftContainer.y = stagePosition.y;
         }
         this.myRightContainer.x = -stagePosition.x;
         this.buffIcon.alpha = 0;
         ShoutcastUtil.getInstance().registerView(this);
      }
      
      public function refreshEnduranceBar(totalSwing:int) : void
      {
         var totalwidth:int = 0;
         var blockwidth:int = 0;
         var blockheight:int = 0;
         var tmv:MovieClip = null;
         var block:MovieClip = null;
         var barClass:Class = null;
         var i:int = 0;
         var tbar:MovieClip = null;
         for each(block in this.enduranceBarBlockArray)
         {
            if(block.parent != null)
            {
               block.parent.removeChild(block);
            }
         }
         this.enduranceBarBlockArray.splice(0);
         tmv = this.enduranceBar.bar as MovieClip;
         totalwidth = tmv.width;
         blockwidth = (totalwidth - (totalSwing - 1) * this.INTV_BLOCK) / totalSwing;
         blockheight = tmv.height;
         this.enduranceBarBlockScaleX = blockwidth / totalwidth;
         barClass = getDefinitionByName("hudClashEnduranceBlock") as Class;
         for(i = 0; i < totalSwing; i++)
         {
            tbar = new barClass();
            this.enduranceBar.addChildAt(tbar,1);
            tbar.x = this.enduranceBar.bar.x + i * (blockwidth + this.INTV_BLOCK);
            tbar.y = this.enduranceBar.bar.y;
            tbar.width = blockwidth;
            tbar.height = blockheight;
            this.enduranceBarBlockArray.push(tbar);
         }
      }
      
      public function refreshBuffIcons(totalBuffs:int) : void
      {
         var tbufficon:MovieClip = null;
         var oldbuff:MovieClip = null;
         var buffIconClass:Class = null;
         var i:int = 0;
         var iconwidth:int = 64;
         var iconintv:int = this.INVT_BUFFICON;
         var startx:int = this.buffIcon.x + iconwidth / 2 - totalBuffs * (iconwidth + iconintv) / 2 + iconintv / 2;
         var starty:int = this.buffIcon.y;
         for each(oldbuff in this.buffArray)
         {
            if(oldbuff.parent != null)
            {
               oldbuff.parent.removeChild(oldbuff);
            }
         }
         this.buffArray.splice(0);
         Logger.print("totalBuffs : " + totalBuffs);
         buffIconClass = getDefinitionByName("hudClashBuffIcon") as Class;
         for(i = 0; i < totalBuffs; i++)
         {
            tbufficon = new buffIconClass();
            tbufficon.x = startx + i * (iconwidth + iconintv);
            tbufficon.y = starty;
            this.addChildAt(tbufficon,1);
            this.buffArray.push(tbufficon);
         }
      }
      
      public function playNotification(imgpath:String) : void
      {
         this.notifications.icon.image.setImage(imgpath);
      }
      
      public function setStatusIcon(tagname:String) : void
      {
         var colTag_dropItem:int = 0;
         var colSplashName_dropItem:int = 0;
         var splashName:String = null;
         var colSplashName_splash:int = 0;
         var colIcon_Splash:int = 0;
         var iconpath:String = null;
         if(tagname != "")
         {
            this.myRightContainer.bar_status.icon.visible = true;
            colTag_dropItem = 0;
            colSplashName_dropItem = 5;
            splashName = CFunctionCommonContainer.StringTableLookup("mp/clashDropItemsTable.csv",colTag_dropItem,tagname,colSplashName_dropItem);
            colSplashName_splash = 0;
            colIcon_Splash = 3;
            iconpath = CFunctionCommonContainer.StringTableLookup("mp/splashTable.csv",colSplashName_splash,splashName,colIcon_Splash);
            this.myRightContainer.bar_status.icon.setImage(iconpath);
         }
         else
         {
            this.myRightContainer.bar_status.icon.visible = false;
         }
      }
   }
}

