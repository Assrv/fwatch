// Function supplied with Fwatch v1.16
// Required to make MainMenu.sqs work

FUNCTION_FIND = {
	if (IS_CWA) then {(_this select 1) find (_this select 0)} else {
		private ["_i","_index"];
		_i=0;
		_index=-1;
		
		{
			if ((_this select 0) == _x) then {_index=_i};
			_i=_i+1
		} forEach (_this select 1);
		
		_index
	}
};



FUNCTION_MODS2STRING = {
	private ["_string", "_i", "_array", "_separator", "_mod_name", "_mod_version", "_index2", "_my_version"];
	_array     = _this select 0;
	_separator = _this select 1;
	_string    = ""; 
	_i         = 0;

	{
		_index = [_x, _all_modsID] call FUNCTION_FIND;
		if (_index >= 0) then {
			_mod_name    = _all_modsNAME select _index;
			_mod_size    = _all_modsSIZE select _index;
			_mod_version = _all_modsVER select _index;
			_verTXT      = Format ["%1", _mod_version];

			if (_separator != ";") then {
				// Show version difference
				_index2 = [_x, FWATCH_MODLISTID] call FUNCTION_FIND;
				if (_index2 >= 0) then {
					_my_version = (FWATCH_MODLISTCFG select _index2) select 0;

					if (_my_version < _mod_version) then {
						_verTXT = Format [MAINMENU_STR select 50, _my_version, _mod_version]
					} else {
						_mod_size = "";
						_index2   = -1;
					}
				};
				
				_string = Format["%1%2", _string, _mod_name];
				
				// Don't display version if it's 1 unless there's an update
				if (_mod_version != 1  ||  _index2 >= 0) then {
					_string = Format ["%1 %2", _string, _verTXT]
				};

				if (_mod_size != "") then {
					_string = Format ["%1 - %2", _string, _mod_size]
				};
				
				_string = Format ["%1%2", _string, _separator]
			} else {
				_string = Format["%1%2%3", _string, _mod_name, (if (_i < count _array-1) then {_separator} else {""})]
			}
		};

		_i = _i + 1
	} 
	forEach _array; 

	_string
};



FUNCTION_ARRAY2STRING = {
	private ["_string", "_i"]; 
	_string = ""; 
	_i      = 0;

	{
		_string = Format["%1%2%3", _string, _x, (if (_i<count (_this select 0)-1) then {_this select 1} else {""})];
		_i      = _i + 1
	} 
	forEach (_this select 0);

	_string
};



FUNCTION_CTRLSETTEXT = {
	{ctrlShow [_x,(_this select 1) != ""]} forEach [(_this select 0),(_this select 0)+1];
	ctrlSetText [(_this select 0)+1, _this select 1]
};



FUNCTION_SHOW_RED_TEXT = {
	// check if yellow is visible in the first place
	if (ctrlVisible ((_this select 0)-2)) then {
		// if so then hide yellow and show red if argument is true
		ctrlShow [(_this select 0)-2, !(_this select 1)]; 
		ctrlShow [_this select 0, _this select 1]
	} else {
		// if not then hide red
		ctrlShow [_this select 0, false]
	}
};



FUNCTION_IS_MOD_MISSING = {
	private ["_index", "_add_to_missing", "_assign", "_my_version", "_mod_name", "_mod_sizearray", "_index2", "_index3", "_j"];

	// _x is unique id of the missing mod. I need to find its index in the mod database so I can get name and version
	_index = [_x, _all_modsID] call FUNCTION_FIND;
	if (_index >= 0) then {
		_add_to_missing = true;
		_assign         = false;
		_my_version     = 0;
		_mod_name       = _all_modsNAME select _index;
		_mod_sizearray  = [0,0,0];

		// Look for the mod id in the user's mod list
		_index2 = [_x, FWATCH_MODLISTID] call FUNCTION_FIND;
		if (_index2 >= 0) then {
			_mod_name       = FWATCH_MODLIST select _index2;
			_my_version     = (FWATCH_MODLISTCFG select _index2) select 0;
			_add_to_missing = _my_version < (_all_modsVER select _index);				// If user has older version
		} else {
			_index3 = [_mod_name,FWATCH_MODLIST] call FUNCTION_FIND;
			if (_index3 >= 0) then {
				_assign = (FWATCH_MODLISTID select _index3) == "";		// If modfolder exists but not tagged
			}
		};
		
		if (_add_to_missing) then {
			_missing_mods           set [count _missing_mods          , _index     ];
			_missing_mods_id        set [count _missing_mods_id       , _x         ];
			_missing_mods_name      set [count _missing_mods_name     , _mod_name  ];
			_missing_mods_assign    set [count _missing_mods_assign   , _assign    ];
			_missing_mods_myversion set [count _missing_mods_myversion, _my_version];

			_j = -1; 
			while "_j=_j+1; _j<count _missing_mods_sizearray" do {
				_missing_mods_sizearray set [_j, (_missing_mods_sizearray select _j)+((_all_modsSIZEARRAY select _index) select _j)]
			}
		}
	}
};



FUNCTION_QUICKSORTM = {
	private ["_array", "_arrays", "_currentARR", "_hi", "_i", "_j", "_k", "_lo", "_mid", "_temp"];

	if (Format ["%1",QUICKSORT_RECURRENCE] == "scalar bool array string 0xfcffffef") then {
		QUICKSORT_RECURRENCE = 1;
		_arrays              = _this;
		_array               = _arrays select 0;
		_lo                  = 0;
		_hi                  = count _array -1;
		_i                   = _lo;
		_j                   = _hi;
	} else {
		QUICKSORT_RECURRENCE = QUICKSORT_RECURRENCE + 1;	
		_arrays              = _this select 0;
		_array               = _arrays select 0;
		_lo                  = _this select 1;
		_hi                  = _this select 2;
		_i                   = _lo;
		_j                   = _hi;
	};

	_mid = (_lo + _hi) / 2;
	_mid = _mid - (_mid mod 1);
	_mid = _array select _mid;
		
	while "_i <= _j" do {
		while "(_array select _i) < _mid" do {_i=_i+1};
		while "(_array select _j) > _mid" do {_j=_j-1};
			
		if (_i <= _j) then {
			_k = 0;
			while "_k < count _arrays" do {
				_currentARR = _arrays select _k;
				_temp       = _currentARR select _i;
				_currentARR set [_i, (_currentARR select _j)];
				_currentARR set [_j, _temp];
				_arrays set [_k, _currentARR];
				_k = _k + 1;
			};
			
			_i = _i + 1;
			_j = _j - 1;
		};
	};

	if (_lo < _j) then {[_arrays, _lo, _j] call FUNCTION_QUICKSORTM};
	if (_i < _hi) then {[_arrays, _i, _hi] call FUNCTION_QUICKSORTM};
		
	QUICKSORT_RECURRENCE = QUICKSORT_RECURRENCE - 1;
	if (QUICKSORT_RECURRENCE == 0) then {QUICKSORT_RECURRENCE=nil};
};



FUNCTION_FORMAT_GAME_TIME = {
	private ["_i", "_eventType", "_length", "_eventChecked","_eventBegan","_startTime","_difference","_endTime","_DiffToStart","_DiffToEnd","_formatPattern"];
	
	_now          = call loadFile ":info date";
	_i            = -1;
	_eventChecked = [];	// hold "daily" and "weekly" events here so they don't get double-checked

	while "_i=_i+1; _i < count _this" do {
		_eventType = (_this select _i) select 0;
		_startTime = (_this select _i) select 1;
		_length    = (_this select _i) select 2;
		
		/*
		event types:
		0 - single
		1 - weekly
		2 - daily
		*/
		
		_eventBegan  = false;
		if (_eventType==2  &&  _i in _eventChecked) then {_eventBegan=true};
		
		// localize time
		["minutes", (_now select 8) - (_startTime select 8), _startTime] call FLIB_MODIFYDATE;
		_startTime set [8, _now select 8];
		
		// if it's a recurrent event
		if (_eventType>0  &&  !(_i in _eventChecked)) then {
			_DiffToStart = [_startTime,_now,"subtract"] call FLIB_DATEDIFF;
			
			// have we passed event start date?
			if ("_x<0" count _DiffToStart > 0) then {
				_eventBegan = true;
				
				// if so then find nearest occurence
				_difference = 
				if (_eventType == 1) then {
					if ((_startTime select 3) >= (_now select 3)) then {
						(_startTime select 3) - (_now select 3)
					} else {
						7 - (_now select 3) + (_startTime select 3)
					}
				};
			
				_startTime set [0, _now select 0];
				_startTime set [1, _now select 1];
				_startTime set [2, _now select 2];
			
				["day", _difference, _startTime] call FLIB_MODIFYDATE
			};
		};
		
		
		// Find when game will end
		_endTime =+ _startTime;
		["minutes", _length, _endTime] call FLIB_MODIFYDATE;
		
		
		// What's the difference between now and game time range
		_DiffToStart = [_startTime,_now,"subtract"] call FLIB_DATEDIFF;
		_DiffToEnd   = [_endTime,  _now,"subtract"] call FLIB_DATEDIFF;

		// if the event has not ended
		if ("_x<0" count _DiffToEnd == 0) then {
			// if the event has started
			if ("_x<0" count _DiffToStart > 0) then {_playingNow=true};
			
			// Format date description
			_formatPattern = "@d MM 0h:0i";
			
			if (_eventBegan && _eventType>0) then {
				_formatPattern = Format ["@~%1~ 0h:0i", (if (_eventType==1) then {MAINMENU_STR select (51 + (_startTime select 3))} else {MAINMENU_STR select 58})];
			};
			
			// add event info to arrays
			_gameTimeDistance set [
				count _gameTimeDistance, 
				[_startTime, _now, "fraction"] call FLIB_DATEDIFFDAY
			];
			
			_gameTimeFormatted set [
				count _gameTimeFormatted, 
				Format ["%1 - %2", [_formatPattern,_startTime] call FLIB_FORMATDATE, ["@0h:0i",_endTime] call FLIB_FORMATDATE]
			];
			
			_gameTimeDates set [
				count _gameTimeDates,
				//["Y,m,d, ,h,i,s,l", _startTime] call FLIB_FORMATDATE
				_startTime
			];
			
			// if it's happening today
			if (([_startTime, _now, "ignorehour"] call FLIB_DATEDIFFDAY) < 1) then {
				_today_game_servers set [
					count _today_game_servers,
					_server_uniqueid
				]
			};
		} else {
			if (!(_i in _eventChecked)  &&  _eventType!=0) then {
				_eventChecked set [count _eventChecked, _i];
				
				// If this is a weekly event then try again next week
				// If this is a daily event then try again tomorrow
				["day", (if (_eventType==1) then {7} else {1}), _startTime] call FLIB_MODIFYDATE;
				
				_i = _i - 1
			};
		};
	};
	
	// If there's more than one valid game time then sort them
	if (count _gameTimeDistance > 1) then {
		[_gameTimeDistance, _gameTimeFormatted, _gameTimeDates] call FUNCTION_QUICKSORTM		
	}
};



FUNCTION_FIND_URL = {
	private ["_i", "_break", "_cut", "_results", "_array", "_find", "_array_item"];
	
	_i     = 0;
	_break = false; 

	while "!_break" do {
		if (_i >= count (_this select 1)) then {
			_i     = -1; 
			_break = true
		} else {
			// remove http://www.
			_array = call loadFile Format ["\:STRING DOMAIN url:%1", _this select 0];
			_find  = call loadFile Format ["\:STRING FIND text:%1find:%2", _this select 0, _array select 3];
			_cut   = loadFile Format ["\:STRING CUT start:%1  text:%2", _find select 0, _this select 0];
			
			// is domain inside other
			_array_item = (_this select 1) select _i;
			if (_array_item in [_array_item]) then {} else {_array_item = ((_this select 1) select _i) select 0};
			_results = call loadFile Format ["\:STRING FIND text:%1find:%2", _array_item, _cut];
			
			if (count _results > 0) then {
				_break = true
			} else {
				_i = _i + 1
			}
		}
	};

	_i
};



FUNCTION_GET_CLOSEST_GAME_TIME = {
	_server_uniqueid   = "";
	_server_game_times = [];
	
	call _x; 
	
	if (count _server_game_times > 0) then {
		_playingNow        = false; 
		_gameTimeDistance  = []; 
		_gameTimeFormatted = []; 

		_server_game_times call FUNCTION_FORMAT_GAME_TIME;

		// If there are valid game times then add first one to the list of closest games
		if (count _gameTimeDistance > 0) then {
			_closest_game_times set [
				count _closest_game_times, 
				(if (_playingNow) then {0} else {_gameTimeDistance select 0})
			]
		} else {
			// If all game times have elapsed then remove server from the list
			_all_servers set [_i, "<null>"];
			//_all_servers = _all_servers - ["<null>"];
			
			_all_serverNames set [_i, "<null>"];
			//_all_serverNames = _all_serverNames - ["<null>"]
			
			_all_serverID set [_i, "<null>"];
			_all_serverURL set [_i, "<null>"];
		};
	} else {
		_closest_game_times set [count _closest_game_times, -1];
		_persistent_servers set [count _persistent_servers, _server_uniqueid]
	};
	
	_i = _i + 1
};



FUNCTION_SERVERS_TO_LISTBOX = {
	if ((_closest_game_times select _i) != -1) then {	//if not a persistent server
		if ((_closest_game_times select _i) == 0) then {
			if (!_nowLabel) then {
				_nowLabel = true;
				lbSetColor [6657, lbAdd [6657, MAINMENU_STR select 59], _color_fireenginered]
			}
		} else {
			if (_x in _today_game_servers) then {
				if (!_todayLabel) then {
					_todayLabel = true;
					lbSetColor [6657, lbAdd [6657, MAINMENU_STR select 60], _color_sandybrown]
				}
			} else {
				if (!_upcomingLabel) then {
					_upcomingLabel = true;
					lbSetColor [6657, lbAdd [6657, MAINMENU_STR select 61], _color_sand]
				}
			}
		};
		
		private ["_entry", "_index"];
		_index = [_all_serverID select _i, GS_SERVER_STATUS select 0] call FUNCTION_FIND;
		_entry = lbAdd [6657, Format ["%1%2", (if (_index>=0) then {Format ["(%1) ",((GS_SERVER_STATUS select 1) select _index) select 1]} else {""}), _all_serverNames select _i]]; 
		lbSetData  [6657, _entry, Format ["%1",_i]];
		lbSetValue [6657, _entry, 201]; 
	};
	
	// After installation display that server options
	if (_x == _jump_to_server) then {
		_data = Format ["%1",_i];
		goto "DisplayServer"
	};
	
	_i = _i + 1
};



FUNCTION_GET_EXECUTE_PARAMS = {
	private ["_string", "_string2", "_ok", "_Input", "_add_param_name", "_modifier"];
	_string  = "";
	_string2 = "";
	
	if (_server_uniqueid != "mod") then {
		_modifier = if (_server_encrypted) then {"e"} else {""};

		_string = Format ["-serveruniqueid=%1 -%2connect=", _server_uniqueid, _modifier] + _server_ip;
		
		if (_server_port != "") then {_string=_string+Format[" -%1port=",_modifier]+_server_port};
		if (_server_password != "") then {_string=_string+Format[" -%1password=",_modifier]+_server_password};
		if (_server_equalModReq) then {_string=_string+" -serverequalmodreq=true"};
		if (_run_voice_program) then {_string=_string+Format[" -%1voice=",_modifier]+(_server_voice select 1)};
		if (_server_maxcustombytes != "") then {_string=_string+Format[" -maxcustom=%1 ""-plrname=%2""",_server_maxcustombytes, FWATCH_USERNAME]};
		
		_add_param_name = true;
		_string2 = "";

		{
			if (_add_param_name) then {
				_add_param_name = false;
				_string         = _string  + " -mod=";
				_string2        = _string2 + " -modid=";
			} else {
				_string         = _string  + ";";
				_string2        = _string2 + ";";
			};
			
			_index = [_x, _all_modsID] call FUNCTION_FIND;
			if (_index >= 0) then {				
				_string  = _string  + (_all_modsNAME select _index);
				_string2 = _string2 + _x;
			}
		}
		forEach _server_modfolders;
	} else {
		_string = "-mod=" + (_missing_mods_name select 0);
	};
	
	_string + _string2
};



FUNCTION_WRITE_INSTALL = {
	private ["_ids", "_names"];
	_ids   = "-installid=";
	_names = "-installdir=";
	
	_i = 0;
	{
		_ids   = _ids   + (if (_i>0) then {","} else {""}) + (_missing_mods_id   select _i);
		_names = _names + (if (_i>0) then {","} else {""}) + (_missing_mods_name select _i);
		_i = _i + 1;
	} 
	forEach _missing_mods;
	
	_ids + " " + _names
};



FUNCTION_BUILD_QUERY_STRING = {
	private ["_output", "_i", "_mod", "_ver"];
	_output = (if (_server_uniqueid=="mod") then {_access_code_mod} else {_access_code}) call FUNCTION_FORMAT_PASSWORD_STRING;
	
	if ((_this select 0) == "modcheck") then {
		_mod = "";
		_ver = "";
		_i   = -1;

		while "_i=_i+1; _i<count (_this select 1)" do {
			_index = [(_this select 1) select _i, FWATCH_MODLISTID] call FUNCTION_FIND;
			
			if (_index >= 0) then {
				_mod = _mod + (if (_mod=="") then {""} else {","}) + (FWATCH_MODLISTID select _index);
				_ver = _ver + (if (_ver=="") then {""} else {","}) + Format["%1",(FWATCH_MODLISTCFG select _index) select 0];
			}
		};
		
		if (_mod != "") then {
			_output = _output + "&mod=" + _mod + "&ver=" + _ver;
		}
	};

	if ((_this select 0) == "modinstall") then {
		_mod = "";
		_ver = "";
		_i   = -1;
		
		while "_i=_i+1; _i<count (_this select 1)" do {
			_mod = _mod + (if (_mod=="") then {""} else {","}) + ((_this select 1) select _i);
			_ver = _ver + (if (_ver=="") then {""} else {","}) + Format["%1",((_this select 2) select _i)];
		};
		
		_output = _output + "&mod=" + _mod + "&ver=" + _ver;
	};
	
	if ((_this select 0) == "allusermods") then {
		_mod    = "";
		_ver    = "";
		_output = _output + " --post-data=";
		_i      = 0;
		
		{
			if (_x != "") then {
				_mod = _mod + (if (_mod=="") then {""} else {","}) + _x;
				_ver = _ver + (if (_ver=="") then {""} else {","}) + Format["%1",(FWATCH_MODLISTCFG select _i) select 0];
			};
			_i = _i + 1
		} 
		forEach FWATCH_MODLISTID;
		
		_output = _output + "&mod=" + _mod + "&ver=" + _ver;
	};

	_output
};



FUNCTION_FORMAT_FILESIZE = {
	private ["_roundToTenths", "_index", "_size"];
	
	_roundToTenths = "private [""_fraction""];_this=_this-(_this mod 0.001); _fraction=(_this mod 0.01);_this=_this-_fraction;if (_fraction>0.004999) then {_this=_this+0.01};_fraction=(_this mod 0.1);_this=_this-_fraction;if (_fraction>0.049999) then {_this=_this+0.1};_this";
	_index         = 2;

	if ((_this select 2) == 0) then {_index=1};
	if ((_this select 1) == 0) then {_index=0};
	
	_size = _this select _index; 
	if (_index > 0) then {_size=_size+(_this select (_index-1))/1024}; 
		
	Format ["%1 %2", _size call _roundToTenths, ["B","KB","MB"] select _index]
};



FUNCTION_CUSTOM_SIZE = {
	private ["_text", "_server_limit"];
	_text = "";
	
	if (count _server_maxcustomfilesize > 0) then {
		_too_big = (((FWATCH_CUSTOMSIZE select 2) * 1024 * 1024) + ((FWATCH_CUSTOMSIZE select 1) * 1024) + (FWATCH_CUSTOMSIZE select 0)) > (((_server_maxcustomfilesize select 2) * 1024 * 1024) + ((_server_maxcustomfilesize select 1) * 1024) + (_server_maxcustomfilesize select 0));
		
		_server_limit =
		if ("_x>0" count _server_maxcustomfilesize > 0) then {
			_server_maxcustomfilesize call FUNCTION_FORMAT_FILESIZE
		} else {
			MAINMENU_STR select 62
		};
	
		_text = 	
		if (_too_big) then {
			Format ["%1 - %2 (%3)", _server_limit, FWATCH_CUSTOMFILE, FWATCH_CUSTOMSIZE call FUNCTION_FORMAT_FILESIZE]
		} else {
			_server_limit
		};
	};
	
	_text
};



FUNCTION_MSG_LB = {
	lbAdd [6657, _this];
	if (lbSize 6657 >= 10) then {
		lbSetCurSel [6657, lbAdd [6657, ""]]
	}
};



FUNCTION_REFRESH_MODLIST = {
	_ok = call loadFile ":file modlist";
	if (_ok select 0) then {
		FWATCH_MODLIST      = _ok select 4; 
		FWATCH_MODLISTID    = _ok select 5;
		FWATCH_MODLISTCFG   = _ok select 6; 
		FWATCH_CUSTOMFILE   = _ok select 7; 
		FWATCH_CUSTOMSIZE   = _ok select 8; 
		FWATCH_MODLISTHASH  = _ok select 9;
		FWATCH_USERNAME     = _ok select 10;
	} else {
		titleText [((MAINMENU_STR select 63)+(_ok select 3)),"PLAIN DOWN",0.1]
	}
};



FUNCTION_DOWNLOAD_INFO = {
	_title = _this select 0;
	_text  = _this select 1;

	lbSetValue [6657, lbAdd [6657,"["+_title+"]"], 0];
	lbSetCurSel [6657, (lbSize 6657)-1];

	"ctrlShow [_x,false]" forEach _serverDialog;
	"ctrlShow [_x,true ]" forEach [6460, 6463];
	
	if (_text != "compareversion") then {
		ctrlSetText [6463, _text];
	} else {
		ctrlSetText [6463, Format [MAINMENU_STR select 75, GS_VERSION, GS_MY_VERSION]];
	};
	
	lbSetValue [6657, lbAdd [6657,MAINMENU_STR select 64], 223];
};



FUNCTION_READ_DOWNLOADED_FILE = {
	private ["_error", "_fileContent","_fileIntegrity","_error_message","_file_name"];
	_error         = !(GS_DOWNLOAD_RESULT select 0);
	_error_message = MAINMENU_STR select 15;
	_file_name     = "downloadLog.txt";

	if (GS_DOWNLOAD_RESULT select 0) then {
		_fileContent   = loadFile "\:IGSE LOAD  mode:execute  file:..\fwatch\tmp\schedule\schedule.sqf";
		_fileIntegrity = call _fileContent;

		if (Format ["%1",_fileIntegrity] != "true") then {
			_error = true;
			
			if (_fileContent != "") then {
				_error_message = MAINMENU_STR select 18;
				_file_name     = "schedule.sqf";
			};
		};
	};
	
	if (_error) then {
		if ((GS_DOWNLOAD_RESULT select 1) == 5) then {
			if ((GS_DOWNLOAD_RESULT select 2) in [5,186]) then {
				GS_DOWNLOAD_RESULT set [3, (GS_DOWNLOAD_RESULT select 3)+"\n\nCheck if firewall or antivirus aren't blocking\n\nGo to fwatch.exe properties and set it to run as an administrator"];
			};
			
			[_error_message, GS_DOWNLOAD_RESULT select 3] call FUNCTION_DOWNLOAD_INFO;
			goto "ResetLMB";
		} else {
			if (_mirror<count (_all_url select _i)-1) then {
				lbSetValue [6657, lbAdd [6657,"["+_error_message+"]"], 0];
				_mirror = _mirror + 1;
				goto _this;
			} else {
				[_error_message,(GS_DOWNLOAD_RESULT select 3)+"\n\n"+(loadFile Format ["\:IGSE LOAD  mode:execute  file:..\fwatch\tmp\schedule\%1",_file_name])] call FUNCTION_DOWNLOAD_INFO;
				goto "ResetLMB";
			};		
		};
	};
};



FUNCTION_VOICE_URL_FIND = {
	private ["_i", "_found"];

	if (count _server_voice > 1) then {
		_i     = -1;
		_found = false;
		
		while "_i=_i+1; _i<count GS_VOICE && !_found" do {
			_positions = call loadFile Format ["\:STRING FIND text:%1find:%2", _server_voice select , _voice_url select _i];
			
			if (count _positions > 0) then {
				_voice_index = _i;
				_found       = true;
			}
		}
	}
};



FUNCTION_BUILD_PREVIEW_LINK = {
	private ["_url", "_id_list", "_ver_list", "_id_string", "_ver_string", "_i", "_positions"];
	
	_url          = _this select 0;
	_id_list      = _this select 1;
	_ver_list     = _this select 2;
	_id_string    = "";
	_ver_string   = "";
	_i            = -1;
	
	_positions = call loadFile ("\:STRING FIND find:/text:"+_url);
	if (count _positions > 0) then {
		_url = loadFile (Format ["\:STRING CUT end:%1 text:", _positions select (count _positions-1)] + _url);
	};
	
	_i=-1;
	while "_i=_i+1; _i<count _id_list" do {		
		_id_string  = _id_string  + (if (_id_string=="" ) then {""} else {","}) + (_id_list select _i);
		_ver_string = _ver_string + (if (_ver_string=="") then {""} else {","}) + (if (_i >= count _ver_list) then {"0"} else {Format ["%1",_ver_list select _i]});
	};
	
	_url + "/show.php?onlychangelog=1&mod=" + _id_string + "&ver=" + _ver_string
};



FUNCTION_STRINGTABLE = {
	call FLIB_CURRENTLANG;
	
	if (CURRENT_LANGUAGE == "Polish") then {
		MAINMENU_STR = [
			"Interfejs niedost�pny. Sprawd� sw�j bin\resource.cpp.",	//0
			"Plik bin\resource.cpp jest przestarza�y. �ci�gnij now� wersj� OFP Aspect Ratio",	//1
			"ROZK�AD ROZGRYWEK",	//2
			"SERWER PRZEGL�DARKI GIER",	//3
			"Jest ju� w��czony!",		//4
			"Napisz has�a do prywatnych serwer�w",	//5
			"[Uruchom bez mod�w]",		//6
			"[Dodaj nowy]",				//7
			"Nie ma nic do zapisania!",	//8
			"Jest ju� na li�cie!", //9
			"[Prosz� czeka�]",	//10
			"[�ci�gnij %1]",	//11
			"[Otw�rz zaproszenie na %1]",	//12
			"Nie uda�o si� utworzy� fwatch\tmp\schedule\n%1\n\nUruchom gr� jako administrator",	//13
			"[Sprawdzanie aktualizacji]",	//14
			"Nie uda�o si� pobra�",			//15
			"[Pobieranie planu]",	//16
			"[Przetwarzanie danych]",	//17
			"Niepoprawne dane",		//18
			"[Brak serwer�w]",		//19
			"Niepoprawna wersja planu",	//20
			"[�ci�ganie loga %1]",	//21
			"Nie uda�o si� pobra� loga\n%1",	//22
			"[Uk�adanie serwer�w]",	//23
			"[Odwo�aj zaplanowane pod��czenie]",	//24
			"[Poka� prywatne gry]",	//25
			"[Do��cz o czasie]",	//26
			"[Do��cz]",	//27
			"[�ci�gnij wymagane mody %1]",	//28
			"[Poka� zmiany w modach]",		//29
			"[Wejd� na stron� serwera]",		//30
			"[Dodatkowe opcje uruchamiania]",	//31
			"[Cofnij]",	//32
			"[Uruchom %1]",	//33
			"[Bez]",	//34
			"",	//35
			"[Przerwij]",	//36
			"Ju� masz folder %1. Czy wolisz:\n\n- zainstalowa� now� kopi� (bezpieczna opcja; nazwa obecnego modu zostanie zmieniona)\n\nLUB\n\n- Oznaczy� obecny mod jako wersj� %2 (szybsza opcja; dane moda b�d� podlega� aktualizacjom)",	//37
			"[�ci�gnij now� kopi�]",	//38
			"[Oznacz aktualn�]",		//39
			"Nie uda�o si� uruchomi� fwatch\data\addonInstaller.exe\n%1",	//40
			"Nie uda�o si� utworzy� pliku\n%1",	//41
			"[Uruchom ponownie po sko�czeniu: %1]",		//42
			"TAK",	//43
			"NIE",	//44
			"\n\n\nFwatch nie widzi instalatora.\nZignoruj ten komunikat je�li wida� post�p instalacji.\n\nW innym przypadku sprawd� w menedrze�e zada� czy jest addonInstaller.exe; przerwij instalacj�; zobacz fwatch\data\addonInstallerLog.txt",	//45
			"Serwer wymaga dok�adnie tych samych mod�w wi�c argument -mod zostanie pomini�ty",	//46
			"Gra zostanie uruchomiona o\n%1\n\ni pod�aczy si� automatycznie do\n%2",	//47
			"[Aktualizuj %1]",	//48
			"Jest dostp�pna aktualizacja %1. Musisz uaktualni�.\n\n\n       Nowa wersja:\n           %2\n\n       Twoja wersja:\n           %3\n\n\nDwuklik na opcj� �eby zacz�� proces. Instalator zamknie gr�, �ci�gnie now� wersj�, zamieni dane i uruchomi gr� ponownie.", //49
			"%1 do %2",	//50
			"Co niedziel�",		//51		
			"Co poniedzia�ek",		//52	
			"Co wtorek",	//53		
			"Co �rod�",	//54	
			"Co czwartek",	//55
			"Co pi�tek",		//56
			"Co sobot�",	//57	
			"Codziennie",	//58
			"==Teraz==",	//59
			"==Dzisiaj==",	//60
			"==Wkr�tce==",	//61
			"niedozwolone",	//62
			"B��D:\n",	//63
			"[Kontynuuj]",	//64
			"Wersja:",	//65
			"Mody:",	//66
			"W�asne pliki:",	//67
			"Rozk�ad:",	//68
			"Rozmowy:",		//69
			"J�zyki:",	//70
			"Po�o�enie:",	//71
			"Strona:",		//72
			"Uwagi:",		//73
			"Wpisz tekst:",	//74
			"�ci�gnij wersj�:\n           %1\n\nTwoja wersja:\n           %2",	//75
			"Nie mo�esz zaktualizowa� %1 bo jest w��czony.\n\nCzy chcia�by� uruchomi� gr� bez mod�w?",	//76
			"Nie mo�esz zaktualizowa� %1 bo s� w��czone.\n\nCzy chcia�by� uruchomi� gr� bez mod�w?",	//77
			"Plan rozgrywek",	//78
			"Serwer przegl�darki gier",	//79		
			"nowej wersji testowej Fwatch 1.16",	//80
			"nowej wersji Resource.cpp",		//81
			"[�ci�gnij mody]",				//82
			"Dost�pne aktualizacje",		//83
			"Pobierz nowy mod",				//84
			"[Zamknij Okno]",				//85
			"Jest dostp�pna aktualizacja nowej wersji testowej Fwatch 1.16",				//86
			"Dostp�pne aktualizacje mod�w: %1",		//87
			"[Do��cz po sko�czeniu: %1]",		//88
			"[Poka� prywatne mody]",			//89
			"Napisz has�a do prywatnych mod�w",	//90
			"[Wyszukaj]",		//91
			"Wpisz nazw� moda lub kategorii (rozszerzenie; zbi�raddon�w; uzupe�nienie; zbi�rmisji; narz�dzia)",	//92
			"Typ:",			//93
			"Do pobrania:",		//94
			"Doda�:",		//95
			"Opis:",		//96
			"wymusza oryginaln� nazw�",	//97
			"niezgodny z gr� sieciow�",	//98
			"rozszerzenie",		//99
			"zbi�r addon�w",		//100
			"uzupe�nienie",		//101
			"zbi�rmisji",		//102
			"narz�dzia",			//103
			"Opcje pod prawym przyciskiem lub spacj�",		//104
			"[Dodaj do kolejki]",	//105
			"Brak po��czenia",	//106
			"Status pod prawym przyciskiem lub spacj�",		//107
			"Ciagle",	// 108
		];
	};
	
	if (CURRENT_LANGUAGE == "Russian") then {
		MAINMENU_STR = [
			"������ ��� �������� ����������� ����. ��������� bin\resource.cpp",		//0
			"���� bin\resource.cpp �������. ��������� ����� ������ ���� OFP Aspect Ratio",		//1
			"���������� ���",		//2
			"������ ������",		//3
			"������� �����!",		//4
			"������� ������, ����� ����������� ����",		//5
			"[������ ��� �����]",		//6
			"[�������� �����]",		//7
			"��� ������ ��� ����������!",		//8
			"��� ���� � ������!",		//9
			"[����������, ���������]",		//10
			"[������� %1]",		//11
			"[��������������� ������ %1]",		//12
			"������ ��� �������� ����� fwatch\tmp\schedule\n%1\n\n��������� ���� �� ����� ��������������",		//13
			"[����� ����������]",		//14
			"������ ��� ��������",		//15
			"[�������� ����������]",		//16
			"[���������� ����������]",		//17
			"������ ��� ����������",		//18
			"[��� ��������]",		//19
			"[�������� ������ ����������]",		//20
			"[�������� ������� %1]",		//21
			"������ ��� ��������\n%1",		//22
			"[���������� ����������]",		//23
			"[�������� �������������� �����������]",		//24
			"[�������� ������� �������]",		//25
			"[������������ �������������]",		//26
			"[������������]",		//27
			"[������� ���� %1]",		//28
			"[����������� ������� ���������]",		//29
			"[�������� ���-����]",		//30
			"[�������������� ��������� �������]",		//31
			"[�����]",		//32
			"[� %1]",		//33
			"[��� %1]",		//34
			"",		//35
			"[������]",		//36
			"��� ������� ����� � ����� %1. \n\n- ��������� ����� ����� (���������� �����; ������� ����� ����� �������������)\n\n���\n\n- �������� ������������� ������ %2 � ������� ����� (������� �����; ��� ����� ���� ������� � ����������)?",		//37
			"[��������� ����� �����]",		//38
			"[�������� �������������]",		//39
			"������ ��� ������� fwatch\data\addonInstaller.exe\n%1",		//40
			"������ ��� �������� �����\n%1",		//41
			"[���������� ����� ���������: %1]",		//42
			"���",		//43
			"����",		//44
			"\n\n\nFwatch �� ��������� ������� ���������.\nIf the progress is still going then ignore this message.\n\nOtherwise open Task Manager and check if addonInstaller.exe is running; abort installation; see addonInstallerLog.txt",		//45
			"���������� ���������� ���� ��� ����������� (�������� -mod ��� ������� �� �����������)",		//46
			"���� ����� ������������ �\n%1\n\n����� ������������ � �������\n%2",		//47
			"[�������� %1]",		//48
			"�������� %1. ��������, ����� ����������.\n\n\n       ����� ������:\n           %2\n\n       ������� ������:\n           %3\n\n\n������� ��� ����, ����� ��������� ����������. ��� ���������� ���� ��������������.",		//49
			"%1 � %2",		//50
			"������ �����������",		//51
			"������ �����������",		//52
			"������ �������",		//53
			"������ �����",		//54
			"������ �������",		//55
			"������ �������",		//56
			"������ �������",		//57
			"������ ����",		//58
			"==�������==",		//59
			"==C������==",		//60
			"==�������==",		//61
			"���������",		//62
			"������:\n",		//63
			"[����������]",		//64
			"������:",		//65
			"����:",		//66
			"����. ����:",		//67
			"����������:",		//68
			"�����. ���:",		//69
			"�����:",		//70
			"������:",		//71
			"���-����:",		//72
			"����������:",		//73
			"������� �����:",		//74
			"��������� ������:\n           %1\n\n���� ������:\n           %2",		//75
			"���������� �������� %1, ���� �� �������.\n\n������������� ����?",		//76
			"���������� �������� %2, ���� ��� ��������.\n\n������������� ����?",	//77
			"���������� ���",		//78
			"������ ������",	//79		
			"����� �������� ������ Fwatch 1.16",	//80
			"����� ������ Resource.cpp",		//81
			"[������� ����]",		//82
			"��������",				//83
			"�������� �����",		//84
			"[������� ����]",		//85
			"�������� ����� �������� ������ Fwatch 1.16",				//86
			"�������� ����: %1",	//87
			"[������������ ����� ���������: %1]",		//88
			"[�������� ������� ����]",			//89
			"������� ������, ����� ����������� ����",	//90
			"[�����]",		//91
			"������� �������� ���� ��� �������� ��������� (������; ������; ����������; ������; �����������)",		//92
			"���:",			//93
			"�������:",		//94
			"��������:",		//95
			"��������:",		//96
			"�������� ����������� ��������",	//97
			"������������ � ������� �����",	//98
			"������",		//99
			"������",		//100
			"����������",		//101
			"������",		//102
			"�����������",			//103
			"�������� ������ ������� ��� ������ ��� ����������",		//104
			"[�������� � �������]",	//105
			"Offline",	//106
			"Right-click or space for status",	//107
			"Persistent"	//108
		];
	};
	
	if (Format["%1", count MAINMENU_STR] == "scalar") then {
		MAINMENU_STR = [
			"Failed to create dialog. Verify your bin\resource.cpp.",	//0
			"File bin\resource.cpp is outdated. Download new OFP Aspect Ratio pack version",	//1
			"GAME SCHEDULE",	//2
			"MASTER SERVER",	//3
			"This is the current one!",		//4
			"Type in password(s) to show private game(s)",	//5
			"[Start Without Mods]",		//6
			"[Add New]",				//7
			"There's nothing to save!",	//8
			"It's already on the list!", //9
			"[Please wait]",	//10
			"[Download %1]",	//11
			"[Open %1 Invite]",	//12
			"Failed to create directory fwatch\tmp\schedule\n%1\n\nSet the game to run as admin",	//13
			"[Checking for updates]",	//14
			"Download Failed",			//15
			"[Downloading schedule]",	//16
			"[Reading data]",	//17
			"Invalid Data",		//18
			"[No servers]",		//19
			"Incorrect schedule version",	//20
			"[Downloading logo %1]",	//21
			"Failed to download logo\n%1",	//22
			"[Sorting game times]",	//23
			"[Cancel Auto Connect]",	//24
			"[Show Private Servers]",	//25
			"[Auto-Connect on Time]",	//26
			"[Connect]",	//27
			"[Download Mods %1]",	//28
			"[View Changelog]",		//29
			"[Visit Website]",		//30
			"[Extra Startup Parameters]",	//31
			"[Back]",	//32
			"[With %1]",	//33
			"[Without]",	//34
			"",	//35
			"[Abort]",	//36
			"You already have %1 modfolder. Would you like to:\n\n- Install a new copy (safer option; current one will be renamed)\n\nOR\n\n- Tag the existing one as version %2 (faster option; mod will be a subject to future modifications)",	//37
			"[Download New]",	//38
			"[Assign ID]",		//39
			"Failed to launch fwatch\data\addonInstaller.exe\n%1",	//40
			"Failed to generate a file\n%1",	//41
			"[Restart when done: %1]",		//42
			"ON",	//43
			"OFF",	//44
			"\n\n\nFwatch can't detect installator.\nIf the progress is still going then ignore this message.\n\nOtherwise open Task Manager and check if addonInstaller.exe is running; abort installation; see addonInstallerLog.txt",	//45
			"Server requires exact mods so the -mod parameter will be ignored",	//46
			"Game will be restarted at\n%1\n\nin order to connect to\n%2",	//47
			"[Update %1]",	//48
			"There is a %1 available. You must update in order to continue.\n\n\n       New version:\n           %2\n\n       Your version:\n           %3\n\n\nDouble-click on the option to start the process. Update program will close the game, download the patch, replace files and then start the game again.", //49
			"%1 to %2",	//50
			"Every Sunday",		//51		
			"Every Monday",		//52	
			"Every Tuesday",	//53		
			"Every Wednesday",	//54	
			"Every Thursday",	//55
			"Every Friday",		//56
			"Every Saturday",	//57	
			"Daily",	//58
			"==Now==",	//59
			"==Today==",	//60
			"==Upcoming==",	//61
			"none allowed",	//62
			"ERROR:\n",	//63
			"[Continue]",	//64
			"Version:",	//65
			"Modfolders:",	//66
			"Custom File:",	//67
			"Game time:",	//68
			"VOIP:",		//69
			"Languages:",	//70
			"Location:",	//71
			"Website:",		//72
			"Message:",		//73
			"Enter Text:",	//74
			"Downloaded version:\n           %1\n\nYour version:\n           %2",	//75
			"You cannot update %1 while you have it loaded.\n\nWould you like to restart the game?",	//76
			"You cannot update %1 while you have them loaded.\n\nWould you like to restart the game?",	//77
			"Game Schedule",	//78
			"Master Server",	//79		
			"new test version of Fwatch 1.16",	//80
			"new Resource.cpp version",		//81
			"[Download Mods]",				//82
			"Available Updates",			//83
			"Install New",					//84
			"[Close Window]",				//85
			"There is a new test version of Fwatch 1.16 available",				//86
			"Available mod updates: %1",	//87
			"[Connect when done: %1]",		//88
			"[Show Private Mods]",			//89
			"Type in password(s) to show private mod(s)",	//90
			"[Search]",		//91
			"Type mod or category name (replacement; addonpack; supplement; missionpack; tools)",		//92
			"Type:",			//93
			"Download:",		//94
			"Added by:",		//95
			"Description:",		//96
			"force original name",	//97
			"multiplayer incompatible",	//98
			"replacement",		//99
			"addonpack",		//100
			"supplement",		//101
			"missionpack",		//102
			"tools",			//103
			"Right-click or space for options",		//104
			"[Add to Queue]",	//105
			"Offline",	//106
			"Right-click or space for status",	//107
			"Persistent"	//108
		];
	};
	
	MAINMENU_STR_MODCAT = [
		["replacement","rozszerzenie","������"],
		["addon pack","zbi�r addon�w","������"],
		["supplement","uzupe�nienie","����������"],
		["mission pack","zbi�r misji","������"],
		["tools","narz�dzia","�����������"]
	];
};



FUNCTION_FORMAT_PASSWORD_STRING = {
	private ["_output", "_values", "_array", "_i"];
	_output = "";
	_values = "";
	_i      = -1;
	_array  = call loadFile Format ["\:STRING TOKENIZE  text:%1delimiter: ", _this];
	
	while "_i=_i+1; _i<count _array" do {
		_values = _values + (if (_i==0) then {""} else {","}) + (_array select _i);
	};
	
	if (_values != "") then {
		_output = _output + "&password=" + _values;
	};
	
	_output
};



FUNCTION_LBADD = {
	private ["_entry"];
	if (!_silent_mode) then {		
		_entry = lbAdd [6657, _this select 0];
		lbSetValue [6657, _entry, _this select 1];
		lbSetColor [6657, _entry, _this select 2];
	}
};



FUNCTION_SHOW_MOD_INFO = {
	private ["_index", "_type", "_description"];
	_index = _this select 0;
	_type  = _this select 1;
	
	if (_index >= 0) then {
		"ctrlShow [_x,false]" forEach _serverDialog;
		"ctrlShow [_x,true ]" forEach [6460, 6461, 6462];
	
		ctrlSetText [6462, _all_modsNAME select _index];
		
		_description = MAINMENU_STR select (99 + (_all_modsTYPE select _index));
		if (_all_modsFORCENAME select _index) then {_description=Format["%1\n%2",_description, MAINMENU_STR select 97]};
		if (!(_all_modsISMP select _index)) then {_description=Format["%1\n%2",_description, MAINMENU_STR select 98]};
		
		[6480, _description] call FUNCTION_CTRLSETTEXT;
		ctrlSetText [6480, MAINMENU_STR select 93];
		
		[6530, _all_modsADDEDBY select _index] call FUNCTION_CTRLSETTEXT;
		ctrlSetText [6530, MAINMENU_STR select 95];
		
		[6550, _all_modsDESCRIPTION select _index] call FUNCTION_CTRLSETTEXT;
		ctrlSetText [6550, MAINMENU_STR select 96];
		
		if ((_all_modsDESCRIPTION select _index) != "") then {
			[6540, (call loadFile Format ["\:STRING DOMAIN url:%1", (_all_modsWEBSITE select _index)]) select 3] call FUNCTION_CTRLSETTEXT
		};
		
		ctrlShow [6464, true];
		ctrlSetText [6464, MAINMENU_STR select 104];
			
		_index_local = [_all_modsID select _index, FWATCH_MODLISTID] call FUNCTION_FIND;
		
		// Showing info for users mods
		if (_type == "local") then {
			if (_index_local >= 0) then {
				[6470, Format["%1",(FWATCH_MODLISTCFG select _index_local) select 0]] call FUNCTION_CTRLSETTEXT;
				
				if (((FWATCH_MODLISTCFG select _index_local) select 0) < (_all_modsVER select _index)) then {
					[6472, true] call FUNCTION_SHOW_RED_TEXT;
					[6490, _all_modsSIZE select _index] call FUNCTION_CTRLSETTEXT;
					ctrlSetText [6490, MAINMENU_STR select 94];
				}
			};
		// Showing info for mods from the db
		} else {
			_description = Format ["%1",_all_modsVER select _index];
			
			if (_index_local >= 0) then {
				if (((FWATCH_MODLISTCFG select _index_local) select 0) != (_all_modsVER select _index)) then {
					_description = Format ["%1 --> %2", (FWATCH_MODLISTCFG select _index_local) select 0, _all_modsVER select _index];
				}
			};
			
			[6470, _description] call FUNCTION_CTRLSETTEXT;
			[6490, _all_modsSIZE select _index] call FUNCTION_CTRLSETTEXT;
			ctrlSetText [6490, MAINMENU_STR select 94];
		};
		
		// Logo
		["logo_mod", "schedulemodlogo.bin", _all_modsLOGO select _index, _all_modsID select _index, _all_modsLOGOHASH select _index, _all_modsNAME select _index, lbCurSel 6657] call FUNCTION_DISPLAY_LOGO;
	} else {
		"ctrlShow [_x,false]" forEach _serverDialog;
	}
};



FUNCTION_DISPLAY_LOGO = {
	private ["_img_folder", "_database", "_url", "_record_id", "_global_hash", "_record_title", "_cursel", "_extension", "_logohash", "_download"];
	_img_folder   = _this select 0;
	_database     = _this select 1;
	_url          = _this select 2;
	_record_id    = _this select 3;
	_global_hash  = _this select 4;
	_record_title = _this select 5;
	_cursel       = _this select 6;
	
	ctrlSetText [6461, ""];

	// Read local record
	_extension = "";
	_logohash  = "";
	call loadFile Format ["\:IGSE DB  file:..\fwatch\tmp\schedule\%1  read:%2", _database, _record_id];
	
	// If logo exist at all
	if (_global_hash != "") then {
		_download = true;
		
		// does it exist locally
		if (_global_hash == _logohash) then {
			_ok = call loadFile Format ["\:IGSE NEW  mode:check  file:..\fwatch\tmp\schedule\%1\%2.%3", _img_folder, _record_id, _extension];
			if (_ok select 0) then {
				ctrlSetText [6461, Format ["..\fwatch\tmp\schedule\%1\%2.%3", _img_folder, _record_id, _extension]];
				_download = false;
			}
		} else {
			loadFile Format ["\:IGSE NEW  file:..\fwatch\tmp\schedule\%1\%2.%3  mode:delete", _img_folder, _record_id, _extension];
		};
		
		// if not then download it
		if (_download) then {
			["download", _img_folder, _database, _url, _record_id, _global_hash, _record_title, _cursel] exec "..\fwatch\data\MainMenu.sqs"
		}
	} else {
		// remove it locally
		if (_logohash != "") then {
			loadFile Format ["\:IGSE DB  file:..\fwatch\tmp\schedule\%1  key:%2write:_extension="""";_logohash="""";", _database, _record_id];
		}
	}
};



FUNCTION_GET_SERVER_STATUS_NAME = {
	private ["_output"];
	_output = MAINMENU_STR select 106;
	if (_this >= 1 && _this <= 14) then {
		_output = localize ([
			"",
			"STR_SESSION_CREATE",
			"STR_SESSION_CREATE",
			"STR_SESSION_CREATE",
			"STR_SESSION_EDIT",
			"STR_SESSION_WAIT",
			"STR_SESSION_WAIT",
			"STR_SESSION_SETUP",
			"STR_SESSION_SETUP",
			"STR_SESSION_DEBRIEFING",
			"STR_SESSION_DEBRIEFING",
			"STR_SESSION_SETUP",
			"STR_SESSION_SETUP",
			"STR_SESSION_BRIEFING",
			"STR_SESSION_PLAY"
		] select _this);
	};
	_output
};