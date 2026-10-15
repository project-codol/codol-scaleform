package codo.objects.uitour
{
   import codo.common.CFunctionCommonContainer;
   import flash.geom.Point;
   
   public class UITourToolTipObj
   {
      
      public var pageID:String;
      
      public var flagID:uint;
      
      public var title:String;
      
      public var description:String;
      
      public var positionCoordinates:Point;
      
      public var arrowDir:uint;
      
      public var destination:String;
      
      public var destinationTab:int;
      
      public var onboardNotif:String;
      
      public var onboardOnly:Boolean;
      
      public var requiredUnlock:String;
      
      public var notified:Boolean;
      
      public var tipStyle:uint;
      
      public var tooltipSize:Point;
      
      public var tourOpened:Boolean;
      
      public var acknowledged:Boolean;
      
      public var linkedTip:UITourToolTipObj;
      
      public function UITourToolTipObj(_pageID:String, flagID:uint, title:String, description:String, positionCoordinates:Point, _onboardOnly:Boolean, _onboardNotif:String = null, _destination:String = null, _requiredUnlock:String = null, _tipStyle:uint = 0, _arrowDir:uint = 0, size:Point = null)
      {
         super();
         this.pageID = _pageID;
         this.flagID = flagID;
         this.title = title;
         this.description = description;
         this.positionCoordinates = positionCoordinates == null ? new Point(0,0) : positionCoordinates;
         this.arrowDir = _arrowDir;
         this.destination = _destination;
         this.onboardNotif = _onboardNotif;
         this.onboardOnly = _onboardOnly;
         this.requiredUnlock = _requiredUnlock;
         this.tipStyle = _tipStyle;
         this.tooltipSize = size;
      }
      
      public function featureIsUnlocked() : Boolean
      {
         if(this.requiredUnlock == null)
         {
            return true;
         }
         var level:String = CFunctionCommonContainer.GetOnboardUnlockLevel(this.requiredUnlock);
         return level == null;
      }
      
      public function tourSkipsIntro() : Boolean
      {
         return this.description == null;
      }
   }
}

