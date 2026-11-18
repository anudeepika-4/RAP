  METHOD apply_max_rows.
    IF iv_max > 0 AND lines( ct_rows ) > iv_max.
      DATA(lv_first_to_delete) = iv_max + 1.
      DELETE ct_rows FROM lv_first_to_delete.
    ENDIF.
  ENDMETHOD.