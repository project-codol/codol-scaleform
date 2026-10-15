package codo.views.hud.popups
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCInGameEvent;
   import codo.constants.DataInGameID;
   import codo.constants.HUDPopupComponentTypes;
   import codo.event.ParaEvent;
   import codo.views.hud.HUDPopupComponent;
   import codo.views.hud.popups.HudSplashPopup_parts.HudSplashPopupContent;
   import codo.views.hud.popups.HudSplashPopup_parts.HudTdSplashContent;
   import codo.views.hud.popups.HudSplashPopup_parts.HudZhuntObtainConsumableSplashContent;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import fl.motion.easing.Linear;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import fsg.util.FsgAudioUtil;
   
   public class HudSplashPopup extends HUDPopupComponent
   {
      
      private var mContent:HudSplashPopupContent;
      
      private var mMenu:String;
      
      public function HudSplashPopup()
      {
         super();
         mShowMask = false;
         mBlurView = false;
      }
      
      override public function get CompType() : int
      {
         return HUDPopupComponentTypes.SPLASH;
      }
      
      override public function set routeData(data:*) : void
      {
         this.mMenu = data as String;
      }
      
      override protected function showView() : void
      {
         super.showView();
         TweenLite.killTweensOf(this);
         this.alpha = 0;
         TweenLite.to(this,0.1,{
            "alpha":1,
            "ease":Linear.easeIn
         });
         if(getDP(DataInGameID.GAME_TYPE) == "zhunt")
         {
            listen(BCInGameEvent.EVT_SET_ZHUNT_OBTAIN_CONSUMABLE_SPLASH_BG_VISIBILITY,this.onSetZhuntObtainConsumableSplashBGVisibility);
         }
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         TweenLite.killTweensOf(this);
         TweenLite.to(this,0.1,{
            "alpha":0,
            "ease":Linear.easeOut
         });
         if(getDP(DataInGameID.GAME_TYPE) == "zhunt")
         {
            unlisten(BCInGameEvent.EVT_SET_ZHUNT_OBTAIN_CONSUMABLE_SPLASH_BG_VISIBILITY,this.onSetZhuntObtainConsumableSplashBGVisibility);
         }
      }
      
      public function cppSetData(nameId:String, icon:String, title:String, titleColor:int, description:String, sound:String, param:String) : void
      {
         var startX:Number = NaN;
         var startY:Number = NaN;
         var endX:Number = NaN;
         var endY:Number = NaN;
         var localEndPoint:Point = null;
         var content:HudZhuntObtainConsumableSplashContent = null;
         var timeLineLite:TimelineLite = null;
         var localPoint:Point = null;
         var tdContent:HudTdSplashContent = null;
         var gameType:String = getDP(DataInGameID.GAME_TYPE) as String;
         if(Boolean(this.mContent))
         {
            removeChild(this.mContent);
         }
         if(gameType == "nftbl")
         {
            this.mContent = this.buildContent("codo.shared.hud.popups.hudNftblSplashContent",icon,title,titleColor,description,param);
            this.mContent.x = mMask.x + (mMask.width - this.mContent.width) * 0.5;
            this.mContent.y = mMask.y + 240;
         }
         else if(gameType == "zhunt")
         {
            this.mContent = this.buildContent("codo.shared.hud.popups.hudZhuntObtainConsumableSplashContent",icon,title,titleColor,description,param);
            startX = CFunctionCommonContainer.Dvar_GetFloat("ui_zhunt_purchase_consumable_option_x");
            startY = CFunctionCommonContainer.Dvar_GetFloat("ui_zhunt_purchase_consumable_option_y");
            endX = CFunctionCommonContainer.Dvar_GetFloat("ui_zhunt_weapon_bar_consumable_icon_x");
            endY = CFunctionCommonContainer.Dvar_GetFloat("ui_zhunt_weapon_bar_consumable_icon_y");
            if(startX == 0 || startY == 0)
            {
               startX = mMask.x + (mMask.width - this.mContent.width) * 0.5;
               startY = mMask.y + mMask.height * 0.5;
            }
            else
            {
               localPoint = this.globalToLocal(new Point(startX,startY));
               startX = localPoint.x;
               startY = localPoint.y;
            }
            this.mContent.x = startX;
            this.mContent.y = startY;
            localEndPoint = this.globalToLocal(new Point(endX,endY));
            content = this.mContent as HudZhuntObtainConsumableSplashContent;
            content.killAllTweens();
            timeLineLite = new TimelineLite();
            timeLineLite.append(new TweenLite(content,0.5,{
               "onStart":content.iconBounce,
               "onStartParams":[0.5]
            }));
            timeLineLite.append(new TweenLite(content,0.2,{
               "delay":1.3,
               "onStart":content.fadeAllElementsExceptIcon,
               "onStartParams":[0.2]
            }));
            timeLineLite.append(new TweenLite(content,0.5,{
               "delay":0.1,
               "x":localEndPoint.x,
               "y":localEndPoint.y,
               "width":0,
               "height":0
            }));
         }
         else if(gameType == "td")
         {
            this.mContent = this.buildContent("codo.shared.hud.popups.hudTdSplashContent",icon,title,titleColor,description,param);
            tdContent = this.mContent as HudTdSplashContent;
            this.mContent.x = mMask.x + (mMask.width - tdContent.myBg.width) * 0.5;
            this.mContent.y = mMask.y + 140;
         }
         if(this.mContent != null && Boolean(sound))
         {
            FsgAudioUtil.getInstance().playSound(sound);
         }
      }
      
      private function buildContent(className:String, icon:String, title:String, titleColor:int, description:String, param:String) : HudSplashPopupContent
      {
         var cls:Class = getDefinitionByName(className) as Class;
         var content:HudSplashPopupContent = addChild(new cls()) as HudSplashPopupContent;
         content.setData(icon,title,titleColor,description,param);
         return content;
      }
      
      private function onSetZhuntObtainConsumableSplashBGVisibility(evt:ParaEvent) : void
      {
         var content:HudZhuntObtainConsumableSplashContent = null;
         if(this.mContent != null && this.mContent is HudZhuntObtainConsumableSplashContent)
         {
            content = this.mContent as HudZhuntObtainConsumableSplashContent;
            content.setDarkBackgroundVisibility(evt.myPara as Boolean);
         }
      }
   }
}

