package components.matchselect_part
{
   import codo.base.BaseSubElement;
   import codo.constants.DataID;
   import components.CodoList;
   import components.fsggamemodes_part.GameModesTutorialButton;
   import components.fsggamemodes_part.MatchSelectSharedGPXPDisplay;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class MatchSelectPvElemsBase extends BaseSubElement
   {
      
      public static const SIZE_DEFAULT:uint = 1;
      
      public static const SIZE_MEDIUM:uint = 2;
      
      public static const SIZE_SMALL:uint = 3;
      
      private var _isActive:Boolean;
      
      public var myDifficultyList:CodoList;
      
      public var myTextBkg:MovieClip;
      
      public var myDescriptionTF:TextField;
      
      public var myGPXPDisplay:MatchSelectSharedGPXPDisplay;
      
      public var myGamemodeTutorialButton:GameModesTutorialButton;
      
      public function MatchSelectPvElemsBase()
      {
         super();
         this.myGamemodeTutorialButton.visible = false;
      }
      
      public function showView() : void
      {
         bind(DataID.GROUP_COUNTS,this.bind_groupCounts);
         bind(DataID.DATA_RECEIVE,this.checkReadyFlags);
         bind(DataID.MARKETPLACE_MAINTAIN_STATE,this.checkReadyFlags);
         this._isActive = true;
      }
      
      public function hideView() : void
      {
         unbind(DataID.GROUP_COUNTS,this.bind_groupCounts);
         unbind(DataID.DATA_RECEIVE,this.checkReadyFlags);
         unbind(DataID.MARKETPLACE_MAINTAIN_STATE,this.checkReadyFlags);
         this._isActive = false;
      }
      
      public function get isActive() : Boolean
      {
         return this._isActive;
      }
      
      private function bind_groupCounts(param1:Object) : void
      {
         this.invalidatePlaylists();
      }
      
      protected function checkReadyFlags(param1:Object = null) : void
      {
         var _loc2_:Boolean = getDP(DataID.IS_MARKETPLACE_READY);
         var _loc3_:Boolean = getDP(DataID.IS_MARKETPLACE_MAINTAIN);
         this.setMarketReady(_loc2_ && !_loc3_);
      }
      
      public function set textBackgroundSize(param1:uint) : void
      {
         this.myTextBkg.gotoAndStop(param1);
         switch(param1)
         {
            case SIZE_DEFAULT:
               this.myGamemodeTutorialButton.y = -58;
               break;
            case SIZE_MEDIUM:
               this.myGamemodeTutorialButton.y = -25;
               break;
            case SIZE_SMALL:
               this.myGamemodeTutorialButton.y = 12.5;
         }
      }
      
      public function set gamemodeTutorialCallback(param1:Function) : void
      {
         this.myGamemodeTutorialButton.clickCallback = param1;
      }
      
      protected function setMarketReady(param1:Boolean) : void
      {
      }
      
      protected function invalidatePlaylists() : void
      {
      }
   }
}

