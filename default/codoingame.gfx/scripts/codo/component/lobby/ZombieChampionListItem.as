package codo.component.lobby
{
   import codo.component.Button;
   import codo.objects.ZombieChampionObj;
   import codo.utils.GraphicUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class ZombieChampionListItem extends Button
   {
      
      public var myImage:FsgImageHolder;
      
      public var myChampImage:MovieClip;
      
      public var myChampName:TextField;
      
      public var mySkill0:ZombieChampionDetailSkill;
      
      public var mySkill1:ZombieChampionDetailSkill;
      
      public var mySkill2:ZombieChampionDetailSkill;
      
      public var mySkill3:ZombieChampionDetailSkill;
      
      private var mSkillClips:Vector.<ZombieChampionDetailSkill>;
      
      private var mNumSkillClips:uint;
      
      public function ZombieChampionListItem()
      {
         super();
         this.mSkillClips = new <ZombieChampionDetailSkill>[this.mySkill0,this.mySkill1,this.mySkill2,this.mySkill3];
         this.mNumSkillClips = this.mSkillClips.length;
      }
      
      override public function setData(data:*) : void
      {
         var champion:ZombieChampionObj = null;
         var i:uint = 0;
         super.setData(data);
         champion = data as ZombieChampionObj;
         this.myChampName.text = champion.name;
         if(Boolean(data.useLargeImage))
         {
            this.myChampImage.gotoAndStop(champion.id);
            this.myChampImage.visible = true;
            this.myImage.clearImage();
         }
         else
         {
            this.myImage.setImage(champion.bustImageURL);
            this.myChampImage.visible = false;
         }
         var numSkills:uint = champion.skills.length;
         for(i = 0; i < this.mNumSkillClips; i++)
         {
            if(i < numSkills)
            {
               this.mSkillClips[i].visible = true;
               this.mSkillClips[i].setData(champion.skills[i]);
               this.mSkillClips[i].setUpgrade("");
            }
            else
            {
               this.mSkillClips[i].visible = false;
            }
         }
      }
      
      override public function setToggled(toggled:Boolean) : void
      {
         super.setToggled(toggled);
         if(mToggled)
         {
            this.showHighlight();
         }
         else
         {
            this.endHighlight();
         }
      }
      
      override public function draw() : void
      {
      }
      
      override protected function showHighlight() : void
      {
         super.showHighlight();
         GraphicUtil.desaturate(this,false);
         this.myChampName.alpha = 1;
         this.myChampImage.alpha = 1;
         this.myImage.alpha = 1;
         for(var i:uint = 0; i < this.mNumSkillClips; i++)
         {
            this.mSkillClips[i].alpha = 1;
         }
      }
      
      override protected function endHighlight() : void
      {
         super.endHighlight();
         GraphicUtil.desaturate(this,true);
         this.myChampName.alpha = 0.3;
         this.myChampImage.alpha = 0.3;
         this.myImage.alpha = 0.3;
         for(var i:uint = 0; i < this.mNumSkillClips; i++)
         {
            this.mSkillClips[i].alpha = 0.3;
         }
      }
   }
}

