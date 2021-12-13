//+------------------------------------------------------------------+
//|                                                    autoentry.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

string symbol,firstCurrency,secondCurrency; // 通貨ペア名のみ取得
int wk;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   //ボタン削除
    ObjectDelete("buy");
    ObjectDelete("sell");
    ObjectDelete("set");
    ObjectDelete("display");

   //displayボタン作成（ボタン表示/非表示）
    ObjectCreate(0,"display",OBJ_BUTTON,0,0,0);
    
   //displayボタン設定
    ObjectSetInteger(0,"display", OBJPROP_CORNER, CORNER_RIGHT_LOWER); // 原点を右下に設定
    ObjectSetInteger(0,"display",OBJPROP_COLOR,clrWhite);      //色設定
    ObjectSetInteger(0,"display",OBJPROP_BGCOLOR,clrGold);  // ボタン色
    ObjectSetInteger(0,"display",OBJPROP_XDISTANCE, 200);                // X座標
    ObjectSetInteger(0,"display",OBJPROP_YDISTANCE, 100);                 // Y座標
    ObjectSetInteger(0,"display",OBJPROP_SELECTABLE,false);     //オブジェクトの選択可否設定
    ObjectSetInteger(0,"display",OBJPROP_SELECTED,false);       //オブジェクトの選択状態
    ObjectSetInteger(0,"display",OBJPROP_HIDDEN,false);          //オブジェクトリストの表示設定
    ObjectSetString(0,"display",OBJPROP_TEXT,"");           //表示テキスト
    ObjectSetInteger(0,"display",OBJPROP_XSIZE,100);            // ボタンサイズ幅
    ObjectSetInteger(0,"display",OBJPROP_YSIZE,70);            // ボタンサイズ高さ
    ObjectSetInteger(0,"display",OBJPROP_STATE,false);          //ボタン押下状態
   
    wk = 2;
    //ObjectSetInteger(1,"sell",OBJPROP_COLOR,Red);
    //ObjectSetInteger(2,"set",OBJPROP_COLOR,Blue);
    
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }


void OnChartEvent(
                 const int     id,      // イベントID
                 const long&   lparam,  // long型イベント
                 const double& dparam,  // double型イベント
                 const string& sparam)  // string型イベント
{
   symbol = transform(Symbol());
    if ( id == CHARTEVENT_OBJECT_CLICK) {         // オブジェクトがクリックされた
        if ( sparam == "buy" ) {           // "buyボタン"がクリックされた
            SendSignalToFile("BUY");
            Alert(symbol);
        }else if ( sparam == "set") {
           SendSignalToFile("SET");
           Alert("set");
        }else if ( sparam == "display") {
           status();
        }
    }
}

  void SendSignalToFile(string BuyOrSell)
{
   int FileHandle;
   string FileName = "SignalDataForHighLow.txt";
   int TryCount;
  
   FileHandle = FileOpen(FileName,FILE_WRITE|FILE_TXT|FILE_COMMON);
   TryCount = 0;
   while( FileHandle == INVALID_HANDLE && TryCount < 30)
   {
      TryCount++;
      FileHandle = FileOpen(FileName,FILE_WRITE|FILE_TXT|FILE_COMMON);
   }
      
   if( FileHandle != INVALID_HANDLE )
   {
      if( BuyOrSell == "BUY" ) FileWrite(FileHandle,"BUY");
      if( BuyOrSell == "SELL") FileWrite(FileHandle,"SELL");
      if( BuyOrSell == "SET") FileWrite(FileHandle,"SET");
                              FileWrite(FileHandle,symbol);
      FileClose(FileHandle);
   }
}

//通貨ペア　変換
  string transform(string symbol2)
{
     if (symbol2 == "XAUUSD")
     {
        symbol2 = "GOLD";
        return(symbol2);
     }else{
        firstCurrency = StringSubstr(Symbol(), 0, 3);
        secondCurrency = StringSubstr(Symbol(), 3, 6);
        symbol2 = StringConcatenate(firstCurrency, "/", secondCurrency) + " ";
        return(symbol2);
     }
}
  int status(){
     if (wk == 1){
      ObjectDelete("buy");
      ObjectDelete("sell");
      ObjectDelete("set");
      wk = 2;
     }else{
        //ボタン作成
       ObjectCreate(0,"buy",OBJ_BUTTON,0,0,0);
       ObjectCreate(0,"sell",OBJ_BUTTON,0,0,0);
       ObjectCreate(0,"set",OBJ_BUTTON,0,0,0);
       

       //HIGHボタン設定
       ObjectSetInteger(0,"buy", OBJPROP_CORNER, CORNER_RIGHT_UPPER); // 原点を右上に設定
       ObjectSetInteger(0,"buy",OBJPROP_COLOR,clrWhite);      //色設定
       ObjectSetInteger(0,"buy",OBJPROP_BGCOLOR,clrMediumSeaGreen);  // ボタン色
       ObjectSetInteger(0,"buy",OBJPROP_XDISTANCE, 300);                // X座標
       ObjectSetInteger(0,"buy",OBJPROP_YDISTANCE, 30);                 // Y座標
       ObjectSetInteger(0,"buy",OBJPROP_SELECTABLE,false);     //オブジェクトの選択可否設定
       ObjectSetInteger(0,"buy",OBJPROP_SELECTED,false);       //オブジェクトの選択状態
       ObjectSetInteger(0,"buy",OBJPROP_HIDDEN,true);          //オブジェクトリストの表示設定
       ObjectSetString(0,"buy",OBJPROP_TEXT,"HIGH");           //表示テキスト
       ObjectSetInteger(0,"buy",OBJPROP_XSIZE,100);            // ボタンサイズ幅
       ObjectSetInteger(0,"buy",OBJPROP_YSIZE,100);            // ボタンサイズ高さ
       ObjectSetInteger(0,"buy",OBJPROP_STATE,false);          //ボタン押下状態
      
       //LOWボタン設定
       ObjectSetInteger(0,"sell", OBJPROP_CORNER, CORNER_RIGHT_UPPER); // 原点を右上に設定
       ObjectSetInteger(0,"sell",OBJPROP_COLOR,clrWhite);      //色設定
       ObjectSetInteger(0,"sell",OBJPROP_BGCOLOR,clrIndianRed);  // ボタン色
       ObjectSetInteger(0,"sell",OBJPROP_XDISTANCE, 200);                // X座標
       ObjectSetInteger(0,"sell",OBJPROP_YDISTANCE, 30);                 // Y座標
       ObjectSetInteger(0,"sell",OBJPROP_SELECTABLE,false);     //オブジェクトの選択可否設定
       ObjectSetInteger(0,"sell",OBJPROP_SELECTED,false);       //オブジェクトの選択状態
       ObjectSetInteger(0,"sell",OBJPROP_HIDDEN,false);          //オブジェクトリストの表示設定
       ObjectSetString(0,"sell",OBJPROP_TEXT,"LOW");           //表示テキスト
       ObjectSetInteger(0,"sell",OBJPROP_XSIZE,100);            // ボタンサイズ幅
       ObjectSetInteger(0,"sell",OBJPROP_YSIZE,100);            // ボタンサイズ高さ
       ObjectSetInteger(0,"sell",OBJPROP_STATE,false);          //ボタン押下状態

       //setボタン設定
       ObjectSetInteger(0,"set", OBJPROP_CORNER, CORNER_RIGHT_UPPER); // 原点を右上に設定
       ObjectSetInteger(0,"set",OBJPROP_COLOR,clrWhite);      //色設定
       ObjectSetInteger(0,"set",OBJPROP_BGCOLOR,clrIndianRed);  // ボタン色
       ObjectSetInteger(0,"set",OBJPROP_XDISTANCE, 200);                // X座標
       ObjectSetInteger(0,"set",OBJPROP_YDISTANCE, 150);                 // Y座標
       ObjectSetInteger(0,"set",OBJPROP_SELECTABLE,false);     //オブジェクトの選択可否設定
       ObjectSetInteger(0,"set",OBJPROP_SELECTED,false);       //オブジェクトの選択状態
       ObjectSetInteger(0,"set",OBJPROP_HIDDEN,false);          //オブジェクトリストの表示設定
       ObjectSetString(0,"set",OBJPROP_TEXT,"SET");           //表示テキスト
       ObjectSetInteger(0,"set",OBJPROP_XSIZE,100);            // ボタンサイズ幅
       ObjectSetInteger(0,"set",OBJPROP_YSIZE,100);            // ボタンサイズ高さ
       ObjectSetInteger(0,"set",OBJPROP_STATE,false);          //ボタン押下状態

       wk = 1;
      
     }
     return(0);
  }

  int deinit(){

   ObjectDelete("buy");
   ObjectDelete("sell");
   ObjectDelete("set");
   ObjectDelete("display");
   return(0);
}
//+------------------------------------------------------------------+
