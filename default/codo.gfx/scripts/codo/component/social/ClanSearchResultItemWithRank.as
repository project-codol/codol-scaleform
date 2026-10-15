package codo.component.social
{
   import codo.component.TextField;
   import codo.style.ClanGuide;
   
   public class ClanSearchResultItemWithRank extends ClanSearchResultItem
   {
      
      public var myRank:TextField;
      
      public function ClanSearchResultItemWithRank()
      {
         super();
      }
      
      override protected function initStage() : void
      {
         super.initStage();
         this.myRank.textStyle = ClanGuide.styleItemRenderText;
         myClanName.width = 190;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         this.myRank.text = data.rank + 1;
      }
   }
}

