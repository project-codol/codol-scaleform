package ime
{
   import codo.constants.GameInfo;
   import codo.utils.TextUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.*;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import scaleform.gfx.*;
   
   public class LangBarElement extends Sprite
   {
      
      public var NumInputLanguages:Number = 5;
      
      public var InputLangNames:String = "English,Japanese,Chinese (Simplified),Chinese (Traditional),Korean";
      
      public var InputLangShortName:Array = [{
         "index":"搜狗",
         "name":"搜"
      },{
         "index":"百度",
         "name":"百"
      },{
         "index":"QQ",
         "name":"QQ"
      },{
         "index":"必应",
         "name":"必"
      },{
         "index":"谷歌",
         "name":"谷"
      },{
         "index":"东方",
         "name":"东"
      },{
         "index":"手心",
         "name":"手"
      },{
         "index":"2345",
         "name":"王"
      },{
         "index":"English",
         "name":"EN"
      },{
         "index":"Japanese",
         "name":"JP"
      },{
         "index":"Chinese",
         "name":"CN"
      },{
         "index":"Korean",
         "name":"KR"
      },{
         "index":"中",
         "name":"CN"
      },{
         "index":"英",
         "name":"EN"
      },{
         "index":"Other",
         "name":"IME"
      }];
      
      public var IMENames:String = "";
      
      public var Clips:Array = new Array();
      
      public var InputLangName:String;
      
      public var LangBar:MovieClip = null;
      
      public var InputLangTab_mc:MovieClip = null;
      
      public var IMENameTab_mc:MovieClip = null;
      
      public var LangBarVisibleState:Boolean = true;
      
      public var isLanguageBar:Boolean = true;
      
      public var TestVariable:Number = 0;
      
      public var NumRows:Number = 0;
      
      public var BGColorOnover:Number = 5619932;
      
      public var BGColor:Number = 14608366;
      
      public var TextColor:Number = 5592921;
      
      public var TextColorSelected:Number = 16777215;
      
      public var IMEListener:Object = new Object();
      
      public function LangBarElement()
      {
         super();
         addEventListener(IMEEventEx.SET_CURRENT_INPUT_LANGUAGE,this.onSetCurrentInputLanguage);
         addEventListener(IMEEventEx.SET_SUPPORTED_LANGUAGES,this.onSetSupportedLanguages);
         addEventListener(IMEEventEx.SET_SUPPORTED_IMENAMES,this.onSetSupportedIMENames);
         addEventListener(IMEEventEx.SET_IMENAME,this.onSetIMEName);
         IMEEx.SendLangBarMessage(this,"LangBar_OnInit","");
      }
      
      public function SetBackgroundColor(color1:Number, color2:Number) : void
      {
         this.BGColorOnover = color2;
         this.BGColor = color1;
      }
      
      public function ChangeBackgroundColor(mc:MovieClip, frameNum:Number) : void
      {
      }
      
      public function SetTextColor(color1:Number, color2:Number) : void
      {
         this.TextColor = color1;
         this.TextColorSelected = color2;
         if(this.IMENameTab_mc != null)
         {
            this.ChangeTextColor(this.IMENameTab_mc,1);
         }
         if(this.InputLangTab_mc != null)
         {
            this.ChangeTextColor(this.InputLangTab_mc,1);
         }
      }
      
      public function ChangeTextColor(cTarget:Object, frameNumber:Number) : void
      {
         var targetTF:TextField = null;
         var targetBg:MovieClip = null;
         if(cTarget is TextField)
         {
            targetTF = cTarget as TextField;
            targetBg = cTarget.parent.Background_mc;
            if(frameNumber == 1)
            {
               targetTF.textColor = this.TextColor;
               if(targetBg != null)
               {
                  targetBg.gotoAndStop(1);
               }
            }
            if(frameNumber == 2)
            {
               targetTF.textColor = this.TextColorSelected;
               if(targetBg != null)
               {
                  targetBg.gotoAndStop(2);
               }
            }
         }
      }
      
      public function ChangeTextColorSelected(tf:Object) : void
      {
         if(!(tf is TextField))
         {
            return;
         }
         var oldTextFormat:TextFormat = tf.getTextFormat();
         oldTextFormat.color = this.TextColorSelected;
         tf.setTextFormat(oldTextFormat);
         tf.defaultTextFormat = oldTextFormat;
      }
      
      public function AddMouseDownToStage() : void
      {
         if(stage != null)
         {
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.MouseDownHandler);
         }
      }
      
      private function getLangShortName(name:String) : String
      {
         for(var i:uint = 0; i < this.InputLangShortName.length; i++)
         {
            if(name.indexOf(this.InputLangShortName[i].index) >= 0)
            {
               return this.InputLangShortName[i].name;
            }
         }
         if(name != "")
         {
            return name.substr(0,1);
         }
         return "CN";
      }
      
      public function onSetCurrentInputLanguage(ev:IMEEventEx) : void
      {
         this.LoadLanguageBar();
         var imeName:String = ev.message;
         this.SetInputLangName(this.getLangShortName(imeName));
      }
      
      public function onSetSupportedLanguages(ev:IMEEventEx) : void
      {
         this.SetSupportedLanguages(ev.message);
      }
      
      public function onSetSupportedIMENames(ev:IMEEventEx) : void
      {
         this.SetSupportedIMEs(ev.message);
      }
      
      public function onSetIMEName(ev:IMEEventEx) : void
      {
         this.SetLastIME(ev.message);
      }
      
      public function GetLanguageBarPositionY() : Number
      {
         return this.IMENameTab_mc.y;
      }
      
      public function GetLanguageBarPositionX() : Number
      {
         return this.IMENameTab_mc.x + this.IMENameTab_mc.width;
      }
      
      public function SetSupportedIMEs(imeNames:String) : void
      {
         this.CreateList("IMENames",imeNames);
      }
      
      public function SetInputLangName(inputLangName:String) : void
      {
         this.CloseList(this.NumRows);
         if(this.InputLangTab_mc.tf.text != inputLangName)
         {
            this.InputLangTab_mc.tf.text = inputLangName;
            this.Resize(this.InputLangTab_mc.tf.width,this.InputLangTab_mc);
         }
      }
      
      public function SetLastIME(lastImeName:String) : void
      {
         if(this.LangBarVisibleState == true)
         {
            this.IMENameTab_mc.visible = true;
         }
         this.IMENameTab_mc.myIconKeyboard.visible = false;
         TextUtil.replaceEnFont(this.IMENameTab_mc.tf,this.getLangShortName(lastImeName),GameInfo.GAME_FONT_AENCY_FB_BOLD,0,GameInfo.GAME_FONT_S,0);
         this.Resize(this.IMENameTab_mc.tf.width,this.IMENameTab_mc);
         this.Reposition(this.InputLangTab_mc,this.IMENameTab_mc);
         this.CloseList(this.NumRows);
         if(lastImeName.length == 0)
         {
            this.IMENameTab_mc.visible = false;
         }
      }
      
      public function SetSupportedLanguages(inputLangNames:String) : void
      {
         this.CreateList("InputLangNames",inputLangNames);
      }
      
      public function LoadLanguageBar() : void
      {
         this.CreateInputLangTab();
      }
      
      public function ShowLanguageBar(display:Boolean) : void
      {
         var i:int = 0;
         if(display)
         {
            this.InputLangTab_mc.visible = true;
            this.IMENameTab_mc.visible = true;
            this.LangBarVisibleState = true;
         }
         else
         {
            this.InputLangTab_mc.visible = false;
            this.IMENameTab_mc.visible = false;
            this.LangBarVisibleState = false;
            for(i = 0; i < this.NumRows; i++)
            {
               this.LangBar.removeChild(this.Clips[i]);
            }
            this.NumRows = 0;
         }
      }
      
      public function SelectItem(name:String) : void
      {
         var inputLangName:String = null;
         var imeShortName:String = null;
         var imeName:String = null;
         this.CloseList(this.NumRows);
         var pos:Number = -1;
         pos = name.indexOf("InputLangTab");
         if(pos != -1)
         {
            IMEEx.SendLangBarMessage(this,"LangBar_GetInstalledLanguages","");
         }
         pos = name.indexOf("InputLangNames");
         if(pos != -1)
         {
            inputLangName = name.substr(pos + "InputLangNames_".length);
            imeShortName = this.getLangShortName(name);
            if(imeShortName != this.InputLangTab_mc.tf.text)
            {
               this.InputLangTab_mc.tf.text = imeShortName;
               this.InputLangName = inputLangName;
               this.Resize(this.InputLangTab_mc.tf.width,this.InputLangTab_mc);
               this.Reposition(this.InputLangTab_mc,this.IMENameTab_mc);
               IMEEx.SendLangBarMessage(this,"LangBar_OnSelectInputLang",inputLangName);
            }
         }
         pos = name.indexOf("IMENameTab");
         if(pos != -1)
         {
            IMEEx.SendLangBarMessage(this,"LangBar_GetIMENames",this.InputLangName);
         }
         pos = name.indexOf("IMENames");
         if(pos != -1)
         {
            imeName = name.substr(pos + "IMENames_".length);
            IMEEx.SendLangBarMessage(this,"LangBar_OnSelectIME",imeName);
            this.IMENameTab_mc.visible = true;
            this.IMENameTab_mc.Event_mc.gotoAndPlay(1);
         }
      }
      
      public function MouseDownHandler(event:MouseEvent) : void
      {
         var i:uint = 0;
         var hit:Boolean = false;
         var point:Point = new Point();
         point.x = event.stageX;
         point.y = event.stageY;
         if(this.IMENameTab_mc != null && this.IMENameTab_mc.hitTestPoint(point.x,point.y,false))
         {
            return;
         }
         if(this.InputLangTab_mc != null && this.InputLangTab_mc.hitTestPoint(point.x,point.y,false))
         {
            return;
         }
         for(i = 0; i < this.NumRows; i++)
         {
            if(Boolean(this.Clips[i].hitTestPoint(point.x,point.y,false)))
            {
               hit = true;
               break;
            }
         }
         if(!hit)
         {
            for(i = 0; i < this.NumRows; i++)
            {
               this.LangBar.removeChild(this.Clips[i]);
            }
            this.NumRows = 0;
         }
      }
      
      public function Resize(width:Number, mc:MovieClip) : void
      {
         mc.Background_mc.width = width;
         mc.Event_mc.width = width;
      }
      
      public function Reposition(left_mc:MovieClip, right_mc:MovieClip) : void
      {
         right_mc.y = left_mc.y;
         right_mc.x = left_mc.x + left_mc.width;
      }
      
      public function CreateInputLangTab() : void
      {
         if(this.LangBar != null)
         {
            this.removeChild(this.LangBar);
            this.LangBar = null;
         }
         this.LangBar = new MovieClip();
         this.InputLangTab_mc = new Bar_mc();
         this.InputLangTab_mc.name = "InputLangTab_mc";
         this.InputLangTab_mc.myIconKeyboard.visible = false;
         this.LangBar.addChild(this.InputLangTab_mc);
         this.IMENameTab_mc = new Bar_mc();
         this.IMENameTab_mc.name = "IMENameTab_mc";
         this.IMENameTab_mc.myIconKeyboard.visible = true;
         this.IMENameTab_mc.tf.text = "";
         this.IMENameTab_mc.visible = false;
         this.LangBar.addChild(this.IMENameTab_mc);
         this.addChild(this.LangBar);
      }
      
      public function CloseList(numRows:Number) : void
      {
         for(var i:int = 0; i < numRows; i++)
         {
            this.LangBar.removeChild(this.Clips[i]);
         }
         this.NumRows = 0;
      }
      
      public function GetListOrigin(listType:String) : Point
      {
         var pt:Point = new Point(0,0);
         if(listType == "InputLangNames")
         {
            pt.x = this.InputLangTab_mc.x;
            pt.y = this.InputLangTab_mc.y + this.InputLangTab_mc.height;
            return this.LangBar.localToGlobal(pt);
         }
         if(listType == "IMENames")
         {
            pt.x = this.IMENameTab_mc.x;
            pt.y = this.IMENameTab_mc.y + this.IMENameTab_mc.height;
            return this.LangBar.localToGlobal(pt);
         }
         return pt;
      }
      
      public function CheckListPosition(yPosTab:Number, tabHeight:Number, listHeight:Number, playerWindowH:Number) : Boolean
      {
         if(listHeight < playerWindowH - (yPosTab + tabHeight))
         {
            return true;
         }
         if(yPosTab > listHeight)
         {
            return false;
         }
         return true;
      }
      
      public function CreateList(listType:String, listData:String) : void
      {
         var nmc:MovieClip = null;
         var i:uint = 0;
         var listHeight:Number = NaN;
         var listPos:Boolean = false;
         var w:Number = NaN;
         var pt:Point = null;
         var newpt:Point = null;
         this.CloseList(this.NumRows);
         var itemNames:Array = listData.split("@@");
         var numRows:Number = itemNames.length - 1;
         this.NumRows = numRows;
         var itemName:String = "item";
         var pos:Point = this.GetListOrigin(listType);
         var x:Number = pos.x;
         var y:Number = pos.y;
         var max:Number = 0;
         if(numRows > 0)
         {
            nmc = new ListRow_mc();
            this.LangBar.addChild(nmc);
            nmc.name = listType + "_" + itemNames[0];
            this.Clips[0] = nmc;
            listHeight = nmc.height * numRows;
            listPos = this.CheckListPosition(y - this.IMENameTab_mc.height,this.IMENameTab_mc.height,listHeight,GameInfo.DEFAULT_HEIGHT);
            TextUtil.replaceEnFont(nmc.tf,itemNames[0],GameInfo.GAME_FONT_AENCY_FB_BOLD,0,GameInfo.GAME_FONT_S,0);
            w = nmc.tf.textWidth + 4;
            max = w;
            if(listPos != true)
            {
               y = y - this.IMENameTab_mc.height - listHeight;
            }
            pt = new Point();
            pt.x = x;
            pt.y = y;
            newpt = this.LangBar.globalToLocal(pt);
            nmc.y = newpt.y;
            nmc.x = newpt.x;
            for(i = 1; i < numRows; i++)
            {
               nmc = new ListRow_mc();
               this.LangBar.addChild(nmc);
               nmc.name = listType + "_" + itemNames[i];
               this.Clips[i] = nmc;
               TextUtil.replaceEnFont(nmc.tf,itemNames[i],GameInfo.GAME_FONT_AENCY_FB_BOLD,0,GameInfo.GAME_FONT_S,0);
               w = nmc.tf.textWidth + 4;
               y += nmc.height - 1;
               pt.x = x;
               pt.y = y;
               newpt = this.LangBar.globalToLocal(pt);
               nmc.x = newpt.x;
               nmc.y = newpt.y;
               if(w > max)
               {
                  max = w;
               }
            }
         }
         for(i = 0; i < numRows; i++)
         {
            this.Clips[i].tf.width = max;
            this.Resize(this.Clips[i].tf.width,this.Clips[i]);
         }
      }
   }
}

