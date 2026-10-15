package components.cyborg.cyborgInGame_part
{
   import codo.localization.DictMatchResults;
   import codo.objects.ObjectiveObject;
   import codo.utils.LocalizeUtil;
   import flash.display.Sprite;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   import shaui.component.core.UIComponent;
   
   public class CyborgObjectiveItem extends UIComponent
   {
      
      private static const IMAGE_SIZE:Number = 150;
      
      private static const IMAGE_SCALE:Number = 0.89;
      
      private static const NO_ITEM_ALPHA:Number = 0.5;
      
      private static const NO_ITEM_FONT_COLOR:Number = 16777215;
      
      public var myObjectiveTitleTF:TextField;
      
      public var myObjectiveDescTF:TextField;
      
      public var myIconHolder:FsgImageHolder;
      
      public var myIconObjectiveOpen:Sprite;
      
      public var myBkg:Sprite;
      
      private var _currentImgURL:String;
      
      public function CyborgObjectiveItem()
      {
         super();
         this._currentImgURL = null;
      }
      
      public function SetData(data:ObjectiveObject) : void
      {
         this.myIconHolder.clearImage();
         this._currentImgURL = null;
         if(Boolean(data))
         {
            this.myIconObjectiveOpen.visible = false;
            this.myObjectiveTitleTF.text = data.name.toUpperCase();
            this.myObjectiveDescTF.text = data.desc;
            this._currentImgURL = data.img;
            this.myIconHolder.setImage(this._currentImgURL);
            this.myIconHolder.width = IMAGE_SIZE;
            this.myIconHolder.height = IMAGE_SIZE;
            this.myIconHolder.scaleX = IMAGE_SCALE;
            this.myIconHolder.scaleY = IMAGE_SCALE;
         }
         else
         {
            this.myIconObjectiveOpen.visible = true;
            this.myObjectiveTitleTF.text = LocalizeUtil.localize(DictMatchResults.ITEM_UNKNOWN).toUpperCase();
            this.myObjectiveDescTF.text = LocalizeUtil.localize(DictMatchResults.ITEM_NOT_FOUND).toUpperCase();
            this.myObjectiveTitleTF.alpha = NO_ITEM_ALPHA;
            this.myObjectiveDescTF.alpha = NO_ITEM_ALPHA;
            this.myObjectiveTitleTF.textColor = NO_ITEM_FONT_COLOR;
            this.myObjectiveDescTF.textColor = NO_ITEM_FONT_COLOR;
         }
      }
   }
}

