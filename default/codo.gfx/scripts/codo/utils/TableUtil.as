package codo.utils
{
   import codo.common.CFunctionCommonContainer;
   
   public class TableUtil
   {
      
      public function TableUtil()
      {
         super();
      }
      
      public static function lookup(csvFile:String, comparisonColumn:int, searchValue:String, targetColumn:int) : String
      {
         return CFunctionCommonContainer.StringTableLookup(csvFile,comparisonColumn,searchValue,targetColumn);
      }
      
      public static function lookupRow(csvFile:String, comparisonColumn:int, searchValue:String) : int
      {
         return CFunctionCommonContainer.StringTableLookupRowNumForValue(csvFile,comparisonColumn,searchValue);
      }
      
      public static function getValue(csvFile:String, row:int, column:int) : String
      {
         return CFunctionCommonContainer.StringTableLookupByRow(csvFile,row,column);
      }
      
      public static function getRowCount(csvFile:String) : int
      {
         return CFunctionCommonContainer.StringTableRowCount(csvFile);
      }
      
      public static function getColumnCount(csvFile:String) : int
      {
         return CFunctionCommonContainer.StringTableColumnCount(csvFile);
      }
   }
}

