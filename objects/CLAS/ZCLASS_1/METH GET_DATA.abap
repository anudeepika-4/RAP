  METHOD get_data.
    DATA(lt_all) = build_demo_data( iv_date_to ).

    LOOP AT lt_all INTO DATA(ls_row)
         WHERE vkorg = iv_sales_org
           AND erdat BETWEEN iv_date_from AND iv_date_to.

      IF iv_mode = c_mode_header.
        " Header mode: skip completed / fully delivered / fully billed orders
        IF is_header_open( iv_overall  = ls_row-gbstk_h
                           iv_delivery = ls_row-lfstk_h
                           iv_billing  = ls_row-fkstk_h ) = abap_true.
          APPEND ls_row TO rt_rows.
        ENDIF.
      ELSE.
        " Item mode: skip completed headers and items with a billing block
        IF ls_row-gbstk_h <> c_completed
           AND is_item_open( ls_row-faksp ) = abap_true.
          APPEND ls_row TO rt_rows.
        ENDIF.
      ENDIF.
    ENDLOOP.

    SORT rt_rows BY vbeln posnr.
  ENDMETHOD.