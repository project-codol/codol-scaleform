package codo.component.lobby
{
   import codo.objects.ZombieChampionSkillObj;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.shared.InputIconUtility;
   import fsg.util.FsgImageHolder;
   
   public class ZombieChampionDetailSkill extends MovieClip
   {
      
      public var myName:TextField;
      
      public var myDesc:TextField;
      
      public var myUpgrade:TextField;
      
      public var myImage:FsgImageHolder;
      
      public var myKeyBind:InputIconUtility;
      
      public var myKeyBindBG:MovieClip;
      
      public var myUpgradeIcon:MovieClip;
      
      public function ZombieChampionDetailSkill()
      {
         super();
      }
      
      public function setData(data:ZombieChampionSkillObj) : void
      {
         this.myName.text = data.title;
         this.myDesc.text = LocalizeUtil.localize(data.description);
         this.myImage.setImage(data.imageURL);
         if(Boolean(data.keybind) && data.keybind != "")
         {
            this.myKeyBind.visible = this.myKeyBindBG.visible = true;
            this.myKeyBind.setForCommand(data.keybind,GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE,false);
         }
         else
         {
            this.myKeyBind.visible = this.myKeyBindBG.visible = false;
         }
      }
      
      public function setUpgrade(text:String) : void
      {
         if(this.myUpgrade != null)
         {
            this.myUpgrade.text = text;
            this.myUpgrade.y = this.myDesc.y + this.myDesc.textHeight + 5;
         }
         if(this.myUpgradeIcon != null)
         {
            this.myUpgradeIcon.visible = Boolean(text) && text.length > 0;
         }
      }
   }
}

