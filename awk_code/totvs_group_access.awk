BEGIN {
    ln = -1;
    cap = 0;
    id = "";

    print "id;acessos;opcao"
}

{
    # capture start ======================================
    if($0 ~ /\*\* Grupo \*\*/){ # start user info
	    ln = 0; 
        cap = 1;        
    }

    if($0 ~ /Data da inclusão/){ # end use info
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

    if($0 ~ /\[/ && cap == 2) {
        
        # Acessos
        raw = trim($0);

        # replace
        gsub(/ \[X\]/,";SIM|",raw);
        gsub(/ \[ \]/,";NAO|",raw);
        gsub(/\[X\]/,"SIM|",raw);
        gsub(/\[ \]/,"NAO|",raw);

        split(raw, d, ";")

        for(i in d) {
            split(trim(d[i]), opc, "|");
            # print id, trim(opc[1]), trim(opc[2])
            printf("%s;\"%s\";%s\n", id, trim(opc[2]), trim(opc[1]));
        }

        # print id, n, raw

    }

    if(cap == 1) {

        if(trim($0) == "Acessos") {
            cap = 2;
        }

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