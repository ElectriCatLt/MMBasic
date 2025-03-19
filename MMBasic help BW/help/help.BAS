help
Sub help
'2025/03/04, 
' Author: ElectriCat =(^^)=
' Version: 0.1 
' Target: picomiteHDMI/USB/RP2350

Dim integer picomite=1

MODE 1
If picomite=1 Then
Font 7
Else
Font 1
End If

CLS

Dim integer v_col=Fix(MM.VRes/MM.Info(fontheight)) 
Dim integer h_col=Fix(MM.HRes/MM.Info(fontwidth)) 
' Adjust this to control max width
Dim integer def_LineWidth = h_col-4   
Dim integer X =  MM.Info(fontwidth) ' Starting X position
Dim integer Y = MM.Info(fontheight) ' Starting Y position
Dim integer font_w=x
Dim integer font_h=y
Dim integer spacing=2
Dim integer scr_clear=1
Dim integer search_restart
Dim string usr$
Dim integer full_info_en
Dim string record$
Dim string categories$
Dim hlp_line_chunks$(10) As string
Dim string work_with$
Dim prev_record(2) As integer

local found

	If picomite=1 Then
'check and choose working drive or stop program 
'if HELP directory does not exists, or drive not ready
		work_with_drive 
	Else
		work_with$="C"
	End If 

search_restart=0
scr_clear=1
clear_screen
open_database

'***********main************

	Do 'restart point
		search_restart=0
		Y = 0
		something_found=0
		move_to_db_first_line ' prepare db for reading

	If scr_clear=1 Then
		clear_screen
		scr_clear=0
	End If

call_search_line ' get user input for search pattern
' -f or > for full info printer ; -h for help screen ; -x ro restart
resolve_keys 

	If scr_clear=1 Then
		clear_screen
	End If

	If usr$<>"" And search_restart<>1 Then
		clear_screen
' A LOOP READ THROUGH ALL DATABASE FILES
	Do While Loc(#1)<Lof(#1) 
		Line Input #1,record$
		record$=LCase$(record$)
		found = Instr(record$,usr$)
			If found <> 0 Then
				something_found=1
' open database file as #2 for readings  etc.
				open_info_file 
					If full_info_EN <> 0 Then
						full_info_printer
					Else
						short_info_printer
					End If
' close if finished
				close_info_file 

				If search_restart=1 Then
				Exit Do
				End If
				clr_wait

				If search_restart=1 Then
				Exit Do
				End If
			End If
' end looop through all database files
	Loop 
	
	End If
	
check_if_nothing_found

	Loop ' loop to restart
end sub

'*********helpers***********

Sub check_if_nothing_found
	If something_found=0 And usr$<>"" Then
		Print @(font_w*2,font_h) "I think, You must refine Your search."
		Print @(font_w*2,font_h*2)"I was searching for >> "+usr$+" << but found nothing."
		Print @(font_w*2,font_h*3)"Input key '-s' and I will suggest some usefull keywords."
		scr_clear=0
		something_found=0
		End If
End Sub

Sub document_printer
	Do While Loc(#2)<Lof(#2)
		Line Input #2,record$
		line_printer
		Loop
End Sub

Sub full_info_printer
'print "full info printer online"
	get_line(1)
	Line Input #2,record$
	clr_wait
		If search_restart=1 Then
			Exit Sub
		End If
	Print @(x,y) record$
	next_line
	get_line(2)
	Line Input #2,record$
		If picomite=0 Then
			Color RGB(yellow),RGB(black)
			line_printer
			Color RGB(white),RGB(black)
		Else
			line_printer
		End If

		next_line
		get_line(3)
			Do While Loc(#2)<Lof(#2)
				Line Input #2,record$
				line_printer
				clr_wait
'		End If
				If search_restart=1 Then
					Exit Sub
				End If
			Loop
		add_separator
		next_line
End Sub

Sub short_info_printer
	Local hlp_sip_chunk_index=0
	'print "Short info printer online"
	get_line(2)
    Line Input #2,record$
		If (Len(record$)) > def_LineWidth Then
			hlp_split_line(record$)
			Do  While hlp_line_chunks$(hlp_sip_chunk_index) <>""
			Print @(x,y) hlp_line_chunks$(hlp_sip_chunk_index)
			Y = Y + MM.Info(fontheight)+spacing
			Inc hlp_sip_chunk_index
			Loop
			add_separator
		Else
			Print @(x,y) record$
			Y = Y + MM.Info(fontheight)+spacing
			add_separator
		End If
End Sub

Sub line_printer
	If (Len(record$)) > def_LineWidth Then
		hlp_split_line(record$)
		hlp_sip_chunk_index=0
			Do  While hlp_line_chunks$(hlp_sip_chunk_index) <>""
				clr_wait
					If search_restart=1 Then
						Exit Sub
					End If
				Print @(x,y) hlp_line_chunks$(hlp_sip_chunk_index)
				next_line
				Inc hlp_sip_chunk_index
			Loop
	else
		Print @(x,y) record$
		clr_wait
			If search_restart=1 Then
			Exit Sub
			End If
		next_line
	End If
End Sub


Sub move_to_db_first_line
Seek #1,1
End Sub

Sub hlp_split_line(hlp_line_to_split$)
	Local hlp_chunk_index=0
	Local hlp_sentence_len
	Local hlp_start_pos =1
	Local hlp_move_pointer =1
	Local hlp_chunk$
	Local hlp_reverse_search_pos
	Local hlp_chunks$(10)
	local a
'def_LineWidth=255
	hlp_sentence_len=Len(hlp_line_to_split$)
' will not split if line shorter than screen width can accept
		If hlp_sentence_len < def_LineWidth Then 
			hlp_chunks$(hlp_chunk_index)=hlp_line_to_split$
				For a=0 To 10
					hlp_line_chunks$(a)=hlp_chunks$(a)
				Next a
			Exit Sub
		End If
	Do
' get first part of line
		hlp_chunk$=Mid$(hlp_line_to_split$,hlp_start_pos,def_LineWidth) 
		hlp_reverse_search_pos=Len(hlp_chunk$)-1
			Do
' reverse search from the end for first space
				hlp_move_pointer=Instr(hlp_reverse_search_pos,hlp_chunk$," ") 
				Inc hlp_reverse_search_pos,-1
			Loop Until hlp_move_pointer > 0
' move truncated line to array
		hlp_chunks$(hlp_chunk_index)=Mid$(hlp_line_to_split$,hlp_start_pos,hlp_move_pointer) 
		hlp_start_pos=hlp_start_pos+hlp_move_pointer
		Inc hlp_chunk_index
' loop until nothing to split
	Loop Until hlp_sentence_len - hlp_start_pos < def_LineWidth 
' write line leftovers to array
	hlp_chunks$(hlp_chunk_index)=Mid$(hlp_line_to_split$,hlp_start_pos) 
		For a=0 To 10
			hlp_line_chunks$(a)=hlp_chunks$(a)
		Next a
End Sub

Sub get_line(hlp_nbr) '2
	Inc hlp_nbr,-2
	Local hlp_tmp_line$
	Seek #2 ,1
		Do While hlp_nbr>=0
			Line Input #2,hlp_tmp_line$
			Inc hlp_nbr,-1
		Loop
End Sub

Sub get_line_f1(hlp_nbr) '2
	Local nbr=hlp_nbr
	Inc nbr,-2
	Local hlp_tmp_line$
	Seek #1 ,1
		Do While nbr>=0
			Line Input #1,hlp_tmp_line$
			Inc nbr,-1
		Loop
End Sub

Sub open_info_file
	Local pat1
	Local pat2
	Local file_name_len
	Local db_file_type$
	Local db_file_record$
	Local db_file_to_call$
	pat1=Instr(record$,"|")
	pat2=Instr(pat1+1,record$,"|")
	file_name_len=pat2-1-pat1
	db_file_type$=Left$(record$,3)+"."
	db_file_record$=Mid$(record$,pat1+1,file_name_len)
	db_file_to_call$=db_file_record$
	Open db_file_to_call$ For input As #2
End Sub

Sub close_info_file
Close #2
End Sub

' check y overflow, wait  for user if overflow
Sub clr_wait 
	local pkey
	local string usr_msg_page$="I found more records. Press 'HOME' to refine; any key for more."
		If search_restart=1 Then
			clear_command_line(4)
			Exit Sub
		End If
		If y >font_h*(v_col-6) Then
			If picomite=1 Then
				Print @(font_w,font_h*(v_col-3)) usr_msg_page$ ;
			Else
				fore_tmp=MM.Info(FCOLOUR)
				back_tmp=MM.Info(BCOLOUR)
				Color RGB(black),RGB(WHITE)
				Print @(font_w,font_h*(v_col-3)) usr_msg_page$ ;
				Color fore_tmp,back_tmp
		End If
        Pause 200

		Do
        Loop Until KeyDown(0) <> 0
        pkey=KeyDown(1)

		If pkey=27 Then
        Close #1
        End
        End If
		
		If pkey=134 Then
			usr$=" "
			search_restart=1
			scr_clear=0
			clear_command_line(4)
			Exit Sub
        End If

        If pkey<>27 And pkey<> 134 Then
			clear_screen
		End If
		y=0
		End If
End Sub

Sub cd..
	Chdir ".."
End Sub

Sub cd
	If LCase$(MM.Info(drive))="a:" Then
		Chdir "a:\"
	End If
	If LCase$(MM.Info(drive))="b:" Then
	Chdir "b:\"
	End If
End Sub

Sub work_with_drive
	Local is_dir_A_ready
	Local status_B_drive$
	Local is_dir_B_ready
	Drive "A:"
	is_dir_A_ready=MM.Info(EXISTS DIR "a:\help")
	Drive "B:"
	status_B_drive$=LCase$(MM.Info(SDCARD))
	Print status_B_drive$
		If status_B_drive$="disabled" Then
			is_dir_B_ready=0
		End If
		If status_B_drive$="not present" Then
			is_dir_B_ready=0
		End If
		If status_B_drive$="unused" Then
			is_dir_B_ready=0
		End If
		If status_B_drive$="ready" Then
			is_dir_B_ready=MM.Info(EXISTS DIR "b:\help")
		End If
		If  is_dir_A_ready=1 And is_dir_B_ready=1 Then
			work_with$="B"
		End If
		If  is_dir_B_ready=1 And is_dir_A_ready=0  Then
			work_with$="B"
		End If
		If  is_dir_A_ready=1 And is_dir_B_ready=0 Then
			work_with$="A"
		End If
		If  is_dir_A_ready=0 And is_dir_B_ready=0 Then
			Print "Problem: drive A: or B: must contain directory 'help\hlp' with database!"
		End
		End If
End Sub

Sub open_database
	If work_with$="A" Then
		Drive "A:"
		Chdir "a:\help\hlp"
		Open "a:\help\hlp\#all_db.txt" For input As #1
	End If
	If work_with$="B" Then
		Drive "B:"
		Chdir "b:\help\hlp"
		Open "b:\help\hlp\#all_db.txt" For input As #1
	End If
	If work_with$="C" Then
		Chdir "C:\0_mmb_win\hlp"
		Open "C:\0_mmb_win\hlp\#all_db.txt" For input As #1
	End If
End Sub

Sub clear_screen
	Box 0,0,MM.HRes,MM.VRes,0,,RGB(black)  
End Sub

Sub clear_command_line(clear_h_from_bottom)
'clear search/command line
	Box 0,MM.VRes-(font_h*clear_h_from_bottom),MM.HRes,font_h*clear_h_from_bottom,0,0,RGB(black) 
End Sub

Sub call_search_line
	Print @(font_w*2,(v_col-3)*font_h) "-f >full info ; -s >suggest search ; -x > exit ; -h >how to"
	Line Input "  Help with?: ",usr$
	usr$=LCase$(usr$)
		if usr$ <>"" then
			check_control_chr=str2bin(int8,Left$(usr$,1))
				if check_control_chr <32 then
				usr$=""
				search_restart=1
				scr_clear=1
				end If
		end if
End Sub

Sub resolve_keys
	local symbols_per_row, row_pos,word_l,yyy,first_key,start,a
	full_info_EN=Instr(usr$,"-f") Or Instr(1,usr$,">")
		If Instr(1,usr$,">") Then
'will search and display exact info according rec. nr
			usr$=usr$+"]" 
		End If
	first_key=Instr(usr$,"-f")
	start=first_key
		If start >1 Then
			For a=first_key To 1 Step-1
				If  Mid$(usr$,a-1,1) <> " " Then
					usr$=Left$(usr$,a-1)
				Exit For
				End If
			Next a
		End If
		If usr$="-h" Then
			If picomite=1 Then
				If work_with$="A" Then
					Chdir "a:\help\hlp"
					Open "a:\help\hlp\#manual.txt" For input As #2
				End If
				If work_with$="B" Then
					Chdir "b:\help\hlp"
					Open "b:\help\hlp\#manual.txt" For input As #2
				End If
			Else
				If work_with$="C" Then
				Open "C:\0_mmb_win\hlp\#manual.txt" For input As #2
			End If
		End If
			clear_screen
			document_printer
			Close #2
			scr_clear=0
			search_restart=1
			usr$=""
		End If
		If usr$="-x" Or usr$="-exit" Or usr$="-e" Then
			Chdir ".."
			clear_command_line(3)
			Print @(0,MM.VRes-font_h*3)
			End
		End If
		If usr$="-s" Then
			If picomite=1 Then
				If work_with$="A" Then
					Chdir "a:\help\hlp"
					Open "a:\help\hlp\#categories_db.txt" For input As #2
				End If
				If work_with$="B" Then
					Chdir "b:\help\hlp"
					Open "b:\help\hlp\#categories_db.txt" For input As #2
				End If
			Else
				If work_with$="C" Then
					Open "C:\0_mmb_win\hlp\#categories_db.txt" For input As #2
				End If
		End If
	clear_screen
	document_printer
	Close #2
	scr_clear=0
	search_restart=1
	usr$=""
	end if
End Sub

Sub next_line
	Y = Y + MM.Info(fontheight)+spacing
End Sub

Sub add_separator
	Line 0+(font_w*1),y,MM.HRes-(font_w*1),y,1,RGB(255,255,255)
	Y = Y + spacing
End Sub

Sub adjust_line_for_tile
	local check_vertical
	'adjust correct vertical Y for tile and text match
	Do 
		check_vertical=(y/font_h) - Int(y/font_h)
		If check_vertical<>0 Then
			y=y+1
		Else
		Exit Do
		End If
	Loop 
End Sub