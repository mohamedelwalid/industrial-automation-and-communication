TYPE
  LOGLEVEL : (CRITICAL, WARNING, INFO, DEBUG) := INFO;
END_TYPE

FUNCTION_BLOCK LOGGER
  VAR_INPUT
    TRIG : BOOL;
    MSG : STRING;
    LEVEL : LOGLEVEL := INFO;
  END_VAR
  VAR
    TRIG0 : BOOL;
  END_VAR

  IF TRIG AND NOT TRIG0 THEN
  {{
   LogMessage(GetFbVar(LEVEL),(char*)GetFbVar(MSG, .body),GetFbVar(MSG, .len));
  }}
  END_IF;
  TRIG0:=TRIG;
END_FUNCTION_BLOCK


PROGRAM E9
  VAR
    start_button : BOOL;
  END_VAR
  VAR
    sensor_1 : BOOL;
    sensor_2 : BOOL;
    sensor_3 : BOOL;
    sensor_4 : BOOL;
    sensor_5 : BOOL;
    conveyor_1 : BOOL;
    conveyor_2 : BOOL;
    conveyor_3 : BOOL;
    conveyor_4 : BOOL;
    process_station1 : BOOL;
    process_station2 : BOOL;
    transfer1_out : BOOL;
    transfer1_back : BOOL;
    transfer1_sensor_home : BOOL;
    transfer1_sensor_end : BOOL;
    transfer2_out : BOOL;
    transfer2_back : BOOL;
    transfer2_sensor_home : BOOL;
    transfer2_sensor_end : BOOL;
  END_VAR

  INITIAL_STEP Step0:
    STEP0_INLINE1(N);
    STEP0_INLINE2(N);
    STEP0_INLINE3(N);
    STEP0_INLINE4(N);
    STEP0_INLINE5(N);
    STEP0_INLINE6(N);
    STEP0_INLINE7(N);
    STEP0_INLINE8(N);
    STEP0_INLINE9(N);
    STEP0_INLINE10(N);
  END_STEP

  ACTION STEP0_INLINE1:
    conveyor_1 := FALSE;
  END_ACTION

  ACTION STEP0_INLINE2:
    conveyor_2 := FALSE;
  END_ACTION

  ACTION STEP0_INLINE3:
    conveyor_3 := FALSE;
  END_ACTION

  ACTION STEP0_INLINE4:
    conveyor_4 := FALSE;
  END_ACTION

  ACTION STEP0_INLINE5:
    process_station1 := FALSE;
  END_ACTION

  ACTION STEP0_INLINE6:
    process_station2 := FALSE;
  END_ACTION

  ACTION STEP0_INLINE7:
    transfer1_out := FALSE;
  END_ACTION

  ACTION STEP0_INLINE8:
    transfer1_back := FALSE;
  END_ACTION

  ACTION STEP0_INLINE9:
    transfer2_out := FALSE;
  END_ACTION

  ACTION STEP0_INLINE10:
    transfer2_back := FALSE;
  END_ACTION

  TRANSITION FROM Step0 TO Step1
    := start_button;
  END_TRANSITION

  STEP Step1:
    STEP1_INLINE27(N);
  END_STEP

  ACTION STEP1_INLINE27:
    conveyor_1:= TRUE;
  END_ACTION

  TRANSITION FROM Step1 TO Step2
    := sensor_2;
  END_TRANSITION

  STEP Step2:
    STEP2_INLINE16(N);
  END_STEP

  ACTION STEP2_INLINE16:
    conveyor_1:= FALSE;
  END_ACTION

  TRANSITION FROM Step2 TO Step3
    := TRUE;
  END_TRANSITION

  STEP Step3:
    STEP3_INLINE21(N);
    STEP3_INLINE22(N);
  END_STEP

  ACTION STEP3_INLINE21:
    transfer1_out := TRUE;
  END_ACTION

  ACTION STEP3_INLINE22:
    transfer1_back := FALSE;
  END_ACTION

  TRANSITION FROM Step3 TO Step4
    := transfer1_sensor_end;
  END_TRANSITION

  STEP Step4:
    STEP4_INLINE23(N);
    STEP4_INLINE24(N);
  END_STEP

  ACTION STEP4_INLINE23:
    transfer1_out := FALSE;
  END_ACTION

  ACTION STEP4_INLINE24:
    transfer1_back := TRUE;
  END_ACTION

  TRANSITION FROM Step4 TO Step5
    := transfer1_sensor_home;
  END_TRANSITION

  STEP Step5:
    STEP5_INLINE25(N);
    STEP5_INLINE26(N);
  END_STEP

  ACTION STEP5_INLINE25:
    transfer1_back := FALSE;
  END_ACTION

  ACTION STEP5_INLINE26:
    conveyor_2 := TRUE;
  END_ACTION

  TRANSITION FROM Step5 TO Step6
    := sensor_3;
  END_TRANSITION

  STEP Step6:
    STEP6_INLINE11(N);
    STEP6_INLINE12(N);
  END_STEP

  ACTION STEP6_INLINE11:
    conveyor_2 := FALSE;
  END_ACTION

  ACTION STEP6_INLINE12:
    process_station1 := TRUE;
  END_ACTION

  TRANSITION FROM Step6 TO Step7
    := Step6.T > T#2s;
  END_TRANSITION

  STEP Step7:
    STEP7_INLINE13(N);
    STEP7_INLINE14(N);
    STEP7_INLINE15(N);
  END_STEP

  ACTION STEP7_INLINE13:
    process_station1 := FALSE;
  END_ACTION

  ACTION STEP7_INLINE14:
    transfer2_out := TRUE;
  END_ACTION

  ACTION STEP7_INLINE15:
    transfer2_back := FALSE;
  END_ACTION

  TRANSITION FROM Step7 TO Step8
    := transfer2_sensor_end;
  END_TRANSITION

  STEP Step8:
    STEP8_INLINE28(N);
    STEP8_INLINE29(N);
  END_STEP

  ACTION STEP8_INLINE28:
    transfer2_out := FALSE;
  END_ACTION

  ACTION STEP8_INLINE29:
    transfer2_back := TRUE;
  END_ACTION

  TRANSITION FROM Step8 TO Step9
    := transfer2_sensor_home;
  END_TRANSITION

  STEP Step9:
    STEP9_INLINE17(N);
    STEP9_INLINE18(N);
  END_STEP

  ACTION STEP9_INLINE17:
    conveyor_3 := TRUE;
  END_ACTION

  ACTION STEP9_INLINE18:
    transfer2_back := FALSE; 
  END_ACTION

  TRANSITION FROM Step9 TO Step10
    := sensor_4;
  END_TRANSITION

  STEP Step10:
    STEP10_INLINE19(N);
    STEP10_INLINE20(N);
  END_STEP

  ACTION STEP10_INLINE19:
    conveyor_3 := FALSE;
  END_ACTION

  ACTION STEP10_INLINE20:
    process_station2 := TRUE;
  END_ACTION

  TRANSITION FROM Step10 TO Step11
    := Step10.T > T#2s;
  END_TRANSITION

  STEP Step11:
    STEP11_INLINE30(N);
    STEP11_INLINE31(N);
  END_STEP

  ACTION STEP11_INLINE30:
    conveyor_4 := TRUE;
  END_ACTION

  ACTION STEP11_INLINE31:
    process_station2 := FALSE;
  END_ACTION

  TRANSITION FROM Step11 TO Step1
    := sensor_5;
  END_TRANSITION

END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : E9;
  END_RESOURCE
END_CONFIGURATION
