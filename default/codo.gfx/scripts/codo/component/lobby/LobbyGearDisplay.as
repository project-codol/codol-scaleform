package codo.component.lobby
{
   import codo.component.TextField;
   import codo.component.loadout.LoadoutButton;
   import codo.component.loadout.LoadoutHeader;
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   
   public class LobbyGearDisplay extends MovieClip
   {
      
      public var myAvatarSlot:MovieClip;
      
      public var myGearSlot0:LoadoutButton;
      
      public var myGearSlot1:LoadoutButton;
      
      public var myGearSlot2:LoadoutButton;
      
      public var myGearSlot3:LoadoutButton;
      
      public var myGearSlot4:LoadoutButton;
      
      public var myGearSlot5:LoadoutButton;
      
      public var myGearSlot6:LoadoutButton;
      
      public var myGearSlot7:LoadoutButton;
      
      public var myGearSlot8:LoadoutButton;
      
      public var GearLabel0:LoadoutHeader;
      
      public var GearLabel1:LoadoutHeader;
      
      public var GearLabel2:LoadoutHeader;
      
      public var GearLabel3:LoadoutHeader;
      
      public var GearLabel4:LoadoutHeader;
      
      public var GearLabel5:LoadoutHeader;
      
      public var GearLabel6:LoadoutHeader;
      
      public var GearLabel7:LoadoutHeader;
      
      public var GearLabel8:LoadoutHeader;
      
      public var GearLabel9:LoadoutHeader;
      
      public var myGearTitle:TextField;
      
      public var myGearSubtitle:TextField;
      
      public var loadoutButtons:Vector.<LoadoutButton>;
      
      public var headers:Vector.<LoadoutHeader>;
      
      public function LobbyGearDisplay()
      {
         var smallSlotWidth:int = 0;
         super();
         this.loadoutButtons = new <LoadoutButton>[this.myGearSlot0,this.myGearSlot1,this.myGearSlot2,this.myGearSlot3,this.myGearSlot4,this.myGearSlot5,this.myGearSlot6,this.myGearSlot7,this.myGearSlot8];
         this.headers = new <LoadoutHeader>[this.GearLabel0,this.GearLabel1,this.GearLabel2,this.GearLabel3,this.GearLabel4,this.GearLabel5,this.GearLabel6,this.GearLabel7,this.GearLabel8,this.GearLabel9];
         this.myGearTitle.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myGearTitle.fontColor = GlobalGuide.WHITE;
         this.myGearTitle.font = GlobalGuide.FONT_FACE_BOLD;
         this.myGearSubtitle.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myGearSubtitle.fontColor = GlobalGuide.CODO_INSTRUCTION_GREY;
         this.myGearSubtitle.font = GlobalGuide.FONT_FACE_BOLD;
         var smallSlotSize:int = 77;
         smallSlotWidth = 87;
         this.myGearSlot0.width = this.myGearSlot1.width = this.myGearSlot8.width = smallSlotWidth;
         this.myGearSlot0.height = this.myGearSlot1.height = this.myGearSlot8.height = smallSlotSize;
         this.GearLabel0.width = this.GearLabel1.width = this.GearLabel8.width = smallSlotWidth;
         var slots:Vector.<LoadoutButton> = new Vector.<LoadoutButton>();
         slots.push(this.myGearSlot2);
         slots.push(this.myGearSlot3);
         slots.push(this.myGearSlot4);
         slots.push(this.myGearSlot5);
         slots.push(this.myGearSlot6);
         slots.push(this.myGearSlot7);
         slots.push(this.myGearSlot8);
         var labels:Vector.<LoadoutHeader> = new Vector.<LoadoutHeader>();
         labels.push(this.GearLabel2);
         labels.push(this.GearLabel3);
         labels.push(this.GearLabel4);
         labels.push(this.GearLabel5);
         labels.push(this.GearLabel6);
         labels.push(this.GearLabel7);
         labels.push(this.GearLabel8);
         labels.push(this.GearLabel9);
         var len:int = int(slots.length);
         var labelWidth:int = 106;
         var slotWidth:int = 106;
         for(var i:int = 0; i < len; i++)
         {
            slots[i].width = slots[i].height = slotWidth;
            labels[i].width = labelWidth;
         }
      }
   }
}

