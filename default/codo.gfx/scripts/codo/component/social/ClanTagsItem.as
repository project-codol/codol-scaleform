package codo.component.social
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class ClanTagsItem extends MovieClip
   {
      
      private var HORIZONTAL_FRAME:int = 1;
      
      private var VERTICAL_FRAME:int = 2;
      
      private var myTags:Array;
      
      public function ClanTagsItem()
      {
         var tag:DisplayObject = null;
         super();
         this.myTags = new Array();
         for(var i:int = 0; true; i++)
         {
            tag = getChildByName("myTag".concat(i));
            if(tag == null)
            {
               break;
            }
            tag.visible = false;
            this.myTags.push(tag);
         }
         this.vertical = false;
      }
      
      public function setData(tagIDs:Array) : void
      {
         var i:int = 0;
         var tag:ClanTag = null;
         var tagNum:int = tagIDs == null ? 0 : int(tagIDs.length);
         for(i = 0; i < this.myTags.length; i++)
         {
            if(i < tagNum)
            {
               tag = this.myTags[i] as ClanTag;
               tag.visible = true;
               tag.id = tagIDs[i];
            }
            else
            {
               this.myTags[i].visible = false;
            }
         }
      }
      
      public function set vertical(v:Boolean) : void
      {
         gotoAndStop(v ? this.VERTICAL_FRAME : this.HORIZONTAL_FRAME);
      }
   }
}

