package codo.component.lobby
{
   import codo.component.Button;
   import codo.objects.ZombieChampionObj;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ZombieChampionSwitcher extends MovieClip
   {
      
      public var myChampName:TextField;
      
      public var mySwitchButton:Button;
      
      public var myDetailButton:Button;
      
      public function ZombieChampionSwitcher()
      {
         super();
         this.mySwitchButton.label = "@SF_UI_SWITCH";
         this.myDetailButton.label = "@SF_UI_MORE_INFO";
      }
      
      public function setData(data:ZombieChampionObj, switchCallback:Function, detailCallback:Function) : void
      {
         this.myChampName.text = data.name;
         this.mySwitchButton.setClickCallback(switchCallback,null,true);
         this.myDetailButton.setClickCallback(detailCallback,data,true);
      }
   }
}

