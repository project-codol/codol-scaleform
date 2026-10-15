package components.asympvp_part
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.SE_ID;
   import codo.objects.AsymPvpLoadoutObj;
   import components.interfaces.IAsymMonsterLoadoutListItem;
   import components.list_part.ListItemRendererBase;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   import fsg.util.FsgAudioUtil;
   
   public class AsymMonsterLoadoutListItem extends ListItemRendererBase implements IAsymMonsterLoadoutListItem
   {
      
      public static const FRAME_NORMAL:int = 1;
      
      public static const FRAME_ROLL_OVER:int = 2;
      
      public static const FRAME_SELECT:int = 3;
      
      public static const FRAME_LOCKED:int = 4;
      
      public var myNameText:MovieClip;
      
      protected var m_clickable:BehaviourClickable;
      
      protected var m_audio:BehaviourAudio;
      
      private var mIsLocked:Boolean = false;
      
      private var mUseAsPurchaseButton:Boolean = false;
      
      private var mTemporarilyUnavailable:Boolean = false;
      
      public function AsymMonsterLoadoutListItem()
      {
         super();
         this.m_clickable = new BehaviourClickable(this);
         this.m_clickable.addClickCallback(this.onClick);
         tipEnable = false;
         (this.myNameText.myTextTF as TextField).autoSize = TextFieldAutoSize.LEFT;
      }
      
      final override public function get height() : Number
      {
         return myHitArea.height;
      }
      
      public function get isLocked() : Boolean
      {
         return this.mIsLocked;
      }
      
      public function isPurchaseButton(b:Boolean) : void
      {
         this.mUseAsPurchaseButton = b;
      }
      
      override protected function onGetData() : void
      {
         var loadout:AsymPvpLoadoutObj = null;
         super.onGetData();
         loadout = _data as AsymPvpLoadoutObj;
         alpha = 1;
         this.mTemporarilyUnavailable = loadout.loadoutTempDisabled;
         if(!this.mUseAsPurchaseButton)
         {
            loadout.isExpired = CFunctionCommonContainer.AS_IsExpiredInventoryItem(loadout.itemID) as Boolean;
            this.mIsLocked = !loadout.isPurchased || !loadout.isDefault && loadout.isExpired;
         }
         else
         {
            this.mIsLocked = false;
         }
         gotoAndStop(this.mIsLocked ? FRAME_LOCKED : FRAME_NORMAL);
         _selected = false;
         this.myNameText.myTextTF.text = loadout.name;
         if(loadout.loadoutTempDisabled)
         {
            alpha = 0.3;
         }
      }
      
      override public function set selected(cSwi:Boolean) : void
      {
         if(this.mIsLocked || this.mTemporarilyUnavailable)
         {
            return;
         }
         _selected = cSwi;
         if(_selected)
         {
            gotoAndStop(FRAME_SELECT);
         }
         else
         {
            gotoAndStop(FRAME_NORMAL);
         }
      }
      
      private function onClick() : void
      {
         if(this.mIsLocked || this.mTemporarilyUnavailable)
         {
            FsgAudioUtil.getInstance().playSound(SE_ID.GENERAL_LOCKED);
            return;
         }
         FsgAudioUtil.getInstance().playSound(SE_ID.GENERAL_PROCEED);
      }
      
      override protected function setToNormal(cTween:Boolean = false) : void
      {
         if(!_selected && !this.mTemporarilyUnavailable)
         {
            gotoAndStop(this.mIsLocked ? FRAME_LOCKED : FRAME_NORMAL);
         }
      }
      
      override protected function setToRollOver(cTween:Boolean = false) : void
      {
         if(!_selected && !this.mTemporarilyUnavailable)
         {
            gotoAndStop(FRAME_ROLL_OVER);
         }
      }
      
      override protected function onUnselected() : void
      {
      }
      
      override protected function onSelected() : void
      {
      }
   }
}

