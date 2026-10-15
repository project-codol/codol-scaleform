package codo.utils
{
   import codo.constants.QuickMatchType;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import scaleform.gfx.Extensions;
   
   public class ScaleformUtil
   {
      
      public static var CFUNCTION_COMMON:*;
      
      private static var _isScaleform:Boolean;
      
      private static var _inFrontendLoadout:Boolean;
      
      private static var _inLobbyLoadout:Boolean;
      
      private static var _inInventoryStorage:Boolean;
      
      private static var _isInit:Boolean = false;
      
      private static var _isMe:Boolean = true;
      
      public function ScaleformUtil()
      {
         super();
      }
      
      public static function set isScaleform(cSwi:Boolean) : void
      {
         _isInit = true;
         _isScaleform = cSwi;
      }
      
      public static function get isScaleform() : Boolean
      {
         if(_isInit == false)
         {
            _isInit = true;
            _isScaleform = Extensions.isScaleform;
         }
         return _isScaleform;
      }
      
      public static function isTempContentEnabled() : Boolean
      {
         var result:Boolean = true;
         if(ScaleformUtil.isScaleform)
         {
            result = Boolean(CFUNCTION_COMMON.Dvar_GetBool("ui_enable_temp_content"));
         }
         return result;
      }
      
      public static function isTempContentEnabled_1() : Boolean
      {
         var result:Boolean = true;
         if(ScaleformUtil.isScaleform)
         {
            result = Boolean(CFUNCTION_COMMON.Dvar_GetBool("ui_enable_temp_content_1"));
         }
         return result;
      }
      
      public static function isTempContentEnabled_2() : Boolean
      {
         var result:Boolean = true;
         if(ScaleformUtil.isScaleform)
         {
            result = Boolean(CFUNCTION_COMMON.Dvar_GetBool("ui_enable_temp_content_2"));
         }
         return result;
      }
      
      public static function isTempContentEnabled_3() : Boolean
      {
         var result:Boolean = true;
         if(ScaleformUtil.isScaleform)
         {
            result = Boolean(CFUNCTION_COMMON.Dvar_GetBool("ui_enable_temp_content_3"));
         }
         return result;
      }
      
      public static function isFsgWeaponCustomizationEnabled() : Boolean
      {
         var result:Boolean = true;
         if(ScaleformUtil.isScaleform)
         {
            result = Boolean(CFUNCTION_COMMON.Dvar_GetBool("ui_fsg_weap_customization"));
         }
         return result;
      }
      
      public static function isFsgOptionsEnabled() : Boolean
      {
         var result:Boolean = true;
         if(ScaleformUtil.isScaleform)
         {
            result = Boolean(CFUNCTION_COMMON.Dvar_GetBool("ui_fsg_options"));
         }
         return result;
      }
      
      public static function isFsgGameModesEnabled() : Boolean
      {
         var result:Boolean = true;
         if(ScaleformUtil.isScaleform)
         {
            result = Boolean(CFUNCTION_COMMON.Dvar_GetBool("ui_fsg_gamemodes"));
         }
         return result;
      }
      
      public static function isFsgPlayercardEnabled() : Boolean
      {
         var result:Boolean = true;
         if(ScaleformUtil.isScaleform)
         {
            result = Boolean(CFUNCTION_COMMON.Dvar_GetBool("ui_fsg_playercard"));
         }
         return result;
      }
      
      public static function isFsgFriendslistEnabled() : Boolean
      {
         var result:Boolean = true;
         if(ScaleformUtil.isScaleform)
         {
            result = Boolean(CFUNCTION_COMMON.Dvar_GetBool("ui_fsg_friendsList"));
         }
         return result;
      }
      
      public static function isFsgKeyboardPopupEnabled() : Boolean
      {
         var result:Boolean = true;
         if(ScaleformUtil.isScaleform)
         {
            result = Boolean(CFUNCTION_COMMON.Dvar_GetBool("ui_fsg_keyboard_popup"));
         }
         return result;
      }
      
      public static function isFsgPartyEnabled() : Boolean
      {
         var result:Boolean = true;
         if(ScaleformUtil.isScaleform)
         {
            result = Boolean(CFUNCTION_COMMON.Dvar_GetBool("ui_fsg_party"));
         }
         return result;
      }
      
      public static function isFsgClanEnabled() : Boolean
      {
         var result:Boolean = true;
         if(ScaleformUtil.isScaleform)
         {
            result = Boolean(CFUNCTION_COMMON.Dvar_GetBool("ui_fsg_clan"));
         }
         return result;
      }
      
      public static function isFsgCyborgTokenEnabled() : Boolean
      {
         var result:Boolean = true;
         if(ScaleformUtil.isScaleform)
         {
            result = Boolean(CFUNCTION_COMMON.Dvar_GetBool("ui_fsg_cyborg_token"));
         }
         return result;
      }
      
      public static function isFsgDailyChallengesEnabled() : Boolean
      {
         var result:Boolean = true;
         if(ScaleformUtil.isScaleform)
         {
            result = Boolean(CFUNCTION_COMMON.Dvar_GetBool("ui_fsg_dailychallenges"));
         }
         return result;
      }
      
      public static function blockAltEnter(shouldBlock:Boolean) : void
      {
         Logger.print("blockAltEnter:" + shouldBlock);
         if(ScaleformUtil.isScaleform)
         {
            CFUNCTION_COMMON.setdvar("ui_blockalt_enter",shouldBlock ? "1" : "0");
         }
      }
      
      public static function isCurrentModeUnlocked(matchType:QuickMatchType) : Boolean
      {
         var unlocked:Boolean = true;
         if(ScaleformUtil.isScaleform)
         {
            if(matchType.isCyborgs())
            {
               unlocked = CFUNCTION_COMMON.AS_IsNotificationUnlocked("un_cyborg_future") as Boolean;
            }
            else if(matchType.isSurvival())
            {
               unlocked = CFUNCTION_COMMON.AS_IsNotificationUnlocked("un_survival") as Boolean;
            }
         }
         return unlocked;
      }
      
      public static function getDebugType() : int
      {
         var result:int = 1;
         if(ScaleformUtil.isScaleform)
         {
            result = int(CFUNCTION_COMMON.Dvar_GetInt("ui_scaleform_log"));
         }
         return result;
      }
      
      public static function isFSGNewContentEnabled() : Boolean
      {
         var result:Boolean = true;
         if(ScaleformUtil.isScaleform)
         {
            result = Boolean(CFUNCTION_COMMON.Dvar_GetBool("ui_fsg_enable_new_content"));
         }
         return result;
      }
      
      public static function IsLogItemIDEnabled() : Boolean
      {
         var result:Boolean = true;
         if(ScaleformUtil.isScaleform)
         {
            result = Boolean(CFUNCTION_COMMON.Dvar_GetBool("ui_fsg_log_item_id"));
         }
         return result;
      }
      
      public static function visibleRect(displayObj:DisplayObject = null) : Rectangle
      {
         if(ScaleformUtil.isScaleform)
         {
            return Extensions.visibleRect;
         }
         if(Boolean(displayObj))
         {
            return new Rectangle(0,0,displayObj.stage.width,displayObj.stage.height);
         }
         return new Rectangle(0,0,0,0);
      }
      
      public static function get inFrontendLoadout() : Boolean
      {
         return _inFrontendLoadout;
      }
      
      public static function get inLobbyLoadout() : Boolean
      {
         return _inLobbyLoadout;
      }
      
      public static function get inStorage() : Boolean
      {
         return _inInventoryStorage;
      }
      
      public static function setInFrontendLoadout(inLoadout:Boolean) : void
      {
         _inFrontendLoadout = inLoadout;
      }
      
      public static function setInLobbyLoadout(inLoadout:Boolean) : void
      {
         _inLobbyLoadout = inLoadout;
      }
      
      public static function setInInventoryStorage(inStorage:Boolean) : void
      {
         _inInventoryStorage = inStorage;
      }
      
      public static function set isMe(me:Boolean) : void
      {
         _isMe = me;
      }
      
      public static function get isMe() : Boolean
      {
         return _isMe;
      }
   }
}

