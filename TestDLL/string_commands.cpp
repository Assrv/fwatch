// -----------------------------------------------------------------
// STRING OPERATIONS
// -----------------------------------------------------------------

case C_STRING_FIRST:
{ // Return the index in str2 of the first occurrence of str1, or -1 if str1 is not found.
	if(numP < 4) {
		QWrite("ERROR: Not enough parameters", out);
		break;
	}

	char *str1 = stripq(par[2]);
	char *str2 = stripq(par[3]);
	char *res = strstr(str2, str1);
	
	if(!res) {
		// It wasn't found
		QWrite("-1", out);
	} else {
		// Found, return relative pointer
		char ret[16];
		sprintf(ret, "%d", res - str2);
		QWrite(ret, out);
	}
}
break;






case C_STRING_LAST:
{ // Return the index in str2 of the last occurrence of str1, or -1 if str1 is not found.
	if(numP < 4) {
		QWrite("ERROR: Not enough parameters", out);
		break;
	}

	char *str1 = stripq(par[2]);
	char *str2 = stripq(par[3]);
	char *str2t = stripq(par[3]);

	char *res = 0, *res2 = 0;
	do {
		// Search substring until its not found anymore
		res = res2;
		res2 = strstr(str2t, str1);
		str2t = res2+1;
	} while (res2 != NULL);
	
	if(!res) {
		// It wasn't found at all
		QWrite("-1", out);
	} else {
		// Found, return relative pointer
		char ret[16];
		sprintf(ret, "%d", res - str2);
		QWrite(ret, out);
	}
}
break;






case C_STRING_LENGTH:
{ // Return the number of characters in string.
	if(numP < 3) {
		QWrite("ERROR: Not enough parameters", out);
		break;
	}

	char *str = stripq(par[2]);
	int res = strlen(str);
	char ret[16];
	sprintf(ret, "%d", res);
	QWrite(ret, out);

}
break;






case C_STRING_RANGE:
{ // Return the range of characters in str from i to j.
	if(numP < 5) {
		QWrite("ERROR: Not enough parameters", out);
		break;
	}

	char *str = stripq(par[2]);
	unsigned int l = strlen(str);
	unsigned int i = atoi(par[3]);
	unsigned int j = atoi(par[4]);

	if(i > l) i = l;
	if(j > l) j = l;

	str[j] = '\0';
	char *ret = new char[l+4];
	if(!ret)
		break;

	sprintf(ret, "\"%s\"", str+i);
	QWrite(ret, out);
	delete[] ret;

}
break;






case C_STRING_TOLOWER:
{ // Return string in lower case.
	if(numP < 3) {
		QWrite("ERROR: Not enough parameters", out);
		break;
	}

	char *str = stripq(par[2]);
	unsigned int l = strlen(str);

	for(unsigned int x=0;x < l;x++)
		str[x] = tolower(str[x]);

	char *ret = new char[l+4];
	if(!ret)
		break;

	sprintf(ret, "\"%s\"", str);
	QWrite(ret, out);
	delete[] ret;
}
break;






case C_STRING_TOUPPER:
{ // Return string in upper case.
	if(numP < 3) {
		QWrite("ERROR: Not enough parameters", out);
		break;
	}

	char *str = stripq(par[2]);
	unsigned int l = strlen(str);

	for(unsigned int x=0;x < l;x++)
		str[x] = toupper(str[x]);

	char *ret = new char[l+4];
	if(!ret)
		break;

	sprintf(ret, "\"%s\"", str);
	QWrite(ret, out);
	delete[] ret;
}
break;






case C_STRING_TOARRAY:
{ // Return all characters in string as array elements
	if(numP < 3) {
		QWrite("ERROR: Not enough parameters", out);
		break;
	}

	char *str = stripq(par[2]);
	unsigned int l = strlen(str);

	QWrite("[", out);
	for(unsigned int x=0;x < l;x++) {
		char ret[5];
		if (str[x]=='"') {sprintf(ret, "\"\"\"\"");} else {sprintf(ret, "\"%c\"", str[x]);};//v1.11 fixed bug with quotes
		QWrite(ret, out);
		if(x < l-1)
		QWrite(",", out);
	}
	QWrite("];", out);
}
break;






case C_STRING_INDEX:
{ // Return the character at the specified index.
	if(numP < 4) {
		QWrite("ERROR: Not enough parameters", out);
		break;
	}

	unsigned int idx = atoi(par[3]);
	par[2] = stripq(par[2]);

	if(idx > (strlen(par[2])-1) || idx < 0) 
		QWrite("ERROR: Index out of bounds", out);
	else {
		// Write char to file
		char c = par[2][idx];
		char ret[6];

		sprintf(ret, "\"%c\"", par[2][idx]);
		QWrite(ret, out);
	}
}
break;










case C_STRING_LENGTH2:
{ // Return the number of characters in a string

	char output[16] = "";
	sprintf(output, "%d", strlen(com)-12);
	QWrite(output, out);
}
break;










case C_STRING_REPLACE:
{ // Replace text in a given string

	char *source        = "";
	char *to_find       = "";
	char *replace_with  = "";
	bool case_sensitive = false;
	bool match_word     = false;

	for (int i=2; i<numP; i++) {
		char *name  = stripq(par[i]);
		char *colon = strchr(name, ':');

		if (colon == NULL) 
			continue;

		int pos     = colon - name;
		name[pos]   = '\0';
		char *value = name + pos + 1;

		if (strcmpi(name,"text") == 0) {
			source = value;
			continue;
		}

		if (strcmpi(name,"find") == 0) {
			to_find = value;
			continue;
		}

		if (strcmpi(name,"replace") == 0) {
			replace_with = value;
			continue;
		}

		if (strcmpi(name, "caseSensitive") == 0) {
			case_sensitive = String2Bool(value);
			continue;
		}

		if (strcmpi(name, "matchWord") == 0) {
			match_word = String2Bool(value);
			continue;
		}
	}

	char *result = str_replace(source, to_find, replace_with, match_word, case_sensitive);

	if (result != NULL) {
		QWrite(result, out);
		free(result);
	}
}
break;










case C_STRING_COMPARE:
{ // Compare two strings with each other

	char *text1         = "";
	char *text2         = "";
	bool case_sensitive = false;
	bool natural_sort   = false;
	bool reverse_case   = false;

	for (int i=2; i<numP; i++) {
		char *name  = stripq(par[i]);
		char *colon = strchr(name, ':');

		if (colon == NULL) 
			continue;

		int pos     = pch - name;
		name[pos]   = '\0';
		char *value = name + pos + 1;

		if (strcmpi(name,"text1") == 0) {
			text1 = value;
			continue;
		}

		if (strcmpi(name,"text2") == 0) {
			text2 = value;
			continue;
		}

		if (strcmpi(name,"caseSensitive") == 0) {
			case_sensitive = String2Bool(value);
			continue;
		}

		if (strcmpi(name,"natural") == 0) {
			natural_sort = String2Bool(value);
			continue;
		}

		if (strcmpi(name,"reverseCase") == 0) {
			reverse_case = String2Bool(value);
			continue;
		}
	}

	if (reverse_case) {
		for (int i=0; text1[i]!='\0'; i++)
			if (isupper(text1[i]))
				text1[i] = tolower(text1[i]);
			else
				text1[i] = toupper(text1[i]);

		for (i=0; text2[i]!='\0'; i++)
			if (isupper(text2[i]))
				text2[i] = tolower(text2[i]);
			else
				text2[i] = toupper(text2[i]);
	}

	int result = 0;

	if (case_sensitive)
		result = natural_sort ? strnatcmp(text1, text2)     : strcmp(text1, text2);
	else
		result = natural_sort ? strnatcasecmp(text1, text2) : strcmpi(text1, text2);

	char output[4] = "";
	sprintf(output, "%d", result);
	QWrite(output, out);
}
break;










case C_STRING_TYPE:
{ // Check if string is a number

	char *text        = "";
	bool skip_math_op = false;

	for (int i=2; i<numP; i++) {
		char *name  = stripq(par[i]);
		char *colon = strchr(name, ':');

		if (colon == NULL) 
			continue;

		int pos     = pch - name;
		name[pos]   = '\0';
		char *value = name + pos + 1;

		if (strcmpi(name,"skipmath") == 0) {
			skip_math_op = String2Bool(value);
			continue;
		}

		if (strcmpi(name,"text") == 0) {
			text = value;
			continue;
		}
	}


	enum STRING_TYPE_RESULT {
		STR_TYPE_STRING,
		STR_TYPE_INTEGER,
		STR_TYPE_FLOAT
	};

	int result               = STR_TYPE_STRING;
	int number_of_dots       = 0;
	bool skip_character      = false;
	bool found_number        = false;
	bool found_non_white     = false;
	bool found_space_between = false;

	for (i=0; text[i]!='\0'; i++) {
		// Ignore whitespace
		if (isspace(text[i])) {
			// remember if there was space between characters
			if (found_non_white  &&  !skip_math_op) 
				found_space_between = true;

			continue;
		}

		// If encountered a math operator
		switch (text[i]) {
			case '+' : 
			case '-' : 
			case '*' : 
			case '/' : 
			case '%' : 
			case '^' : skip_character=true; break;
			default	 : found_non_white=true;
		}

		// Ignore operators if argument was passed
		if (skip_character) {
			if (skip_math_op) {
				skip_character = false; 
				continue;
			}

			found_space_between = false;
		}

		// If there is a dot -  it could be a float
		if (text[i] == '.') {
			number_of_dots++;

			if (number_of_dots>1  &&  !skip_math_op) {
				result = STR_TYPE_STRING; 
				break;
			} else 
				continue;
		}

		// If there is a minus - it could be a negative number
		if (text[i] == '-') {
			if (found_number) {
				result = STR_TYPE_STRING; 
				break;
			}

			continue;
		}


		// If current character is a digit
		if (isdigit(text[i])  &&  !found_space_between) {
			found_number = true;

			// If previous character was dot - it could be a float
			if (i>0  &&  text[i-1]=='.')
				result = STR_TYPE_FLOAT;

			// If it wasn't already set to 'float' then assume it's integer
			if (result != STR_TYPE_FLOAT) 
				result = STR_TYPE_INTEGER;
		// Otherwise it's a string
		} else {
			result = STR_TYPE_STRING;
			break;
		}
	}


	// If dot occured without a number then it's a string
	if (number_of_dots>0  &&  !found_number) 
		result = STR_TYPE_STRING;

	switch(result) {
		case STR_TYPE_STRING  : QWrite("string", out); break;
		case STR_TYPE_INTEGER : QWrite("integer", out); break;
		case STR_TYPE_FLOAT   : QWrite("float", out); break;
	}
}
break;










case C_STRING_VARIABLE:
{ // Check if string is a compliant variable

	char *text = "";
	char *mode = "";

	for (int i=2; i<numP; i++) {
		char *name  = stripq(par[i]);
		char *colon = strchr(name, ':');

		if (colon == NULL) 
			continue;

		int pos     = pch - name;
		name[pos]   = '\0';
		char *value = Trim(name + pos + 1);

		if (strcmpi(name,"mode") == 0) {
			mode = value;
			continue;
		}

		if (strcmpi(name,"text") == 0) {
			text = value;
			continue;
		}
	}
	

	int result         = true;  // return value
	bool allow_global  = true;	// allow global variables
	bool allow_local   = true;	// allow local variables
	bool allow_number  = false;	// allow the name to start with a number
	bool allow_bracket = false;	// allow square brackets at the end
	bool allow_inherit = false;	// allow second class name after colon
	char *class1       = text;
	char *class2       = NULL;

	if (strcmpi(mode,"onlyLocal") == 0)
		allow_global = false;

	if (strcmpi(mode,"onlyGlobal") == 0)
		allow_local = false;

	if (strcmpi(mode,"className")==0  ||  strcmpi(mode,"classToken")==0  ||  strcmpi(mode,"classNameInherit")==0) {
		allow_global  = true;
		allow_local   = true;
		allow_number  = true;
		allow_bracket = strncmpi(mode,"className",9) != 0;
		allow_inherit = strcmpi(mode,"classNameInherit") == 0;

		// Keyword "class" is reserved
		if (strncmpi(text,"class ",6)==0  ||  strncmpi(text,"class=",6)==0) {
			QWrite("false", out); 
			break;
		}

		// If there are two class names then separate
		if (allow_inherit)
			if ((class2 = strchr(text, ':')) != NULL) {
				int pos   = class2 - text;
				text[pos] = '\0';
				class1    = Trim(text);
				class2    = Trim(class2 + 1);
			}
	}


	int length = strlen(text);

	if (length == 0) {
		QWrite("false", out); 
		break;
	}


	// Optional mode - remove square brackets at the end
	if (allow_bracket  &&  length>2)
		if (text[(length-2)]=='['  &&  text[(length-1)]==']')
			text[(length-2)] = '\0';


	for (i=0;  result;  i++) {
		// End loop on string end OR check second string if it exists
		if (text[i] == '\0') {
			if (class2!=NULL  &&  text!=class2) {
				i	 = 0;
				text = class2;
			} else
				break;
		}

		// Fail conditions for the first character
		if (i == 0)	{						
			if (
				// DEFAULT - first char is (not alpha assuming digits aren't allowed OR not alpha and not a digit assuming allowed digits) and not underscore
				allow_global  &&   allow_local  &&  (!isalpha(text[0]) && !allow_number || !isalpha(text[0]) && !isdigit(text[0]) && allow_number)  &&  text[0]!='_'
				||	
				// GLOBALS ONLY - first char is (not alpha with digits not allowed OR not alpha and not digit with allowed digits)
				allow_global  &&  !allow_local  &&  (!isalpha(text[0]) && !allow_number || !isalpha(text[0]) && !isdigit(text[0]) && allow_number) 
				||
				// LOCALS ONLY - first char is not underscore
				!allow_global &&  allow_local  &&  text[0]!='_'
			) 
				result = false;
		// If character isn't alphanumeric and isn't underscore then fail
		} else
			if (!isalnum(text[i])  &&  text[i]!='_')	
				result = false;
	}

	QWrite(getBool(result), out);
}
break;










case C_STRING_EMPTY:
{ // Check if string consists solely of white-space

	QWrite(getBool(IsWhiteSpace(com+15)), out);
}
break;










case C_STRING_RANGE2:
{ // Alternative version of C_STRING_RANGE

	// Read arguments
	char *text          = "";
	char *search_start  = "";
	char *search_end    = "";
	int range_start     = 0;
	int range_end       = 0;
	int range_length    = 0;
	int offset_start    = 0;
	int offset_end      = 0;
	bool is_end_set     = false;
	bool is_length_set  = false;
	bool crop_mode      = false;
	bool match_word     = false;
	bool case_sensitive = false;

	for (int i=2; i<numP; i++) {
		char *name  = stripq(par[i]);
		char *colon = strchr(name, ':');

		if (colon == NULL) 
			continue;

		int pos     = colon - name;
		name[pos]   = '\0';
		char *value = name + pos + 1;

		if (strcmpi(name,"text") == 0) {
			text = value;
			continue;
		}

		if (strcmpi(name,"start") == 0) {
			range_start = atoi(value);
			continue;
		}

		if (strcmpi(name,"end") == 0) {
			range_end     = atoi(value);
			is_end_set	  = true;
			is_length_set = false;
			continue;
		}

		if (strcmpi(name,"range_length") == 0) {
			range_length  = atoi(value);
			is_end_set    = false;
			is_length_set = true;
			continue;
		}

		if (strcmpi(name,"exclude") == 0) {
			crop_mode = String2Bool(value);
			continue;
		}


		if (strcmpi(name,"startfind") == 0) {
			search_start = value;
			continue;
		}

		if (strcmpi(name,"endfind") == 0) {
			search_end = value;
			continue;
		}

		if (strcmpi(name,"matchWord") == 0) {
			match_word = String2Bool(value);
			continue;
		}

		if (strcmpi(name,"caseSensitive") == 0) {
			case_sensitive = String2Bool(value);
			continue;
		}

		if (strcmpi(name,"startoffset") == 0) {
			offset_start = atoi(value);
			continue;
		}

		if (strcmpi(name,"endoffset") == 0) {
			offset_end = atoi(value);
			continue;
		}
	}

	int text_length = strlen(text);
	if (text_length == 0)
		break;

	// Search for the start and end position
	if (strcmp(search_start,"") != 0) {
		char *start_ptr = strstr2(text, search_start, match_word, case_sensitive);
		if (start_ptr == NULL) {
			QWrite("", out);
			break;
		}

		range_start = start_ptr - text;

		if (strcmp(search_end,"") != 0) {
			char *end_ptr = strstr2(start_ptr, search_end, match_word, case_sensitive);
			if (start_ptr != NULL) {
				range_end     = end_ptr - text;
				is_end_set    = true;
				is_length_set = false;
			}
		}
	}

	range_start += offset_start;
	range_end   += offset_end;

	CorrectStringPos(&range_start, &range_end, range_length, is_end_set, is_length_set, text_length);

	// Exclusion mode - remove range of characters
	if (crop_mode) {
		// Normal range
		if (range_start <= range_end)
			for (int i=0; i<text_length; i++) {
				if (i<range_start  ||  i>=range_end) {
					char output[2] = "";
					sprintf(output, "%c", text[i]);
					QWrite(output, out);
				}
			}

		// Reverse range - iterate characters from the end
		else
			for (int i=text_length-1; i>0; i--) {
				if (i<range_end  ||  i>=range_start) {
					char output[2] = "";
					sprintf(output, "%c", text[i]);
					QWrite(output, out);
				}
			}

	// Inclusion mode - return range of characters
	} else {
		// Normal range
		if (range_start <= range_end) {
			text[range_end] = '\0';
			QWrite(text+range_start, out);
		// Reverse range - iterate characters from the end
		} else
			for (--range_start; range_start>=range_end; range_start--)
				if (range_start>=0  &&  range_start<text_length) {
					char output[2] = "";
					sprintf(output, "%c", text[range_start]);
					QWrite(output, out);
				}
	}
}
break;










case C_STRING_TOKENIZE:
{ // Split string on given occurences

	// Read arguments
	char *text         = "";
	char *delimiter    = "";
	char *addEmpty     = "";
	bool byString      = false;
	bool skipQuotes    = false;
	bool matchWord     = false;
	bool caseSensitive = false;

	for (int i=2; i<numP; i++) {
		char *arg = stripq(par[i]);
		char *pch = strchr(arg, ':');

		if (pch == NULL) 
			continue;

		int pos   = pch - arg;
		arg[pos]  = '\0';
		char *val = arg + pos + 1;

		if (strcmpi(arg,"text") == 0) {
			text = val;
			continue;
		}

		if (strcmpi(arg,"delimiter") == 0) {
			delimiter = val;
			continue;
		}

		if (strcmpi(arg,"wordDelimiter") == 0) {
			byString = String2Bool(val);
			continue;
		}

		if (strcmpi(arg,"quoteSkip") == 0) {
			skipQuotes = String2Bool(val);
			continue;
		}

		if (strcmpi(arg,"matchWord") == 0) {
			matchWord = String2Bool(val);
			continue;
		}

		if (strcmpi(arg,"caseSensitive") == 0) {
			caseSensitive = String2Bool(val);
			continue;
		}

		if (strcmpi(arg,"addEmpty") == 0) {
			addEmpty = val;
			continue;
		}
	};


	// Set variables for preparing text
	char *pch   = "";
	char *text2 = text;
	int l1      = strlen(text);
	int l2      = strlen(delimiter);
	int skip    = 0;
	int Qmax    = 0;
	int Qindex  = -2;
	int *Qarray;


	// If we're skipping occurences in quotes
	// then first we need to save position of quot marks
	if (skipQuotes) {
		// Count how many quotes there are
		for (int i=0;  i<l1;  i++)
			if (text[i] == '"')
				Qmax++;

		// Even number
		if (Qmax % 2 != 0)
			Qmax++;

		// Allocate integer array
		if (Qmax > 0) {
			Qarray = (int*) calloc (Qmax, sizeof(int));

			if (Qarray == NULL) {
				QWrite("[]", out);
				break;
			}
		}

		// Store quotes position in an array
		bool inQuote = false;

		for (i=0;  i<l1 && Qindex<Qmax;  i++)
			if (text[i] == '"') {
				inQuote = !inQuote;

				if (inQuote) {
					Qindex          += 2;
					Qarray[Qindex]   = i;
					Qarray[Qindex+1] = l1;
				} else 
					Qarray[Qindex+1] = i;
			}
	}


	// Prepare text before tokenizing by words
	if (byString) {		
		// Search for the word
		while (pch = strstr2(text2, delimiter, matchWord, caseSensitive)) {
			int pos		= pch - text2;
			bool inQuot = false;

			// Check if the word is inside quotation
			if (skipQuotes  &&  Qmax>0) {
				for (int i=0;  i<Qmax && !inQuot;  i+=2)
					if (Qarray[i]<=(skip+pos)  &&  (skip+pos)<=Qarray[i+1]) 
						inQuot = true;

				// If so then skip it
				if (inQuot) {
					skip += pos + l2; 
					text2 = text + skip;
					continue;
				}
			}
			
			// Replace the word with unused characters
			for (int i=pos; i<(pos+l2); i++) 
				text2[i] = '\a';
		}

	// Prepare text before tokenizing by single characters
	} else {
		// For each char in delim
		for (int i=0; i<l2; i++) {
			text2 = text;
			skip  = 0;

			char currentChar[2] = "";
			sprintf(currentChar, "%c", delimiter[i]);

			while (pch = strstr2(text2, currentChar, matchWord, caseSensitive)) {
				int pos     = pch - text2;
				bool inQuot = false;

				// Check if the character is inside quotation
				if (skipQuotes) {
					for (int i=0;  i<Qmax && !inQuot;  i+=2)
						if (Qarray[i]<=(skip+pos)  &&  (skip+pos)<=Qarray[i+1]) 
							inQuot = true;

					// If so then skip it
					if (inQuot) {
						skip += pos + 1; 
						text2 = text + skip;  
						continue;
					}
				}

				// Replace char with an unused char
				text2[pos] = '\a';
			}
		}
	}

	if (Qmax > 0)
		free(Qarray);


	// Set variables for adding empty
	bool addEmptyStart = false;
	bool addEmptyEnd   = false;
	int pchLen		   = 0;
	int pos			   = 0;
	int count		   = 0;

	if (strncmpi(addEmpty,"both",4)==0) {
		addEmptyStart = true;
		addEmptyEnd	  = true;
	} else
		if (strncmpi(addEmpty,"start",5)==0)
			addEmptyStart = true;
	else
		if (strncmpi(addEmpty,"end",3)==0)
			addEmptyEnd	= true;


	// Start tokenization
	QWrite("[", out);
	pch = strtok (text, "\a");

	while (pch != NULL) {
		// keep track of numbers
		if (addEmptyStart  ||  addEmptyEnd) {
			pos		= pch - text;
			pchLen	= strlen(pch);
		}

		// if string begins with token 
		if (addEmptyStart) {
			addEmptyStart = false;

			// then add empty string to the output array
			if (pos != 0)
				QWrite("\"\"", out);
		}
		
		QWrite("]+[\"", out);
		PrintDoubleQ(pch, out);
		QWrite("\"", out);

		count++;
		pch = strtok (NULL, "\a");
	}


	// if there were no parts at all
    if (addEmptyStart)
        QWrite("\"\"", out);

	// if last part doesn't end the string
	if (addEmptyEnd)
		if (pos+pchLen < l1  ||  count==0)
			QWrite("]+[\"\"", out);

	QWrite("]", out);
}
break;










case C_STRING_TRIMWHITESPACE:
{ // Trim white-space from string

	// Read arguments
	char *text        = "";
	bool left         = false;
	bool middle       = false;
	bool right        = false;
	bool middleSingle = false;

	for (int i=2; i<numP; i++) {
		char *arg = stripq(par[i]);
		char *pch = strchr(arg, ':');

		if (pch == NULL) 
			continue;

		int pos   = pch - arg;
		arg[pos]  = '\0';
		char *val = arg + pos + 1;

		if (strcmpi(arg,"left") == 0) {
			left = String2Bool(val);
			continue;
		}

		if (strcmpi(arg,"middle") == 0) {
			middle		 = String2Bool(val);
			middleSingle = !middle;
			continue;
		}

		if (strcmpi(arg,"middleSingle") == 0) {
			middleSingle = String2Bool(val);
			middle		 = !middleSingle;
			continue;
		}

		if (strcmpi(arg,"right") == 0) {
			right = String2Bool(val);
			continue;
		}

		if (strcmpi(arg,"text") == 0) {
			text = val;
			continue;
		}
	}


	if (left) 
		while (isspace(text[0])) 
			text++;

	if (right) 
		for (int i=strlen(text)-1; i>=0 && isspace(text[i]); i--) 
			text[i] = '\0';

	if (middle || middleSingle) {
		// get starting position (ignore leading space)
		for (int i=0; isspace(text[i]);  i++);

		// get ending position (ignore leading space)
		for (int END=strlen(text)-1;  isspace(text[END]);  END--);

		int countSpace = 0;

		// shift chars to the left when encountered whitespace
		for (; i<END-1; i++)
			if (isspace(text[i])) {
				countSpace++;

				if (!middleSingle || middleSingle && countSpace>1)
					strcpy(text+i, text+i+1),
					END--;
			} else
				countSpace = 0;
	}

	QWrite(text, out);
}
break;










case C_STRING_OCCURRENCES:
{ // Search string

	// Read arguments
	char *text         = "";
	char *find         = "";
	bool matchWord     = false;
	bool caseSensitive = false;
	bool EndSet        = false;
	bool LengthSet     = false;
	bool skipQuotes    = false;
	int Start          = 0;
	int End            = 0;
	int Length         = 0;
	int	Limit          = -1;
	int Count          = 0;

	for (int i=2; i<numP; i++) {
		char *arg = stripq(par[i]);
		char *pch = strchr(arg, ':');

		if (pch == NULL) 
			continue;

		int pos   = pch - arg;
		arg[pos]  = '\0';
		char *val = arg + pos + 1;

		if (strcmpi(arg,"text") == 0) {
			text = val;
			continue;
		}

		if (strcmpi(arg,"find") == 0) {
			find = val;
			continue;
		}

		if (strcmpi(arg,"matchWord") == 0) {
			matchWord = String2Bool(val);
			continue;
		}

		if (strcmpi(arg,"caseSensitive") == 0) {
			caseSensitive = String2Bool(val);
			continue;
		}

		if (strcmpi(arg,"start") == 0) {
			Start = atoi(val);
			continue;
		}

		if (strcmpi(arg,"end") == 0) {
			End		  = atoi(val);
			EndSet	  = true;
			LengthSet = false;
			continue;
		}

		if (strcmpi(arg,"length") == 0) {
			Length	  = atoi(val);
			EndSet	  = false;
			LengthSet = true;
			continue;
		}

		if (strcmpi(arg,"limit") == 0) {
			Limit = atoi(val);
			continue;
		}

		if (strcmpi(arg,"quoteSkip") == 0) {
			skipQuotes = String2Bool(val);
			continue;
		}
	}


	// Set variables
	int CurrentCOL = 0;
	int pos        = 0;
	int textSize   = strlen(text);
	int findSize   = strlen(find);
	char *text2    = text;
	char *pch      = NULL;
	char tmp[20]   = "";

	// Correct values
	if (textSize > 0)
		CorrectStringPos(&Start, &End, Length, EndSet, LengthSet, textSize);
	

	// If we're skipping occurences in quotes
	// then first we need to save position of quot marks
	int skip     = 0;
	int Qmax     = 0;
	int Qindex   = -1;
	int *Qarray;
	bool inQuote = false;

	if (skipQuotes) {
		// Count how many quotes there are
		for (int i=0;  i<textSize;  i++)
			if (text[i] == '"')
				Qmax++;

		// Even number
		if (Qmax % 2 != 0)
			Qmax++;

		// Allocate integer array
		if (Qmax > 0) {
			Qarray = (int*) calloc (Qmax, sizeof(int));

			if (Qarray == NULL) {
				QWrite("[]", out);
				break;
			}
		}

		// Store quotes position in an array
		inQuote = false;

		for (i=0;  i<textSize && Qindex<Qmax;  i++)
			if (text[i] == '"') {
				inQuote = !inQuote;

				if (inQuote) {
					Qindex          += 2;
					Qarray[Qindex]   = i;
					Qarray[Qindex+1] = textSize;
				} else 
					Qarray[Qindex+1] = i;
			}
	}


	// Search
	QWrite("[", out);

	while ((pch=strstr2(text2, find, matchWord, caseSensitive)) != NULL) {
		pos     = pch - text2;
		inQuote = false;

		// If in range
		if (pos+CurrentCOL >= Start) {
			// If passed the range
			if (pos+CurrentCOL > End)
				break;

			// If within result limit
			if (Limit>=0  &&  ++Count>Limit)
				break;

			// Check if the word is inside quotation
			if (skipQuotes  &&  Qmax>0)
				for (int i=0;  i<Qmax && !inQuote;  i+=2)
					if (Qarray[i]<=(CurrentCOL+pos)  &&  (CurrentCOL+pos)<=Qarray[i+1]) 
						inQuote = true;

			if (!inQuote) {
				sprintf(tmp, "]+[%d", CurrentCOL + pos);
				QWrite(tmp, out);
			}
		}

		// Move past the current occurence
		CurrentCOL += pos + 1;
		text2       = text + CurrentCOL;
	}

	if (Qmax > 0)
		free(Qarray);

	QWrite("]", out);
}
break;










case C_STRING_TOARRAY2:
{ // Alternative version of C_STRING_TOARRAY

	// Read arguments
	char *text		= "";
	int SegmentSize	= 1;
	int Limit		= -1;
	int Parts		= 0;
	int Start		= 0;
	int End			= 0;
	int Length		= 0;
	bool EndSet		= false;
	bool LengthSet	= false;

	for (int i=2; i<numP; i++) {
		char *arg = stripq(par[i]);
		char *pch = strchr(arg, ':');

		if (pch == NULL) 
			continue;

		int pos   = pch - arg;
		arg[pos]  = '\0';
		char *val = arg + pos + 1;

		if (strcmpi(arg,"text") == 0) {
			text = val;
			continue;
		}

		if (strcmpi(arg,"size") == 0) {
			SegmentSize = atoi(val);
			continue;
		}

		if (strcmpi(arg,"limit") == 0) {
			Limit = atoi(val);
			continue;
		}

		if (strcmpi(arg,"start") == 0) {
			Start = atoi(val);
			continue;
		}

		if (strcmpi(arg,"end") == 0) {
			End		  = atoi(val);
			EndSet	  = true;
			LengthSet = false;
			continue;
		}

		if (strcmpi(arg,"length") == 0) {
			Length		= atoi(val);
			EndSet	    = false;
			LengthSet   = true;
			continue;
		}
	}

	if (SegmentSize < 1)
		SegmentSize = 1;

	int	textSize = strlen(text);
	int count    = 0;
	char tmp[2]  = "";


	// Correct values
	if (textSize > 0)
		CorrectStringPos(&Start, &End, Length, EndSet, LengthSet, textSize);


	// Split
	QWrite("[", out);

	for (i=Start;  i<End && Limit!=0;  i++) {
		// Start segment
		if (count == 0)
			QWrite("\"", out);

		// Output character
		if (text[i] == '"') 
			QWrite("\"\"", out); 
		else {
			sprintf(tmp, "%c", text[i]);
			QWrite(tmp, out);
		}

		// Limit segment length
		if (++count >= SegmentSize  ||  i==End-1) {
			QWrite("\"", out);

			count = 0;
			QWrite("]+[", out);

			Parts++;

			if (Limit>=0  &&  Parts>=Limit)
				break;
		}
	}

	QWrite("]", out);
}
break;










case C_STRING_DOMAIN:
{ // Tokenize domain
	
	int i = 0;

	// Search for protocol and world wide web
	int hpos   = -1;
	int wpos   = -1;
	char *txt  = com + 14;
	char *http = strstr(txt, "://");
	char *www  = strstr(txt, "www.");

	if (http != NULL) 
		hpos = http - txt;

	if (www != NULL) {
		// Confirm www validity
		wpos = www - txt;

		for (i=wpos-4;  i>0 && i>hpos;  i++)
			if (isalnum(txt[i])) {
				wpos = -1; 
				break;
			}

		if (wpos >= 0) 
			txt[wpos+3] = '/';
	}


	// Find domain start position
	int dpos    = 0;
	int	dposEnd = 0;

	if (wpos >= 0) 
		dpos = wpos + 4; 
	else 
		if (hpos >= 0) 
			dpos = hpos+3;

	char *dom = txt + dpos;


	// Find query string start position
	int  qpos   = -1;
	int	 dirs   = 0;
	char *qmark = strchr(dom, '?');

	if (qmark != NULL) {
		qpos = qmark - dom;
		for (int i=0; i<qpos; i++) 
			if (dom[i]=='/'  &&  dom[i+1]!='?') 
				dirs++;
	}


	// Tokenize whole address
	int  cnt   = 0;
	bool count = true;
	char *pch  = strtok(txt, ":/?&");

	QWrite("[[", out);
	
	while (pch != NULL) {
		if (strncmp(pch,dom,strlen(pch)) == 0) {
			cnt++;
			count = 0;
		}

		if (count) 
			cnt++;
		
		QWrite("]+[\"", out); 
		QWrite(pch, out); 
		QWrite("\"", out);

		pch = strtok(NULL, ":/?&");
	}


	// Return index where query string vars start
	char tmp[16] = "";

	if (qmark != NULL) 
		sprintf(tmp,"],%d,[", cnt+dirs);
	else
		sprintf(tmp,"],%d,[", -1);

	QWrite(tmp, out);
	

	// Tokenize domain
	pch       = strtok(dom, ".");
	int parts = -1;

	while (pch != NULL) {
		parts++;
		QWrite("]+[\"", out); 
		QWrite(pch, out); 
		QWrite("\"", out);
		pch = strtok(NULL, ".");
	}


	// Reassemble domain and then return it
	QWrite("],\"", out);

	for (i=0; parts>0; i++)
		if (dom[i] == '\0') {
			dom[i] = '.';
			parts--;
		}

	QWrite(dom, out);
	QWrite("\"]", out);
}
break;










case C_STRING_UPPERLOWERCASE:
{ // Convert to upper or lower case

	// Read arguments
	char *text     = "";
	bool sentences = false;
	bool words     = false;
	bool upper     = false;
	bool lower     = false;
	bool StartSet  = false;
	bool EndSet    = false;
	bool LengthSet = false;
	int Start      = 0;
	int End        = 0;
	int Length     = 0;

	for (int i=2; i<numP; i++) {
		char *arg = stripq(par[i]);
		char *pch = strchr(arg, ':');

		if (pch == NULL) 
			continue;

		int pos   = pch - arg;
		arg[pos]  = '\0';
		char *val = arg + pos + 1;

		if (strcmpi(arg,"sentences") == 0) {
			sentences = String2Bool(val);
			continue;
		}

		if (strcmpi(arg,"words") == 0) {
			words = String2Bool(val);
			continue;
		}

		if (strcmpi(arg,"upper") == 0) {
			upper = String2Bool(val);
			continue;
		}

		if (strcmpi(arg,"lower") == 0) {
			lower = String2Bool(val);
			continue;
		}

		if (strcmpi(arg,"text") == 0) {
			text = val;
			continue;
		}

		if (strcmpi(arg,"start") == 0) {
			Start	 = atoi(val);
			StartSet = true;
			continue;
		}

		if (strcmpi(arg,"end") == 0) {
			End		  = atoi(val);
			EndSet	  = true;
			LengthSet = false;
			continue;
		}

		if (strcmpi(arg,"length") == 0) {
			Length	  = atoi(val);
			EndSet	  = false;
			LengthSet = true;
			continue;
		}
	}


	// Set vars
	int textSize    = strlen(text);
	bool Capitalize = true;

	if (textSize == 0)
		break;

	CorrectStringPos(&Start, &End, Length, EndSet, LengthSet, textSize);


	// For each character
	for (i=Start; i<End; i++) {
		// Default mode - change all characters
		if (!sentences && !words) {
			if (upper && !lower) 
				text[i] = toupper(text[i]);

			if (!upper && lower) 
				text[i] = tolower(text[i]);

		// Special mode - change first character in sentences or words
		} else {
			if (Capitalize && (words || sentences && !isspace(text[i]))) {
				Capitalize = false;

				if (upper) 
					text[i] = toupper(text[i]);
			} else
				if (lower) 
					text[i] = tolower(text[i]);

			// separator between words/sentences
			if (words  &&  isspace(text[i])  ||	 sentences  &&  (text[i]=='.' || text[i]=='?' || text[i]=='!')) 
				Capitalize = true;
		}
	}

	QWrite(text, out);
}
break;










case C_STRING_REPLACECHARS:
{ // Replace single characters in a string

	// Read arguments
	char *text         = "";
	char *find         = "";
	char *replace      = "";
	bool correspond    = false;
	bool caseSensitive = false;
	bool matchWord     = false;

	for (int i=2; i<numP; i++) {
		char *arg = stripq(par[i]);
		char *pch = strchr(arg, ':');

		if (pch == NULL) 
			continue;

		int pos   = pch - arg;
		arg[pos]  = '\0';
		char *val = arg + pos + 1;

		if (strcmpi(arg,"text") == 0) {
			text = val;
			continue;
		}

		if (strcmpi(arg,"find") == 0) {
			find = val;
			continue;
		}

		if (strcmpi(arg,"replace") == 0) {
			replace = val;
			continue;
		}

		if (strcmpi(arg,"correspond") == 0) {
			correspond = String2Bool(val);
			continue;
		}

		if (strcmpi(arg,"caseSensitive") == 0) {
			caseSensitive = String2Bool(val);
			continue;
		}

		if (strcmpi(arg,"matchWord") == 0) {
			matchWord = String2Bool(val);
			continue;
		}
	}


	// Set vars
	char output[2] = "";
	int textLength = strlen(text);
	int findLength = strlen(find);
	int replLength = strlen(replace);


	// For each character in "searchIN"
	for (i=0; i<textLength; i++) {	
		sprintf(output, "%c", text[i]);

		// If matching word - occurrence musn't be surrounded by alphanum chars
		if (matchWord) {
			bool LeftCleared  = false;
			bool RightCleared = false;

			// Left of character must be empty or not alfanum
			if (i == 0) 
				LeftCleared = true; 
			else 
				if (!isalnum(text[i-1])  &&  text[i-1]!='_') 
					LeftCleared = true;

			// Right of character must be empty or not alfanum
			if (i >= textLength) 
				RightCleared = true; 
			else 
				if (!isalnum(text[i+1])  &&  text[i+1]!='_') 
					RightCleared = true;

			if (!LeftCleared  ||  !RightCleared) {
				QWrite(output, out);
				continue;
			}
		}


		// Search for the current character in "find"
		bool match = false;

		for (int j=0; j<findLength; j++) {
			if (caseSensitive  &&  text[i]==find[j]  ||  !caseSensitive  &&  tolower(text[i])==tolower(find[j])) {		
				// Default mode
				if (!correspond) {
					// Replace if given third argument; otherwise remove
					if (replLength > 0)
						sprintf(output, "%c", replace[0]);
					else
						strcpy(output, "");

				// Find corresponding character from the third argument; otherwise remove
				} else {
					if (j < replLength)
						sprintf(output, "%c", replace[j]);
					else
						strcpy(output, "");
				}
			}
		}

		QWrite(output, out);
	}
}
break;










case C_STRING_INSERT:
{ // Add characters in the midddle of the string

	// Read arguments
	char *text  = "";
	char *merge = "";
	int index   = 0;

	for (int i=2; i<numP; i++) {
		char *arg = stripq(par[i]);
		char *pch = strchr(arg, ':');

		if (pch == NULL) 
			continue;

		int pos   = pch - arg;
		arg[pos]  = '\0';
		char *val = arg + pos + 1;

		if (strcmpi(arg,"text") == 0) {
			text = val;
			continue;
		}

		if (strcmpi(arg,"merge") == 0) {
			merge = val;
			continue;
		}

		if (strcmpi(arg,"position") == 0) {
			index = atoi(val);
			continue;
		}
	}

	// Validate arguments
	int textLength  = strlen(text);
	int mergeLength = strlen(merge);

	if (textLength == 0) {
		QWrite(merge, out);
		break;
	}

	if (mergeLength == 0) {
		QWrite(text, out);
		break;
	}


	// If index is out of bounds
	if (index < 0)
		index += textLength;

	if (index < 0)
		index = 0;

	if (index > textLength)
		index = textLength;


	// Cut text in half
	char saved  = text[index];
	text[index] = '\0';


	// Output first half and new text
	QWrite(text,  out);
	QWrite(merge, out);


	// Put it back together and output second half
	text[index] = saved;
	QWrite(text+index, out);
}
break;










case C_STRING_WORDPOS:
{ // Add characters in the midddle of the string

	// Read arguments
	char *text = "";

	for (int i=2; i<numP; i++) {
		char *arg = stripq(par[i]);
		char *pch = strchr(arg, ':');

		if (pch == NULL) 
			continue;

		int pos   = pch - arg;
		arg[pos]  = '\0';
		char *val = arg + pos + 1;

		if (strcmpi(arg,"text") == 0) 
			text = val;
	}

	// Validate arguments
	int textSize = strlen(text);
	if (textSize == 0) {
		QWrite("[]", out);
		break;
	}


	char output[128] = "";
	int StartType = -1;

	i = 0;
	QWrite("[", out);

	do {
		// Current word
		StartType = GetCharType(text[i]);

		// Output word position
		if (StartType != 1) {
			sprintf(output, "]+[%d", i);
			QWrite(output, out);
		}

		// Iterate until current word ends
		while (i<textSize  &&  GetCharType(text[i])==StartType)
			i++;

		// Skip spaces
		while (i<textSize  &&  GetCharType(text[i])==1)
			i++;
	} while (i < textSize);

	QWrite("]", out);
}
break;
