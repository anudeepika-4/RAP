"! Unit tests for ZCLASS_1 (sales order report)
CLASS ltc_sales_order_test DEFINITION FINAL
  FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT.

  PRIVATE SECTION.
    TYPES tt_rows TYPE zclass_1=>tt_rows.

    CONSTANTS c_today TYPE d VALUE '20260115'.

    DATA mo_cut TYPE REF TO zclass_1.

    METHODS setup.

    METHODS recent_today        FOR TESTING.
    METHODS recent_edge_7       FOR TESTING.
    METHODS recent_future       FOR TESTING.
    METHODS not_recent_8        FOR TESTING.
    METHODS icon_green          FOR TESTING.
    METHODS icon_grey           FOR TESTING.
    METHODS header_open         FOR TESTING.
    METHODS header_completed    FOR TESTING.
    METHODS header_delivered    FOR TESTING.
    METHODS header_blank        FOR TESTING.
    METHODS item_open           FOR TESTING.
    METHODS item_blocked        FOR TESTING.
    METHODS sales_org_valid     FOR TESTING.
    METHODS sales_org_empty     FOR TESTING.
    METHODS max_rows_cut        FOR TESTING.
    METHODS max_rows_keep       FOR TESTING.
    METHODS post_process_recent FOR TESTING.
    METHODS post_process_old    FOR TESTING.
    METHODS get_data_header     FOR TESTING.
    METHODS get_data_item       FOR TESTING.
ENDCLASS.


CLASS ltc_sales_order_test IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW #( ).
  ENDMETHOD.


  METHOD recent_today.
    cl_abap_unit_assert=>assert_true(
      act = mo_cut->is_recent( iv_date = c_today iv_today = c_today )
      msg = 'Today should be recent' ).
  ENDMETHOD.


  METHOD recent_edge_7.
    cl_abap_unit_assert=>assert_true(
      act = mo_cut->is_recent( iv_date = CONV d( c_today - 7 ) iv_today = c_today )
      msg = 'Exactly 7 days ago should be recent' ).
  ENDMETHOD.


  METHOD recent_future.
    cl_abap_unit_assert=>assert_true(
      act = mo_cut->is_recent( iv_date = CONV d( c_today + 1 ) iv_today = c_today )
      msg = 'Future date should be recent' ).
  ENDMETHOD.


  METHOD not_recent_8.
    cl_abap_unit_assert=>assert_false(
      act = mo_cut->is_recent( iv_date = CONV d( c_today - 8 ) iv_today = c_today )
      msg = '8 days ago should not be recent' ).
  ENDMETHOD.


  METHOD icon_green.
    cl_abap_unit_assert=>assert_equals(
      act = mo_cut->recent_icon( abap_true )
      exp = zclass_1=>c_icon_green
      msg = 'Recent icon should be green' ).
  ENDMETHOD.


  METHOD icon_grey.
    cl_abap_unit_assert=>assert_equals(
      act = mo_cut->recent_icon( abap_false )
      exp = zclass_1=>c_icon_grey
      msg = 'Non-recent icon should be grey' ).
  ENDMETHOD.


  METHOD header_open.
    cl_abap_unit_assert=>assert_true(
      act = mo_cut->is_header_open( iv_overall = 'A' iv_delivery = 'A' iv_billing = 'A' )
      msg = 'Header with status A should be open' ).
  ENDMETHOD.


  METHOD header_completed.
    cl_abap_unit_assert=>assert_false(
      act = mo_cut->is_header_open( iv_overall = 'C' iv_delivery = 'A' iv_billing = 'A' )
      msg = 'Completed header should not be open' ).
  ENDMETHOD.


  METHOD header_delivered.
    cl_abap_unit_assert=>assert_false(
      act = mo_cut->is_header_open( iv_overall = 'A' iv_delivery = 'C' iv_billing = 'A' )
      msg = 'Fully delivered header should not be open' ).
  ENDMETHOD.


  METHOD header_blank.
    cl_abap_unit_assert=>assert_true(
      act = mo_cut->is_header_open( iv_overall = space iv_delivery = space iv_billing = space )
      msg = 'Header with blank status should be open' ).
  ENDMETHOD.


  METHOD item_open.
    cl_abap_unit_assert=>assert_true(
      act = mo_cut->is_item_open( space )
      msg = 'Item without billing block should be open' ).
  ENDMETHOD.


  METHOD item_blocked.
    cl_abap_unit_assert=>assert_false(
      act = mo_cut->is_item_open( '01' )
      msg = 'Item with billing block should not be open' ).
  ENDMETHOD.


  METHOD sales_org_valid.
    cl_abap_unit_assert=>assert_true(
      act = mo_cut->is_valid_sales_org( '1010' )
      msg = 'Sales Org 1010 should be valid' ).
  ENDMETHOD.


  METHOD sales_org_empty.
    cl_abap_unit_assert=>assert_false(
      act = mo_cut->is_valid_sales_org( space )
      msg = 'Empty Sales Org should not be valid' ).
  ENDMETHOD.


  METHOD max_rows_cut.
    DATA(lt_rows) = VALUE tt_rows( ( vbeln = '1' ) ( vbeln = '2' ) ( vbeln = '3' )
                                   ( vbeln = '4' ) ( vbeln = '5' ) ).

    mo_cut->apply_max_rows( EXPORTING iv_max = 3 CHANGING ct_rows = lt_rows ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_rows )
      exp = 3
      msg = '5 rows capped at 3 should leave 3' ).
  ENDMETHOD.


  METHOD max_rows_keep.
    DATA(lt_rows) = VALUE tt_rows( ( vbeln = '1' ) ( vbeln = '2' ) ).

    mo_cut->apply_max_rows( EXPORTING iv_max = 5 CHANGING ct_rows = lt_rows ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_rows )
      exp = 2
      msg = '2 rows with max 5 should stay 2' ).
  ENDMETHOD.


  METHOD post_process_recent.
    DATA(lt_rows) = VALUE tt_rows( ( vbeln = '1' erdat = c_today ) ).

    mo_cut->post_process( EXPORTING iv_today = c_today CHANGING ct_rows = lt_rows ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_rows[ 1 ]-iconrec
      exp = zclass_1=>c_icon_green
      msg = 'Row created today should get the green icon' ).
  ENDMETHOD.


  METHOD post_process_old.
    DATA(lt_rows) = VALUE tt_rows( ( vbeln = '1' erdat = CONV d( c_today - 10 ) ) ).

    mo_cut->post_process( EXPORTING iv_today = c_today CHANGING ct_rows = lt_rows ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_rows[ 1 ]-iconrec
      exp = zclass_1=>c_icon_grey
      msg = 'Row older than 7 days should get the grey icon' ).
  ENDMETHOD.


  METHOD get_data_header.
    DATA(lt_rows) = mo_cut->get_data( iv_sales_org = '1010'
                                      iv_date_from = CONV d( c_today - 30 )
                                      iv_date_to   = c_today
                                      iv_mode      = zclass_1=>c_mode_header ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_rows )
      exp = 3
      msg = 'Header mode should return 3 open rows' ).
  ENDMETHOD.


  METHOD get_data_item.
    DATA(lt_rows) = mo_cut->get_data( iv_sales_org = '1010'
                                      iv_date_from = CONV d( c_today - 30 )
                                      iv_date_to   = c_today
                                      iv_mode      = zclass_1=>c_mode_item ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_rows )
      exp = 2
      msg = 'Item mode should return 2 open rows' ).
  ENDMETHOD.

ENDCLASS.