package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.CodoPageViewDB;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictSystem;
   import codo.objects.QuestionObj;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   
   public class QuestionnaireController extends BaseController
   {
      
      private const QUESTIONNAIRE_NONE:uint = 0;
      
      private const QUESTIONNAIRE_READY:uint = 1;
      
      private const QUESTIONNAIRE_SHOWN:uint = 2;
      
      private const QUESTIONNAIRE_FINISHED:uint = 3;
      
      private const QUESTIONNAIRE_FILTER:uint = 2;
      
      private var questionnaireState:uint = 0;
      
      private var _questions:Array = new Array();
      
      public function QuestionnaireController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         this.listen(BCEvent.SUBMIT_QUESTIONNAIRE,this.onSubmitQuestionnaire);
         this.listen(BCEvent.SHOW_QUESTIONNAIRE,this.onShowQuestionnaire);
         this.listen(BCEvent.HIDE_QUESTIONNAIRE,this.onCloseQuestionnaire);
         this.listen(BCEvent.TRYOPEN_QUESTIONNAIRE,this.onTryOpenQuestionnaire);
         CFunctionContainer.AS_ParseQuestionnaire();
         this.questionnaireState = this.QUESTIONNAIRE_READY;
      }
      
      private function onSubmitQuestionnaire(cEvt:ParaEvent) : void
      {
         var i:int = 0;
         var hasEmptyAnswer:Boolean = false;
         var iAns:uint = 0;
         var ansObj:Object = null;
         var answerFirstLine:String = null;
         var answerSecondLine:String = null;
         var options:Array = null;
         var optIndex:int = 0;
         var checkedOptionCount:int = 0;
         if(!ScaleformUtil.isScaleform)
         {
            this.hideQuestionnaire();
            this.showMsg(Dict.QUESTION_SUBMITTED,MsgBtnCount.ONE);
            return;
         }
         var answers:Array = cEvt.myPara.answer;
         var tLogs:Array = new Array();
         if(answers.length == this._questions.length)
         {
            for(i = 0; i < answers.length; i++)
            {
               hasEmptyAnswer = true;
               if(answers[i].answer != undefined)
               {
                  for(iAns = 0; iAns < answers[i].answer.length; iAns++)
                  {
                     if(Boolean(answers[i].answer[iAns]))
                     {
                        hasEmptyAnswer = false;
                        break;
                     }
                  }
               }
               if(hasEmptyAnswer)
               {
                  this.showMsg(Dict.QUESTION_EMPTY_ANSWER,MsgBtnCount.ONE);
                  return;
               }
            }
            for(i = 0; i < answers.length; i++)
            {
               ansObj = answers[i];
               answerFirstLine = String(ansObj.answerIndex) + ":";
               answerSecondLine = "";
               if(this._questions[i].type == QuestionObj.TYPE_OPEN)
               {
                  answerSecondLine = ansObj.text;
               }
               else if(this._questions[i].type == QuestionObj.TYPE_SINGLE)
               {
                  options = ansObj.answer;
                  for(optIndex = 0; optIndex < options.length; optIndex++)
                  {
                     if(Boolean(options[optIndex]))
                     {
                        answerFirstLine += String(optIndex);
                        break;
                     }
                  }
                  answerSecondLine = ansObj.text;
               }
               else if(this._questions[i].type == QuestionObj.TYPE_MULTI)
               {
                  options = ansObj.answer;
                  checkedOptionCount = 0;
                  for(optIndex = 0; optIndex < options.length; optIndex++)
                  {
                     if(Boolean(options[optIndex]))
                     {
                        if(checkedOptionCount == 0)
                        {
                           answerFirstLine += String(optIndex);
                        }
                        else
                        {
                           answerFirstLine += "," + String(optIndex);
                        }
                        checkedOptionCount++;
                     }
                  }
                  answerSecondLine = ansObj.text;
               }
               tLogs.push(answerFirstLine);
            }
            CFunctionContainer.AS_ReplyQuestionnaire(tLogs);
            this.questionnaireState = this.QUESTIONNAIRE_FINISHED;
            this.hideQuestionnaire();
            this.showMsg(Dict.QUESTION_SUBMITTED,MsgBtnCount.ONE,0,this.onConfirmBtnClicked);
         }
      }
      
      private function onConfirmBtnClicked() : void
      {
         this.broadcast(BCEvent.EVT_GOTO_QUIT);
      }
      
      private function onShowQuestionnaire(cEvt:ParaEvent) : void
      {
         this.onTakeQuestionnaire();
      }
      
      private function onCloseQuestionnaire(cEvt:ParaEvent) : void
      {
         CFunctionContainer.AS_CloseQuestionnaire();
         this.questionnaireState = this.QUESTIONNAIRE_READY;
         this.hideQuestionnaire();
         this.broadcast(BCEvent.EVT_GOTO_QUIT);
      }
      
      private function onTryOpenQuestionnaire(cEvt:ParaEvent) : void
      {
         if(CFunctionCommonContainer.Dvar_GetBool("ui_lockQuestionnaire") == false)
         {
            if(this.questionnaireState == this.QUESTIONNAIRE_SHOWN)
            {
               return;
            }
            if(this.questionnaireState == this.QUESTIONNAIRE_READY && Boolean(CFunctionContainer.AS_NeedQuestionnaire()))
            {
               this.showMsg(Dict.QUESTIONNAIRE_QUERY,MsgBtnCount.TWO,0,this.onTakeQuestionnaire,DictSystem.CONFIRM,this.onRefusedTakeQuestionnaire,DictSystem.CANCEL);
            }
            else
            {
               this.broadcast(BCEvent.EVT_GOTO_QUIT);
            }
         }
         else
         {
            this.broadcast(BCEvent.EVT_GOTO_QUIT);
         }
      }
      
      private function onTakeQuestionnaire() : void
      {
         var questionnaireResult:Object = null;
         if(this.questionnaireState == this.QUESTIONNAIRE_READY && Boolean(CFunctionContainer.AS_NeedQuestionnaire()))
         {
            Logger.print("QuestionnaireController:::onTakeQuestionnaire");
            questionnaireResult = CFunctionContainer.AS_GetQuestionnaire();
            this._questions = questionnaireResult.questions;
            this.setBindData(DataID.QUESTION_DATA,{
               "title":questionnaireResult.title,
               "question":this._questions
            });
            this.showQuestionnaire();
         }
         else
         {
            this.broadcast(BCEvent.EVT_GOTO_QUIT);
         }
      }
      
      private function onRefusedTakeQuestionnaire() : void
      {
         this.questionnaireState = this.QUESTIONNAIRE_FINISHED;
         CFunctionContainer.AS_CloseQuestionnaire();
         this.broadcast(BCEvent.EVT_GOTO_QUIT);
      }
      
      private function showQuestionnaire() : void
      {
         Logger.print("QuestionnaireController:::showQuestionnaire");
         this.questionnaireState = this.QUESTIONNAIRE_SHOWN;
         this.gotoPage(CodoPageViewDB.PAGE_POPUP_QUESTION);
      }
      
      private function hideQuestionnaire() : void
      {
         Logger.print("QuestionnaireController:::hideQuestionnaire");
         this.prevPage();
      }
   }
}

