package codo.utils
{
   public class IDGeneratorUtil
   {
      
      private var _allocatedIDs:Array = new Array();
      
      private var front_pointer:int = 1;
      
      public function IDGeneratorUtil()
      {
         super();
      }
      
      public function generateID() : int
      {
         var ret:int = 0;
         var i:int = 0;
         if(this._allocatedIDs.length != 0)
         {
            for(i = 0; i < this._allocatedIDs.length; i++)
            {
               if(this.front_pointer <= this._allocatedIDs[i])
               {
                  if(this.front_pointer < this._allocatedIDs[i])
                  {
                     this._allocatedIDs.splice(i - 1,0,this.front_pointer);
                     ret = this.front_pointer;
                     ++this.front_pointer;
                     return ret;
                  }
                  ++this.front_pointer;
               }
            }
            ret = this.front_pointer;
            ++this.front_pointer;
            return ret;
         }
         this._allocatedIDs.splice(0,0,this.front_pointer);
         ret = this.front_pointer;
         ++this.front_pointer;
         return ret;
      }
      
      public function releaseID(theid:int) : void
      {
         for(var i:int = 0; i < this._allocatedIDs.length; i++)
         {
            if(this._allocatedIDs[i] == theid)
            {
               this._allocatedIDs.splice(i,1);
            }
         }
      }
   }
}

