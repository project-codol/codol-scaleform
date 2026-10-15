package components.scoreboard_part
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.ContentContainer;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class SurvivalPanel extends MovieClip
   {
      
      private static const BASE_HEIGHT:uint = 48;
      
      private static const ELEMENT_HEIGHT:uint = 62;
      
      private static const MIN_CONTAINER_HEIGHT:uint = 48;
      
      private static const OBJ_TABLE:String = "mp/survival_events.csv";
      
      private static const COL_ID:int = 0;
      
      private static const COL_NAME:int = 3;
      
      private static const COL_DESC:int = 2;
      
      public var myTitle:TextField;
      
      public var myNoObjectives:TextField;
      
      public var myObjective0:SurvivalPanelObjective;
      
      public var myObjective1:SurvivalPanelObjective;
      
      public var myObjective2:SurvivalPanelObjective;
      
      public var myContainer:ContentContainer;
      
      private var mObjectives:Vector.<SurvivalPanelObjective>;
      
      private var mMaxVisible:uint;
      
      public function SurvivalPanel()
      {
         super();
         this.mObjectives = new Vector.<SurvivalPanelObjective>();
         this.mObjectives.push(this.myObjective0);
         this.mObjectives.push(this.myObjective1);
         this.mObjectives.push(this.myObjective2);
         this.mMaxVisible = this.mObjectives.length;
         this.myTitle.text = "@SURVIVAL_EVENTS_OBJECTIVES_TITLE";
         this.myNoObjectives.text = "@SURVIVAL_EVENTS_NO_OBJECTIVES";
         this.myContainer.showAccents = false;
         this.myContainer.width = 791;
      }
      
      public function refreshObjectives() : void
      {
         var numVisible:uint = 0;
         var objectives:Array = null;
         var i:uint = 0;
         var objective:String = null;
         var objectiveData:Array = null;
         var objectiveID:int = 0;
         var objectiveStatus:int = 0;
         var tableRows:int = 0;
         var j:int = 0;
         var rowID:int = 0;
         numVisible = 0;
         for(var iClip:uint = 0; iClip < this.mMaxVisible; iClip++)
         {
            this.mObjectives[iClip].visible = false;
         }
         var objectiveDvar:String = CFunctionCommonContainer.Dvar_GetString("ui_surv_activeEventIds");
         if(objectiveDvar.length > 0)
         {
            objectives = objectiveDvar.split(" ");
            i = 0;
            while(i < objectives.length && i < this.mMaxVisible)
            {
               objective = objectives[i];
               objectiveData = objective.split(":");
               if(objectiveData.length == 2)
               {
                  objectiveID = parseInt(objectiveData[0]);
                  objectiveStatus = parseInt(objectiveData[1]);
                  tableRows = CFunctionCommonContainer.StringTableRowCount(OBJ_TABLE);
                  for(j = 0; j < tableRows; j++)
                  {
                     rowID = parseInt(CFunctionCommonContainer.StringTableLookupByRow(OBJ_TABLE,j,COL_ID));
                     if(rowID == objectiveID)
                     {
                        this.mObjectives[i].setData("@" + CFunctionCommonContainer.StringTableLookupByRow(OBJ_TABLE,j,COL_NAME),"@" + CFunctionCommonContainer.StringTableLookupByRow(OBJ_TABLE,j,COL_DESC),objectiveStatus);
                        this.mObjectives[i].visible = true;
                        numVisible++;
                        break;
                     }
                  }
               }
               i++;
            }
         }
         this.myNoObjectives.visible = numVisible == 0;
         this.myContainer.height = (numVisible > 0 ? ELEMENT_HEIGHT * numVisible + 15 : MIN_CONTAINER_HEIGHT) + BASE_HEIGHT;
      }
      
      override public function get height() : Number
      {
         return this.myContainer.height;
      }
   }
}

