Make.latex_command = "${htlatex} --interaction=${interaction} ${latex_par} '\\makeatletter"..
"\\def\\HCode{\\futurelet\\HCode\\HChar}\\def\\HChar{\\ifx\"\\HCode"..
"\\def\\HCode\"##1\"{\\Link##1}\\expandafter\\HCode\\else"..
"\\expandafter\\Link\\fi}\\def\\Link#1.a.b.c.{\\AddToHook"..
"{class/before}{\\RequirePackage[#1,html]{tex4ht}${packages}}"..
"\\let\\HCode\\documentstyle\\def\\documentstyle{\\let\\documentstyle"..
"\\HCode\\expandafter\\def\\csname tex4ht\\endcsname{#1,html}\\def"..
"\\HCode####1{\\documentstyle[tex4ht,}\\@ifnextchar[{\\HCode}{"..
"\\documentstyle[tex4ht]}}}\\makeatother\\HCode ${tex4ht_sty_par}.a.b.c."..
"\\input \"\\detokenize{${tex_file}}\"'"
