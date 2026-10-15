package codo.views.hudSpy
{
   import codo.localization.DictHud;
   import codo.style.GlobalGuide;
   import codo.style.SpyHudGuide;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import fsg.util.FsgImageHolder;
   
   public class SkillActiveHint extends MovieClip
   {
      
      private const SKILL_IMAGE_WIDTH:int = 57;
      
      private const SKILL_IMAGE_MARGIN:int = 2;
      
      public var mySkillGetLabel:TextField;
      
      public var mySkillImage:FsgImageHolder;
      
      public var myShortcut:TextField;
      
      public var mySkillName:TextField;
      
      public var myShortCutBg:MovieClip;
      
      public var mIsPassiveSkill:Boolean;
      
      public function SkillActiveHint()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.mySkillGetLabel.autoSize = TextFieldAutoSize.LEFT;
         this.mySkillName.autoSize = TextFieldAutoSize.LEFT;
         this.myShortcut.autoSize = TextFieldAutoSize.LEFT;
         this.mySkillGetLabel.text = LocalizeUtil.localize(DictHud.SPY_SKILL_GET);
      }
      
      public function setData(skill:*) : void
      {
         var indices:Vector.<Point> = null;
         var index:Point = null;
         var leftRect:Rectangle = null;
         var rightRect:Rectangle = null;
         this.mySkillImage.setImage(skill.icon);
         this.mySkillName.text = LocalizeUtil.localize("@" + skill.title);
         this.mySkillImage.x = this.mySkillGetLabel.width + this.SKILL_IMAGE_MARGIN;
         this.mySkillName.x = this.mySkillImage.x + this.SKILL_IMAGE_WIDTH + this.SKILL_IMAGE_MARGIN;
         this.myShortcut.x = this.mySkillName.width + this.mySkillName.x + this.SKILL_IMAGE_MARGIN;
         var keyBind:String = LocalizeUtil.localizeFirstKeyBindingForCommand("+help");
         if(keyBind.length > 0)
         {
            indices = LocalizeUtil.paramTextFieldInput(this.myShortcut,DictHud.SPY_SHOW_SKILL_HELP,[keyBind],[SpyHudGuide.HINT_COLOR_DARK_YELLOW],[GlobalGuide.FONT_FACE_BOLD]);
            if(indices.length > 0)
            {
               index = indices[0];
               leftRect = this.myShortcut.getCharBoundaries(index.x);
               rightRect = this.myShortcut.getCharBoundaries(index.y - 1);
               this.myShortCutBg.width = rightRect.right - leftRect.left + 6;
               this.myShortCutBg.x = this.myShortcut.x + (leftRect.left + rightRect.right - this.myShortCutBg.width) / 2;
            }
            this.myShortcut.visible = this.myShortCutBg.visible = true;
            this.mIsPassiveSkill = false;
         }
         else
         {
            this.myShortcut.visible = this.myShortCutBg.visible = false;
            this.mIsPassiveSkill = true;
         }
      }
      
      override public function get width() : Number
      {
         return this.myShortcut.x + (this.mIsPassiveSkill ? 0 : this.myShortcut.width);
      }
   }
}

