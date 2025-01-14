#pragma once
#include "common.h"

std::wstring utf16(std::string &input);
std::string utf8(const wchar_t* input, int input_size);
std::string utf8(std::wstring& input);
std::wstring FormatError(DWORD error);
bool Equals(const std::string& a, const std::string& b);
bool Equals(const std::wstring& a, const std::wstring& b);
DWORD GetProcessID(std::wstring exename);
GameInfo FindProcess(DWORD input_pid, std::wstring input_window_name);
DWORD GetOFPArguments(DWORD pid, HANDLE *phandle, std::wstring module_name, int offset_input, std::vector<std::wstring> &container);
void WriteSaveStateFile(std::string input);
std::wstring ReplaceAll(std::wstring str, const std::wstring& from, const std::wstring& to);
unsigned int HashFNV1A(unsigned int hash, const char *text, size_t text_length, bool lowercase);
BinarySearchResult BinarySearchString(const char *buffer, size_t array_size, unsigned int value_to_find, size_t low, size_t high);
std::string ReadStartupParams(std::string key_name);
std::string UnQuote(std::string text);
std::wstring UnQuote(std::wstring text);
void Tokenize(std::string text, std::string delimiter, std::vector<std::string> &container);
void Tokenize(std::wstring text, std::wstring delimiter, std::vector<std::wstring> &container);
std::string Int2Str(int num);
std::wstring Int2StrW(int num, bool leading_zero=false);
std::wstring Hex2StrW(int num);
WORD Str2Short(std::string num);
std::string Trim(std::string s);
std::wstring PathLastItem(std::wstring path) ;
std::wstring PathNoLastItem(std::wstring path, bool end_slash=true);
std::wstring WrapInQuotes(std::wstring text);
int ParseWgetLog(std::string &error);
int ParseUnpackLog(std::string &error);
DWORD DeleteDirectory(const std::wstring &refcstrRootDirectory, bool bDeleteSubdirectories=true);
DWORD Download(std::wstring url);
DWORD Unpack(std::wstring file_name, std::wstring password, bool tmp_dir=false);
std::wstring Decrypt(std::wstring sentence) ;
void LogMessage(std::wstring input, bool close=false);
bool RenameWithBackup(std::wstring &rename_src, std::wstring &rename_dst);
std::vector<std::wstring> ReadModID(std::wstring folder_name);
void SelectFileInExplorer(std::wstring path_to_file);
void ProcessArguments(LPWSTR command_line, INPUT_ARGUMENTS &input);
void readStringFromBinaryFile(FILE *f, std::wstring &destination);
bool WTS_OpenTask(WINDOWS_TASK_SCHEDULER &wts, std::wstring task_name);
bool WTS_SaveTask(WINDOWS_TASK_SCHEDULER &wts, TASK_TRIGGER &new_trigger);
void WTS_CloseTask(WINDOWS_TASK_SCHEDULER &wts);
bool WTS_Error(WINDOWS_TASK_SCHEDULER &wts, std::wstring message);
DWORD ReadLocalMods(std::vector<MODLIST> &local_mods);
std::wstring FormatMessageArray(std::vector<std::wstring> &message_list, int type=OPTION_LOGFILE);
std::wstring FormatSystemTime(SYSTEMTIME &date, int type=OPTION_LOGFILE);
