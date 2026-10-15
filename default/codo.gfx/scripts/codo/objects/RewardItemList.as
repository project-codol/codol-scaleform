package codo.objects
{
   import codo.utils.ScaleformUtil;
   
   public class RewardItemList
   {
      
      private var m_all:Array;
      
      private var m_goldTierlist:Array;
      
      private var m_silverTierlist:Array;
      
      private var m_bronzeTierlist:Array;
      
      public function RewardItemList()
      {
         super();
         this.m_all = new Array();
         this.m_goldTierlist = new Array();
         this.m_silverTierlist = new Array();
         this.m_bronzeTierlist = new Array();
      }
      
      public function SetData(val:Array, buildAll:Boolean) : void
      {
         this.m_goldTierlist = val[0];
         this.m_silverTierlist = val[1];
         this.m_bronzeTierlist = val[2];
         this.m_all.length = 0;
         if(ScaleformUtil.isScaleform)
         {
            if(buildAll)
            {
               this.m_all = this.m_bronzeTierlist.concat(this.m_silverTierlist);
               this.m_all = this.m_all.concat(this.m_goldTierlist);
            }
         }
      }
      
      public function get all() : Array
      {
         return this.m_all;
      }
      
      public function get gold() : Array
      {
         return this.m_goldTierlist;
      }
      
      public function get silver() : Array
      {
         return this.m_silverTierlist;
      }
      
      public function get bronze() : Array
      {
         return this.m_bronzeTierlist;
      }
   }
}

