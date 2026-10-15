package codo.views.persistentView_parts
{
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.greensock.easing.Back;
   import com.greensock.easing.Linear;
   import flash.display.Sprite;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   public class PurchaseSuccessBanner extends Sprite
   {
      
      public var myLabel:TextField;
      
      public function PurchaseSuccessBanner()
      {
         super();
         TextFieldEx.setVerticalAlign(this.myLabel,TextFieldEx.VALIGN_CENTER);
         visible = false;
      }
      
      public function onPurchaseSuccess(msg:String) : void
      {
         visible = true;
         alpha = 0;
         var myTimeLine:TimelineLite = new TimelineLite();
         this.myLabel.text = msg;
         myTimeLine.append(TweenLite.to(this,0.4,{
            "alpha":1,
            "y":96,
            "ease":Back.easeOut
         }));
         myTimeLine.append(TweenLite.to(this,0.2,{
            "alpha":0,
            "y":12,
            "ease":Linear.easeIn,
            "delay":4,
            "onComplete":this.onAnimComplete
         }));
      }
      
      private function onAnimComplete() : void
      {
         visible = false;
      }
   }
}

