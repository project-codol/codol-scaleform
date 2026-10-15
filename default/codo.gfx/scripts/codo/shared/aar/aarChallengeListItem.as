package codo.shared.aar
{
   import codo.component.aar.AARChallengeListItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2409")]
   public dynamic class aarChallengeListItem extends AARChallengeListItem
   {
      
      public function aarChallengeListItem()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

