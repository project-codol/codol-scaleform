package codo.views.hudSpy
{
   import codo.common.CFunctionInGameContainer;
   import codo.component.TextField;
   import codo.constants.SpyModeRoleType;
   import codo.helpmenu.spyRoleSkill;
   import codo.localization.DictHud;
   import codo.objects.SpyModeSkillObj;
   import codo.style.SpyHudGuide;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   
   public class HelpMenuRoleInfo extends MovieClip
   {
      
      private const SKILL_INFO_ANCHOR:int = 255;
      
      private const SKILL_INFO_HEIGHT:int = 66;
      
      private const SKILL_INFO_TOTAL_HEIGHT:int = 500;
      
      private const SKILL_INFO_X_POS:int = 8;
      
      private const MINI_GAP_SIZE:int = 8;
      
      public var myRoleIcon:MovieClip;
      
      public var myRoleNameTF:TextField;
      
      public var myRoleDescTitleTF:TextField;
      
      public var myRoleDescTF:TextField;
      
      public var mySkillTitleTF:TextField;
      
      private var mSkills:Vector.<HelpMenuSkill>;
      
      public function HelpMenuRoleInfo()
      {
         super();
         this.myRoleDescTF.width = 280;
         this.myRoleDescTitleTF.text = DictHud.SPY_ROLE_DESC_LABEL;
         this.mySkillTitleTF.text = DictHud.SPY_COMMIT_SKILLS_LABEL;
         this.mSkills = new Vector.<HelpMenuSkill>(0);
      }
      
      public function setRole(role:int) : void
      {
         var skillInfoHeight:int = 0;
         var scale:Number = NaN;
         var totalGap:int = 0;
         var gapSize:int = 0;
         var nextSkillMCYPos:int = 0;
         var i:int = 0;
         var skill:HelpMenuSkill = null;
         var skillObj:SpyModeSkillObj = null;
         this.myRoleIcon.gotoAndStop(role);
         this.myRoleNameTF.textStyle = SpyHudGuide.HelpMenuRoleCivilian;
         this.myRoleDescTF.textStyle = SpyHudGuide.HelpMenuRoleDescCivilian;
         if(role == SpyModeRoleType.SPY_ROLE_INVESTIGATOR)
         {
            this.myRoleNameTF.textStyle = SpyHudGuide.HelpMenuRoleInvestigater;
            this.myRoleDescTF.textStyle = SpyHudGuide.HelpMenuRoleDescInvestigater;
            this.myRoleDescTitleTF.textStyle = SpyHudGuide.HelpMenuInvestigatorTitle;
            this.mySkillTitleTF.textStyle = SpyHudGuide.HelpMenuInvestigatorTitle;
         }
         else if(role == SpyModeRoleType.SPY_ROLE_SPY)
         {
            this.myRoleNameTF.textStyle = SpyHudGuide.HelpMenuRoleSpy;
            this.myRoleDescTF.textStyle = SpyHudGuide.HelpMenuRoleDescSpy;
            this.myRoleDescTitleTF.textStyle = SpyHudGuide.HelpMenuSpyTitle;
            this.mySkillTitleTF.textStyle = SpyHudGuide.HelpMenuSpyTitle;
         }
         var roleInfoObj:Object = CFunctionInGameContainer.AS_SpyMode_GetRoleInfo(role);
         this.myRoleNameTF.text = "@" + roleInfoObj.name;
         this.myRoleDescTF.text = "@" + roleInfoObj.desc;
         var skillsObj:Vector.<SpyModeSkillObj> = CFunctionInGameContainer.AS_SpyMode_GetSkillsByRole(role);
         for(var j:int = 0; j < this.mSkills.length; j++)
         {
            this.removeChild(this.mSkills[j]);
         }
         this.mSkills = new Vector.<HelpMenuSkill>(0);
         if(skillsObj.length == 0)
         {
            this.mySkillTitleTF.visible = false;
         }
         else
         {
            this.mySkillTitleTF.visible = true;
            skillInfoHeight = this.SKILL_INFO_HEIGHT;
            scale = 1;
            totalGap = this.SKILL_INFO_TOTAL_HEIGHT - skillInfoHeight * skillsObj.length;
            gapSize = skillsObj.length > 1 ? int(totalGap / (skillsObj.length - 1)) : this.SKILL_INFO_TOTAL_HEIGHT;
            if(gapSize < this.MINI_GAP_SIZE)
            {
               gapSize = this.MINI_GAP_SIZE;
               skillInfoHeight = (this.SKILL_INFO_TOTAL_HEIGHT - gapSize * (skillsObj.length - 1)) / skillsObj.length;
               scale = Number(skillInfoHeight) / this.SKILL_INFO_HEIGHT;
            }
            nextSkillMCYPos = this.SKILL_INFO_ANCHOR;
            for(i = 0; i < skillsObj.length; i++)
            {
               skill = new spyRoleSkill();
               this.addChild(skill);
               skillObj = skillsObj[i];
               skill.visible = true;
               skill.image = skillObj.icon;
               skill.key = LocalizeUtil.localizeFirstKeyBindingForCommand(skillObj.keybind);
               skill.description = "@" + skillObj.desc;
               skill.x = this.SKILL_INFO_X_POS;
               skill.y = nextSkillMCYPos;
               nextSkillMCYPos += gapSize + skillInfoHeight;
               skill.scaleX = skill.scaleY = scale;
               this.mSkills.push(skill);
            }
         }
      }
   }
}

