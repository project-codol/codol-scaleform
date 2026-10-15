package codo.utils
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.SE_Flag;
   import codo.constants.SE_ID;
   import codo.interfaces.ISoundUtil;
   
   public class SoundUtil implements ISoundUtil
   {
      
      private static var instance:SoundUtil;
      
      public function SoundUtil()
      {
         super();
      }
      
      public static function getInstance() : SoundUtil
      {
         if(SoundUtil.instance == null)
         {
            SoundUtil.instance = new SoundUtil();
         }
         return SoundUtil.instance;
      }
      
      public function playMusic(cMusicName:String, cAmbName:String) : void
      {
         CFunctionCommonContainer.playmusic(cMusicName,cAmbName);
      }
      
      public function stopMusic() : void
      {
         CFunctionCommonContainer.stopmusic();
      }
      
      public function playSound(cSoundName:String) : void
      {
         if(cSoundName != SE_ID.MUTE)
         {
            CFunctionCommonContainer.playsound(cSoundName);
         }
      }
      
      public function stopSound() : void
      {
         CFunctionCommonContainer.stopsound();
      }
      
      public function playSoundByFullName(cFullName:String, cFlag:uint, cMatchType:uint = 0) : void
      {
         var uinames_1:Array = null;
         var uiBaseName:String = null;
         var uiChildNameWithTag:String = null;
         var uiChildName:String = null;
         var uiTagName:String = null;
         var prioritizedNameList:Array = null;
         var highPriorityName:String = null;
         var middlePriorityName:String = null;
         var lowPriorityName:String = null;
         var uinames_2:Array = null;
         if(ScaleformUtil.isScaleform)
         {
            uinames_1 = cFullName.split("@");
            uiBaseName = uinames_1[0];
            uiChildNameWithTag = "";
            uiChildName = "";
            uiTagName = "";
            if(uinames_1.length > 1)
            {
               uiChildNameWithTag = uinames_1[1];
               uinames_2 = uiChildNameWithTag.split("$");
               if(uinames_2.length == 2)
               {
                  uiChildName = uinames_2[0];
                  uiTagName = uinames_2[1];
               }
               else if(uinames_2.length == 1)
               {
                  uiChildName = uinames_2[0];
               }
            }
            prioritizedNameList = new Array();
            highPriorityName = "";
            middlePriorityName = "";
            lowPriorityName = "";
            if(uiChildName != "" && uiTagName != "")
            {
               highPriorityName = uiBaseName + "@" + uiChildName + "$" + uiTagName;
               middlePriorityName = uiBaseName + "@" + uiChildName;
               lowPriorityName = uiBaseName;
               prioritizedNameList.push(highPriorityName);
               prioritizedNameList.push(middlePriorityName);
               prioritizedNameList.push(lowPriorityName);
            }
            else if(uiChildName != "" && uiTagName == "")
            {
               highPriorityName = uiBaseName + "@" + uiChildName;
               middlePriorityName = uiBaseName;
               prioritizedNameList.push(highPriorityName);
               prioritizedNameList.push(middlePriorityName);
            }
            else
            {
               highPriorityName = uiBaseName;
               prioritizedNameList.push(highPriorityName);
            }
            if(CFunctionCommonContainer.PlaySoundByFullName(prioritizedNameList,cFlag) == false)
            {
               switch(cFlag)
               {
                  case SE_Flag.over:
                     this.playSound(SE_ID.GENERAL_BUTTON_OVER[cMatchType]);
                     break;
                  case SE_Flag.click:
                     this.playSound(SE_ID.GENERAL_BUTTON_CLICK[cMatchType]);
               }
            }
            else
            {
               Logger.exportSoundFullName(cFullName + "#" + cFlag);
            }
         }
      }
   }
}

