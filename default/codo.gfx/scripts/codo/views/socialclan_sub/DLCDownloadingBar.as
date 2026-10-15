package codo.views.socialclan_sub
{
   import codo.base.BaseSubElement;
   import codo.constants.DataID;
   import codo.localization.Dict;
   import codo.utils.LocalizeUtil;
   import codo.utils.TimeUtil;
   import flash.text.TextField;
   
   public class DLCDownloadingBar extends BaseSubElement
   {
      
      public var myDLCTitleTF:TextField;
      
      public var myRemainTimeTitleTF:TextField;
      
      public var myRemainTimeTF:TextField;
      
      public function DLCDownloadingBar()
      {
         super();
         this.visible = false;
         this.stop();
         this.myDLCTitleTF.multiline = true;
         this.myDLCTitleTF.wordWrap = true;
         this.myRemainTimeTitleTF.text = Dict.TIME_REMAINING;
      }
      
      override public function active() : void
      {
         this.bind(DataID.DLC_INFO,this.bind_dlcInfo);
      }
      
      override public function deactive() : void
      {
         this.unbind(DataID.DLC_INFO,this.bind_dlcInfo);
      }
      
      private function bind_dlcInfo(cRes:Object) : void
      {
         if(Boolean(cRes.data.miniclient))
         {
            this.myDLCTitleTF.text = LocalizeUtil.localize(Dict.MINICLIENT_DLC_IS_DOWNLOADING);
         }
         else
         {
            this.myDLCTitleTF.text = LocalizeUtil.localize(Dict.CLIENT_DLC_IS_DOWNLOADING);
         }
         this.myRemainTimeTF.text = TimeUtil.timeToStringEN(cRes.data.remainTime);
         this.gotoAndStop(Math.round(cRes.data.percent * 100) + 1);
         this.visible = cRes.data.visible;
      }
   }
}

