package codo.component
{
   import codo.objects.ItemBuffObj;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   import fsg.util.FsgImageHolder;
   
   public class BuffInformation extends MovieClip
   {
      
      public var myBuffTitle:TextField;
      
      public var myBuffDesc:TextField;
      
      private var mImgHolder:FsgImageHolder;
      
      public function BuffInformation()
      {
         super();
         var imgClass:Class = getDefinitionByName("codo.shared.Size32ImageHolder") as Class;
         this.mImgHolder = new imgClass() as FsgImageHolder;
         addChild(this.mImgHolder);
         this.mImgHolder.y = -2;
         this.myBuffTitle.width = 190;
         this.myBuffTitle.height = 190;
         this.myBuffTitle.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myBuffTitle.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myBuffTitle.font = GlobalGuide.FONT_FACE_BOLD;
         this.myBuffDesc.width = 190;
         this.myBuffDesc.height = 190;
         this.myBuffDesc.fontColor = GlobalGuide.GRAY_80;
         this.myBuffDesc.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myBuffDesc.font = GlobalGuide.FONT_FACE_MEDIUM;
      }
      
      public function setData(buff:ItemBuffObj) : void
      {
         this.mImgHolder.setImage(buff.icon);
         this.myBuffTitle.text = buff.name;
         this.myBuffDesc.text = LocalizeUtil.replaceConversionString(LocalizeUtil.localize(buff.desc),[buff.percent]);
         buff.desc;
         this.myBuffDesc.y = this.myBuffTitle.y + this.myBuffTitle.textHeight + 2;
      }
      
      public function setTierColor(tierColor:uint) : void
      {
         this.myBuffTitle.fontColor = tierColor;
      }
      
      override public function get height() : Number
      {
         return this.myBuffTitle.textHeight + this.myBuffDesc.textHeight + 2;
      }
   }
}

