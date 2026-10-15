package view_fsg_complaint_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.component.fsgComplaint_part.additionalCommentsTextField;
   import fsg.widgets.scrollBarVertical;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4556")]
   public dynamic class myAdditionalCommentsBox_3 extends MovieClip
   {
      
      public var mCharLimit:TextField;
      
      public var myAdditionalComments:additionalCommentsTextField;
      
      public var myScrollBar:scrollBarVertical;
      
      public var myTitleTF:TextField;
      
      public function myAdditionalCommentsBox_3()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

