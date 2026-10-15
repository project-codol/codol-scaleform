package IME_fla
{
   import adobe.utils.*;
   import fl.motion.*;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.globalization.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.sensors.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import ime.*;
   import scaleform.gfx.*;
   
   [SWF(width="100", height="100", backgroundColor="#ffffff", frameRate="30")]
   public dynamic class MainTimeline extends MovieClip
   {
      
      public var Repositioned:Boolean;
      
      public var candidateList:Object;
      
      public var inputWindow_mc:MovieClip;
      
      public var list_mc:MovieClip;
      
      public var isCandListOpen:Boolean;
      
      public var isListCreated:Boolean;
      
      public var candListWidth:Number;
      
      public var candListHeight:Number;
      
      public var readingWindowTextColor:uint;
      
      public var readingWindowBckgndColor:uint;
      
      public var readingWindowFontSize:uint;
      
      public var inputWindowHeight:uint;
      
      public var candListx:uint;
      
      public var candListy1:uint;
      
      public var candListy2:uint;
      
      public var playerWindowH:*;
      
      public var playerWindowW:*;
      
      public var SendLangBarMessage:*;
      
      public function MainTimeline()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function IsCandidateList() : Boolean
      {
         return true;
      }
      
      public function InitReadingWindowDefaults(styles:IMECandidateListStyle) : void
      {
         if(styles.readingWindowTextColor == styles.readingWindowBackgroundColor && styles.readingWindowTextColor == styles.readingWindowFontSize && (styles.readingWindowTextColor == -1 || styles.readingWindowTextColor == 0))
         {
            this.readingWindowTextColor = 0;
            this.readingWindowBckgndColor = 15725300;
            this.readingWindowFontSize = 20;
         }
         else
         {
            this.readingWindowTextColor = styles.readingWindowTextColor;
            this.readingWindowBckgndColor = styles.readingWindowBackgroundColor;
            this.readingWindowFontSize = styles.readingWindowFontSize;
         }
      }
      
      public function DisplayCallback(SelectedItemIndex:Number) : *
      {
         var candidateListRow_mc:MovieClip = null;
         var li:Object = null;
         var size:Number = NaN;
         var value_tb:* = undefined;
         var maxSize:* = 0;
         for(var i:* = 0; i < this.candidateList.DisplayItemIndex; i++)
         {
            li = this.candidateList.GetItemAtIndex(i);
            if(li != null)
            {
               candidateListRow_mc = li.ItemObj;
               value_tb = candidateListRow_mc.Value;
               if(value_tb.text == "")
               {
                  candidateListRow_mc.ID.alpha = 25;
               }
               else
               {
                  candidateListRow_mc.ID.alpha = 100;
               }
            }
         }
         var yy:Number = Number(this.candidateList.GetItemAtIndex(0).ItemObj.y);
         this.candListHeight = 0;
         this.candListWidth = 0;
         for(i = 0; i < this.candidateList.DisplayItemIndex; i++)
         {
            li = this.candidateList.GetItemAtIndex(i);
            if(li != null)
            {
               candidateListRow_mc = li.ItemObj;
               candidateListRow_mc.bkGround_mc.width = Math.round(candidateListRow_mc.Value.width + 17);
               candidateListRow_mc.RowNumberBackground_mc.width = candidateListRow_mc.ID.width;
               candidateListRow_mc.RowNumberBackground_mc.height = candidateListRow_mc.Value.height;
               candidateListRow_mc.x = this.candListWidth;
               this.candListWidth += candidateListRow_mc.width;
               candidateListRow_mc.y = 0;
               candidateListRow_mc.Value.y = 0;
               candidateListRow_mc.ID.y = 0;
               candidateListRow_mc.RowNumberBackground_mc.y = 0;
               candidateListRow_mc.bkGround_mc.y = 0;
               yy += candidateListRow_mc.height - 2;
            }
         }
         this.isCandListOpen = true;
      }
      
      public function ChangeFont(fontSize:Number) : void
      {
         var li:* = undefined;
         var candidateListRow_mc:* = undefined;
         var textFormat:Object = null;
         for(var i:* = 0; i < this.candidateList.DisplayItemIndex; i++)
         {
            li = this.candidateList.GetItemAtIndex(i);
            if(li != undefined)
            {
               candidateListRow_mc = li.ItemObj;
               textFormat = new TextFormat();
               textFormat.size = fontSize;
               candidateListRow_mc.Value.setNewTextFormat(textFormat);
               candidateListRow_mc.ID.setNewTextFormat(textFormat);
            }
         }
      }
      
      public function SetCandidateListProps(_textColor:Number, selectedTextColor:Number, textBackgroundColor:Number, selectedTextBackgroundColor:Number, fontSize:Number, indexBackgroundColor:Number, selectedIndexBackgroundColor:Number) : *
      {
         this.candidateList.SetCandidateListProps(_textColor,selectedTextColor,textBackgroundColor,selectedTextBackgroundColor,fontSize,indexBackgroundColor,selectedIndexBackgroundColor);
      }
      
      public function SetReadingWindowProps(backgroundColor:Number, textColor:Number, fontSize:Number) : *
      {
         this.readingWindowTextColor = backgroundColor >= 0 ? uint(backgroundColor) : this.readingWindowTextColor;
         this.readingWindowBckgndColor = textColor >= 0 ? uint(textColor) : uint(backgroundColor);
         this.readingWindowFontSize = fontSize >= 0 ? uint(fontSize) : this.readingWindowFontSize;
      }
      
      public function CreateList(numRows:Number, candListStartFrom1:Number) : *
      {
         var mc:MovieClip = null;
         trace("IME: IME::CreateList numRows: " + numRows);
         this.RemoveList();
         this.isListCreated = true;
         this.Repositioned = false;
         var startFrom1:Number = 1;
         var styles:IMECandidateListStyle = IMEEx.getIMECandidateListStyle();
         this.InitReadingWindowDefaults(styles);
         this.list_mc = new MovieClip();
         this.list_mc.visible = false;
         MovieClip(this).addChild(this.list_mc);
         this.candidateList.CreateCandidateList(this.list_mc,numRows,"Character",0,0,"ListRow",new Array("Value"),styles);
         for(var i:Number = 0; i < numRows; i++)
         {
            mc = MovieClip(this.list_mc.getChildByName("Character" + i));
            mc.ID.text = (i + startFrom1) % 10;
            mc.Value.autoSize = "left";
         }
         this.list_mc.tabEnabled = false;
         this.list_mc.tabChildren = false;
      }
      
      public function MakeVisible() : *
      {
         if(this.list_mc != null)
         {
            this.list_mc.visible = true;
         }
      }
      
      public function MakeInvisible() : *
      {
         if(this.list_mc != null)
         {
            this.list_mc.visible = false;
         }
      }
      
      public function RepositionWindow(xPos:Number, yPos1:Number, inputWindowHeight:Number, yPos2:Number, playerWindowW:Number, playerWindowH:Number) : Boolean
      {
         trace("IME: IME::RepositionWindow candListWidth: " + this.candListWidth + " candListHeight: " + this.candListHeight);
         if(xPos + this.candListWidth > playerWindowW)
         {
            xPos = playerWindowW - this.candListWidth;
            xPos = xPos >= 0 ? xPos : 0;
         }
         this.list_mc.x = xPos;
         if(this.candListHeight < playerWindowH - (yPos1 + inputWindowHeight))
         {
            this.list_mc.y = yPos1 + 5 + inputWindowHeight;
            this.MakeVisible();
            return false;
         }
         if(playerWindowH - yPos1 > yPos2)
         {
            this.list_mc.y = yPos1 + 5 + inputWindowHeight;
            this.MakeVisible();
            return false;
         }
         this.list_mc.y = yPos2 - this.candListHeight - 5;
         this.MakeVisible();
         return true;
      }
      
      public function RepositionInputWindow(x:Number, y:Number) : void
      {
         if(this.inputWindow_mc == null)
         {
            return;
         }
         this.inputWindow_mc.x = x;
         this.inputWindow_mc.y = y;
      }
      
      public function DisplayInputWindow(text:String, x:Number, y:Number, color:uint) : void
      {
         if(text == "" && this.inputWindow_mc == null)
         {
            return;
         }
         if(text == "" && this.inputWindow_mc != null)
         {
            MovieClip(this).removeChild(this.inputWindow_mc);
            return;
         }
         this.inputWindow_mc = new InputWindow_mc();
         MovieClip(this).addChild(this.inputWindow_mc);
         this.inputWindow_mc.readingWindowTextFld.autoSize = "left";
         this.inputWindow_mc.readingWindowTextFld.text = text;
         this.inputWindow_mc.inputWindowBackground_mc.width = this.inputWindow_mc.readingWindowTextFld.width;
         this.inputWindow_mc.inputWindowBackground_mc.height = this.inputWindow_mc.readingWindowTextFld.height;
         this.inputWindow_mc.x = x;
         this.inputWindow_mc.y = y;
      }
      
      public function RemoveList() : *
      {
         removeEventListener(Event.ENTER_FRAME,this.OnEnterRepositionWindow);
         if(this.list_mc != null)
         {
            trace("IME: IME::RemoveList");
            this.candidateList.DestroyList();
            MovieClip(this).removeChild(this.list_mc);
            this.isCandListOpen = false;
            this.isListCreated = false;
            this.list_mc = null;
         }
      }
      
      public function RemoveInputWindow() : void
      {
         if(this.inputWindow_mc != null && this.inputWindow_mc != null)
         {
            MovieClip(this).removeChild(this.inputWindow_mc);
            this.inputWindow_mc = null;
         }
      }
      
      public function RepositionCandWindow(xx:Number, yy:Number, charHeight:Number) : void
      {
         if(xx < 0)
         {
            xx = 0;
         }
         this.candListx = xx;
         this.candListy1 = yy;
         this.candListy2 = yy - charHeight;
         if(this.isListCreated)
         {
            addEventListener(Event.ENTER_FRAME,this.OnEnterRepositionWindow);
         }
      }
      
      public function OnEnterRepositionWindow() : void
      {
         var inputWindowWidth:Number = NaN;
         if(this.isCandListOpen)
         {
            removeEventListener(Event.ENTER_FRAME,this.OnEnterRepositionWindow);
            inputWindowWidth = 0;
            if(this.inputWindow_mc != null)
            {
               this.inputWindowHeight = this.inputWindow_mc.readingWindowTextFld.height;
            }
            else
            {
               this.inputWindowHeight = 0;
            }
            this.playerWindowH = stage.stageHeight;
            this.playerWindowW = stage.stageWidth;
            this.RepositionWindow(this.candListx,this.candListy1,this.inputWindowHeight,this.candListy2,this.playerWindowW,this.playerWindowH);
         }
      }
      
      internal function frame1() : *
      {
         this.Repositioned = false;
         this.candidateList = new FxCandidateListBox();
         this.candidateList.RegisterPostDisplayCallback(this.DisplayCallback);
         this.isCandListOpen = false;
         this.isListCreated = false;
         this.candListWidth = 0;
         this.candListHeight = 0;
         this.readingWindowTextColor = 0;
         this.readingWindowBckgndColor = 15725300;
         this.readingWindowFontSize = 20;
         this.inputWindowHeight = 0;
         this.candListx = 0;
         this.candListy1 = 0;
         this.candListy2 = 0;
      }
   }
}

