package codo.views.uitour
{
   import com.greensock.TweenLite;
   
   public class UIInGameTutorialSplash extends UITutorialTourBase
   {
      
      public function UIInGameTutorialSplash()
      {
         super();
         myTitleTF.fontSize = 22;
         myTitleTF.width = 450;
      }
      
      override protected function revealText() : void
      {
         mTransitionTimeline.append(new TweenLite(myTitleTF,0.2,{
            "alpha":1,
            "onComplete":this.onTitleRevealed
         }));
         mTransitionTimeline.play();
      }
      
      override protected function initAnimation() : void
      {
         this.revealText();
      }
      
      override protected function onTitleRevealed() : void
      {
         myTopicArrow.active();
         super.onTitleRevealed();
      }
   }
}

