package components.fsgmatchresult_part
{
   import codo.objects.ScoreboardRowObj;
   import fsg.util.FsgImageHolder;
   
   public class FsgScoreboardDataRow extends MatchDataRow
   {
      
      public var myStatusIcon:FsgImageHolder;
      
      public function FsgScoreboardDataRow()
      {
         super();
      }
      
      override public function SetData(data:ScoreboardRowObj, orderedKeys:Array) : void
      {
         super.SetData(data,orderedKeys);
         this.statusIcon = data.statusIcon;
      }
      
      override public function ClearData() : void
      {
         super.ClearData();
         this.myStatusIcon.visible = false;
      }
      
      override public function set isMe(value:Boolean) : void
      {
         super.isMe = value;
         if(value == true)
         {
            this.myStatusIcon.alpha = HIGHLIGHTED_TEXT_ALPHA;
         }
         else
         {
            this.myStatusIcon.alpha = UNHIGHLIGHTED_TEXT_ALPHA;
         }
      }
      
      public function set statusIcon(value:String) : void
      {
         if(value != null && value.length > 0)
         {
            this.myStatusIcon.visible = true;
            this.myStatusIcon.setImage(value);
         }
         else
         {
            this.myStatusIcon.visible = false;
            this.myStatusIcon.setImage("");
         }
      }
   }
}

