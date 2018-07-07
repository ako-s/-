       IDENTIFICATION         DIVISION.
       PROGRAM-ID.            SAMPLE.
      ********************************************************
      * プログラム名    ：さんぷる  こぼ
      * 作成日／作成者  ：２０１８年０７月０７日  山田太郎
      * 変更日／変更者  ：
      *       変更内容  ：
      ********************************************************
       ENVIRONMENT            DIVISION.
       INPUT-OUTPUT           SECTION.
       FILE-CONTROL.
           SELECT  IN1-FILE  ASSIGN TO   
                   "C:\GnuCobol\file\SAMPLE_IN.txt"
                   ORGANIZATION  LINE  SEQUENTIAL.
           SELECT  OT1-FILE  ASSIGN TO   
                   "C:\GnuCobol\file\SAMPLE_OUT.txt"
                   ORGANIZATION  LINE  SEQUENTIAL.
      *
       DATA                   DIVISION.
       FILE                   SECTION.
       FD  IN1-FILE.
       01  IN1-REC.
      *      漢字氏名全角6文字 
         05  IN1-NAME         PIC  X(12).
         05  IN1-CM1          PIC  X(01).
      *      生年月日 YYYYMMDD 
         05  IN1-BIRTH        PIC  X(08).
         05  IN1-CM2          PIC  X(01).
      *      性別 (1:男、2:女、3:不明) 
         05  IN1-SEX          PIC  X(01).
      *
       FD  OT1-FILE.
       01  OT1-REC.
      *      漢字氏名全角6文字 
         05  OT1-NAME         PIC  X(12).
         05  OT1-CM1          PIC  X(01).
      *      生年月日 YYYY/MM/DD 
         05  OT1-BIRTH        PIC  X(10).
         05  OT1-CM2          PIC  X(01).
      *      性別 (1:男、2:女) 
         05  OT1-SEX          PIC  X(01).
      *
       WORKING-STORAGE        SECTION.
       01  WK-AREA.
           05  WK-YMD.
             10  WK-YYYY      PIC  X(04).
             10  WK-S1        PIC  X(01).
             10  WK-MM        PIC  X(02).
             10  WK-S2        PIC  X(01).
             10  WK-DD        PIC  X(02).
       01  FLG-AREA.
         05  FLG-IN1-END      PIC  X(01).
       01  CNT-AREA.
         05   CNT-IN1         PIC  9(09).
         05   CNT-OT1         PIC  9(09).
      *
      ********************************************************
      *    さんぷる  コントロール
      ********************************************************
       PROCEDURE              DIVISION.
           PERFORM  INIT-RTN.
           PERFORM  MAIN-RTN  UNTIL  FLG-IN1-END = "1".
           PERFORM  END-RTN.
           STOP  RUN.
      ********************************************************
      *    初期処理
      ********************************************************
       INIT-RTN               SECTION.
           DISPLAY  "*** SAMPLE START ***".
      *    初期化
           INITIALIZE         WK-AREA
                              FLG-AREA
                              CNT-AREA.
           OPEN  INPUT        IN1-FILE.
           OPEN  OUTPUT       OT1-FILE.
      *    1件目READ
           PERFORM  READ-RTN.
       EXT.
            EXIT.
      ********************************************************
      *    入力処理
      ********************************************************
       READ-RTN               SECTION.
            READ  IN1-FILE
              AT  END
                 MOVE  "1"    TO  FLG-IN1-END
              NOT  AT  END
                 ADD  1       TO  CNT-IN1
            END-READ.
       EXT.
            EXIT.
      ********************************************************
      *    編集処理
      ********************************************************
       MAIN-RTN               SECTION.
      *     性別不明データは読み飛ばし
            IF  IN1-SEX = '1' OR '2'
      *         初期化
                MOVE  SPACE   TO  OT1-REC
                MOVE  ','     TO  OT1-CM1
                                  OT1-CM2
      *         データセット
                MOVE  IN1-NAME        TO  OT1-NAME
      *
                MOVE  IN1-BIRTH(1:4)  TO  WK-YYYY
                MOVE  IN1-BIRTH(5:2)  TO  WK-MM
                MOVE  IN1-BIRTH(7:2)  TO  WK-DD
                MOVE  '/'             TO  WK-S1
                                          WK-S2
                MOVE  WK-YMD          TO  OT1-BIRTH
      *
                MOVE  IN1-SEX         TO  OT1-SEX
      *         ファイル出力
                WRITE  OT1-REC
                ADD  1        TO  CNT-OT1
            END-IF.
      *
            PERFORM  READ-RTN.
       EXT.
            EXIT.
      ********************************************************
      *    終了処理
      ********************************************************
       END-RTN                SECTION.
            CLOSE  IN1-FILE.
            CLOSE  OT1-FILE.
            DISPLAY  "*** IN1 = " CNT-IN1 " ***".
            DISPLAY  "*** OT1 = " CNT-OT1 " ***".
            DISPLAY  "*** SAMPLE END ***".
       EXT.
            EXIT.
