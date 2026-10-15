package codo.component.playerAccount
{
   import codo.common.CFunctionCommonContainer;
   import codo.utils.PrivilegeUtil;
   import codo.utils.ScaleformUtil;
   import flash.display.Sprite;
   import flash.geom.Point;
   import fsg.shared.ToolTipItem;
   
   public class PlayerAccountInfoPrivileges extends Sprite
   {
      
      private static var SPACING:int = 15;
      
      public var myVIPImage:ToolTipItem;
      
      public var myBlueDiamondImage:ToolTipItem;
      
      public var myNetCafeImage:ToolTipItem;
      
      public var myTGPImage:ToolTipItem;
      
      public function PlayerAccountInfoPrivileges()
      {
         super();
      }
      
      public function init() : void
      {
         if(ScaleformUtil.isScaleform)
         {
            this.myVIPImage.visible = false;
            this.myBlueDiamondImage.visible = false;
            this.myNetCafeImage.visible = false;
         }
      }
      
      private function positionClips() : void
      {
         var x:Number = this.myNetCafeImage.x = 0;
         if(this.myNetCafeImage.visible == true)
         {
            x -= this.myNetCafeImage.width;
         }
         if(this.myVIPImage.visible == true)
         {
            this.myVIPImage.x = x;
            x -= this.myVIPImage.width + SPACING;
         }
         if(this.myBlueDiamondImage.visible == true)
         {
            this.myBlueDiamondImage.x = x;
            x -= this.myBlueDiamondImage.width + SPACING;
         }
         if(this.myTGPImage.visible == true)
         {
            this.myTGPImage.x = x;
            x -= this.myTGPImage.width + SPACING;
         }
      }
      
      private function setToolTips() : void
      {
         var netCafeTipOffset:Point = new Point(-95,-5);
         var qqVipTipOffset:Point = new Point(-32,5);
         var blueDiamondTipOffset:Point = new Point(-32,5);
         var tgpTipOffset:Point = new Point(-25,5);
         this.myNetCafeImage.tipOffset = netCafeTipOffset;
         this.myVIPImage.tipOffset = qqVipTipOffset;
         this.myBlueDiamondImage.tipOffset = blueDiamondTipOffset;
         this.myTGPImage.tipOffset = tgpTipOffset;
      }
      
      public function showLocalPlayerPrivileges() : void
      {
         var qq_membership:int = 0;
         var netcafe_privileges:int = 0;
         var privileges:Object = CFunctionCommonContainer.GetPlayerPrivileges();
         if(privileges != null)
         {
            qq_membership = int(privileges.qq_membership);
            netcafe_privileges = int(privileges.netcafe);
            this.showPlayerPrivileges(qq_membership,netcafe_privileges);
         }
      }
      
      public function showPlayerPrivileges(qq_membership:int, netcafe_privileges:int) : void
      {
         PrivilegeUtil.showNetCafePrivileges(netcafe_privileges,this.myNetCafeImage);
         PrivilegeUtil.showQQMembership(qq_membership,this.myVIPImage,this.myBlueDiamondImage,this.myTGPImage);
         this.positionClips();
         this.setToolTips();
      }
   }
}

