BEGIN {
    ln = -1;
    cap = 0;
    id  = "";
    mod = "";
    fnc = "";
    rtn = "";
    print "id;modulo;funcao;rotina;opcao"
  
}

{

    # capture start ======================================
    if($0 ~ /\*\* Grupo \*\*/){ # start user info
	    ln = 0; 
        cap = 1; 
   
    }

    if($0 ~ /Restrição de Acessos/){ # end use info
	    ln = -1; 
        cap = 0;

    }

    if($0 ~ /LGRL[[:digit:]][[:digit:]]\.BMP/) { # pause capture
        cap = 0;

    }

    if(index($0, ":") > 0 && cap >= 1) {
        raw = trim($0);

        split(raw, d, ":")

        key = trim(d[1])
        value = trim(d[2])

        # Get ID
        if(key == "ID") {
            id = value;
        }  
    }

    if(trim($0) == "" && cap == 2) {
        cap = 1;
    }  

    if (cap == 2) {

        raw = trim($0);

         # Módulo
         if(substr(raw,5,5) != "-----" && substr(raw,5,5) != "*****" && length(substr(raw,1,32)) >= 30) {
            
            rotina = trim(substr($0, 1, 25));
            funcao = trim(substr($0, 26, 10));
            opcoes = tolower(trim(substr($0, 36, 81)));

            if(funcao != "") {
                rtn = rotina;
                fnc = funcao;
            } 
            
            if(fnc != "") {

                if(opcoes != "") {
                    split(opcoes, d, "-")

                    for(i in d) {
                        o = trim(d[i])
                        
                        if(o != "")
                            printf("%s;\"%s\";\"%s\";\"%s\";\"%s\"\n", id, mod, fnc, rtn, o);

                            # print id, mod, fnc, rtn, o
                    }
                } else {
                    printf("%s;\"%s\";\"%s\";\"%s\";\"%s\"\n", id, mod, fnc, rtn, "");
                }

                
            }
         }
    }

    if(cap == 1) {

        if(trim($1) ~ /Rotina/) {
            cap = 2;
        }
    } 

    if(trim($0) ~ /\[X\] SIG/) {
         mod = trim($2);
    }

    # Count line

    if(ln >= 0){ 
	    ln = ln + 1;
    }

    if($0 ~ /Hora\.\.\.\:/ && cap == 0 && ln > 0) { # start capture
        cap = 1; 
    }

}

function ltrim(s) { sub(/^[ \t]+/, "", s); return s }
function rtrim(s) { sub(/[ \t]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

END {
  
}