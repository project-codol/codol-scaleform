package codo.utils
{
   import codo.constants.PlayerPrivilege;
   import codo.localization.Dict;
   import com.society.comscore.DAXDispatcher;
   import flash.display.MovieClip;
   import fsg.shared.ToolTipItem;
   
   public class PrivilegeUtil
   {
      
      private static var s_debugPrivileges:Boolean = false;
      
      public static var enableBlueDiamondDeluxe:Boolean = false;
      
      private static const QQ_VIP:int = 0;
      
      private static const NETCAFE:int = 1;
      
      private static const TGP:int = 2;
      
      public function PrivilegeUtil()
      {
         super();
      }
      
      public static function showNetCafePrivileges(privilegeFlags:int, netCafeClip:MovieClip, isMe:Boolean = false) : void
      {
         var toolTipItem:ToolTipItem = null;
         if(s_debugPrivileges)
         {
            privilegeFlags |= 1 << 2;
         }
         if(netCafeClip == null)
         {
            return;
         }
         if(privilegeFlags == 0)
         {
            netCafeClip.visible = false;
         }
         else
         {
            netCafeClip.visible = true;
            toolTipItem = netCafeClip as ToolTipItem;
            if(Boolean(privilegeFlags & PlayerPrivilege.NETCAFE_BRONZE))
            {
               comScoreReportPrivilege(NETCAFE,"netcafe_bronze");
               netCafeClip.gotoAndStop(isMe ? 4 : 1);
               if(toolTipItem != null)
               {
                  toolTipItem.setTip(Dict.PRIVILEGE_TOOLTIP_NETCAFE_BRONZE);
               }
            }
            else if(Boolean(privilegeFlags & PlayerPrivilege.NETCAFE_SILVER))
            {
               comScoreReportPrivilege(NETCAFE,"netcafe_silver");
               netCafeClip.gotoAndStop(isMe ? 5 : 2);
               if(toolTipItem != null)
               {
                  toolTipItem.setTip(Dict.PRIVILEGE_TOOLTIP_NETCAFE_SILVER);
               }
            }
            else if(Boolean(privilegeFlags & PlayerPrivilege.NETCAFE_GOLD))
            {
               comScoreReportPrivilege(NETCAFE,"netcafe_gold");
               netCafeClip.gotoAndStop(isMe ? 6 : 3);
               if(toolTipItem != null)
               {
                  toolTipItem.setTip(Dict.PRIVILEGE_TOOLTIP_NETCAFE_PLATINUM);
               }
            }
         }
      }
      
      public static function showQQMembership(privilegeFlags:int, vipClip:MovieClip, diamondClip:MovieClip, tgpClip:MovieClip) : void
      {
         var vipTipItem:ToolTipItem = null;
         var tgpClipItem:ToolTipItem = null;
         var tip:String = null;
         var diamondTipItem:ToolTipItem = null;
         if(s_debugPrivileges)
         {
            privilegeFlags |= 1 << 1;
            privilegeFlags |= 1 << 2;
         }
         if(vipClip == null || diamondClip == null || tgpClip == null)
         {
            return;
         }
         if(privilegeFlags == 0)
         {
            vipClip.visible = false;
            diamondClip.visible = false;
            tgpClip.visible = false;
         }
         else
         {
            if(Boolean(privilegeFlags & PlayerPrivilege.QQ_MEMBERSHIP))
            {
               vipClip.visible = true;
               comScoreReportPrivilege(QQ_VIP,"qq_membership");
            }
            else
            {
               vipClip.visible = false;
            }
            vipTipItem = vipClip as ToolTipItem;
            if(vipTipItem != null)
            {
               vipTipItem.setTip(Dict.PRIVILEGE_TOOLTIP_QQVIP);
            }
            if(Boolean(privilegeFlags & PlayerPrivilege.BLUE_DIAMOND) || Boolean(privilegeFlags & PlayerPrivilege.CODO_BLUE_DIAMOND_DELUXE) && Boolean(enableBlueDiamondDeluxe))
            {
               diamondClip.visible = true;
               if(Boolean(privilegeFlags & PlayerPrivilege.BLUE_DIAMOND))
               {
                  comScoreReportPrivilege(QQ_VIP,"blue_diamond");
                  diamondClip.gotoAndStop(1);
                  tip = Dict.PRIVILEGE_TOOLTIP_BLUEDIAMOND;
               }
               if(Boolean(privilegeFlags & PlayerPrivilege.CODO_BLUE_DIAMOND_DELUXE))
               {
                  comScoreReportPrivilege(QQ_VIP,"blue_diamond_deluxe");
                  diamondClip.gotoAndStop(2);
                  tip = Dict.PRIVILEGE_TOOLTIP_BLUEDIAMONDDELUXE;
               }
               diamondTipItem = diamondClip as ToolTipItem;
               if(diamondTipItem != null)
               {
                  diamondTipItem.setTip(tip);
               }
            }
            else
            {
               diamondClip.visible = false;
            }
            if(Boolean(privilegeFlags & PlayerPrivilege.TPG_LOGIN))
            {
               tgpClip.visible = true;
               comScoreReportPrivilege(TGP,"tgp");
            }
            else
            {
               tgpClip.visible = false;
            }
            tgpClipItem = tgpClip as ToolTipItem;
            if(tgpClipItem != null)
            {
               tgpClipItem.setTip(Dict.PRIVILEGE_TOOLTIP_TGP);
            }
         }
      }
      
      private static function comScoreReportPrivilege(type:int, value:String) : void
      {
         try
         {
            if(type == QQ_VIP)
            {
               DAXDispatcher.setQQIV(value);
            }
            else if(type == NETCAFE)
            {
               DAXDispatcher.setNetCafe(value);
            }
            else if(type == TGP)
            {
               DAXDispatcher.setTGP(value);
            }
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
      }
   }
}

