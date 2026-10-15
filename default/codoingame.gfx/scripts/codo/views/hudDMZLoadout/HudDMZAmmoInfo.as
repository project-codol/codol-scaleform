package codo.views.hudDMZLoadout
{
   import codo.common.CFunctionInGameContainer;
   import flash.display.MovieClip;
   
   public class HudDMZAmmoInfo extends MovieClip
   {
      
      public var myArlmgAmmo:HudDMZAmmoSlot;
      
      public var myPstsmgAmmo:HudDMZAmmoSlot;
      
      public var myShotgunAmmo:HudDMZAmmoSlot;
      
      public var mySniperAmmo:HudDMZAmmoSlot;
      
      public function HudDMZAmmoInfo()
      {
         super();
         this.arlmgAmmo = 0;
         this.pstsmgAmmo = 0;
         this.shotgunAmmo = 0;
         this.sniperAmmo = 0;
         this.myArlmgAmmo.ammoType = "arlmg";
         this.myPstsmgAmmo.ammoType = "pstsmg";
         this.myShotgunAmmo.ammoType = "shotgun";
         this.mySniperAmmo.ammoType = "sniper";
         this.myArlmgAmmo.myDropButton.visible = false;
         this.myPstsmgAmmo.myDropButton.visible = false;
         this.myShotgunAmmo.myDropButton.visible = false;
         this.mySniperAmmo.myDropButton.visible = false;
      }
      
      public function set arlmgAmmo(num:int) : void
      {
         this.myArlmgAmmo.myCount.text = num.toString();
         this.myArlmgAmmo.myDropButton.visible = true;
         if(num == 0)
         {
            this.myArlmgAmmo.myDropButton.visible = false;
         }
         if(Boolean(CFunctionInGameContainer.AS_IsPlayerDead()))
         {
            this.myArlmgAmmo.myDropButton.visible = false;
         }
      }
      
      public function set pstsmgAmmo(num:int) : void
      {
         this.myPstsmgAmmo.myCount.text = num.toString();
         this.myPstsmgAmmo.myDropButton.visible = true;
         if(num == 0)
         {
            this.myPstsmgAmmo.myDropButton.visible = false;
         }
         if(Boolean(CFunctionInGameContainer.AS_IsPlayerDead()))
         {
            this.myPstsmgAmmo.myDropButton.visible = false;
         }
      }
      
      public function set shotgunAmmo(num:int) : void
      {
         this.myShotgunAmmo.myCount.text = num.toString();
         this.myShotgunAmmo.myDropButton.visible = true;
         if(num == 0)
         {
            this.myShotgunAmmo.myDropButton.visible = false;
         }
         if(Boolean(CFunctionInGameContainer.AS_IsPlayerDead()))
         {
            this.myShotgunAmmo.myDropButton.visible = false;
         }
      }
      
      public function set sniperAmmo(num:int) : void
      {
         this.mySniperAmmo.myCount.text = num.toString();
         this.mySniperAmmo.myDropButton.visible = true;
         if(num == 0)
         {
            this.mySniperAmmo.myDropButton.visible = false;
         }
         if(Boolean(CFunctionInGameContainer.AS_IsPlayerDead()))
         {
            this.mySniperAmmo.myDropButton.visible = false;
         }
      }
   }
}

