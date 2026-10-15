package ui_fsg_widgets_fla
{
   import adobe.utils.*;
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
   import fsg.shared.ComboBoxItem;
   import fsg.widgets.comboBox;
   import fsg.widgets.comboBoxDropDownMenu;
   import fsg.widgets.comboBoxItem;
   import fsg.widgets.comboBoxOption;
   import fsg.widgets.comboBoxWithImage;
   import fsg.widgets.primaryButton;
   
   public dynamic class MainTimeline extends MovieClip
   {
      
      public var myBestScore:fsgGameModesTrainingBestScoreBar;
      
      public var myCBItem:comboBoxItem;
      
      public var myCBMouseInvert:fsgCheckBox;
      
      public var myComboBoxImage:comboBoxWithImage;
      
      public var myComboBoxNew:comboBox;
      
      public var myDropDownMenu:comboBoxDropDownMenu;
      
      public var myNewCB:comboBoxOption;
      
      public var myTab00:primaryButton;
      
      public var myTokens:pveTokenCounter;
      
      public var testData:Array;
      
      public var i:uint;
      
      public var j:uint;
      
      public var item:ComboBoxItem;
      
      public function MainTimeline()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.testData = [];
         for(this.i = 0; this.i < 10; ++this.i)
         {
            this.testData.push({"name":"item" + this.i});
         }
         this.myNewCB.dataProvider = this.testData;
         for(this.j = 0; this.j < this.testData.length; ++this.j)
         {
            this.item = new comboBoxItem();
            this.item.label = this.testData[this.j].name;
            this.myDropDownMenu.push(this.item);
         }
         trace("hello world");
      }
   }
}

