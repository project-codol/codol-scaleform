package codo.component
{
   import codo.component.core.UIInteractiveComponent;
   import codo.objects.ChallengeRewardObj;
   import codo.style.GlobalGuide;
   import codo.utils.GraphicUtil;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   
   public class ChallengeChecklistGPReward extends UIInteractiveComponent
   {
      
      public var myGPEarned:MovieClip;
      
      public var myRewardGPTF:flash.text.TextField;
      
      public var myXp:flash.text.TextField;
      
      public var myCheck:MovieClip;
      
      public function ChallengeChecklistGPReward()
      {
         super();
         isInteractiveEnabled = true;
      }
      
      public function setComplete(complete:Boolean) : void
      {
         GraphicUtil.desaturate(this.myGPEarned,complete);
         var tint:Number = 0.6;
         this.myGPEarned.transform.colorTransform = complete ? new ColorTransform(tint,tint,tint,tint,7,66,96,0.5) : null;
         this.myRewardGPTF.textColor = this.myXp.textColor = complete ? GlobalGuide.CODO_GRAY_LIGHT : GlobalGuide.WHITE;
         this.myCheck.visible = complete;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         var reward:ChallengeRewardObj = data as ChallengeRewardObj;
         this.myRewardGPTF.text = reward.entityInfo.toString();
         this.myXp.text = "+ " + reward.xp.toString() + " XP";
         this.setComplete(reward.claimed);
      }
   }
}

