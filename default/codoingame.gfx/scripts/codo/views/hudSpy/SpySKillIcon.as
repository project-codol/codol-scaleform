package codo.views.hudSpy
{
   import codo.style.SpyHudGuide;
   import codo.utils.GraphicUtil;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class SpySKillIcon extends MovieClip
   {
      
      private static const SKILL_STATE_READY:int = 0;
      
      private static const SKILL_STATE_COOLDOWN:int = 1;
      
      private static const SKILL_STATE_UNAVAILABLE:int = 2;
      
      private static const SKILL_STATE_ENABLED:int = 4;
      
      public var myBG:MovieClip;
      
      public var myImageContainer:MovieClip;
      
      public var myImage:FsgImageHolder;
      
      public var myKey:TextField;
      
      public var myCooldown:TextField;
      
      public var myLockIcon:MovieClip;
      
      public var mySelectable:MovieClip;
      
      public var myProgress:MovieClip;
      
      private var mImagePath:String;
      
      public function SpySKillIcon()
      {
         super();
         this.myImage = this.myImageContainer["myImage"];
         this.myLockIcon.visible = true;
         this.mySelectable.visible = false;
         this.myImageContainer.visible = false;
         this.myImage.visible = false;
         this.myKey.visible = false;
         this.myCooldown.visible = false;
      }
      
      public function cppSetAirdropSkillData(skill:Object) : void
      {
         this.myImageContainer.visible = true;
         this.myImage.visible = true;
         this.myKey.visible = true;
         this.myCooldown.visible = true;
         this.myProgress.visible = false;
         this.myLockIcon.visible = false;
         this.mySelectable.visible = false;
         this.myCooldown.visible = false;
         this.myImage.setImage(skill.icon);
         this.myKey.text = skill.keybind.length > 0 ? LocalizeUtil.localizeFirstKeyBindingForCommand(skill.keybind) : "";
         this.myKey.textColor = SpyHudGuide.SKILL_READY_COLOR;
      }
      
      public function cppSetSkillData(skill:Object) : void
      {
         this.myLockIcon.visible = false;
         this.mySelectable.visible = false;
         this.myImageContainer.visible = true;
         this.myImage.visible = true;
         this.myKey.visible = true;
         this.myCooldown.visible = true;
         this.myProgress.visible = false;
         this.myImage.visible = this.myKey.visible = true;
         if(this.mImagePath != skill.icon)
         {
            this.mImagePath = skill.icon;
            this.myImage.setImage(skill.icon);
         }
         this.myKey.text = skill.keybind.length > 0 ? LocalizeUtil.localizeFirstKeyBindingForCommand(skill.keybind) : "";
         if(skill.state == SKILL_STATE_READY)
         {
            this.myCooldown.visible = false;
            this.myKey.textColor = SpyHudGuide.SKILL_READY_COLOR;
            GraphicUtil.desaturate(this.myImage,false);
            gotoAndPlay(2);
            this.myKey.visible = !skill.hideKey;
         }
         else if(skill.state == SKILL_STATE_COOLDOWN)
         {
            this.myCooldown.visible = true;
            this.myCooldown.text = skill.cooldown;
            this.myKey.textColor = SpyHudGuide.SKILL_COOLDOWN_COLOR;
            GraphicUtil.desaturate(this.myImage);
         }
         else if(skill.state == SKILL_STATE_UNAVAILABLE)
         {
            this.myCooldown.visible = false;
            this.myKey.textColor = SpyHudGuide.SKILL_COOLDOWN_COLOR;
            GraphicUtil.desaturate(this.myImage);
         }
         else if(skill.state == SKILL_STATE_ENABLED)
         {
            if(skill.cooldown > 0)
            {
               this.myCooldown.visible = true;
               this.myCooldown.text = skill.cooldown;
               this.myKey.textColor = SpyHudGuide.SKILL_COOLDOWN_COLOR;
               GraphicUtil.desaturate(this.myImage);
            }
            else
            {
               this.myCooldown.visible = false;
               this.myKey.textColor = SpyHudGuide.SKILL_READY_COLOR;
               GraphicUtil.desaturate(this.myImage,false);
               gotoAndPlay(2);
            }
         }
      }
      
      public function cppSetSelectableMode(keybind:String) : void
      {
         this.myLockIcon.visible = false;
         this.mySelectable.visible = true;
         this.myImageContainer.visible = false;
         this.myImage.visible = false;
         this.myKey.visible = true;
         this.myCooldown.visible = false;
         this.myProgress.visible = false;
         this.myKey.text = keybind.length > 0 ? LocalizeUtil.localizeFirstKeyBindingForCommand(keybind) : "";
         this.myKey.textColor = SpyHudGuide.SKILL_READY_COLOR;
      }
      
      public function cppSetLockedMode(progressInfo:Object) : void
      {
         var bar:MovieClip = null;
         var haveCredit:int = 0;
         var demandCredit:int = 0;
         this.myLockIcon.visible = true;
         this.mySelectable.visible = false;
         this.myImageContainer.visible = false;
         this.myImage.visible = false;
         this.myKey.visible = false;
         this.myCooldown.visible = false;
         this.myProgress.visible = false;
         if(progressInfo != null)
         {
            this.myProgress.visible = true;
            bar = this.myProgress["myProgress"] as MovieClip;
            if(progressInfo.maxCredit == 0)
            {
               bar.width = 64;
            }
            else
            {
               haveCredit = progressInfo.credit > progressInfo.minCredit ? int(progressInfo.credit - progressInfo.minCredit) : 0;
               demandCredit = progressInfo.maxCredit > progressInfo.minCredit ? int(progressInfo.maxCredit - progressInfo.minCredit) : 0;
               if(haveCredit > demandCredit)
               {
                  haveCredit = demandCredit;
               }
               bar.width = 64 * haveCredit / demandCredit;
            }
            trace(bar.width);
         }
      }
   }
}

