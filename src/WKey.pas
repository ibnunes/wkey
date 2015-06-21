(* ===== WKey =====                                                                                             *
 *  Ver: 1.0                                                                                                    *
 *   By: thoga31                                                                                                *
 * Date: June 21st, 2015                                                                                        *
 *                                                                                                              *
 * Windows Key Decoder - for when your label wore out or doesn't even exist (e.g., laptops with Windows 8/8.1). *
 * Must be used only for genuine Windows when you need your original key to reinstall the OS.                   
 * License: WTFPL 2 *)

{$mode objfpc}
program WKey;
uses sysutils;

const
   MAXREG = 164;        // The buffer size needed
   CRLF   = #13+#10;    // Just for some output elegance

type
   TRegBinary = array [0..MAXREG-1] of integer;    // The key is somewhat encrypted with this type


function ConvertToKey(key : TRegBinary) : string;
(* I must apologize to the original author of this algorithm.
 * It spread over the Internet and I just used it here.
 * We all must thank the author of this algorithm for its time and expertise. *)

const
   KEYOFFSET = 52;
   CHARS     = 'BCDFGHJKMPQRTVWXY2346789';

var
   i   : smallint = 28;
   x   : smallint;
   cur : smallint;
   keyoutput : string = '';

begin    // Let the magic begin!
   repeat
      cur := 0;
      x   := 14;
      repeat
         cur := cur * 256;
         cur := key[x + KEYOFFSET] + cur;
         key[x + KEYOFFSET] := Round(cur / 24);
         cur := cur mod 24;
         Dec(x);
      until x < 0;
      Dec(i);
      keyoutput := CHARS[cur+1] + keyoutput;
      if ((29-i) mod 6 = 0) and (i <> -1) then begin
         Dec(i);
         keyoutput := '-' + keyoutput;
      end;
   until i < 0;
   ConvertToKey := keyoutput;    // We loved that little label under the laptop, didn't we? ^^
end;


function GetWindowsKey(out winkey : string) : boolean;
(* Gets the content from the generated file and loads it. *)

const
   FILE_KEY = 'mykey.txt';    // The file with our information

var
   f   : Text;        // Stream for the file
   i   : word = 0;    // Just a counter
   n   : string;      // To read the contents
   key : TRegBinary;  // Our precious information ready to be "decrypted"

begin
   GetWindowsKey := false;
   
   try
      // Extraction from the file...
      Assign(f, FILE_KEY);
      Reset(f);
      while (not eof(f)) and (i+1 <= MAXREG) do begin
         readln(f, n);
         key[i] := StrToInt(n);
         Inc(i);
      end;
      Close(f);
      DeleteFile(FILE_KEY);
      
      winkey := ConvertToKey(key);  // Time to "purify" and get our "diamond"
      GetWindowsKey := true;        // Everything was ok! Great!
      
   except   // If this happens, something was messed up and I don't know what it could be... oops :/
      on ex : Exception do begin
         writeln;
         writeln('ERROR <', ex.classname, '> ', ex.message);
         writeln('I''m so sorry :(');  // Really, I am!
      end;
   end;
end;


var
   key : string = '';

begin  {Main block}
   writeln('WKey v1.0, by thoga31');
   
   (* This program must be called by 'wkey.bat' in order to work properly.
      The validation is very very simple, but whatever, we don't need fancy validation methods. xD  *)
   if (ParamCount <> 1) or ((ParamCount = 1) and (ParamStr(1) <> '--FromBatch')) then begin
      writeln(CRLF, 'Validation failed. The program won''t execute.');
      write('Press ENTER to exit...');
      readln;  // Pause - I didn't found necessary to implement a function, it'd use 'crt' just for that...
      
   end else begin
      if GetWindowsKey(key) then
         writeln('Success! This is your key: ', key)  // Weee!
      else
         writeln('Something happened while processing the key...');
   end;
   
   writeln(CRLF, 'Program ended.');    // Cya next time! :D
end.