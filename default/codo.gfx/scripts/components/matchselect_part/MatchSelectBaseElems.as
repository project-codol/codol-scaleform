package components.matchselect_part
{
   import components.fsggamemodes_part.FsgHeroOpsImageSliderWithLock;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class MatchSelectBaseElems extends Sprite
   {
      
      public var myTitleText:MovieClip;
      
      public var myMissionTitle:MovieClip;
      
      public var myImgSlider:FsgHeroOpsImageSliderWithLock;
      
      public var my3DRotationHitarea:MovieClip;
      
      public function MatchSelectBaseElems()
      {
         super();
         TextField(this.myMissionTitle.getChildByName("myTextTF")).autoSize = TextFieldAutoSize.LEFT;
      }
   }
}

