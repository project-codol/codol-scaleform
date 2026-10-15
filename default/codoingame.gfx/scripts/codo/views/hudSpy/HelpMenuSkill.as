package codo.views.hudSpy
{
   import codo.component.TextField;
   import codo.style.SpyHudGuide;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import fsg.util.FsgImageHolder;
   
   public class HelpMenuSkill extends MovieClip
   {
      
      public var myKeyTF:TextField;
      
      public var mySkillIcon:FsgImageHolder;
      
      public var myDescriptionTF:TextField;
      
      public function HelpMenuSkill()
      {
         super();
         this.myKeyTF.textStyle = SpyHudGuide.HelpMenuSkillKey;
         this.myDescriptionTF.textStyle = SpyHudGuide.HelpMenuSkillDesc;
         this.myDescriptionTF.width = 260;
      }
      
      public function set key(val:String) : void
      {
         if(val == LocalizeUtil.localize("@KEY_UNBOUND"))
         {
            this.myKeyTF.visible = false;
         }
         else
         {
            this.myKeyTF.visible = true;
            this.myKeyTF.text = val;
         }
      }
      
      public function set image(url:String) : void
      {
         this.mySkillIcon.setImage(url);
      }
      
      public function set description(txt:String) : void
      {
         this.myDescriptionTF.text = txt;
      }
   }
}

