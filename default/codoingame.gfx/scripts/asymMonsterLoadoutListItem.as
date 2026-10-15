package
{
   import components.asympvp_part.AsymMonsterLoadoutListItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4041")]
   public dynamic class asymMonsterLoadoutListItem extends AsymMonsterLoadoutListItem
   {
      
      public function asymMonsterLoadoutListItem()
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

