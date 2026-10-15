package codo.component.career
{
   import codo.localization.DictCareer;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ChallengeChecklistVeteranReward extends MovieClip
   {
      
      public var myText:TextField;
      
      public function ChallengeChecklistVeteranReward()
      {
         super();
         this.myText.text = LocalizeUtil.localize(DictCareer.CAREER_REFRESH_VETERAN_LIST);
      }
   }
}

