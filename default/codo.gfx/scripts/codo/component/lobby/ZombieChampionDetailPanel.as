package codo.component.lobby
{
   import codo.objects.ZombieChampionObj;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ZombieChampionDetailPanel extends MovieClip
   {
      
      public var myWeaponName:TextField;
      
      public var myWeaponImage:MovieClip;
      
      public var mySkillsTitle:TextField;
      
      public var mySkill0:ZombieChampionDetailSkill;
      
      public var mySkill1:ZombieChampionDetailSkill;
      
      public var mySkill2:ZombieChampionDetailSkill;
      
      public var mySkill3:ZombieChampionDetailSkill;
      
      protected var mSkillClips:Vector.<ZombieChampionDetailSkill>;
      
      protected var mNumSkillClips:uint;
      
      private var mChampionID:uint;
      
      public function ZombieChampionDetailPanel()
      {
         super();
         this.mSkillClips = new <ZombieChampionDetailSkill>[this.mySkill0,this.mySkill1,this.mySkill2,this.mySkill3];
         this.mNumSkillClips = this.mSkillClips.length;
         this.mySkillsTitle.text = "@ZCHAMP_SKILLS_TITLE";
      }
      
      public function show(champion:ZombieChampionObj) : void
      {
         var i:uint = 0;
         this.visible = true;
         if(this.mChampionID == champion.id)
         {
            return;
         }
         this.mChampionID = champion.id;
         this.myWeaponName.text = champion.weaponName;
         this.myWeaponImage.gotoAndStop(champion.id);
         var numSkills:uint = champion.skills.length;
         for(i = 0; i < this.mNumSkillClips; i++)
         {
            if(i < numSkills)
            {
               this.mSkillClips[i].visible = true;
               this.mSkillClips[i].setData(champion.skills[i]);
            }
            else
            {
               this.mSkillClips[i].visible = false;
            }
         }
      }
      
      public function hide() : void
      {
         this.visible = false;
      }
   }
}

