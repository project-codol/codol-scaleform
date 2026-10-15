package codo.views.supplyDrop_parts
{
   public class SupplyDropRewardItemCoverPieceBottom extends SupplyDropRewardItemCoverPiece
   {
      
      public function SupplyDropRewardItemCoverPieceBottom()
      {
         super();
      }
      
      override public function get animationTargetY() : int
      {
         return mEndY + Y_OFFSET;
      }
   }
}

