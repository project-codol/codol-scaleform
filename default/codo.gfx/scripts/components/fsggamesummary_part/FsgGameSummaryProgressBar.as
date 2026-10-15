package components.fsggamesummary_part
{
   import components.XPBar;
   
   public class FsgGameSummaryProgressBar extends XPBar
   {
      
      public function FsgGameSummaryProgressBar()
      {
         super();
      }
      
      public function setProgress(percentage:uint) : void
      {
         if(this.myBarMask != null)
         {
            this.myBarMask.width = percentage * (this.myBar.width / 100);
         }
         else
         {
            this.myBar.width = percentage * (this.myBar.width / 100);
         }
      }
   }
}

