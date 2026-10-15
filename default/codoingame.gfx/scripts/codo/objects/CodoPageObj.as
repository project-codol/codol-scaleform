package codo.objects
{
   import codo.common.CFunctionCommonContainer;
   import codo.interfaces.ICodoPageObj;
   import codo.utils.Logger;
   
   public dynamic class CodoPageObj extends CustomObject implements ICodoPageObj
   {
      
      private static var _pageIdToObj:Object = {};
      
      public var id:String;
      
      public var owner:CodoPageLayerObj;
      
      public var views:Array;
      
      public var tutorialView:CodoViewObj;
      
      public var enableCloseByESC:Boolean = false;
      
      public var onboardingESC:Boolean = false;
      
      public var historyAble:Boolean = true;
      
      public var bypassDrawMask:Boolean = false;
      
      public var ingameSupportKeyEvent:Boolean = false;
      
      public function CodoPageObj(cObj:Object = null)
      {
         super(cObj);
         if(_pageIdToObj[this.id] != null)
         {
            Logger.print("Page ID collision: " + this.id);
         }
         _pageIdToObj[this.id] = this;
      }
      
      public static function getObjByID(id:String) : CodoPageObj
      {
         return _pageIdToObj[id];
      }
      
      public function closedByEscape() : Boolean
      {
         if(this.enableCloseByESC)
         {
            if(!CFunctionCommonContainer.OnboardIntroDone())
            {
               return this.onboardingESC;
            }
            if(this.tutorialView != null && this.tutorialView.instance != null)
            {
               return this.onboardingESC;
            }
            return true;
         }
         return false;
      }
      
      override public function toString() : String
      {
         var ownerValue:String = "null";
         if(this.owner != null)
         {
            ownerValue = this.owner.name;
         }
         return "{ id: " + this.id + ", owner: " + ownerValue + ", views: " + this.views + ", enableCloseByESC: " + this.enableCloseByESC + ", historyAble: " + this.historyAble + ", bypassDrawMask: " + this.bypassDrawMask + " }";
      }
   }
}

