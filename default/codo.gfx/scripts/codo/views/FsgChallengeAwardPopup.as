package codo.views
{
   import components.fsgpopups_part.FsgChallengeAwardViewContent;
   import fsg.shared.popups.PopupBaseView;
   
   public class FsgChallengeAwardPopup extends PopupBaseView
   {
      
      private var mAwardContent:FsgChallengeAwardViewContent;
      
      public function FsgChallengeAwardPopup()
      {
         super();
         this.mAwardContent = myContent as FsgChallengeAwardViewContent;
      }
      
      override public function set routeData(data:*) : void
      {
         var obj:Object = data as Object;
         this.mAwardContent.setData(obj);
      }
   }
}

