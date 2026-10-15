package codo.views.hud.td
{
   import codo.constants.HUDComponentTypes;
   import codo.localization.DictTD;
   import codo.utils.LocalizeUtil;
   import codo.views.hud.HUDComponent;
   import flash.display.MovieClip;
   
   public class HUDTDGainLootHint extends HUDComponent
   {
      
      private static const TIER_COLORS:Array = [16777215,8706109,3781375,12211412,16745000];
      
      private var mHintInstances:Array;
      
      private var mNextInstanceIndex:int;
      
      public function HUDTDGainLootHint()
      {
         var instance:MovieClip = null;
         super();
         this.mHintInstances = new Array();
         for(var i:int = 0; true; i++)
         {
            instance = getChildByName("myHintInstance".concat(i)) as MovieClip;
            if(instance == null)
            {
               break;
            }
            instance.gotoAndStop(1);
            this.mHintInstances.push(instance);
         }
         this.mNextInstanceIndex = 0;
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.TD_GAIN_LOOT_HINT;
      }
      
      public function cppShowHint(item:Object, amount:int) : void
      {
         var instance:MovieClip = this.mHintInstances[this.mNextInstanceIndex];
         instance.gotoAndPlay(1);
         var hintStr:String = LocalizeUtil.localize(DictTD.GAIN_LOOT_HINT);
         if(amount > 1)
         {
            hintStr += "x" + amount;
         }
         LocalizeUtil.paramTextFieldInput(instance.label.textField,hintStr,[LocalizeUtil.localize(item.name)],[TIER_COLORS[item.tier]]);
         setChildIndex(instance,numChildren - 1);
         ++this.mNextInstanceIndex;
         if(this.mNextInstanceIndex >= this.mHintInstances.length)
         {
            this.mNextInstanceIndex = 0;
         }
      }
   }
}

