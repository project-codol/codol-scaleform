package codo.component.social
{
   import fsg.util.FsgImageHolder;
   
   public class MemberRankIcon extends FsgImageHolder
   {
      
      private var mUrl:String = "";
      
      public function MemberRankIcon()
      {
         super();
      }
      
      override public function setImage(strImage:String = null) : void
      {
         if(Boolean(strImage) && this.mUrl == strImage)
         {
            return;
         }
         super.setImage(strImage);
         this.mUrl = strImage;
      }
   }
}

