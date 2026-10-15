package codo.views.hud.popups.HudTdTurretUpgradeView_parts
{
   import codo.utils.MathUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HudTdTurretMaterialsMount extends MovieClip
   {
      
      private const DEFAULT_GAP:Number = 4;
      
      private const AMOUNT_COLOR_DEFAULT:uint = 16777215;
      
      private const AMOUNT_COLOR_LACK:uint = 15617100;
      
      public var myMoney:MovieClip;
      
      public var myMaterial0:MovieClip;
      
      public var myMaterial1:MovieClip;
      
      public var myMaterial2:MovieClip;
      
      private var mElements:Array;
      
      private var mElementGap:Number;
      
      private var mElementNum:int;
      
      private var mShowLackColor:Boolean;
      
      public function HudTdTurretMaterialsMount()
      {
         super();
         this.mElements = [this.myMoney,this.myMaterial0,this.myMaterial1,this.myMaterial2];
         this.mElementGap = this.DEFAULT_GAP;
      }
      
      public function set showLackColor(show:Boolean) : void
      {
         this.mShowLackColor = show;
      }
      
      public function set elementGap(gap:Number) : void
      {
         if(this.mElementGap != gap)
         {
            this.mElementGap = gap;
            this.updateLayout();
         }
      }
      
      public function get elementGap() : Number
      {
         return this.mElementGap;
      }
      
      public function setData(cash:int, playerCash:int, lootItems:Array) : Boolean
      {
         var i:int = 0;
         var cashObj:Object = new Object();
         cashObj.stackNum = cash;
         cashObj.ownedNum = playerCash;
         this.mElements[0].data = cashObj;
         if(lootItems != null && lootItems.length > 0)
         {
            this.mElementNum = MathUtil.clamp(lootItems.length + 1,1,this.mElements.length);
            for(i = 1; i < this.mElementNum; i++)
            {
               this.mElements[i].data = lootItems[i - 1];
            }
         }
         else
         {
            this.mElementNum = 1;
         }
         this.updateLayout();
         return this.refreshRequirements(playerCash);
      }
      
      public function refreshRequirements(playerCash:int) : Boolean
      {
         var lootItem:Object = null;
         var amountLabel:TextField = null;
         if(this.mElements[0].data == null)
         {
            return true;
         }
         this.mElements[0].data.ownedNum = playerCash;
         var anyLack:Boolean = false;
         for(var i:int = 0; i < this.mElementNum; i++)
         {
            lootItem = this.mElements[i].data;
            amountLabel = this.mElements[i].myAmount;
            if(lootItem.stackNum > lootItem.ownedNum)
            {
               anyLack = true;
               amountLabel.textColor = this.mShowLackColor ? this.AMOUNT_COLOR_LACK : this.AMOUNT_COLOR_DEFAULT;
            }
            else
            {
               amountLabel.textColor = this.AMOUNT_COLOR_DEFAULT;
            }
         }
         return !anyLack;
      }
      
      private function updateLayout() : void
      {
         if(this.mElementNum == 0)
         {
            return;
         }
         var elementWidth:Number = Number(this.mElements[0].width);
         var totalWidth:Number = (this.mElementNum - 1) * this.mElementGap + this.mElementNum * elementWidth;
         var elementPosX:Number = -totalWidth * 0.5;
         for(var i:int = 0; i < this.mElements.length; i++)
         {
            if(i < this.mElementNum)
            {
               this.mElements[i].visible = true;
               this.mElements[i].x = elementPosX;
               elementPosX += elementWidth + this.mElementGap;
            }
            else
            {
               this.mElements[i].visible = false;
            }
         }
      }
   }
}

