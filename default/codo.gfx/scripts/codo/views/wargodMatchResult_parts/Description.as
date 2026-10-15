package codo.views.wargodMatchResult_parts
{
   import com.greensock.TweenLite;
   import flash.text.TextField;
   
   public class Description extends WarGodAnimateElement
   {
      
      public var myTF:TextField;
      
      public function Description()
      {
         super();
      }
      
      public function setText(text:String) : void
      {
         this.myTF.text = text;
      }
      
      override public function startAni() : void
      {
         super.startAni();
         this.myTF.alpha = 0;
         TweenLite.to(this.myTF,0.5,{
            "alpha":1,
            "onComplete":this.onShowComplete
         });
      }
      
      private function onShowComplete() : void
      {
         complete();
      }
   }
}

