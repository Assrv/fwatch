// -----------------------------------------------------------------
// FILE OPERATIONS
// -----------------------------------------------------------------

case C_FILE_EXISTS:
{ // Return 1 if name exists, else 0.
	if(argument_num < 3) {
		QWrite("ERROR: Not enough parameters");
		break;
	}

	if(fdbExists(String_trim_quotes(argument[2])))
		QWrite("1");
	else
		QWrite("-1");
}
break;






case C_FILE_READ:
{ // Read val from file fwatcher/mdb/name
	if(argument_num < 4) {
		QWrite("ERROR: Not enough parameters");
		break;
	}

	global.option_error_output |= OPTION_ERROR_ARRAY_LOCAL;

	QWrite(fdbGet(String_trim_quotes(argument[2]), String_trim_quotes(argument[3])));
}
break;






case C_FILE_WRITE:
{ // Write var=val to file fwatcher/mdb/name
	if(argument_num < 5) {
		QWrite("ERROR: Not enough parameters");
		break;
	}

	global.option_error_output |= OPTION_ERROR_ARRAY_LOCAL;

	if(fdbPut(String_trim_quotes(argument[2]), String_trim_quotes(argument[3]), argument[4].text, false))
		QWrite("1");
	else
		QWrite("-1");
}
break;






case C_FILE_QWRITE:
{ // Write var=val to file fwatcher/mdb/name without checking if it already exists
	if(argument_num < 5) {
		QWrite("ERROR: Not enough parameters");
		break;
	}

	if(fdbPutQ(String_trim_quotes(argument[2]), String_trim_quotes(argument[3]), argument[4].text))
		QWrite("1");
	else
		QWrite("-1");
}
break;






case C_FILE_AWRITE:
{ // Append val to var in file fwatcher/mdb/name
	if(argument_num < 5) {
		QWrite("ERROR: Not enough parameters");
		break;
	}

	global.option_error_output |= OPTION_ERROR_ARRAY_LOCAL;

	if(fdbPut(String_trim_quotes(argument[2]), String_trim_quotes(argument[3]), argument[4].text, true))
		QWrite("1");
	else
		QWrite("-1");
}
break;






case C_FILE_VARS:
{ // Return array of vars in file fwatcher/mdb/name
	if(argument_num < 3) {
		QWrite("ERROR: Not enough parameters");
		break;
	}

	char *res = fdbVars(String_trim_quotes(argument[2]));
	QWrite(res);
	delete[] res;
}
break;






case C_FILE_READVARS:
{ // Return all vars from file fwatcher/mdb/name
	if(argument_num < 3) {
		QWrite("ERROR: Not enough parameters");
		break;
	}

	char *res = fdbReadvars(String_trim_quotes(argument[2]));
	QWrite(res);
	delete[] res;
}
break;






case C_FILE_REMOVE:
{ // Remove a val from file fwatcher/mdb/name
	if(argument_num < 4) {
		QWrite("ERROR: Not enough parameters");
		break;
	}

	if(fdbRemove(String_trim_quotes(argument[2]), String_trim_quotes(argument[3])))
		QWrite("1");
	else
		QWrite("-1");
}
break;






case C_FILE_DELETE:
{ // Remove file fwatcher/mdb/name
	if(argument_num < 3) {
		QWrite("ERROR: Not enough parameters");
		break;
	}

	if(fdbDelete(String_trim_quotes(argument[2])))
		QWrite("1");
	else
		QWrite("-1");
}
break;






case C_FILE_WGET:
{ // Get a http/ftp file with wget
  // Execute wget, outputing to a named pipe
  // Not very clean but it works...
	if(argument_num < 3) {
		QWrite("ERROR: Not enough parameters");
		break;
	}

	if((GetTickCount() - global.lastWget) < WGET_MINWAIT) {
		// Return -1 if user is calling wget too often
		QWrite("-1");
		break;
	}

	// wget should always return an empty file if an error occurs so no handling should be required for it
	// TODO: maybe should return some sort of error message for OFP...

	HANDLE pipe;
	if(global.nomap)
		// Create a named pipe for wget to write into					
		pipe = CreateNamedPipe(file.filename, PIPE_ACCESS_DUPLEX, PIPE_TYPE_BYTE | PIPE_READMODE_BYTE | PIPE_WAIT,
								PIPE_UNLIMITED_INSTANCES, PIPEBUFSIZE, PIPEBUFSIZE, NMPWAIT_USE_DEFAULT_WAIT, NULL);

	char *cline = new char[256+strlen(file.filename)+argument[2].length];
	sprintf(cline, "-q --tries=1 --output-document=\"%s\" --timeout=3 --user-agent=fwatch/%.2f %s", file.filename, SCRIPT_VERSION, argument[2].text);

	// Win23 API bloat
	STARTUPINFO si;
	PROCESS_INFORMATION pi;
	ZeroMemory(&si, sizeof(si));
	si.cb = sizeof(si);
	si.dwFlags = STARTF_USESHOWWINDOW;
	si.wShowWindow = SW_HIDE;
	ZeroMemory(&pi, sizeof(pi));

	// Execute wget
	CreateProcess("fwatch/data/wget.exe", cline, NULL, NULL, TRUE, HIGH_PRIORITY_CLASS, NULL, NULL, &si, &pi);
	delete[] cline;
	global.lastWget = GetTickCount();
				
	if(global.nomap) {
		// Wait for wget to do its thing
		char *buf = new char[PIPEBUFSIZE+1];
		if(!buf)
			break;

		DWORD st, foo = 1, foo2;
		do {					
			// Check exit code
			GetExitCodeProcess(pi.hProcess, &st);
			Sleep(5); // Lets not eat all cpu cycles

			// Read named pipe and output to the out pipe for OFP
			ReadFile(pipe, buf, PIPEBUFSIZE, &foo, NULL);
			//buf[foo] = 0x00;
			if(foo)
				WriteFile(global.out, buf, foo, &foo2, NULL);

			// Wait until the process has exited and no more data in pipe
		} while(st == STILL_ACTIVE || foo);

		WriteFile(global.out, "\0", 1, &foo2, NULL);
		CloseHandle(pipe); 
		delete[] buf;
	} else {
		DWORD st;
		do {					
			// Check exit code
			GetExitCodeProcess(pi.hProcess, &st);
			Sleep(10); // Lets not eat all cpu cycles
			// Wait until the process has exited
		} while(st == STILL_ACTIVE);
	}
}
break;





case C_FILE_DXDLL:
{ // Check if dxdll is in OFP folder

	FILE *f = fopen("d3d8.dll", "r");

	if (f) {
		fclose(f);
		QWrite("true");
	} else 
		QWrite("false");
}
break;






case C_FILE_READ2:
{ // Read variable from selected file (any path)

	if (argument_num < 4) {
		QWrite(":file read2 ERROR - not enough parameters");
		break;
	}

	global.option_error_output |= OPTION_ERROR_ARRAY_LOCAL;

	fdbGet2(String_trim_quotes(argument[2]), String_trim_quotes(argument[3]));
}
break;






case C_FILE_MODLIST:		
{ // Return list of modfolders in the game folder

	int base		  = 0;
	int pointer       = 0;
	char username[30] = "";

	switch(global_exe_version[global.exe_index]) {
		case VER_196 : base=0x7DD184; break;
		case VER_199 : base=0x7CC144; break;
		case VER_201 : base=global.exe_address+0x714C10; break;
	}

	if (base) {
		ReadProcessMemory(phandle, (LPVOID)base,		  &pointer,  4, &stBytes);
		ReadProcessMemory(phandle, (LPVOID)(pointer+0x8), &username, 30, &stBytes);
	}


	WIN32_FIND_DATA fd;
	HANDLE hFind = INVALID_HANDLE_VALUE;
	hFind		 = FindFirstFile("*", &fd);

	if (hFind != INVALID_HANDLE_VALUE) {
		StringDynamic Names, Attributes, Versions, Dates;
		StringDynamic_init(Names);
		StringDynamic_init(Attributes);
		StringDynamic_init(Versions);
		StringDynamic_init(Dates);

		char sub_folder[][16] = {
			"addons", 
			"bin", 
			"campaigns", 
			"dta", 
			"worlds", 
			"Missions", 
			"MPMissions", 
			"Templates", 
			"SPTemplates",
			"MissionsUsers",
			"MPMissionsUsers"
		};
		int sub_folder_num = sizeof(sub_folder) / sizeof(sub_folder[0]);

		do {
			if (strcmp(fd.cFileName,".")==0  ||  strcmp(fd.cFileName,"..")==0)
				continue;

			// skip non-folders and "Res" folder
			if ((fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)==0  ||  strcmpi("Res",fd.cFileName)==0)
				continue;

			char path2[MAX_PATH] = "";

			// Check if current directory contains at least one of four required sub-folders
			for (int i=0; i<sub_folder_num; i++) {			
				sprintf(path2, "%s\\%s", fd.cFileName, sub_folder[i]);

				DWORD attributes = GetFileAttributes(path2);

				if (attributes != -1  &&  attributes & FILE_ATTRIBUTE_DIRECTORY) {
					StringDynamic_append(Names, "]+[\"");
					StringDynamic_appendq(Names, fd.cFileName);
					StringDynamic_append(Names, "\"");

					sprintf(path2, "%s\\__gs_id", fd.cFileName);
					FILE *f = fopen(path2, "r");

					if (f) {
						char data_buffer[256] = "";
						fread(data_buffer, sizeof(char), 255, f);
						String data = {data_buffer, strlen(data_buffer)};
						String item;
						int index = 0;
						size_t data_pos = 0;

						while ((item = String_tokenize(data,";",data_pos,OPTION_NONE)).length > 0) {
							switch (index) {
								case 0 : StringDynamic_appendf(Attributes, "]+[{%s}", item.text); break;
								case 1 : StringDynamic_appendf(Versions, "]+[%s", item.text); break;
								case 2 : StringDynamic_appendf(Dates, "]+[%s", item.text); break;
							}

							index++;
						}

						fclose(f);
					} else {
						StringDynamic_append(Attributes, "]+[\"\"");
						StringDynamic_append(Versions, "]+[0");
						StringDynamic_append(Dates, "]+[0");
					}

					break;
				}
			}
		} while (FindNextFile(hFind, &fd));
		FindClose(hFind);

		double bytes              = 0;
		char custom_filename[256] = "";
		char path_to_user[256]    = "";

		// Check if profile is using a custom face
		sprintf(path_to_user, "Users\\%s\\UserInfo.cfg", username);
		FILE *f = fopen(path_to_user,"r");

		if (f) {
			fseek(f, 0, SEEK_END);
			int fsize = ftell(f);
			fseek(f, 0, SEEK_SET);

			char *settings	 = new char[fsize+1];
			int result		 = fread(settings, 1, fsize, f);
			settings[result] = '\0';

			// Check custom face file size
			if (strstr(settings, "face=\"Custom\"")) {
				sprintf(path_to_user, "Users\\%s\\face.paa", username);

				hFind = FindFirstFile(path_to_user, &fd);

				if (hFind != INVALID_HANDLE_VALUE) {
					if (fd.nFileSizeLow > bytes && fd.nFileSizeLow <= 102400) {
						strncpy(custom_filename, fd.cFileName, 255);
						bytes = fd.nFileSizeLow;
					}

					FindClose(hFind);
				} else {
					sprintf(path_to_user, "Users\\%s\\face.jpg", username);
					hFind = FindFirstFile(path_to_user, &fd);

					if (hFind != INVALID_HANDLE_VALUE)
						if (fd.nFileSizeLow > bytes && fd.nFileSizeLow <= 102400) {
							strncpy(custom_filename, fd.cFileName, 255);
							bytes = fd.nFileSizeLow;
						}

					FindClose(hFind);
				}
			}

			delete[] settings;
			fclose(f);
		}


		// Check custom sounds file sizes
		sprintf(path_to_user, "Users\\%s\\sounds\\*.*", username);
		hFind = FindFirstFile(path_to_user, &fd);

		if (hFind != INVALID_HANDLE_VALUE) {
			do {
				if (fd.cFileName[0] == '.')
					continue;

				if (fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
					continue;

				if (fd.nFileSizeLow > bytes && fd.nFileSizeLow <= 51200) {
					bytes = fd.nFileSizeLow;
					strncpy(custom_filename, fd.cFileName, 255);
				}
			} while (FindNextFile(hFind, &fd) != 0);
			FindClose(hFind);
		}

		
		// Output result
		QWrite_err(FWERROR_NONE, 0);
		QWritef("[%s],[%s],[%s],[%s],\"%s", Names.text, Attributes.text, Versions.text, Dates.text, custom_filename);

		FileSize size = DivideBytes(bytes);

		unsigned int hash = FNV_BASIS;
		hash              = fnv1a_hash(hash, Attributes.text, Attributes.length, OPTION_NONE);
		hash              = fnv1a_hash(hash, Versions.text, Versions.length, OPTION_NONE);

		QWritef("\",[%f,%f,%f],\"%u\",\"%s\"]", size.bytes, size.kilobytes, size.megabytes, hash, username);
		StringDynamic_end(Names);
		StringDynamic_end(Attributes);
		StringDynamic_end(Versions);
		StringDynamic_end(Dates);
	} else {
		QWrite_err(FWERROR_WINAPI, 2, GetLastError(), username);
		QWrite("[],[]]"); 
		return;
	}
}
break;
