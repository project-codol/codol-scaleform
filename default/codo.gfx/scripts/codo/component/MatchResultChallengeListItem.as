package codo.component
{
   import codo.component.core.UIInteractiveComponent;
   import codo.component.factory.ButtonFactory;
   import codo.component.home.HomeChallengeListItem;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import flash.utils.getDefinitionByName;
   
   public class MatchResultChallengeListItem extends UIInteractiveComponent
   {
      
      private static const TEXT_FIELD_PATH:String = "codo.shared.TextField";
      
      private var mChild:UIInteractiveComponent = null;
      
      public function MatchResultChallengeListItem()
      {
         super();
      }
      
      override public function setData(data:*) : void
      {
         var textField:TextField = null;
         var listItem:HomeChallengeListItem = null;
         super.setData(data);
         if(this.mChild != null)
         {
            this.removeChild(this.mChild);
         }
         var cls:Class = null;
         if(data is String)
         {
            cls = getDefinitionByName(TEXT_FIELD_PATH) as Class;
            this.mChild = new cls();
            textField = this.mChild as TextField;
            textField.fontSize = 17;
            textField.fontColor = 3450325;
            textField.font = GlobalGuide.FONT_FACE_MEDIUM;
            textField.alignment = TextStyle.HALIGN_LEFT;
            textField.text = data as String;
            textField.width = 400;
         }
         else
         {
            listItem = ButtonFactory.BUILD_HOME_CHALLENGE_LIST_ITEM();
            this.mChild = listItem;
            listItem.setData(data);
         }
         this.mChild.x = 0;
         this.mChild.y = 0;
         this.addChild(this.mChild);
      }
      
      override public function get width() : Number
      {
         if(this.mChild != null)
         {
            return this.mChild.width;
         }
         return 0;
      }
      
      override public function get height() : Number
      {
         if(this.mChild != null)
         {
            return this.mChild.height;
         }
         return 0;
      }
   }
}

