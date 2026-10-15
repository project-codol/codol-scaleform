package codo.component.social
{
   import codo.utils.TableUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ClanTag extends MovieClip
   {
      
      public static const TAGS_TABLE_PATH:String = "mp/coClanTags.csv";
      
      public static const TAGS_TABLE_COL_ID:int = 0;
      
      public static const TAGS_TABLE_COL_DESC:int = 1;
      
      public static const TAGS_TABLE_COL_COLOR:int = 2;
      
      public var myText:TextField;
      
      public var myTagID:int;
      
      private var mColorIndex:int;
      
      public function ClanTag()
      {
         super();
      }
      
      public function set id(idVal:int) : void
      {
         this.myTagID = idVal;
         this.fillTagData(TableUtil.lookupRow(TAGS_TABLE_PATH,TAGS_TABLE_COL_ID,this.id.toString()));
      }
      
      public function get id() : int
      {
         return this.myTagID;
      }
      
      public function get colorIndex() : int
      {
         return this.mColorIndex;
      }
      
      public function setTagIDByRow(row:int) : void
      {
         this.myTagID = int(TableUtil.getValue(TAGS_TABLE_PATH,row,TAGS_TABLE_COL_ID));
         this.fillTagData(row);
      }
      
      private function fillTagData(rowInTable:int) : void
      {
         var desc:String = TableUtil.getValue(TAGS_TABLE_PATH,rowInTable,TAGS_TABLE_COL_DESC);
         this.mColorIndex = int(TableUtil.getValue(TAGS_TABLE_PATH,rowInTable,TAGS_TABLE_COL_COLOR));
         gotoAndStop(this.mColorIndex);
         this.myText.text = "@" + desc;
      }
   }
}

