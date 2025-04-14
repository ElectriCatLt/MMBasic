' Navigator 0415F
' target system PICOMITE HDMI/USB/2350A
' version 0.1
' please feed and help stray cats if you found this program usefull
' navigator.bas
' (C) 2025 Electricat =(^^)=
' Licensed under the GPLv3  =(^^)= 

'navigator ' this must be commented or deleted before LIBRARY SAVE
Sub navigator
Font 1
Dim nav_is_dir
Dim nav_is_file
Dim nav_page=0
Dim nav_more_pages=0

Dim yof=3 ' vertical offset
Dim nav_max_idx,nav_max_db_idx,nav_min_idx,nav_pos,pkey
nav_max_idx=MM.VRES/MM.Info(fontheight)
Dim nav_new_fname$,nav_fname$,nav_dir$
Dim nav_path$
Dim navtmp_str$
Dim nav_sub_idx,nav_max_sub_idx,nav_min_sub_idx
Dim nav_rec_idx,nav_path_len
Dim nav_flag_exit
Dim nav_dirct$(33) length 60
Dim nav_col_v=MM.VRES/MM.Info(fontheight)
Dim  nav_scr_w=MM.HRES
Dim nav_scr_h=MM.VRES
Dim nav_font_w=MM.Info(fontwidth)
Dim  nav_font_h=MM.Info(fontheight)
Dim nav_root$="B:"
Dim nav_level=0
Dim nav_record(255) As integer
Dim nav_idx
Dim nav_time_flag,nav_advert_flag,nav_esc_flag
Dim nav_text$ As string
Dim nav_selected(nav_max_idx)
Dim nav_source_dir$(nav_max_idx)
Local nav_aa%=Peek(varaddr nav_dirct$())
Local  nav_tmp_dir$,nav_time_stamp$,nav_tmp_str$
Local nav_chk
Local nav_step,nav_len,nav_x,nav_y,nav_wdth,nav_end_scrool_p
Local nav_ad_x=MM.HRES-19*MM.Info(fontwidth)
Local nav_time_x=MM.HRES-13*MM.Info(fontwidth)
Local nav_fname_x=nav_scr_w-18*nav_font_w
Local nav_cursor_x=nav_scr_w-19*nav_font_w'-3
Local nav_dlg_x = nav_scr_w-27*nav_font_w
Local nav_dlg_y= nav_font_h*5
Local nav_dlg_l=25*nav_font_w
Local nav_dlg_h=nav_font_h*4
Local nav_subm_x=nav_scr_w-21*nav_font_w
Local nav_subm_cursor_x=nav_scr_w-23*nav_font_w
Local nav_subm_spaces_x=nav_scr_w-22*nav_font_w
Local nav_subm_spaces_y=(14+yof)*nav_font_h
Local nav_dlg_esc_x=nav_scr_w-8*nav_font_w
Local nav_object_is,nav_start_pos As integer
nav_record(0)=2
Local nav_at_x=MM.HRES-(27*MM.Info(fontwidth))
Local nav_scr_h=MM.VRES
Local nav_at_y=MM.Info(fontheight)*5
Local nav_bl=25*MM.Info(fontwidth)
Local nav_bh=MM.Info(fontheight)*4
Local nav_sym_w=MM.Info(fontwidth)
Local nav_sym_h=MM.Info(fontheight)
Local nav_drv_B$

Dim  ship_x=0
Dim  ship_y=nav_font_h*25
Dim  ship2_x=0
Dim  ship2_y=nav_font_h*15

ship_acceleration=Rnd()*0.01
Dim  ship_speed=Rnd()*0.25
Dim ship_type=1
nav_ship_move_allowed =1
aship=51
max_ship_x=MM.HRES-(21*nav_font_w)

nav_prepare_space()

SetTick 20, rise_20ms_flag
SetTick 100, rise_100ms_flag,2
SetTick 5, rise_5ms_flag,3

MODE 3
nav_chk_disk()

Do 'INIT LOOP
stars_will_born
ships_will_move
 Memory set byte nav_aa%,0,(Bound(nav_dirct$(),1)+1)*60
 Font 1
 Color RGB(white),RGB(blue)
 RBox nav_scr_w-20*nav_font_w+3,MM.Info(fontheight)*2+2,19*nav_font_w,MM.Info(fontheight)*36+1,9,RGB(white)

 RBox nav_scr_w-20*nav_font_w,MM.Info(fontheight)*2,19*nav_font_w,MM.Info(fontheight)*36,9,RGB(white),RGB(blue)
 nav_idx=1

read_files_dirs()
print_files_dirs()
nav_max_db_idx=nav_idx
If nav_clipboard=0 Then
For nav_erase=0 To nav_max_idx
nav_selected(nav_erase)=0
nav_source_dir$(nav_erase)=""
Next nav_erase
Else
    Font 7
    Color RGB(green),RGB(blue)
    Print @(nav_ad_x+(nav_font_w*16),nav_font_h*(yof-1)+3) "c*"
    Color RGB(white),RGB(blue)
    Font 1

End If

 If nav_level=0 Then
 nav_min_idx=1
 Else
 nav_min_idx=0
 End If

nav_idx=nav_record(nav_level)
If nav_idx > nav_max_db_idx Then
nav_idx=nav_max_db_idx
End If
Print @(nav_cursor_x,(nav_idx+yof)*nav_font_h) ">"
nav_pos=2

Do ' NAVIGATION LOOP
stars_will_born
ships_will_move


advertising(nav_ad_x,nav_time_x)
pkey=KeyDown(1)
modkey=KeyDown(7)

If pkey=132 Then ' insert/select
If  nav_clipboard=1 Then
 Font 7
  Color RGB(white),RGB(blue)
   Print @(nav_ad_x+(nav_font_w*16),nav_font_h*(yof-1)+3) "  "

For nav_erase=0 To nav_max_idx
If nav_selected(nav_erase)<>0 Then
Print @(nav_cursor_x-nav_font_w+3,(nav_erase+yof+1)*nav_font_h+2) " ";
nav_selected(nav_erase)=0
nav_source_dir$(nav_erase)=""

End If
Next nav_erase

nav_clipboard=0
End If

Font 7
Color RGB(white),RGB(blue)
For nav_erase=0 To nav_max_idx
If nav_selected(nav_erase)<>0 Then
Print @(nav_cursor_x-nav_font_w+3,(nav_erase+yof+1)*nav_font_h+2) "*";
End If
Next nav_erase

 nav_dir$=nav_dirct$(nav_idx-1)
 nav_object_is=nav_iis_file_or_dir(nav_dir$)
 If nav_object_is=1 Then

Select Case nav_selected(nav_idx-1)

Case 0
nav_pause_me(100)
pkey=129
Case is<>0
nav_pause_me(100)
pkey=129
End Select
Font 1
End If

 If nav_object_is=2 Then

Select Case nav_selected(nav_idx-1)

Case 0
Font 7
Print @(nav_cursor_x-nav_font_w+3,(nav_idx+yof)*nav_font_h+2) "*";
nav_selected(nav_idx-1)=nav_idx-1
Font 1
nav_pause_me(100)
pkey=129
Case is<>0
Font 7
Print @(nav_cursor_x-nav_font_w+3,(nav_idx+yof)*nav_font_h+2) " ";
nav_selected(nav_idx-1)=0
Font 1
nav_pause_me(100)
pkey=129
End Select
End If
 If nav_object_is=0 Then

Select Case nav_selected(nav_idx-1)

Case 0
Font 7
Color RGB(red),RGB(blue)
Print @(nav_cursor_x-nav_font_w+3,(nav_idx+yof)*nav_font_h+2) "!";
Font 1
nav_pause_me(100)
pkey=129
Case is<>0
Font 7
Print @(nav_cursor_x-nav_font_w+3,(nav_idx+yof)*nav_font_h+2) " ";
Font 1
nav_pause_me(100)
pkey=129
End Select
End If

End If
If pkey=157 Then 'PrntScr
nav_new_fname$="Scr"+Date$+Time$+".bmp"
nav_new_fname$=nav_format_time_stamp(nav_new_fname$)
If Len(Cwd$)+Len(nav_new_fname$) >63 Then
 nav_dlg_box_error(nav_at_x,nav_at_y,nav_bl,nav_bh,nav_sym_w,nav_sym_h,"Error:","","Path exceeds 64 chr!")
Else
Save image nav_new_fname$
End If
 nav_object_is=nav_iis_file_or_dir(nav_new_fname$)
 If nav_object_is=2 Then
 nav_dlg_box_error(nav_at_x,nav_at_y,nav_bl,nav_bh,nav_sym_w,nav_sym_h,"Saved:","","Screen saved")
 Else
  If nav_object_is=0 Then
   nav_dlg_box_error(nav_at_x,nav_at_y,nav_bl,nav_bh,nav_sym_w,nav_sym_h,"Error:","","Drive problem?")
  End If
 End If
    nav_flag_exit=1
End If

If pkey=9 Then ' TAB
 nav_swap_disk
    nav_pause_me(200)
    nav_flag_exit=1
End If

If pkey=149 Then 'F5

  Select Case nav_clipboard
    Case 1
    Font 7
    Color RGB(white),RGB(blue)
    For nav_erase=0 To nav_max_idx
    If nav_selected(nav_erase)<>0 Then
      nav_fname$=nav_source_dir$(nav_erase)
      nav_file_to_copy$=Cwd$+nav_get_fname(nav_fname$)
      Copy nav_source_dir$(nav_erase) To nav_file_to_copy$
    End If
    Next nav_erase
    nav_clipboard=1
    nav_flag_exit=1
    pkey=0
    nav_pause_me(200)

    Case 0
    Font 7
    Color RGB(green),RGB(blue)
    Print @(nav_ad_x+(nav_font_w*16),nav_font_h*(yof-1)+3) "c*"

    For nav_erase=0 To nav_max_idx
    If nav_selected(nav_erase)<>0 Then
      Print @(nav_cursor_x-nav_font_w+3,(nav_erase+yof+1)*nav_font_h+2) "*";
    nav_source_dir$(nav_erase)=Cwd$+"/"+nav_dirct$(nav_erase)
    End If
    Next nav_erase
    Color RGB(white),RGB(blue)
    Font 1
    nav_clipboard=1
    pkey=0
    nav_pause_me(200)
  End Select

End If

If (modkey=2 Or modkey=3) And pkey=134 Then' c=99,67 v=118,86
nav_page=0
nav_idx=0+yof
nav_flag_exit=1
nav_time_flag=20
End If

If (modkey=10 Or modkey=160) And pkey=134 Then' c=99,67 v=118,86
'End
nav_path$=""
Chdir nav_root$
nav_level=0
nav_page=0
nav_idx=0+yof
nav_flag_exit=1
End If

If pkey=150 Then  'F6 /full rename
 nav_dir$=nav_dirct$(nav_idx-1)
 nav_object_is=nav_iis_file_or_dir(nav_dir$)
 If nav_object_is=1 And nav_dir$<>".." Then ' 1 is dir, 2 is file , 0 - does not exists
  nav_fname$=nav_dlg_box_e(nav_dlg_x,nav_dlg_y,nav_dlg_l,nav_dlg_h,nav_font_w,nav_font_h,"Rename directory:","Name conflict!",nav_dir$)
   If nav_fname$<>"" Then
   nav_new_fname$=nav_root$+"\"+nav_path$+"\"+nav_fname$
   Rename nav_dir$ As nav_new_fname$
   nav_flag_exit=1
   nav_new_fname$=""
   End If
 End If

 If nav_object_is=2 Then ' file
  nav_tmp_dir$ = nav_dir$
  nav_tmp_str$ = nav_get_extension(nav_dir$)
  nav_fname$=nav_dlg_box_e(nav_dlg_x,nav_dlg_y,nav_dlg_l,nav_dlg_h,nav_font_w,nav_font_h,"Rename file:","Name conflict!",nav_tmp_dir$)
   If nav_fname$<>"" Then
   nav_new_fname$=nav_root$+"\"+nav_path$+"\"+nav_fname$
nav_object_is=nav_iis_file_or_dir(nav_new_fname$)
If nav_object_is<>2 Then
  Rename nav_dir$ As nav_new_fname$
    Else
  nav_dlg_box_error(nav_at_x,nav_at_y,nav_bl,nav_bh,nav_sym_w,nav_sym_h,"Problem:","System limit!","FILE name exists!")

 End If
   nav_flag_exit=1
   nav_new_fname$=""
   End If
 End If

End If

If pkey=151 Then  'F7 / make dir
nav_fname$=nav_dlg_box_e(nav_dlg_x,nav_dlg_y,nav_dlg_l,nav_dlg_h,nav_font_w,nav_font_h,"Make new directory:","Directory exists!","New")
 If nav_fname$<>"" Then
 nav_new_fname$=nav_root$+"\"+nav_path$+"\"+nav_fname$
 nav_object_is=nav_iis_file_or_dir(nav_new_fname$)
If nav_object_is<>1 Then
If Len(Cwd$)+Len(nav_new_fname$) >63 Then
 nav_dlg_box_error(nav_at_x,nav_at_y,nav_bl,nav_bh,nav_sym_w,nav_sym_h,"Error:","","Path exceeds 64 chr!")
Else

 Mkdir nav_new_fname$
 nav_flag_exit=1
 nav_new_fname$=""
 End If

    Else
  nav_dlg_box_error(nav_at_x,nav_at_y,nav_bl,nav_bh,nav_sym_w,nav_sym_h,"Problem:","System limit!","DIR name exists!")

 End If

 End If
End If

If pkey=152 Then  'F8 /delete
nav_delete
End If

If pkey=147 Then  'F3 /view
nav_dir$=nav_dirct$(nav_idx-1)
nav_object_is=nav_iis_file_or_dir(nav_dir$)
 If nav_dir$<>".." And nav_object_is=2 Then
 Color RGB(brown),RGB(black)
 CLS
 wiev_file(nav_font_h,nav_dir$)
 Color RGB(white),RGB(blue)
 End If
 If nav_object_is=0 Then
nav_dlg_box_error(nav_at_x,nav_at_y,nav_bl,nav_bh,nav_sym_w,nav_sym_h,"Problem:","System limit!","Too long path/name")
End If

End If

'down
If pkey=129 Or pkey = 137 Or pkey=135 Then

 Select Case pkey
 Case 129
 nav_step=1
 Case 137
 nav_step=5
 Case 135
 nav_step=nav_max_idx
 End Select

If Len(nav_dirct$(nav_idx))>16 Then
 nav_time_flag=20
 Print @(nav_fname_x,(nav_idx+yof)*nav_font_h) Mid$(nav_dirct$(nav_idx-1),1,14);
  If Len(nav_dirct$(nav_idx-1))>14 Then
  Print "~";
  End If
Else
 nav_time_flag=20

 Print @(nav_fname_x,(nav_idx+yof)*nav_font_h) Mid$(nav_dirct$(nav_idx-1),1,14);
  If Len(nav_dirct$(nav_idx-1))>14 Then
  Print "~";
  End If
End If

Print @(nav_cursor_x,(nav_idx+yof)*nav_font_h) " ";
Inc nav_idx,nav_step
nav_record(nav_level)=nav_idx
 If nav_idx>=nav_max_idx Or nav_idx>=nav_max_db_idx+1 Then
  If nav_max_db_idx > nav_max_idx Then
  nav_max_db_idx=nav_max_idx-1
  End If
 nav_idx=nav_max_db_idx
 nav_record(nav_level)=nav_idx
 End If
Print @(nav_cursor_x,(nav_idx+yof)*nav_font_h) ">";
nav_is_file=nav_iis_file_or_dir(nav_dirct$(nav_idx-1))
Color RGB(white),RGB(blue)
nav_pause_me(150)
End If

'up
If pkey=128 Or pkey=136 Or pkey=134 Then
 Select Case pkey
 Case 128
 nav_step=1
 Case 136
 nav_step=5
 Case 134
 nav_step=nav_max_idx
 End Select


If Len(nav_dirct$(nav_idx))>16 Then
 nav_time_flag=20
 Print @(nav_fname_x,(nav_idx+yof)*nav_font_h) Mid$(nav_dirct$(nav_idx-1),1,14);
 If Len(nav_dirct$(nav_idx-1))>14 Then
 Print "~";
 End If
Else
 nav_time_flag=20
 Print @(nav_fname_x,(nav_idx+yof)*nav_font_h) Mid$(nav_dirct$(nav_idx-1),1,14);
 If Len(nav_dirct$(nav_idx-1))>14 Then
 Print "~";
 End If
End If

Print @(nav_cursor_x,(nav_idx+yof)*nav_font_h) " ";
Inc nav_idx,0-nav_step
nav_record(nav_level)=nav_idx
 If nav_idx<=nav_min_idx Then
  If nav_level=0 Then
  nav_idx=2
  Else
  nav_idx=1
  End If
 nav_record(nav_level)=nav_idx
 End If
Print @(nav_cursor_x,(nav_idx+yof)*nav_font_h) ">";
nav_is_file=nav_iis_file_or_dir(nav_dirct$(nav_idx-1))
nav_pause_me(150)
End If

'page back left
If pkey = 130 Then
If nav_page>=1 Then
Inc nav_page,-1
nav_flag_exit=1
nav_time_flag=20
End If

End If
'page next right
If pkey=131 Then
If nav_more_pages=1 Then
Inc nav_page
nav_flag_exit=1
nav_time_flag=20
End If
End If

If pkey=146 Then ' F2 EDITOR nSave
nav_new_fname$="Pr_v"
nav_new_fname$=nav_format_time_stamp(nav_new_fname$)

  nav_fname$=nav_dlg_box_e(nav_dlg_x,nav_dlg_y,nav_dlg_l,nav_dlg_h,nav_font_w,nav_font_h,"Name EDIT file:","Name conflict!",nav_new_fname$)
   If nav_fname$<>"" Then
   nav_new_fname$=nav_root$+"\"+nav_path$+"\"+nav_fname$+".bas"
Save nav_new_fname$
nav_flag_exit=1
nav_time_flag=20

pkey=0
nav_pause_me(300)
Exit Do
End If
End If




If pkey=145 Then ' F1 quicksave
nav_new_fname$="Edit_tmp"+Date$+Time$+".bas"
nav_new_fname$=nav_format_time_stamp(nav_new_fname$)
Save nav_new_fname$
pkey=0
nav_pause_me(300)
Exit Do
End If

If pkey=10 Then 'enter / file&dir actions
 nav_dir$=nav_dirct$(nav_idx-1)
 nav_object_is=nav_iis_file_or_dir(nav_dir$)
If nav_object_is=0 Then
nav_dlg_box_error(nav_at_x,nav_at_y,nav_bl,nav_bh,nav_sym_w,nav_sym_h,"Problem:","System limit!","Drive B: not ready")
End If
If nav_object_is=1 Then
  If nav_dir$<>".." Then
  nav_path$=nav_path$+"\"+nav_dir$
  Chdir nav_root$+nav_path$
  nav_record(nav_level)=nav_idx
  Inc nav_level
  nav_idx=1
  nav_record(nav_level)=nav_idx
  Else
  nav_path_len=Len(nav_path$)
   If Instr(nav_path$,"\")=0 Then
   Exit Do
   End If

   Do
stars_will_born
ships_will_move
   nav_pos=Instr(nav_path_len,nav_path$,"\")
    If nav_pos<>0 Then
    Exit Do
    End If
   Inc  nav_path_len,-1
   Loop
   If nav_path_len>0 Then
   nav_path$=Left$(nav_path$,nav_path_len-1)
   Chdir nav_root$+nav_path$
   Inc nav_level,-1
   Inc nav_rec_idx,-1
   End If
  End If
nav_pause_me(200)
   Exit Do
 End If

pkey=0
nav_pause_me(300)

 If nav_object_is=2 Then
  nav_start_pos=1
Sprite read #1,nav_scr_w-24*nav_font_w-2,nav_dlg_y-2,19*nav_font_w+4,nav_font_h*13+4
  RBox nav_scr_w-24*nav_font_w+2,nav_dlg_y+2,19*nav_font_w,nav_font_h*13,9,RGB(yellow)
  RBox nav_scr_w-24*nav_font_w,nav_dlg_y,19*nav_font_w,nav_font_h*13,9,RGB(white),RGB(blue)
  Font 7
  Color RGB(yellow),RGB(blue)
  Print @(nav_dlg_esc_x-3,nav_dlg_y+2) "esc*"    '1
  Color RGB(white),RGB(blue)
  Font 1
  nav_sub_idx=6
  nav_max_sub_idx=13
  nav_min_sub_idx=5

  Print @(nav_subm_x,nav_font_h*(nav_sub_idx)) "EDITOR qSave"   '4
  Print @(nav_subm_x,nav_font_h*(nav_sub_idx+1)) "EDITOR nSave"   '6
  Print @(nav_subm_x,nav_font_h*(nav_sub_idx+2)) "Rename As"   '3
  Print @(nav_subm_x,nav_font_h*(nav_sub_idx+3)) "Backup As"    '1
  Print @(nav_subm_x,nav_font_h*(nav_sub_idx+4)) "View As TXT"'5
  Print @(nav_subm_x,nav_font_h*(nav_sub_idx+5)) "Load & RUN"   '2
  Color RGB(red),RGB(blue)
  Print @(nav_subm_x,nav_font_h*(nav_sub_idx+6)) "Delete" '7
  Color RGB(grey),RGB(blue)
  Print @(nav_subm_x,nav_font_h*(nav_sub_idx+7)) "View As HEX"'5
  Color RGB(white),RGB(blue)

  Print @(nav_subm_cursor_x,(nav_sub_idx)*nav_font_h) ">";
  nav_time_flag=20
  nav_text$=nav_get_help_line(nav_sub_idx-6)
Font 7
nav_fsize=MM.Info(filesize nav_dir$)
If nav_fsize>1024 Then
nav_fsize=Fix(nav_fsize/1024)
nav_modified$=MM.Info(modified nav_dir$)
  Print @(nav_subm_spaces_x,nav_font_h*(nav_sub_idx+9))  nav_fsize " Kb";
  Print @(nav_subm_spaces_x,nav_font_h*(nav_sub_idx+10)) nav_modified$;
Else
     Print @(nav_subm_spaces_x,nav_font_h*(nav_sub_idx+9)) "File: " nav_fsize " b"
End If
pkey=KeyDown(1)
 Do
stars_will_born
ships_will_move
  nav_print_time(nav_ad_x,nav_time_x)
  If pkey=10 Then
   Select Case nav_sub_idx-5
    Case 1 ' "EDITOR qSave"   '1
    nav_tmp_dir$=nav_trim_extension(nav_dir$,1)
    nav_time_stamp$=nav_format_time_stamp(Date$+"_"+Time$)
    nav_new_fname$=nav_tmp_dir$+"_"+nav_time_stamp$+".bas"
nav_object_is=nav_iis_file_or_dir(nav_new_fname$)
If nav_object_is<>2 Then
    Save nav_new_fname$
    nav_flag_exit=1

    Else
  nav_dlg_box_error(nav_at_x,nav_at_y,nav_bl,nav_bh,nav_sym_w,nav_sym_h,"Problem:","System limit!","FILE name exists!")

 End If

    Case 2 '"EDITOR nSave"   '6
    nav_tmp_str$=nav_get_extension(nav_dir$)
    nav_tmp_dir$=nav_trim_extension(nav_dir$,1)
    nav_fname$=nav_dlg_box_e(nav_dlg_x,nav_dlg_y,nav_dlg_l,nav_dlg_h,nav_font_w,nav_font_h,"Rename file:","Name conflict!",nav_tmp_dir$)
    If nav_fname$<>"" Then
    nav_new_fname$=nav_fname$+".bas"
nav_object_is=nav_iis_file_or_dir(nav_new_fname$)
    If nav_object_is<>2 Then
   Save nav_new_fname$
    nav_flag_exit=1

    Else
  nav_dlg_box_error(nav_at_x,nav_at_y,nav_bl,nav_bh,nav_sym_w,nav_sym_h,"Problem:","System limit!","FILE name exists!")

 End If

    End If

    Case 3 '"Rename As"   '3
    nav_tmp_str$=nav_get_extension(nav_dir$)
    nav_tmp_dir$ = nav_trim_extension(nav_dir$)
    nav_fname$=nav_dlg_box_e(nav_dlg_x,nav_dlg_y,nav_dlg_l,nav_dlg_h,nav_font_w,nav_font_h,"Rename file:","Name conflict!",nav_tmp_dir$)
    If nav_fname$<>"" Then
    nav_new_fname$=nav_root$+"\"+nav_path$+"\"+nav_fname$+nav_tmp_str$
nav_object_is=nav_iis_file_or_dir(nav_new_fname$)
    If nav_object_is<>2 Then
    Rename nav_dir$ As nav_new_fname$
    nav_flag_exit=1
    nav_new_fname$=""

    Else
  nav_dlg_box_error(nav_at_x,nav_at_y,nav_bl,nav_bh,nav_sym_w,nav_sym_h,"Problem:","System limit!","FILE name exists!")

 End If

    End If

            Case 4 ' "Backup As"    '4
            nav_tmp_str$=nav_get_extension(nav_dir$)
   nav_tmp_dir$=nav_trim_extension(nav_dir$)
   nav_fname$=nav_dlg_box_e(nav_dlg_x,nav_dlg_y,nav_dlg_l,nav_dlg_h,nav_font_w,nav_font_h,"Rename file:","Name conflict!",nav_tmp_dir$)
            If nav_fname$<>"" Then
            nav_new_fname$=nav_fname$+nav_tmp_str$+".bak"
            Else
            nav_new_fname$=nav_dir$
            End If
            If nav_new_fname$ <>nav_dir$ Then
nav_object_is=nav_iis_file_or_dir(nav_new_fname$)
    If nav_object_is<>2 Then
            Copy nav_dir$ To nav_new_fname$
            nav_flag_exit=1
            nav_new_fname$=""

    Else
  nav_dlg_box_error(nav_at_x,nav_at_y,nav_bl,nav_bh,nav_sym_w,nav_sym_h,"Problem:","System limit!","Backup exists!")

 End If

            End If

            Case 5 '"View"'5
            Color RGB(brown),RGB(black)
            CLS
            wiev_file(nav_font_h,nav_dir$)
            Color RGB(white),RGB(blue)

            Case 6 '"Load & RUN"   '2
            Run nav_dir$

            Case 7 '"Delete" '7
            nav_delete

   End Select

  If nav_flag_exit=1 Then
  pkey=0
nav_pause_me(200)
  Exit Do
  End If
nav_pause_me(200)
 End If

 'scrool mini help

 If Len(nav_text$) >16 Then
  If nav_time_flag > 35 Then
 nav_pos =1
 nav_chk=0
 nav_text$=Space$(16)+nav_text$
 nav_len=Len(nav_text$)
 nav_time_flag=0
 nav_x=nav_subm_spaces_x
 nav_y=nav_subm_spaces_y-4
 nav_wdth=16
 nav_time_flag=0
 End If
 If nav_time_flag > 1 And nav_time_flag<10 Then
 nav_end_scrool_p=nav_scrool_p(" ",nav_x,nav_y,nav_pos,nav_chk,nav_len,nav_text$,nav_wdth)
 If nav_end_scrool_p =0  Then
 nav_pos=1
 nav_time_flag=20
 End If
 nav_time_flag=0
 End If
 Else
 Print @(nav_subm_spaces_x,nav_subm_spaces_y-4) nav_text$
 End If

 pkey=KeyDown(1)
 If pkey=129 Then
 Print @(nav_subm_cursor_x,(nav_sub_idx)*nav_font_h) " ";
 Print @(nav_subm_spaces_x,nav_subm_spaces_y-4) Space$(16);
 Inc nav_sub_idx,1
 If nav_sub_idx>=nav_max_sub_idx Then
 Inc nav_sub_idx,-1
 End If
 Print @(nav_subm_cursor_x,(nav_sub_idx)*nav_font_h) ">";
 nav_text$=nav_get_help_line(nav_sub_idx-6)
 nav_time_flag=20
 nav_start_pos=1
nav_pause_me(200)
 End If

 If pkey=128 Then
 Print @(nav_subm_cursor_x,(nav_sub_idx)*nav_font_h) " ";
 Print @(nav_subm_spaces_x,nav_subm_spaces_y-4) Space$(16);
 Inc nav_sub_idx,-1
 If nav_sub_idx<=nav_min_sub_idx Then
 Inc nav_sub_idx,1
 End If
 Print @(nav_subm_cursor_x,(nav_sub_idx)*nav_font_h) ">";
 nav_text$=nav_get_help_line(nav_sub_idx-6)
 nav_time_flag=20
 nav_start_pos=1
nav_pause_me(200)
  End If

 If pkey=27 Then
nav_pause_me(200)
  Exit Do
 End If

 Loop
 pkey=0
Sprite set transparent 11
Sprite WRITE #1,nav_scr_w-24*nav_font_w-2,nav_dlg_y-2',1
Sprite  close #1
 End If
End If

If pkey=27 Then
Sprite read #8,nav_scr_w-20*nav_font_w+3,MM.Info(fontheight)*2+2,19*nav_font_w,MM.Info(fontheight)*36+1
nav_esc_flag=0
Do While pkey=27
pkey=KeyDown(1)


Pixel (nav_scr_w-20*nav_font_w+3)+Int(Rnd*(nav_font_w*18)),27+Int(Rnd*(nav_font_h*35+5)),RGB(cyan)

If nav_esc_flag>10 Then
nav_flag_exit=1
Exit Do
End If
Loop
Sprite write #8,nav_scr_w-20*nav_font_w+3,MM.Info(fontheight)*2+2

If nav_flag_exit=1 Then
Color RGB(white),RGB(black)
CLS
MODE 1
End
End If
Sprite close #8
End If

If nav_idx <> 0 And Len(nav_dirct$(nav_idx-1))>15 Then
'scrool fname
If nav_time_flag > 60 Then
nav_pos =1
nav_chk=0
nav_text$=nav_dirct$(nav_idx-1)
nav_len=Len(nav_text$)
nav_time_flag=0
nav_x=nav_fname_x
nav_y=(nav_idx+yof)*nav_font_h
nav_wdth=15
nav_time_flag=0
End If

If nav_time_flag > 1 And nav_time_flag<10 Then
nav_end_scrool_p=nav_scrool_p(">",nav_x,nav_y,nav_pos,nav_chk,nav_len,nav_text$,nav_wdth)
If nav_end_scrool_p =0  Then
nav_pos=1
nav_time_flag=0
nav_text$=Space$(16)+nav_dirct$(nav_idx-1)
nav_len=Len(nav_text$)
End If
nav_time_flag=0
End If
Else
Print @(nav_fname_x,(nav_idx+yof)*nav_font_h) nav_dirct$(nav_idx-1)
End If
EndIf

If nav_flag_exit=1 Then
nav_flag_exit=0
Exit Do
End If

Loop

Loop
End
End Sub

Sub rise_20ms_flag
Inc nav_time_flag
Inc nav_free_time_flag
Inc nav_ship_move
End Sub
Sub rise_5ms_flag
Inc nav_ship_move
End Sub


Sub rise_100ms_flag
Inc nav_esc_flag
Inc nav_advert_flag
End Sub

Sub advertising(nav_ad_x,nav_time_x)
Local nav_advert$

Select Case Fix(nav_advert_flag/25)' nbr 25 is period
  Case 0
    nav_advert$="F1-EDIT quickSave    "
  Case 1
    nav_advert$="F2-EDIT name & Save  "
  Case 2
    nav_advert$="F3-Wiev              "
  Case 3
    nav_advert$="INS-select files     "
  Case 4
    nav_advert$="F5-copy/paste sel.   "
  Case 5
    nav_advert$="F6-full ReName       "
  Case 6
    nav_advert$="F7-Create DIR        "
  Case 7
    nav_advert$="F8-Delete            "
  Case 8
    nav_advert$="ENTER- file actions  "
  Case 9
    nav_advert$="TAB- swap drive A<>B "
  Case 10
    nav_advert$="SPACE- halt scrool   "
  Case 11
    nav_advert$="Ctrl+HOME DirTop     "
  Case 12
    nav_advert$="Ctrl+HOME+SHFT Root  "
  Case 13
    nav_advert$="PgUp,PgDwn- jp +5/-5 "
  Case 14
    nav_advert$="Home,End- jp up/down "
  Case 15
    nav_advert$="<-> next/prev. page  "
  Case 16
    nav_advert$="PrntScr save screen  "
  Case 17
    nav_advert$="Long ESC-Exit        "


  Case is > 18
    nav_advert_flag=0
End Select

Font 7
Color RGB(cyan),RGB(blue)
Print @(nav_ad_x,6+((yof)*MM.Info(fontheight))) nav_advert$
nav_print_time(nav_ad_x,nav_time_x)

End Sub

Sub nav_get_line(nav_cnt)
  Local nav_tmp_line$
  Seek #1,1
    Do  While nav_cnt >=1

      Line Input #1, nav_tmp_line$
      Inc nav_cnt,-1
    Loop
End Sub

Sub  wiev_file(nav_font_h,nav_dir$)
CLS
Local nav_max_lines=MM.VRES/MM.Info(fontheight)-4
Local nav_cnt=0
Local nav_page=0
Local nav_line$
Local pkey

Open nav_dir$  For input As #1
Pause 300

Do
Do While Loc(#1)<Lof(#1)
  Line Input #1,nav_line$
  Print @(0,nav_cnt*nav_font_h) Left$(nav_line$,255)
  pkey=KeyDown(1)
  Inc nav_cnt
  If nav_cnt > nav_max_lines Then
  Inc nav_cnt,-2
      Color RGB(white),RGB(black)
Print @(0,(nav_max_lines+2)*nav_font_h)Chr$(146)" prev. page. "Chr$(147)" next page. ESC -exit. Page:";nav_page+1
    Color RGB(brown),RGB(black)
'pg up 136
'pg down 137
    Do
    pkey=KeyDown(1)

    If pkey=27 Then
    nav_flag_exit=1
    Close #1
    Exit Sub
    End If

    If pkey=128 Then
      If nav_page=1 Then
      nav_get_line((nav_max_lines)*(nav_page-1)))
      Inc nav_page,-1
      Exit Do
      End If

     If nav_page >1 Then
      nav_get_line((nav_max_lines+1)*(nav_page-1)))
      Inc nav_page,-1
      Exit Do
      End If
End If

    If pkey=129 Then
    Inc nav_page,1
    Exit Do
    End If
    Loop
    nav_cnt=0
Pause 200
CLS
  End If
  pkey=KeyDown(1)
  If pkey=27 Then
    Exit Do
    End If
Loop
    Color RGB(white),RGB(black)
    Print @(0,(nav_max_lines+2)*nav_font_h)Chr$(146)" prev. page. ESC -exit. Page:";nav_page+1
    Color RGB(brown),RGB(black)
Do While pkey<>27 Or pkey<>128
pkey=KeyDown(1)
If pkey=27 Then
nav_flag_exit=1
Close #1
Exit Sub
End If
    If pkey=128 Then
      If nav_page=1 Then
      nav_get_line((nav_max_lines)*(nav_page-1)))
      Inc nav_page,-1
      Exit Do
      End If

     If nav_page >1 Then
      nav_get_line((nav_max_lines+1)*(nav_page-1)))
      Inc nav_page,-1
      Exit Do
      End If
End If

    Loop
    nav_cnt=0
Pause 200
CLS
  End If

Loop
Loop

Close #1

End Sub
' dlg with editing
Sub nav_dlg_box_error(nav_at_x,nav_at_y,nav_w,nav_ht,nav_sym_w,nav_sym_h,nav_dlg_name$,nav_dlg_warning$,nav_start_name$)

Local nav_dlg_nx=nav_at_x+nav_sym_w
Local nav_dlg_ny=nav_at_y+2
Local nav_dlg_esc_nx=nav_at_x+nav_sym_w*19
Local nav_dlg_line_markx=nav_at_x+nav_sym_w*1
Local nav_dlg_line_marky=nav_at_y+nav_sym_h*2
Local nav_dlg_linex=nav_at_x+nav_sym_w*4
Local nav_dlg_liney=nav_at_y+nav_sym_h*2
Local key$
Local nav_ad_x=MM.HRES-19*MM.Info(fontwidth)
Local nav_time_x=MM.HRES-13*MM.Info(fontwidth)

Sprite read #2, nav_at_x-2,nav_at_y-2,nav_w+4,nav_ht+4
RBox nav_at_x+2,nav_at_y+2,nav_w,nav_ht,9,RGB(yellow)
RBox nav_at_x,nav_at_y,nav_w,nav_ht,9,RGB(white),RGB(blue)
Font 7
Color RGB(cyan),RGB(blue)
Print @(nav_dlg_nx,nav_dlg_ny) nav_dlg_name$
Color RGB(yellow),RGB(blue)
Color RGB(yellow),RGB(blue)
Print @(nav_dlg_esc_nx,nav_dlg_ny) "   esc*"    '1
Color RGB(white),RGB(blue)
Font 1
Print @(nav_dlg_line_markx,nav_dlg_line_marky) nav_start_name$
           Do
           stars_will_born
           ships_will_move
            advertising(nav_ad_x,nav_time_x)

            key$=Inkey$
            If key$<>"" Then
            Exit Do
            End If

            Loop

Sprite set transparent 11
Sprite WRITE #2,nav_at_x-2,nav_at_y-2
Sprite  close #2
nav_pause_me(200)
End Sub

Function nav_dlg_box_e(nav_at_x,nav_at_y,nav_w,nav_ht,nav_sym_w,nav_sym_h,nav_dlg_name$,nav_dlg_warning$,nav_start_name$) As string
Local nav_dlg_nx=nav_at_x+nav_sym_w
Local nav_dlg_ny=nav_at_y+2
Local nav_dlg_esc_nx=nav_at_x+nav_sym_w*19
Local nav_dlg_line_markx=nav_at_x+nav_sym_w*2
Local nav_dlg_line_marky=nav_at_y+nav_sym_h*2
Local nav_dlg_linex=nav_at_x+nav_sym_w*4
Local nav_dlg_liney=nav_at_y+nav_sym_h*2
Local key$
Local stop_pos
Local nav_chk
Local nav_object_is
Local nav_ad_x=MM.HRES-19*MM.Info(fontwidth)
Local nav_time_x=MM.HRES-13*MM.Info(fontwidth)
Sprite read #2, nav_at_x-2,nav_at_y-2,nav_w+4,nav_ht+4
RBox nav_at_x+2,nav_at_y+2,nav_w,nav_ht,9,RGB(yellow)
RBox nav_at_x,nav_at_y,nav_w,nav_ht,9,RGB(white),RGB(blue)
Font 7
Color RGB(cyan),RGB(blue)
Print @(nav_dlg_nx,nav_dlg_ny) nav_dlg_name$
Color RGB(yellow),RGB(blue)
Color RGB(yellow),RGB(blue)
Print @(nav_dlg_esc_nx,nav_dlg_ny) "   esc*"    '1
Color RGB(white),RGB(blue)
Font 1

nav_fname$=nav_start_name$
nav_esc_flag=60
Print @(nav_dlg_line_markx,nav_dlg_line_marky) "->";

Do
stars_will_born
ships_will_move
 stop_pos=MM.Info(hpos)
  If Len(nav_fname$)>18 Then
      Print @(nav_dlg_linex,nav_dlg_liney) Right$(nav_fname$,18)
     Else
      Print @(nav_dlg_linex,nav_dlg_liney) nav_fname$+" ";
     End If
nav_insert=Len(nav_fname$)
If nav_insert>=18 Then
nav_insert=18
End If
  Do
  stars_will_born
  ships_will_move
    advertising(nav_ad_x,nav_time_x)
   If nav_esc_flag >5 Then
    Color RGB(white),RGB(blue)
            Else
    Font 7
    Color RGB(white),RGB(red)
    Print @(nav_dlg_nx,nav_dlg_ny) nav_dlg_warning$;
    Color RGB(yellow),RGB(blue)
    Print "  ";
    Font 1
   End If

  key$=Inkey$
   If key$<>"" Then
    If nav_esc_flag>5 Then
     Font 7
     Color RGB(cyan),RGB(blue)
     Print @(nav_at_x+nav_sym_w,nav_at_y+2) nav_dlg_name$;
     Color RGB(yellow),RGB(blue)
     Font 1
    End If

   If key$=Chr$(13) Then
    Exit Do
   End If

   If key$=Chr$(27) Then
    nav_fname$=""
    Exit Do
   End If

  nav_chk=Str2bin(int8,key$)

   If nav_chk>31 And nav_chk<129 Then
   If Len(nav_fname$) >= 18 Then
left_nav_fname$=Left$(nav_fname$,Len(nav_fname$)-18)
right_nav_fname$= Right$(nav_fname$,18)
nav_fname$=left_nav_fname$+Left$(right_nav_fname$,nav_insert)+key$+Right$(right_nav_fname$,18-nav_insert)
   Else
   nav_fname$=Left$(nav_fname$,nav_insert)+key$+Right$(nav_fname$,Len(nav_fname$)-nav_insert)
   End If
     If Len(nav_fname$)>18 Then
      Print @(nav_dlg_linex,nav_dlg_liney) Left$(right_nav_fname$,nav_insert)+key$+"_"+Right$(right_nav_fname$,18-nav_insert)
     Else
      Print @(nav_dlg_linex,nav_dlg_liney) Left$(nav_fname$,nav_insert)+key$+"_"+Right$(nav_fname$,Len(nav_fname$)-nav_insert-1)
     End If

       Inc nav_insert
       If nav_insert >= 18 Then
       nav_insert=18
       End If

   End If

   If nav_chk=8 And Len(nav_fname$)>0 Then
    Color RGB(white),RGB(blue)
   If Len(nav_fname$) >= 18 Then
left_nav_fname$=Left$(nav_fname$,Len(nav_fname$)-18)
right_nav_fname$= Right$(nav_fname$,18)
nav_fname$=left_nav_fname$+Left$(right_nav_fname$,nav_insert-1)+Right$(right_nav_fname$,18-nav_insert)
left_nav_fname$=Left$(nav_fname$,Len(nav_fname$)-17)
right_nav_fname$= Right$(nav_fname$,18)

   Else
left_nav_fname$=Left$(nav_fname$,nav_insert-1)
right_nav_fname$=Right$(nav_fname$,Len(nav_fname$)-nav_insert)
   nav_fname$=left_nav_fname$+right_nav_fname$
   End If

     If Len(nav_fname$)>=18 Then
  Print @(nav_dlg_linex,nav_dlg_liney) Left$(right_nav_fname$,nav_insert)+"_"+Right$(right_nav_fname$,18-nav_insert)+" "
     Else

     left_nav_fname$=Left$(nav_fname$,nav_insert-1)
     right_nav_fname$=Right$(nav_fname$,Len(nav_fname$)-nav_insert+1)
      Print @(nav_dlg_linex,nav_dlg_liney) left_nav_fname$+"_"+right_nav_fname$+"  "

      Inc nav_insert,-1
      If nav_insert <0 Then
      nav_insert=0
      End If

     End If

   End If

      If key$=Chr$(130) And Len(nav_fname$)>0 Then
             Inc nav_insert,-1
   If nav_insert=-1 Then
   nav_insert=0
   End If
      If nav_insert > 18 Then
      nav_insert=18
      End If
    Color RGB(white),RGB(blue)
     If Len(nav_fname$)>=18 Then
        If nav_insert<0 Then
   nav_insert=0
   End If

      right_nav_fname$=Right$(nav_fname$,18)
      Print @(nav_dlg_linex,nav_dlg_liney) Left$(right_nav_fname$,nav_insert)+"_"+Right$(right_nav_fname$,18-nav_insert)+" "

     Else
      Print @(nav_dlg_linex,nav_dlg_liney) Mid$(nav_fname$,1,nav_insert)+"_"+Mid$(nav_fname$,nav_insert+1)+" ";
     End If


   End If

      If key$=Chr$(131) And Len(nav_fname$)>0 Then
   Inc nav_insert
 If   nav_insert = 19 Then
nav_insert=18
 End If

    Color RGB(white),RGB(blue)
     If Len(nav_fname$)>18 Then
      right_nav_fname$=Right$(nav_fname$,18)
      Print @(nav_dlg_linex,nav_dlg_liney) Left$(right_nav_fname$,nav_insert)+"_"+Right$(right_nav_fname$,18-nav_insert)+" "
     Else
         If nav_insert>Len(nav_fname$) Then
     nav_insert=Len(nav_fname$)
     End If


      Print @(nav_dlg_linex,nav_dlg_liney) Mid$(nav_fname$,1,nav_insert)+"_"+Mid$(nav_fname$,nav_insert+1)+" ";
     End If

      End If

   End If


  End If
  Loop
nav_chk=0
 If nav_fname$<>"" Then
nav_object_is=nav_iis_file_or_dir(nav_fname$)
   If nav_object_is<>1 Then
   nav_dlg_box_e$=nav_fname$
   Exit Do
            Else
    Color RGB(white),RGB(red)
    Print @(nav_dlg_linex,nav_dlg_liney) Right$(nav_fname$,18)
    nav_esc_flag=0
            End If
 Else
 nav_pause_me(100)
  pkey=0
  nav_dlg_box_e$=""
  Exit Do
 End If
   nav_print_time(nav_ad_x,nav_time_x)


Loop
Sprite set transparent 11
Sprite WRITE #2,nav_at_x-2,nav_at_y-2
Sprite  close #2
nav_pause_me(200)
End Function
' dlg with choice
Function nav_dlg_box_f(nav_at_x,nav_at_y,nav_w,nav_ht,nav_sym_w,nav_sym_h,nav_dlg_name$,nav_dlg_warning$,nav_start_name$) As string
Local nav_dlg_nx=nav_at_x+nav_sym_w
Local nav_dlg_ny=nav_at_y+2
Local nav_dlg_esc_nx=nav_at_x+nav_sym_w*19
Local nav_dlg_line_markx=nav_at_x+nav_sym_w*2
Local nav_dlg_line_marky=nav_at_y+nav_sym_h*2
Local nav_dlg_linex=nav_at_x+nav_sym_w*4
Local nav_dlg_liney=nav_at_y+nav_sym_h*2
Local nav_dlg_confirmx=nav_at_x+nav_sym_w*6
Local nav_dlg_confirmy=nav_at_y+nav_sym_h*3
Local key$
Local stop_pos
Local nav_ad_x=MM.HRES-19*MM.Info(fontwidth)
Local nav_time_x=MM.HRES-13*MM.Info(fontwidth)

Sprite read #2, nav_at_x-2,nav_at_y-2,nav_w+4,nav_ht+4
RBox nav_at_x+2,nav_at_y+2,nav_w,nav_ht,9,RGB(yellow)
RBox nav_at_x,nav_at_y,nav_w,nav_ht,9,RGB(white),RGB(blue)
Font 7
Color RGB(cyan),RGB(blue)
Print @(nav_dlg_nx,nav_dlg_ny) nav_dlg_name$
Color RGB(yellow),RGB(blue)
Color RGB(yellow),RGB(blue)
Print @(nav_dlg_esc_nx,nav_dlg_ny) "   esc*"    '1
Color RGB(white),RGB(blue)
Font 1

nav_fname$=nav_start_name$

 Print @(nav_dlg_line_markx,nav_dlg_line_marky) "->";
 stop_pos=MM.Info(hpos)
 Print @(nav_dlg_linex,nav_dlg_line_marky)Left$(nav_fname$,18);
            Color RGB(red),RGB(white)
            Font 7
            Print @(nav_dlg_confirmx,nav_dlg_confirmy) "Confirm action y/n ?"
            Font 1
            Color RGB(white),RGB(blue)
            Color RGB(red),RGB(blue)
           Do
           stars_will_born
           ships_will_move
           advertising(nav_ad_x,nav_time_x)
            key$=Inkey$
            If key$<>"" Then
            If key$="y" Or key$="Y" Then
   nav_dlg_box_f$="y"
            Exit Do
            Else
   nav_dlg_box_f$="n"
            Exit Do
            End If
            End If

            Loop
   Color RGB(white),RGB(blue)

Sprite set transparent 11
Sprite WRITE #2,nav_at_x-2,nav_at_y-2
Sprite  close #2
nav_pause_me(200)
End Function

Function nav_iis_file_or_dir(nav_obj$) As integer
Local nav_iis_dir
Local nav_iis_file
nav_iis_dir=MM.Info(EXISTS DIR nav_obj$)
nav_iis_file=MM.Info(EXISTS FILE nav_obj$)
If nav_iis_dir=1 And nav_iis_file=0 Then
nav_iis_file_or_dir=1
End If
If nav_iis_dir=0 And nav_iis_file=1 Then
nav_iis_file_or_dir=2
End If
If nav_iis_dir=0 And nav_iis_file=0 Then
nav_iis_file_or_dir=0
End If
End Function


Function nav_get_fname(nav_dir$) As string
Local nav_pos
Local nav_tmp
Local nav_tmp_str$
Local nav_chk

nav_pos=Len(nav_dir$)-1
nav_tmp=0
nav_tmp_str$=""

 Do
  If nav_pos<1 Then
   Exit Do
  End If

  nav_chk=Instr(nav_pos,nav_dir$,"/")
  If nav_chk<>0 Then
   nav_tmp=nav_chk
   Exit Do
  End If
  Inc nav_pos,-1
 Loop

 If nav_tmp<>0 Then
  nav_get_fname$=Mid$(nav_dir$,nav_tmp)
  Else
  nav_get_fname$=""
 End If
End Function


Function nav_get_extension(nav_dir$) As string
Local nav_pos
Local nav_tmp
Local nav_tmp_str$
Local nav_chk

nav_pos=Len(nav_dir$)-1
nav_tmp=0
nav_tmp_str$=""

 Do
  If nav_pos<1 Then
   Exit Do
  End If

  nav_chk=Instr(nav_pos,nav_dir$,".")
  If nav_chk<>0 Then
   nav_tmp=nav_chk
   Exit Do
  End If
  Inc nav_pos,-1
 Loop

 If nav_tmp<>0 Then
  nav_get_extension$=Mid$(nav_dir$,nav_tmp)
  Else
  nav_get_extension$=""
 End If
End Function

Function nav_trim_extension(nav_dir$,nav_full) As string
Local nav_pos
Local nav_tmp
Local nav_tmp_str$
Local nav_tmp_dir$
Local nav_chk

nav_pos=Len(nav_dir$)-1
nav_tmp=0
nav_tmp_str$=""
nav_tmp_dir$=nav_dir$

 Do
  If nav_pos<1 Then
   Exit Do
  End If

  nav_chk=Instr(nav_pos,nav_dir$,".")
  If nav_chk<>0 Then
   nav_tmp=nav_chk
If nav_full=0 Then
  Exit Do ' trims only everything after last dot e.i. .exe but not .exe.bak
End If
  End If
  Inc nav_pos,-1
 Loop

 If nav_tmp<>0 Then
  nav_tmp_str$=Mid$(nav_dir$,nav_tmp)
 MID$(nav_tmp_dir$,nav_tmp,Len(nav_tmp_str$))=""
   nav_trim_extension$=nav_tmp_dir$
   Else
   nav_trim_extension$=nav_dir$
 End If
End Function

Function nav_format_time_stamp(nav_date_time$) As string
Local nav_chk
            Do
            nav_chk=Instr(nav_date_time$,"-")
            If nav_chk<>0 Then
            MID$(nav_date_time$,nav_chk,1)=""
            Else
            Exit Do
            End If
            Loop

            Do
            nav_chk=Instr(nav_date_time$,":")
            If nav_chk<>0 Then
            MID$(nav_date_time$,nav_chk,1)=""
            Else
            Exit Do
            End If
            Loop
   nav_format_time_stamp$=nav_date_time$
End Function

Sub nav_delete()
Local nav_at_x=MM.HRES-(27*MM.Info(fontwidth))
Local nav_scr_h=MM.VRES
Local nav_at_y=MM.Info(fontheight)*5
Local nav_bl=25*MM.Info(fontwidth)
Local nav_bh=MM.Info(fontheight)*4
Local nav_sym_w=MM.Info(fontwidth)
Local nav_sym_h=MM.Info(fontheight)
Local nav_object_is

nav_dir$=nav_dirct$(nav_idx-1)
nav_object_is=nav_iis_file_or_dir(nav_dir$)
If nav_object_is=0 Then
nav_dlg_box_error(nav_at_x,nav_at_y,nav_bl,nav_bh,nav_sym_w,nav_sym_h,"Problem:","System limit!","Too long path/name")
End If


 If nav_object_is=1 And nav_dir$<>".." Then
  nav_fname$=nav_dlg_box_f(nav_at_x,nav_at_y,nav_bl,nav_bh,nav_sym_w,nav_sym_h,"Delete directory:","Directory full!",nav_dir$)
   If nav_fname$="y" Then
    Chdir nav_root$+nav_path$
    On error skip 2
    Rmdir nav_dir$
    If MM.Errno=7 Then
nav_dlg_box_error(nav_at_x,nav_at_y,nav_bl,nav_bh,nav_sym_w,nav_sym_h,"Problem:","Undefined Error!","Directory is not empty.")
    End If
    nav_flag_exit=1
    Inc nav_idx,-1
    nav_record(nav_level)=nav_idx
   End If
 End If

 If nav_object_is=2 Then
  nav_fname$=nav_dlg_box_f(nav_at_x,nav_at_y,nav_bl,nav_bh,nav_sym_w,nav_sym_h,"Delete file:","Undefined Error!",nav_dir$)
   If nav_fname$="y" Then
    nav_new_fname$=nav_path$+"\"+nav_dir$
    nav_new_fname$=nav_root$+nav_new_fname$
    Kill nav_new_fname$
    nav_flag_exit=1
    Inc nav_idx,-1
    nav_record(nav_level)=nav_idx
   End If
 End If
 End Sub

Function nav_scrool_p(nav_mask$,nav_x,nav_y,nav_pos,nav_chk,nav_len,nav_text$,nav_wdth) As integer
Do While pkey=32 ' stop scrool if SPACE pressed
stars_will_born
ships_will_move
pkey=KeyDown(1)
Loop
Print @(nav_x-nav_chk,nav_y) Mid$(nav_text$,nav_pos,nav_wdth)
Print @(nav_x-MM.Info(fontwidth),nav_y) nav_mask$;
Inc nav_chk,1
If nav_chk=MM.Info(fontwidth) Then
Inc nav_pos
nav_chk=0
End If
If nav_pos>nav_len Then
nav_scrool_p=0
Else
nav_scrool_p=nav_pos
End If
End Function

Sub nav_print_time(nav_ad_x,nav_time_x)

Font 7
Color RGB(yellow),RGB(black)
Print @(nav_time_x,3+MM.Info(fontheight)*(yof+54)+1) Time$
Color RGB(white),RGB(blue)
Font 1
End Sub

Function nav_get_help_line(nav_help_idx) As string
 Select Case nav_help_idx
 Case 0
 Restore minihelp1
 Read  nav_get_help_line$
 Case 1
 Restore minihelp2
 Read  nav_get_help_line$
 Case 2
 Restore minihelp3
 Read  nav_get_help_line$
 Case 3
 Restore minihelp4
 Read  nav_get_help_line$
 Case 4
 Restore minihelp5
 Read  nav_get_help_line$
 Case 5
 Restore minihelp6
 Read  nav_get_help_line$
 Case 6
 Restore minihelp7
 Read  nav_get_help_line$
 End Select

 End Function

Sub read_files_dirs()
Local entry$
Local nav_cnt
If nav_page=0 Then
nav_idx=1
 nav_dirct$(0)=".."
Else
nav_idx=0
End If
 entry$=Dir$("*",dir)
  Do
    If entry$="" Then
    Exit Do
    End If
    If nav_idx >= nav_page*32 Then
  entry$=Left$(entry$,60)
  nav_dirct$(nav_idx)=entry$
  End If
    Inc nav_idx
  entry$=Dir$()
  Loop  Until entry$="" Or nav_idx>=nav_page*32+32
'  Sort
Sort  nav_dirct$() ,,4
If nav_page >0 Then
Inc nav_idx
End If
 sort_start=nav_idx
 entry$=Dir$("*",file)

 Do
  If entry$="" Then
 Exit Do
  End If
  If nav_idx >= nav_page*32 Then
 entry$=Left$(entry$,60)
 nav_dirct$(nav_idx-(nav_page*32))=entry$
 End If
 Inc nav_idx
 entry$=Dir$()
 Loop  Until entry$="" Or nav_idx >=nav_page*32+32
Sort  nav_dirct$() ,,4,sort_start
If entry$ <> "" Then '  if there might be more files left

nav_more_pages=1
Else
nav_more_pages=0
 End If
nav_idx=nav_idx-nav_page*32
 End Sub

 Sub print_files_dirs()
 Local nav_a
 Local nav_fname_x=nav_scr_w-18*nav_font_w
 Local nav_pad_l$,nav_pad_r$
 Static nav_col_v_max=(MM.VRES/MM.Info(fontheight))-5
 If nav_level<>0 Then
 For nav_a= 0 To 32
 Print @(nav_fname_x,(nav_a+1+yof)*nav_font_h) Left$(nav_dirct$(nav_a),14);
  If Len(nav_dirct$(nav_a))>14 Then
  Print "~";
  End If
 Next nav_a
Else
 For nav_a= 1 To 32
 Print @(nav_fname_x,(nav_a+1+yof)*nav_font_h) Left$(nav_dirct$(nav_a),14);
  If Len(nav_dirct$(nav_a))>14 Then
  Print "~";
  End If
 Next nav_a
End If
If nav_more_pages =1 Then
 Print @(nav_fname_x+(9*nav_font_w),(33+yof)*nav_font_h+5) "pg. 2 " Chr$(148) ;
End If
If nav_more_pages =0 And nav_page<>0 Then
 Print @(nav_fname_x-nav_font_w,(33+yof)*nav_font_h+5) Chr$(149) ;"  pg."; nav_page ;
End If

If nav_page >0 And nav_more_pages<>0 Then
 nav_pad_l$=Space$(4-Len(Str$(nav_page)))
 nav_pad_r$=Space$(4-Len(Str$(nav_page+2)))

 Print @(nav_fname_x-nav_font_w,(33+yof)*nav_font_h+5) Chr$(149);Space$(15); Chr$(148);
 Print @(nav_fname_x+nav_font_w,(33+yof)*nav_font_h+5) Str$(nav_page);nav_pad_l$;" pg. "; nav_pad_r$ ;Str$(nav_page+2);

End If


 End Sub

Sub nav_pause_me(nav_period)
Local nav_divider=20
Local rate_key
Local nav_step=0.0002
nav_free_time_flag=0
Do While nav_free_time_flag< nav_period/nav_divider
ships_will_move
stars_will_born
stars_will_die
stars_will_die
stars_will_die
stars_will_die
stars_will_die
stars_will_die
stars_will_die
stars_will_die
stars_will_die

Loop
End Sub

Sub stars_will_die
 nav_rand_x=Rnd()*nav_scr_w
 nav_rand_y=Rnd()*nav_scr_h

nav_chk_area=nav_protected_area(nav_rand_x,nav_rand_y)
If nav_chk_area=1 Then
 Pixel nav_rand_x,nav_rand_y,RGB(black)
End If

End Sub

Sub ships_will_move

If nav_ship_restart =1 And nav_ship_move > nav_ship_delay Then
ship_x=0
ship_speed=Rnd()*0.8
ship_acceleration=Rnd()*0.01
Inc aship,-3
ship_y=Rnd()*MM.VRES-1
If ship_y < nav_font_h*2 Or ship_y > nav_font_h*39-5 Then
max_ship_x=MM.HRES-(nav_font_w)
Else
max_ship_x=MM.HRES-(21*nav_font_w)
End If
nav_ship_move_allowed =1
nav_ship_restart =0
End If

If nav_ship_move_allowed =1 Then


Inc ship_speed,ship_acceleration'0.001
 If nav_ship_move>ship_speed Then
Sprite show aship,ship_x,ship_y,1
 Sprite hide aship
Sprite show aship,ship_x,ship_y,1
Inc ship_x,ship_speed

If ship_x>Fix(MM.HRES*0.2) And aship=51 Then
Sprite hide aship
Inc aship
Sprite show aship,ship_x,ship_y,1
End If
If ship_x>Fix(MM.HRES*0.4) And aship=52 Then
 Sprite hide aship
 Inc ship_speed,0.1
Inc aship
Sprite show aship,ship_x,ship_y,1
End If
If ship_x>Fix(MM.HRES*0.6) And aship=53 Then
 Sprite hide aship
  Inc ship_speed,0.5
Inc aship
Sprite show aship,ship_x,ship_y,1
End If
If ship_x>Fix(MM.HRES*0.8) And aship=54 Then
 Sprite hide aship
  Inc ship_speed,0.8
Inc aship
Sprite show aship,ship_x,ship_y,1
End If


If ship_x > max_ship_x Then
 Sprite hide aship
nav_ship_move_allowed =0
nav_ship_restart =1
nav_ship_move=0
nav_ship_delay=(Rnd()*10500)+100
End If
End If

End If
End Sub


 Sub stars_will_born
 Local nav_clr=Rnd()*16777215
 Local nav_rand_x
 Local nav_rand_y
 nav_rand_x=Rnd()*nav_scr_w
 nav_rand_y=Rnd()*nav_scr_h

nav_chk_area=nav_protected_area(nav_rand_x,nav_rand_y)
If nav_chk_area=1 Then
 Pixel nav_rand_x,nav_rand_y,nav_clr
End If

stars_will_die
stars_will_die
stars_will_die
stars_will_die
stars_will_die
stars_will_die
stars_will_die
stars_will_die
stars_will_die
stars_will_die
stars_will_die
stars_will_die
stars_will_die
stars_will_die
stars_will_die
stars_will_die
stars_will_die
stars_will_die
End Sub

Function nav_protected_area(nav_rand_x,nav_rand_y) As integer
Local nav_c_font=MM.Info(font)
Font 1
nav_protected_area=1

 If nav_rand_x >MM.HRES-(MM.Info(fontwidth)*3)-5 And nav_rand_y<MM.Info(fontheight)*3 Then
nav_protected_area=0
End If


 If sprite(W,1) <> -1 Then
 If nav_rand_x >MM.HRES-(MM.Info(fontwidth)*24)-5 And nav_rand_x<MM.HRES And nav_rand_y > MM.Info(fontheight)*4+5  And nav_rand_y<MM.Info(fontheight)*18+5 Then 'MM.VRES-(MM.Info(fontheight)*31)+5 Then
nav_protected_area=0
End If
End If

 If sprite(W,2) <> -1 Then
 If nav_rand_x >MM.HRES-(MM.Info(fontwidth)*27)-5 And nav_rand_x<MM.HRES And nav_rand_y > MM.Info(fontheight)*5-5  And nav_rand_y<MM.Info(fontheight)*10-5 Then
nav_protected_area=0
End If
End If

 If nav_rand_x >MM.HRES-(MM.Info(fontwidth)*20)-5 And nav_rand_x<MM.HRES And nav_rand_y > MM.Info(fontheight)*2-5 And nav_rand_y<MM.Info(fontheight)*39-5 Then
nav_protected_area=0
End If

Font nav_c_font
End Function

Sub nav_prepare_space
Local spr51arr%(2)=(184,7,184)
Local spr51clr%(7)=(13,13,13,13,13,13,13,13)
Local spr52arr%(2)=(112,14,112)
Local spr52clr%(7)=(13,13,13,13,13,13,13,13)
Local spr53arr%(2)=(192,48,192)
Local spr53clr%(7)=(13,13,13,13,13,13,13,13)
Local spr54arr%(2)=(128,64,128)
Local spr54clr%(7)=(13,13,13,13,13,13,13,13)
Local spr55arr%(2)=(0,128,0)
Local spr55clr%(7)=(13,13,13,13,13,13,13,13)

prepare_sprite(51,8,3,spr51arr%(),spr51clr%())
prepare_sprite(52,8,3,spr52arr%(),spr52clr%())
prepare_sprite(53,8,3,spr53arr%(),spr53clr%())
prepare_sprite(54,8,3,spr54arr%(),spr54clr%())
prepare_sprite(55,8,3,spr55arr%(),spr55clr%())

End Sub

minihelp1:
Data "Gets selected name, adds time stamp and saves EDITOR contents as new *.bas files"
minihelp2:
Data "Gets selected name and saves EDITOR contents as new *.bas file"
minihelp3:
Data "Alows to ReName file, saves original extension"
minihelp4:
Data "Backups selected file. Adds *.bak extension"
minihelp5:
Data "View file in TXT reading mode"
minihelp6:
Data "LOADs and RUNs program. Use it to LOAD file for editing"
minihelp7:
Data "Deletes file with confirmation"

Sub nav_chg_disk_icon(disk$)
Local spr%(7)=(0,5,0,3,0,255,0,255)
Local spr2%(7)=(0,0,0,0,0,1,0,1)

Select Case disk$
Case "b"
Font 1
Color RGB(yellow),RGB(black)
print_sprite(MM.HRES-(3*MM.Info(fontwidth)+2),MM.Info(fontheight)+3,8,8,spr2%(),RGB(green))
print_sprite(MM.HRES-(2*MM.Info(fontwidth)),MM.Info(fontheight)+3,8,8,spr%(),RGB(green))
Print @(MM.HRES-(2*MM.Info(fontheight)+3),8) "b"
Case "a"
Font 1
Color RGB(green),RGB(black)
print_sprite(MM.HRES-(3*MM.Info(fontwidth)+2),MM.Info(fontheight)+3,8,8,spr2%(),RGB(yellow))
print_sprite(MM.HRES-(2*MM.Info(fontwidth)),MM.Info(fontheight)+3,8,8,spr%(),RGB(yellow))
Print @(MM.HRES-(2*MM.Info(fontheight)+3),8) "a"

End Select
End Sub

Sub rgb121_to_rgb888(arr%()) ' for 8x8 block
For w=0 To 23
chk%=arr%(w)
red=(chk% >>3) And 1
green=(chk% >>1 ) And 3
blue = chk% And 1
arr%(w)=((red*255)<<16) Or ((green*85)<<8) Or (blue*255)
Next w
End Sub

Sub nav_chk_disk
Local nav_drv_B$
nav_drv_B$=LCase$(MM.Info(sdcard))
If nav_drv_B$="disabled" Or nav_drv_B$="not present" Or nav_drv_B$="unused" Then
nav_root$="A:"
Drive "a:"
nav_chg_disk_icon("a")
Else
nav_chg_disk_icon("b")
nav_root$="B:"
Drive "b:"
End If
Chdir nav_root$
End Sub

Sub nav_swap_disk
Local nav_drv_B$
nav_drv_B$=LCase$(MM.Info(sdcard))
If nav_drv_B$="disabled" Or nav_drv_B$="not present" Or nav_drv_B$="unused" Then
nav_root$="A:"
Drive "a:"
nav_chg_disk_icon("a")
Else

Select Case MM.Info(drive)

Case "a:", "A:"
nav_root$="B:"
Drive "b:"
nav_chg_disk_icon("b")
nav_path$=""

Case "b:", "B:"
nav_root$="A:"
Drive "a:"
nav_chg_disk_icon("a")
nav_path$=""
End Select
End If

Chdir nav_root$
End Sub

Sub prepare_sprite(sprn,sprw,sprh,spr%(),sprclr%())
Local srite_dat%(63)
Local strt_b,arb,isset,nn
Local isbyte%,clr%

strt_b=0
For arb=0 To sprh-1
isbyte%=spr%(arb)
For nn=sprw-1 To 0 Step -1
isset=Bit(isbyte%,nn)
Select Case isset
Case 0
Print "0";
srite_dat%(strt_b)=0
Case 1
Print "1";
clr%=get_clr(sprclr%(nn))
srite_dat%(strt_b)=clr%
End Select
Inc strt_b
Next nn
Print ""
Next arb
Sprite loadarray sprn,sprw,sprh,srite_dat%()
End Sub


Function get_clr(sprclr%) As integer
Local allclrs%(15)=(&h0,&h0000AA,&h005500,&h0055AA,&h00AA00,&h00AAA,&h00FF00,&h00FFFF,&hAA0000,&hAA00AA,&hAA5500,&hFF00FF,&hAA5500,&hAA55AA,&hFFFF00,&hFFFFFF)
get_clr=allclrs%(sprclr%)
End Function

Sub print_sprite(sprx,spry,sprw,sprh,spr%(),sprclr)
Local strt_b,arb,isset,nn
Local isbyte%

strt_b=0
For arb=0 To sprh-1
isbyte%=spr%(arb)
For nn=7 To 0 Step -1
isset=Bit(isbyte%,nn)
Select Case isset
Case 0
Pixel sprx-nn,spry+arb,RGB(black)
Case 1
Pixel sprx-nn,spry+arb,sprclr'RGB(yellow)
End Select
Inc strt_b
Next nn
Next arb
End Sub
