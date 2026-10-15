package codo.objects
{
   public dynamic class CallSignObj extends CustomObject
   {
      
      public var cardTitleItemID:int = 0;
      
      public var cardIconItemID:int = 0;
      
      public var cardBackgroundItemID:int = 0;
      
      public var cardNameplateItemID:int = 0;
      
      public var cardTitle:String = "";
      
      public var cardTitleURL:String = "";
      
      public var cardIconURL:String = "";
      
      public var cardBackgroundURL:String = "";
      
      public var cardBackgroundName:String = "";
      
      public var cardNameplateColor:uint = 16777215;
      
      public var cardFrameURL:String = "";
      
      public var cardTitleTryon:Boolean = false;
      
      public var cardIconTryon:Boolean = false;
      
      public var cardBackgroundTryon:Boolean = false;
      
      public function CallSignObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

