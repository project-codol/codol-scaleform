package codo.component.home
{
   import codo.component.marketplaceitem.parts.IconLock;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.objects.WarGodPlayerObj;
   import codo.objects.WarGodSeasonObj;
   import flash.display.Sprite;
   
   public class WarGodPlayModeButton extends HomePlayModeButton
   {
      
      public var myLock:IconLock;
      
      public var myLockScrim:Sprite;
      
      private var mEnabled:Boolean;
      
      private var mDataReady:Boolean = false;
      
      public function WarGodPlayModeButton()
      {
         super();
         myLabel.fontSize = 22;
         this.myLock.visible = false;
         this.myLockScrim.visible = false;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
      }
      
      public function switchWarGodActive(enable:Boolean) : void
      {
         this.mEnabled = enable;
      }
      
      public function setWarGodData(wargodSetting:WarGodGlobalSettingObj, seasonObj:WarGodSeasonObj, playerObj:WarGodPlayerObj) : void
      {
         this.mDataReady = true;
         if(Boolean(wargodSetting))
         {
            myLabel.text = wargodSetting.entranceLabel;
         }
         else
         {
            myLabel.text = "";
         }
      }
      
      public function setLockLevel(level:String) : void
      {
         this.myLock.visible = true;
         this.myLock.setLockLevel(level);
         this.myLockScrim.visible = true;
         mClickable.setEnabled(false);
         myHitArea.visible = false;
      }
   }
}

