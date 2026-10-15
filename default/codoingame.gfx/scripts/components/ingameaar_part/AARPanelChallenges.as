package components.ingameaar_part
{
   import codo.localization.DictInGame;
   import codo.objects.AARChallengeObj;
   
   public class AARPanelChallenges extends AARPanelBase
   {
      
      public var myChallenge0:AARChallengeListItem;
      
      public var myChallenge1:AARChallengeListItem;
      
      public var myChallenge2:AARChallengeListItem;
      
      private var _challengeItems:Vector.<AARChallengeListItem>;
      
      public function AARPanelChallenges()
      {
         super();
         this.SetHeader(DictInGame.AAR_CHALLENGE_PROGRESS);
         this._challengeItems = new <AARChallengeListItem>[this.myChallenge0,this.myChallenge1,this.myChallenge2];
      }
      
      public function SetChallengeData(challenges:Vector.<AARChallengeObj>) : void
      {
         var i:int = 0;
         if(challenges != null)
         {
            for(i = 0; i < this._challengeItems.length; i++)
            {
               if(challenges.length > i)
               {
                  this._challengeItems[i].visible = true;
                  this._challengeItems[i].SetData(challenges[i]);
               }
               else
               {
                  this._challengeItems[i].visible = false;
               }
            }
         }
      }
   }
}

