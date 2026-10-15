package codo.views.hudSpy
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.BCInGameEvent;
   import codo.constants.SpyModeRoleType;
   import codo.constants.SpyRoundType;
   import codo.hud.spy.killMapDivisor;
   import codo.hud.spy.killMapItem;
   import codo.localization.DictHud;
   import codo.localization.DictMatchResults;
   import codo.manager.EventManager;
   import codo.objects.SpyModeKillMapItemObj;
   import codo.style.SpyHudGuide;
   import codo.utils.LocalizeUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class KillMap extends UIInteractiveComponent
   {
      
      public var myItemsHolder:MovieClip;
      
      public var myCollapseText:TextField;
      
      public var myText:TextField;
      
      public var myIcon:MovieClip;
      
      public var myBG:MovieClip;
      
      private var mItems:Vector.<KillMapItem>;
      
      private var mDivisors:Vector.<MovieClip>;
      
      public function KillMap()
      {
         super();
         this.mItems = new Vector.<KillMapItem>(0);
         this.mDivisors = new Vector.<MovieClip>(0);
         this.myCollapseText.textStyle = SpyHudGuide.SpyKillMapCollapseText;
         var keyChar:String = LocalizeUtil.localizeFirstKeyBindingForCommand("+melee");
         LocalizeUtil.paramColorized(this.myCollapseText.myTextClip,DictHud.SPY_PRESS_KEY_E_TO_COLLAPSE,[keyChar.toUpperCase()],[16743724]);
      }
      
      public function toggle() : void
      {
         if(!visible)
         {
            this.show();
         }
         else
         {
            this.hide();
         }
      }
      
      public function show() : void
      {
         var items:Vector.<SpyModeKillMapItemObj> = null;
         var winRole:int = 0;
         var blur:Number = 1;
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_BLUR,blur);
         var roundType:int = CFunctionInGameContainer.AS_SpyMode_GetRoundType();
         if(roundType == SpyRoundType.ROUND_NORMAL)
         {
            winRole = CFunctionCommonContainer.Dvar_GetInt("ui_spy_winner");
            this.myIcon.gotoAndStop(winRole);
            if(winRole == SpyModeRoleType.SPY_ROLE_SPY)
            {
               this.myText.textStyle = SpyHudGuide.SpyKillMapWinnerSpy;
               this.myText.text = DictHud.SPY_MATCH_SPY_WIN;
            }
            else
            {
               this.myText.textStyle = SpyHudGuide.SpyKillMapWinnerCivilian;
               this.myText.text = DictHud.SPY_MATCH_CIVILIAN_WIN;
            }
         }
         else
         {
            this.myIcon.gotoAndStop(roundType + 3);
            this.myText.textStyle = SpyHudGuide.SpyKillMapWinnerCivilian;
            this.myText.text = DictMatchResults.MATCH_WON;
         }
         items = CFunctionInGameContainer.AS_SpyGetKillMap();
         this.cleanItems();
         visible = true;
         this.setData(items);
      }
      
      public function hide() : void
      {
         var blur:Number = 0;
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_BLUR,blur);
         visible = false;
         this.cleanItems();
      }
      
      private function cleanItems() : void
      {
         for(var i:int = 0; i < this.mItems.length; i++)
         {
            TweenLite.killTweensOf(this.mItems[i]);
         }
         this.mItems = new Vector.<KillMapItem>(0);
         this.mDivisors = new Vector.<MovieClip>(0);
         while(this.myItemsHolder.numChildren > 0)
         {
            this.myItemsHolder.removeChildAt(0);
         }
      }
      
      override public function setData(data:*) : void
      {
         var items:Vector.<SpyModeKillMapItemObj> = null;
         var i:int = 0;
         var divisor:MovieClip = null;
         var item:KillMapItem = null;
         super.setData(data);
         items = data as Vector.<SpyModeKillMapItemObj>;
         for(i = 0; i < items.length; i++)
         {
            divisor = new killMapDivisor();
            this.myItemsHolder.addChild(divisor);
            this.mDivisors.push(divisor);
            divisor.y = i * 61;
            item = new killMapItem();
            this.myItemsHolder.addChild(item);
            this.mItems.push(item);
            item.y = i * 61;
            item.setData(items[i]);
            TweenLite.to(item,0.2,{
               "alpha":1,
               "delay":0.2 + 0.01 * i
            });
         }
      }
   }
}

