package components.ingameaar_part
{
   import codo.objects.AARChallengeObj;
   import components.Label;
   import flash.text.TextField;
   import shaui.component.core.UIComponent;
   
   public class AARChallengeListItem extends UIComponent
   {
      
      public var myTitleTF:TextField;
      
      public var myDescLabel:Label;
      
      public var myProgressBar:AARProgressBar;
      
      public function AARChallengeListItem()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         if(this.myDescLabel != null)
         {
            this.myDescLabel.enableRollBack = false;
         }
      }
      
      public function SetData(data:AARChallengeObj) : void
      {
         this.myTitleTF.text = data.title;
         this.myDescLabel.text = data.description;
         this.myDescLabel.startRoll();
         this.SetBarData(data.progressStart,data.progressGain);
      }
      
      protected function SetBarData(progressStart:Number, progressGain:Number) : void
      {
         AARProgressBar(this.myProgressBar).SetBarData(progressStart,progressGain);
      }
   }
}

