package codo.views.hudSpy
{
   import codo.utils.LocalizeUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public class SkillEffectHint extends MovieClip
   {
      
      public var myTitle:TextField;
      
      public var mySubtitle:TextField;
      
      public var myBG:MovieClip;
      
      private var myNicknames:Array;
      
      public function SkillEffectHint()
      {
         var mc:DisplayObject = null;
         super();
         this.myNicknames = new Array();
         for(var i:int = 0; true; i++)
         {
            mc = getChildByName("myNickname".concat(i));
            if(mc == null)
            {
               break;
            }
            this.myNicknames.push(mc);
         }
      }
      
      public function setData(data:Object) : void
      {
         var obj:Object = null;
         var indices:Vector.<Point> = null;
         var firstCharBound:Rectangle = null;
         var lastCharBound:Rectangle = null;
         var textFieldLeft:Number = NaN;
         var textFieldRight:Number = NaN;
         var i:int = 0;
         var nicknameRight:Number = NaN;
         var nicknameLeft:Number = NaN;
         var texts:Array = [];
         var colors:Array = [];
         for each(obj in data.infos)
         {
            texts.push(obj.text);
            colors.push(obj.color);
         }
         this.mySubtitle.text = data.subtitle;
         indices = LocalizeUtil.paramTextFieldInput(this.myTitle,data.title,texts,colors,null,null);
         firstCharBound = this.myTitle.getCharBoundaries(0);
         lastCharBound = this.myTitle.getCharBoundaries(this.myTitle.text.length - 1);
         textFieldLeft = firstCharBound.x;
         textFieldRight = lastCharBound.x + lastCharBound.width;
         this.myBG.width = textFieldRight - textFieldLeft + 20;
         this.myBG.x = textFieldLeft - 10;
         for(i = 0; i < this.myNicknames.length; i++)
         {
            if(i >= data.infos.length || data.infos[i].nickname == null)
            {
               this.myNicknames[i].visible = false;
            }
            else
            {
               this.myNicknames[i].visible = true;
               this.myNicknames[i].nickname = data.infos[i].nickname;
               nicknameRight = this.myTitle.getCharBoundaries(indices[i].x).x;
               nicknameLeft = this.myTitle.getCharBoundaries(indices[i].x - 5).x;
               this.myNicknames[i].x = nicknameLeft + (nicknameRight - this.myNicknames[i].width - nicknameLeft) / 2;
            }
         }
      }
   }
}

