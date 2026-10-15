package codo.mail
{
   import components.fsgSocialPanel_part.FsgEmailPanel;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol5096")]
   public dynamic class mailView extends FsgEmailPanel
   {
      
      public function mailView()
      {
         super();
         this.__setTab_myTitle_view_mail_myTitle_0();
      }
      
      internal function __setTab_myTitle_view_mail_myTitle_0() : *
      {
         myTitle.tabIndex = 1;
      }
   }
}

